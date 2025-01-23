import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildgids/config/theme/asset_icons.dart';
import 'package:wildgids/config/theme/custom_colors.dart';
import 'package:wildgids/services/animal.dart';
import 'package:wildgids/services/isar/helpers/isar_db.dart';
import 'package:wildgids/services/tracking.dart';
import 'package:wildgids/widgets/location.dart';
import 'package:wildlife_api_connection/models/animal_tracking.dart';
import 'package:wildlife_api_connection/models/isar/isar_animal_tracking.dart';
import 'package:wildlife_api_connection/models/species.dart';

class MapView extends StatefulWidget {
  final AnimalService animalService;
  final TrackingService trackingService;

  const MapView({
    super.key,
    required this.animalService,
    required this.trackingService,
  });

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  // Set global properties
  late Timer _animalTimer;
  late Timer _trackingTimer;
  List<Marker> _markers = [];
  LatLng? _initialPosition;
  final MapController _mapController = MapController();
  bool _isSatellite = false;

  // On initial state, set the initial location and start fetching markers with a timer
  @override
  void initState() {
    super.initState();
    processing();
  }

  // On initial state, set the initial location and start fetching markers with a timer await to prevent multiple permission requests
  void processing() async {
    await _setInitialLocation();
    await _startTimers();
    await _sendTracking();
    await _fetchMarkers();
  }

  @override
  void dispose() {
    _animalTimer.cancel();
    _trackingTimer.cancel();
    super.dispose();
  }

  // Set initial location for map bounds and camera center
  Future<void> _setInitialLocation() async {
    LatLng position = await _determinePosition();

    setState(() {
      _initialPosition = position;
    });
  }

  // Start timer to retrieve/upload location and fetch markers
  Future<void> _startTimers() async {
    // Set timer to fetch markers every 10 seconds
    _animalTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _fetchMarkers();
    });

    // Set timer to send location every minute
    _trackingTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      await _sendTracking();
    });
  }

  // Get the current location of the device
  Future<LatLng> _determinePosition() async {
    if (!context.mounted) {
      return const LatLng(51.25851739912562, 5.622422796819703);
    }
    final location = await LocationManager().getUserLocation(context);
    return location;
  }

  // Fetch markers from isar database using the animal service
  Future<void> _fetchMarkers() async {
    try {
      final isar = IsarDB.shared.instance;
      List<AnimalTracking> animalTrackings = [];

      List<IsarAnimalTracking> isarAnimalTrackings =
          await isar.isarAnimalTrackings.where().findAll();

      if (isarAnimalTrackings.isNotEmpty) {
        setState(() {
          animalTrackings = isarAnimalTrackings
              .map((isarAnimalTracking) =>
                  AnimalTracking.fromIsar(isarAnimalTracking))
              .toList();
        });
      }

      // Api call to get all animal trackings and update isar database
      List<AnimalTracking> apiAnimalTrackings =
          await widget.animalService.getAllAnimalTrackings();

      if (apiAnimalTrackings.isNotEmpty) {
        isar.writeTxn(() async {
          await isar.isarAnimalTrackings.clear();
        });
        for (final animalTracking in apiAnimalTrackings) {
          final isarAnimalTracking =
              IsarAnimalTracking.fromAnimalTracking(animalTracking);

          await isar.writeTxn(() async {
            return isar.isarAnimalTrackings.put(isarAnimalTracking);
          });
        }
      }

      setState(() {
        animalTrackings = apiAnimalTrackings;
      });
      // Create markers for each animal tracking with options based on species
      List<Marker> newMarkers = animalTrackings.map((tracking) {
        var animalMarkerOptions = _getAnimalMarkerOptions(tracking.species);
        return Marker(
            width: animalMarkerOptions.size,
            height: animalMarkerOptions.size,
            rotate: true, // Keeps markers upright when rotating the map
            point:
                LatLng(tracking.location.latitude, tracking.location.longitude),
            child: GestureDetector(
              onTap: () {
                // Show dialog when clicking on a marker
                showDialog(
                    builder: (_) => AlertDialog(
                            title: const Text("Caught"),
                            content: Text("Clicked on ${tracking.name}"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Close"))
                            ]),
                    context: context,
                    barrierDismissible: true);
              },
              child: SvgPicture.asset(animalMarkerOptions.svgPath,
                  colorFilter: ColorFilter.mode(
                      animalMarkerOptions.color, BlendMode.srcIn)),
            ));
      }).toList();

      // Set the new markers
      setState(() {
        _markers = newMarkers;
      });
    } catch (e) {
      debugPrint('Error fetching markers: $e');
    }
  }

  Future<void> _sendTracking() async {
    LatLng position = await _determinePosition();
    widget.trackingService
        .sendTrackingReading(LatLng(position.latitude, position.longitude));
    debugPrint('Sent tracking reading');
  }

  // Build the map view with the current location and markers
  @override
  Widget build(BuildContext context) {
    // If the initial position is not set, show a loading indicator
    if (_initialPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Set bounds for the camera constraint using initial position (Make sure this is not done dynamically which may crash because of camera constraint #https://github.com/fleaflet/flutter_map/issues/1760)
    final bounds = LatLngBounds(
      LatLng(
          _initialPosition!.latitude - 0.1, _initialPosition!.longitude - 0.1),
      LatLng(
          _initialPosition!.latitude + 0.1, _initialPosition!.longitude + 0.1),
    );

    return Scaffold(
      body: Stack(
        children: [
          // FlutterMap to display the map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialPosition!,
              initialZoom: 16,
              minZoom: 12,
              maxZoom: 20,
              cameraConstraint: CameraConstraint.containCenter(bounds: bounds),
            ),
            children: [
              // Map tiles (Satellite or Street view based on _isSatellite)
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CancellableNetworkTileProvider(),
                userAgentPackageName: 'com.wildlifenl.wildgids',
              ),
              // Current location indicator
              CurrentLocationLayer(),
              // Marker layer
              MarkerLayer(markers: _markers),
            ],
          ),

          // Floating toggle button
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isSatellite = !_isSatellite; // Toggle map view
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.satellite_alt,
                  color: _isSatellite ? CustomColors.primary : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Struct for animal marker
class AnimalMarker {
  final String svgPath;
  final Color color;
  final double size;

  AnimalMarker({
    required this.svgPath,
    required this.color,
    required this.size,
  });
}

// Function to determine icon based on animal species
AnimalMarker _getAnimalMarkerOptions(Species species) {
  switch (species.id) {
    case '2e6e75fb-4888-4c8d-81c6-ab31c63a7ecb':
      return AnimalMarker(
          svgPath: AssetIcons.bison, color: Colors.lightGreen, size: 40);
    case '79952c1b-3f43-4d6e-9ff0-b6057fda6fc1':
      return AnimalMarker(
          svgPath: AssetIcons.scottishHighlander,
          color: Colors.lightGreen,
          size: 40);
    case '28775ecb-1af6-4b22-a87a-e15b1999d55c':
      return AnimalMarker(
          svgPath: AssetIcons.wildBoar, color: Colors.lightGreen, size: 50);
    case 'cf83db9d-dab7-4542-bc00-08c87d1da68d':
      return AnimalMarker(
          svgPath: AssetIcons.wolf, color: Colors.red.shade400, size: 40);
    default:
      return AnimalMarker(
          svgPath: AssetIcons.universal, color: Colors.lightGreen, size: 40);
  }
}

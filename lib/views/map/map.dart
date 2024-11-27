import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wildgids/services/animal.dart';
import 'package:wildlife_api_connection/models/animal_tracking.dart';

class MapView extends StatefulWidget {
  final AnimalService animalService;

  const MapView({
    super.key,
    required this.animalService,
  });

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  // Set global properties
  late Timer _timer;
  List<Marker> _markers = [];
  LatLng? _initialPosition;
  final MapController _mapController = MapController();

  // On initial state, set the initial location and start fetching markers with a timer
  @override
  void initState() {
    super.initState();
    _setInitialLocation();
    _startTimer();
    _fetchMarkers();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Set initial location for map bounds and camera center
  void _setInitialLocation() async {
    Position position = await _determinePosition();

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  // Start timer to retrieve/upload location and fetch markers
  void _startTimer() async {
    // Set timer to retrieve location every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position position = await _determinePosition();
      _sendLocation(position);
      _fetchMarkers();
    });
  }

  // Get the current location of the device
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // Check if location permissions are permanently denied
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location with granted permissions
    return await Geolocator.getCurrentPosition();
  }

  // TODO: Send location to the server
  Future<void> _sendLocation(Position position) async {
    debugPrint('Location: ${position.latitude}, ${position.longitude}');
  }

  // Fetch markers from the server using the animal service
  void _fetchMarkers() async {
    try {
      // Simulating API call
      List<AnimalTracking> animalTrackings =
          await widget.animalService.getAllAnimalTrackings();
      debugPrint('Animal trackings length: ${animalTrackings.length}');

      // Marker options
      List<Marker> newMarkers = animalTrackings.map((tracking) {
        return Marker(
          width: 40.0,
          height: 40.0,
          rotate: true, // Keeps markers upright when rotating the map
          point:
              LatLng(tracking.location.latitude, tracking.location.longitude),
          child: const Icon(
            Icons.location_on,
            color: Colors.lightGreen,
            size: 40.0,
          ),
        );
      }).toList();

      // Set the new markers
      setState(() {
        _markers = newMarkers;
      });
    } catch (e) {
      debugPrint('Error fetching markers: $e');
    }
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

    // Map settings
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _initialPosition!,
        initialZoom: 16,
        minZoom: 12,
        maxZoom: 20,
        cameraConstraint: CameraConstraint.containCenter(bounds: bounds),
      ),
      children: [
        // Used to display the map tiles, in this case the World Imagery tiles (Check out other free tiles #https://alexurquhart.github.io/free-tiles/)
        TileLayer(
          urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.wildlifenl.wildgids',
        ),
        CurrentLocationLayer(), // Used to display the current location of the user (blue dot)
        MarkerLayer(markers: _markers),
      ],
    );
  }
}

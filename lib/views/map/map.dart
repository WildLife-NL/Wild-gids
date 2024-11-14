import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildgids/config/theme/asset_icons.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startLocationUpdates() async {
    // Initial location
    Position initPosition = await _determinePosition();
    _sendLocation(initPosition);

    // Set timer to to retrieve location every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position position = await _determinePosition();
      _sendLocation(position);
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

  Future<void> _sendLocation(Position position) async {
    // Log location to console
    print('Location: ${position.latitude}, ${position.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    const startingPoint = LatLng(51.25851739912562, 5.622422796819703);

    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
          initialCenter: startingPoint, // Center the map over Weerterbos
          initialZoom: 11,

          // Set map zoom and location boundaries
          minZoom: 9,
          maxZoom: 18,
          cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(const LatLng(52.25851, 6.6224),
                  const LatLng(50.25851, 4.6224)))),
      children: [
        TileLayer(
          // Display map tiles from any source
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
          userAgentPackageName: 'com.wildlifenl.wildgids',
        ),
        CurrentLocationLayer(),
        // Display a marker on the map
        MarkerLayer(markers: [
          Marker(
              point: startingPoint,
              width: 30,
              height: 30,
              child: SvgPicture.asset(AssetIcons.locationDot),
              rotate: true),
        ])
      ],
    );
  }
}

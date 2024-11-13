import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionDialog extends StatefulWidget {
  const LocationPermissionDialog({super.key});

  @override
  LocationPermissionDialogState createState() =>
      LocationPermissionDialogState();
}

class LocationPermissionDialogState extends State<LocationPermissionDialog> {
  String _locationMessage = "Press the button to get location";

  // Function to check and request location permissions
  Future<void> _requestLocationPermission() async {
    // Check if location permission is granted
    PermissionStatus status = await Permission.location.request();

    // If permission is granted, fetch the current location
    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied) {
      setState(() {
        _locationMessage = "Location permission denied";
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      setState(() {
        _locationMessage = "Location permission is permanently denied.";
      });
    }
  }

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Failed to get location: $e";
      });
    }
  }

  // Show dialog asking for location permission
  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Access"),
          content: const Text(
              "We need your location to show you relevant information. Do you allow us to access your location?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _requestLocationPermission(); // Request permission
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Permission Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed:
                  _showLocationPermissionDialog, // Show dialog to request permission
              child: const Text("Request Location Access"),
            ),
            const SizedBox(height: 20),
            Text(_locationMessage, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: LocationPermissionDialog(),
  ));
}

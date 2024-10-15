// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:wildgids/models/services/user.dart';
import 'package:wildlife_api_connection/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _profile;
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchProfileInfo();
  }

  Future<void> _fetchProfileInfo() async {
    try {
      final profile = await UserService().getMyProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading profile";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Manage your profile information",
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        if (_isLoading) ...[
          const CircularProgressIndicator()
        ] else ...[
          if (_errorMessage.isNotEmpty) ...[
            Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            )
          ] else ...[
            Text(
              "User ID: ${_profile!.id}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            if (_profile!.name != null && _profile!.name != "") ...[
              Text(
                "Name: ${_profile!.name}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
            Text(
              "Email: ${_profile!.email}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
        InkWell(
          onTap: () {
            // TODO: Add logout functionality
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.grey,
            ),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            height: 70,
            width: double.maxFinite,
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Uitloggen",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // TODO: Add account deletion functionality
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.grey,
            ),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            height: 70,
            width: double.maxFinite,
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verwijder je account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

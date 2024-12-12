import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wildgids/config/theme/custom_colors.dart';
import 'package:wildgids/services/auth.dart';
import 'package:wildgids/services/user.dart';
import 'package:wildgids/views/login/login.dart';
import 'package:wildgids/widgets/custom_scaffold.dart';
import 'package:wildlife_api_connection/models/user.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  User? _profile;
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchProfileInfo();
  }

  void _fetchProfileInfo() async {
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
    return CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 85.0),
                    child: Image.asset(
                      'assets/images/no-profile-image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _profile?.name ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
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
                const Text(
                  "Algemeen",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primary,
                  ),
                ),
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
              MaterialButton(
                minWidth: double.maxFinite,
                color: CustomColors.primary,
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(
                        authService: AuthService(),
                      ),
                    ),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Uitloggen',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

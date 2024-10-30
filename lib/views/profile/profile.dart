import 'package:flutter/material.dart';
import 'package:wildgids/config/theme/custom_colors.dart';
import 'package:wildgids/models/services/auth.dart';
import 'package:wildgids/models/services/user.dart';
import 'package:wildlife_api_connection/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  User? _profile;
  bool _isLoading = true;
  String _errorMessage = "";

  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchProfileInfo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Profiel",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Manage je profiel informatie",
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
            const Text(
              "Algemeen",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_profile!.name != null && _profile!.name != "") ...[
              ListTile(
                leading: const Icon(Icons.person),
                trailing: const Icon(Icons.chevron_right),
                title: Text(_profile!.name ?? ""),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Enter je naam'),
                        content: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: 'Naam',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Naam kan niet leeg zijn';
                              }

                              String pattern = r'^[A-Za-z\s]+$';
                              RegExp regex = RegExp(pattern);

                              if (!regex.hasMatch(value)) {
                                return 'Naam kan geen cijfers of speciale tekens bevatten';
                              }
                              return null;
                            },
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await UserService().updateProfile(
                                "",
                              );
                              _fetchProfileInfo();

                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                            },
                            child: const Text('Verwijder naam'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await UserService().updateProfile(
                                  _controller.text.trim(),
                                );
                                _fetchProfileInfo();

                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Wijzig naam'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.email),
              trailing: const Icon(Icons.chevron_right),
              title: Text(_profile!.email ?? ""),
            ),
          ],
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            "Legal",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.policy),
            trailing: Icon(Icons.chevron_right),
            title: Text("Privacy policy"),
          ),
          const ListTile(
            leading: Icon(Icons.question_answer),
            trailing: Icon(Icons.chevron_right),
            title: Text("FAQ"),
          ),
          const ListTile(
            leading: Icon(Icons.book),
            trailing: Icon(Icons.chevron_right),
            title: Text("Terms & Conditions"),
          ),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: CustomColors.primary,
                  ),
                  onPressed: () async {
                    AuthService().logout();
                  },
                  child: const Text(
                    "Uitloggen",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ],
    );
  }
}

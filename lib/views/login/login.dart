// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:wildgids/models/services/auth.dart';
import 'package:wildgids/views/login/verfication.dart';
import 'package:wildgids/views/widgets/custom_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          const Text(
            "Login",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Enter your email to login",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20.0),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email*',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty.';
                    }

                    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$';
                    RegExp regex = RegExp(pattern);

                    if (!regex.hasMatch(value)) {
                      return 'Give a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  minWidth: double.maxFinite,
                  color: Colors.grey,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final email = _emailController.text;

                      AuthService().authenticate(email, "", "");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificationPage(
                            email: email,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Send code'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wildgids/config/theme/custom_colors.dart';
import 'package:wildgids/services/auth.dart';
import 'package:wildgids/views/login/verfication.dart';
import 'package:wildgids/widgets/custom_scaffold.dart';

class LoginView extends StatefulWidget {
  final AuthService authService;

  const LoginView({
    super.key,
    required this.authService,
  });

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 100),
          Image.asset(
            'assets/images/wildlife-logo.png',
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 30),
          const Text(
            "Welkom bij Wild Gids!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CustomColors.primary,
            ),
          ),
          const Text(
            "Login in met je email.",
            style: TextStyle(
              fontSize: 18,
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
                  color: CustomColors.primary,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final email = _emailController.text;
                      await widget.authService.authenticate(email, "WildGids");

                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificationView(
                            email: email,
                            authService: widget.authService,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Inloggen',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wildgids/config/theme/custom_theme.dart';
import 'package:wildgids/models/services/auth.dart';
import 'package:wildgids/views/login/login.dart';
import 'package:wildgids/views/widgets/custom_scaffold.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme(context).themeData,
      title: 'Wildgids',
      debugShowCheckedModeBanner: false,
      home: const Initializer(),
    );
  }
}

class Initializer extends StatefulWidget {
  const Initializer({super.key});

  @override
  State<Initializer> createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  Future<bool>? _isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    _isUserLoggedIn = _checkUserLoginStatus();
  }

  Future<bool> _checkUserLoginStatus() async {
    String? token = await _getBearerToken();
    return token != null && token != "";
  }

  Future<String?> _getBearerToken() async {
    return await AuthService().getBearerToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        } else if (snapshot.data != null && snapshot.data == true) {
          return CustomScaffold(selectedIndex: 0, body: const Center());
        } else {
          return const Scaffold(
            body: Center(
              child: LoginPage(),
            ),
          );
        }
      },
    );
  }
}

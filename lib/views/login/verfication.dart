import 'package:flutter/material.dart';
import 'package:wildgids/app.dart';
import 'package:wildgids/config/app_config.dart';
import 'package:wildgids/models/services/auth.dart';
import 'package:wildgids/views/widgets/custom_scaffold.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  final AuthService authService;

  const VerificationPage({
    super.key,
    required this.email,
    required this.authService,
  });

  @override
  VerificationPageState createState() => VerificationPageState();
}

class VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _nextField(int currentIndex) {
    if (currentIndex < _focusNodes.length - 1) {
      _focusNodes[currentIndex + 1].requestFocus();
    }
  }

  void _previousField(int currentIndex) {
    if (currentIndex > 0) {
      _focusNodes[currentIndex - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedIndex: -1,
      isAuthenticated: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter code',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'An email has been sent to: ${widget.email}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return _buildCodeInputBox(_controllers[index], index);
              }),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () {
                AuthService().authenticate(
                    widget.email, AppConfig.shared.displayNameApp);
              },
              child: const Text(
                'Did not receive a code? Send new email',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final code = _controllers
                      .map((controller) => controller.text.trim())
                      .join();
                  await widget.authService.authorize(widget.email, code);

                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Initializer(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInputBox(TextEditingController controller, int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        focusNode: _focusNodes[index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.isNotEmpty) {
            _nextField(index);
          } else {
            _previousField(index);
          }
        },
        onSubmitted: (_) => _nextField(index),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.purple, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

import 'package:expense_tracker/app/config/theme/app_colors.dart';
import 'package:expense_tracker/app/shared/util/static_widgets.dart';
import 'package:expense_tracker/app/shared/util/toast_service.dart';
import 'package:expense_tracker/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> onLogin() async {
    final navigator = Navigator.of(context);
    final scaffold = ScaffoldMessenger.of(context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      scaffold.showSnackBar(
        const SnackBar(content: Text('Signed in successfully')),
      );

      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    } catch (e) {
      ToastService.showErrorToast(context, "Could not login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            labelInputContainer(
                label: "Email",
                controller: _emailController
            ),
            SizedBox(height: 32),
            labelInputContainer(
              label: "Password",
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: onLogin,
              child: Text(
                'Login',
                style: TextStyle(color: AppColors.primaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

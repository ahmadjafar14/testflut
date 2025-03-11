import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../screens/home_screen.dart';
import '../styles/app_styles.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

 void _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username dan password tidak boleh kosong"))
      );
      return;
    }

    try {
      await dbHelper.registerUser(username, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registrasi Berhasil"))
      );
      Navigator.pop(context); // Kembali ke login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username sudah digunakan"))
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/img/logo.png",
            width: 120,
            height: 120,
          ),
          const Text("Register", style: AppStyles.titleStyle),
          const SizedBox(height: 20),
          TextFormField(
            controller: _usernameController,
            decoration: AppStyles.inputDecoration("Username").copyWith(
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Username tidak boleh kosong";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            decoration: AppStyles.inputDecoration("Password").copyWith(
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password tidak boleh kosong";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _register,
            style: AppStyles.buttonStyle(context),
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}

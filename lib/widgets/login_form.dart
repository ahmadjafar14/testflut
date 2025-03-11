import 'package:flutter/material.dart';
import 'package:testflutter/screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../styles/app_styles.dart';
import '../database/database_helper.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  bool _isPasswordVisible = false; // Tambahkan variabel ini

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _regis() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Informasi"),
          content: Text("Ini adalah pesan dari AlertDialog."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final user = await dbHelper.loginUser(username, password);
    print(user);
    if (user != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Berhasil")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username atau Password salah")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/img/logo.png",
            width: 120,
            height: 120,
          ),
          const Text("Login", style: AppStyles.titleStyle),
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
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password tidak boleh kosong";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            style: AppStyles.buttonStyle(context),
            child: const Text("Login"),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _regis,
            child: const Text(
              "Register",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

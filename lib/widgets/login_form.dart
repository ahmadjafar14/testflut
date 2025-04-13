import 'package:flutter/material.dart';
import 'package:testflutter/screens/register_screen.dart';
import 'package:testflutter/services/ApiService.dart';
import '../screens/home_screen.dart';
import '../styles/app_styles.dart';
import '../database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi input
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username dan password tidak boleh kosong')),
      );
      return;
    }

    try {
      final api = ApiService(); // Pastikan ApiService kamu sudah benar
      final response = await api.loginUser(username, password);
      if (response.statusCode == 200) {
        final token = response.data['token'];
        final user = response.data['user'];

        if (token == null || user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Token atau data pengguna tidak ditemukan')),
          );
          return;
        }

        //   // Simpan data ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user_email', user['email']);
        await prefs.setString('user_name', user['username']);

        //   // Arahkan ke halaman home
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
      //  else {
      //   // Respons gagal
      //   print('Login gagal: ${response.data}');
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //         content: Text(
      //             'Login gagal: ${response.data['error'] ?? 'Unknown error'}')),
      //   );
      // }
    } catch (e) {
      // Tangani kesalahan jika terjadi pada API request
      print('Login gagal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
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

import 'package:flutter/material.dart';
import 'package:testflutter/models/Menus.dart';
import 'package:testflutter/services/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profilepage> {
  String _userName = '';
  String _userEmail = '';
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk memuat data pengguna dari SharedPreferences
  Future<void> _loadUserData() async {
    await Future.delayed(Duration(seconds: 3));
    if (!mounted) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userName = prefs.getString('user_name') ?? 'Nama tidak ditemukan';
      _userEmail = prefs.getString('user_email') ?? 'Email tidak ditemukan';
    });
  }

  // Fungsi untuk logout
  Future<void> logoutUser() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      if (!mounted) return;
      final response = await ApiService().logoutUser();
      if (response?.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // Berhasil logout
        await prefs.remove('token');
        await prefs.remove('user_email');
        await prefs.remove('user_name');
        print("Logout successful");
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        print('Logout failed: ${response?.data}');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Menampilkan Nama Pengguna
        Text(
          'Nama: $_userName',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // Menampilkan Email Pengguna
        Text(
          'Email: $_userEmail',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 30),
        // Tombol Logout
        ElevatedButton(
          onPressed: logoutUser,
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

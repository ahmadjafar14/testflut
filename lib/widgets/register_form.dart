import 'package:flutter/material.dart';
import 'package:testflutter/models/Users.dart';
import 'package:testflutter/services/ApiService.dart';
// import '../database/database_helper.dart';
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
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tgllahirController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _genderController =
      TextEditingController(); // For gender selection

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2101);

    // Show Date Picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        _tgllahirController.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format the date
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    _emailController.dispose();
    _tgllahirController.dispose();
    _nohpController.dispose();
    _alamatController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final user = Users(
        username: _usernameController.text,
        password: _passwordController.text,
        fullname: _fullnameController.text,
        email: _emailController.text,
        tgllahir: _tgllahirController.text,
        gender: _genderController.text,
        nohp: _nohpController.text,
        alamat: _alamatController.text,
      );

      final api = ApiService();
      final response = await api.registerUser(user);

      if (response.statusCode == 201) {
        // Registrasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registrasi berhasil")),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        // Registrasi gagal
        final errorMsg = response.data['error'] ?? 'Gagal mendaftar';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
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
            // Username Field
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
            // Fullname Field
            TextFormField(
              controller: _fullnameController,
              decoration: AppStyles.inputDecoration("Fullname").copyWith(
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Fullname tidak boleh kosong";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: AppStyles.inputDecoration("Email").copyWith(
                prefixIcon: const Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email tidak boleh kosong";
                }
                // You can add additional email format validation if necessary
                return null;
              },
            ),
            const SizedBox(height: 10),
            // Password Field
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
            const SizedBox(height: 10),
            // Date of Birth Field (tgllahir)
            TextFormField(
              controller: _tgllahirController,
              readOnly: true, // Make it read-only
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context), // Open DatePicker on tap
            ),
            const SizedBox(height: 10),
            // Gender Field
            DropdownButtonFormField<String>(
              value: _genderController.text.isEmpty
                  ? null
                  : _genderController.text,
              onChanged: (newValue) {
                setState(() {
                  _genderController.text = newValue!;
                });
              },
              items: <String>['Laki-Laki', 'Perempuan']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: AppStyles.inputDecoration("Gender").copyWith(
                prefixIcon: const Icon(Icons.accessibility),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Gender tidak boleh kosong";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // Phone Number Field (nohp)
            TextFormField(
              controller: _nohpController,
              decoration: AppStyles.inputDecoration("Nomor HP").copyWith(
                prefixIcon: const Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nomor HP tidak boleh kosong";
                }
                // You can add phone number validation here, for example, using regex
                return null;
              },
            ),
            const SizedBox(height: 10),
            // Address Field (alamat)
            TextFormField(
              controller: _alamatController,
              decoration: AppStyles.inputDecoration("Alamat").copyWith(
                prefixIcon: const Icon(Icons.home),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Alamat tidak boleh kosong";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Register Button
            ElevatedButton(
              onPressed: _register,
              style: AppStyles.buttonStyle(context),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}

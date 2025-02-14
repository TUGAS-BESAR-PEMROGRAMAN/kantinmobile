import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/screen/login.dart';
import 'package:flutter_application_1/model/handler_model.dart'; //import untuk login dan register
// import 'package:flutter_application_1/service/Auth_manager.dart'; //import untuksharedpreference
import 'package:flutter_application_1/service/api_services.dart'; // impoet untuk API login dan register

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordHidden = true;

  // kumpulan functionya
  // Controllers untuk form fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();

  final ApiServices _apiServices =
      ApiServices(); // Menggunakan ApiServices untuk register

  // Menambahkan SnackBar dengan emoticon senyum
  void showLoadingSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
              'Silakan menunggu proses registrasi... 😄',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        duration: Duration(seconds: 2), // Tampilkan SnackBar selama 2 detik
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://media.istockphoto.com/id/1199215257/id/vektor/anak-anak-di-kantin-membeli-dan-makan-siang-kembali-ke-sekolah-kartun-vektor-terisolasi.jpg?s=612x612&w=0&k=20&c=z32HXhBGfeFGHUL7bhx9b7YHO1ZlGDOePT09WF5PFuY=",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay supaya teks lebih terbaca
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Tombol Back di atas
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
              ),
            ),
          ),

          // Form Register
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 60),

                  Icon(Icons.storefront, color: Colors.white, size: 60),
                  SizedBox(height: 10),
                  Text(
                    "Register",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Field Username
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Field Password
                  TextField(
                    obscureText: _isPasswordHidden,
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Field Role
                  TextField(
                    controller: _roleController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Role",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.person_pin, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Tombol Register
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      // Ambil data inputan dari controller
                      final registerInput = RegisterInput(
                        username: _usernameController.text,
                        password: _passwordController.text,
                        role: _roleController.text,
                      );

                      // Tampilkan SnackBar saat proses dimulai
                      showLoadingSnackbar();

                      // Panggil fungsi register API
                      RegisterResponse? response =
                          await _apiServices.register(registerInput);

                      if (response != null &&
                          response.message == 'Registration successful') {
                        // Jika registrasi sukses, arahkan ke login
                        Navigator.pop(context); // Kembali ke login
                      } else {
                        // Tampilkan pesan error jika gagal
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed')),
                        );
                      }
                    },
                    child: Text(
                      "Register",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // Login Link
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );

                      // Navigator.pop(context); // Kembali ke login
                    },
                    child: Text(
                      "Sudah punya akun? Login",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/bottom_navbar.dart';
import 'package:flutter_application_1/screen/dashboard_admin.dart';
import 'package:flutter_application_1/screen/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/main.dart'; // Import HomeScreen
import 'package:flutter_application_1/screen/register.dart';
import 'package:flutter_application_1/model/handler_model.dart'; //import untuk login dan register
import 'package:flutter_application_1/service/Auth_manager.dart'; //import untuksharedpreference
import 'package:flutter_application_1/service/api_services.dart'; // impoet untuk API login dan register
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import spinner package untuk animasi bergeraknya

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true; // Untuk toggle password visibility
  final ApiServices _dataService = ApiServices(); // untuk memanggil API
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Validasi form
  final _usernameController = TextEditingController(); // Controller username
  final _passwordController = TextEditingController(); // Controller password
  final _roleController = TextEditingController(); // Controller role

  // Method untuk mengecek apakah user sudah login
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    bool isLoggedIn = await AuthManager.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DynamicBottomNavbar(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  // Validasi untuk username, password, dan role
  String? _validateUsername(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  String? _validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Role Harus diisi';
    }
    return null;
  }
// animasi bergeraknya

// Menampilkan pop-up dengan spinner animasi
  void showWelcomePopup(String username) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Agar dialog tidak bisa ditutup dengan tap di luar
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitPouringHourGlass(
                // Animasi spinner dengan dots bergerak
                color: Colors.green, // Ganti warna sesuai kebutuhan
                size: 50.0, // Ukuran spinner
              ),
              SizedBox(height: 20),
              Text(
                'Selamat datang, $username! 👋',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Selamat berbelanja!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );

    // Delay untuk menutup dialog setelah 3 detik
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context); // Tutup dialog setelah 3 detik
    });
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
                  Navigator.pop(context); // Kembali ke HomeScreen
                },
              ),
            ),
          ),
          // Form Login
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 60),
                    Icon(Icons.storefront, color: Colors.white, size: 60),
                    SizedBox(height: 10),
                    Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30),
                    // Field Username
                    TextFormField(
                      controller: _usernameController,
                      validator: _validateUsername,
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
                    TextFormField(
                      obscureText: _isPasswordHidden,
                      controller: _passwordController,
                      validator: _validatePassword,
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
                    TextFormField(
                      controller: _roleController,
                      validator: _validateRole,
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
                    // Tombol Login
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
                        final isValidForm = _formKey.currentState!.validate();
                        if (isValidForm) {
                          final postModel = LoginInput(
                            username: _usernameController.text,
                            password: _passwordController.text,
                            role: _roleController.text,
                          );
                          LoginResponse? res =
                              await _dataService.login(postModel);

                          if (res!.message == 'Login successful') {
                            await AuthManager.login(_usernameController.text);

                            // Show Welcome Popup
                            showWelcomePopup(_usernameController.text);

                            // Navigasi ke halaman bottom navbar setelah pop-up
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DynamicBottomNavbar(),
                                ),
                                (route) => false,
                              );
                            });
                          } else {
                            displaySnackbar(res.message);
                          }
                        }
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    // Register Link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Belum punya akun? Daftar",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    //untuk halaman admin
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardAdmin(),
                          ),
                        );
                      },
                      child: Text(
                        "Apakah Anda Admin? login",
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
          ),
        ],
      ),
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

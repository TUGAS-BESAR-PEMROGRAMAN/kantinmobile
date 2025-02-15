import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/bottom_navbar.dart';
import 'package:flutter_application_1/screen/dashboard_admin.dart';
import 'package:flutter_application_1/screen/login.dart';
import 'package:flutter_application_1/screen/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/screen/home.dart';

void main() {
  runApp(KantinModernApp());
}

class KantinModernApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: DashboardAdmin(),
    );
  }
}

class HomeScreen extends StatelessWidget {
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

          // Overlay untuk teks agar lebih jelas terbaca
          Container(
            color: Colors.black.withOpacity(0.5),
            width: double.infinity,
            height: double.infinity,
          ),

          // Konten Utama
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront, color: Colors.white, size: 60),
                  SizedBox(height: 10),
                  Text(
                    "Kantin Modern",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nikmati kemudahan berbelanja makanan\ndan minuman favorit Anda!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: "Login",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    text: "Register",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
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

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

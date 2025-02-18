import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_application_1/service/Auth_manager.dart';
import 'package:flutter_application_1/screen/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardUser extends StatefulWidget {
  @override
  _DashboardUserState createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  String loggedInUsername = "User";
  String loggedInRole = "Customer";

  Map<String, dynamic> latestProduct = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUsername = prefs.getString('username') ?? "User";
      loggedInRole = prefs.getString('role') ?? "Customer";
    });
  }

  Future<void> _fetchLatestProduct() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://ats-714220023-serlipariela-38bba14820aa.herokuapp.com/produk'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Assuming the product list is inside a key like 'data'
        if (responseData.containsKey('data')) {
          final List products = responseData['data'];

          if (products.isNotEmpty) {
            // Sort the products by 'created_at' to get the latest one
            products.sort((a, b) => DateTime.parse(b['created_at'])
                .compareTo(DateTime.parse(a['created_at'])));
            setState(() {
              latestProduct = products[0]; // Assign the latest product
            });
          }
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void _showLatestProductDialog() {
    if (latestProduct.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Wah, Ada Produk Baru!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(latestProduct['nama_produk']),
                SizedBox(height: 10),
                Image.network(latestProduct['gambar']),
                SizedBox(height: 10),
                Text('Deskripsi: ${latestProduct['deskripsi']}'),
                Text('Harga: Rp ${latestProduct['harga']}'),
                Text('Stok: ${latestProduct['stok']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await AuthManager.logout();
                Navigator.pushAndRemoveUntil(
                  dialogContext,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 255, 121, 11),
                  Color.fromARGB(255, 255, 179, 0),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  // Bagian atas: Foto, Nama, Role, Logout & Notifikasi
                  Row(
                    children: [
                      // Foto & Nama
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 27,
                                backgroundImage: NetworkImage(
                                    'https://avatars.githubusercontent.com/u/57899334?v=4'),
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi, $loggedInUsername',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    overflow: TextOverflow
                                        .ellipsis, // Handles long text
                                    maxLines: 1,
                                  ),
                                  Text(
                                    '$loggedInRole',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.white),
                                    overflow: TextOverflow
                                        .ellipsis, // Handles long text
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Notifikasi & Logout
                      Row(
                        children: [
                          // Notifikasi Icon
                          InkWell(
                            onTap: () async {
                              // Fetch latest product when tapped
                              await _fetchLatestProduct();
                              _showLatestProductDialog();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.notifications,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                          SizedBox(width: 8),

                          // Logout Button
                          InkWell(
                            onTap: () => _showLogoutConfirmationDialog(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.logout,
                                      color: Colors.white, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    "Logout",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Text(
                    'Welcome!',
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),

                  // Info Menarik
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildInfoCard(
                              Icons.health_and_safety,
                              "Manfaat Makanan Sehat",
                              "Makanan sehat meningkatkan energi, memperkuat imun, dan baik untuk metabolisme tubuh."),
                          _buildInfoCard(
                              Icons.fastfood,
                              "Kenapa Harus Memesan di Kantin Modern?",
                              "Makanan berkualitas, harga terjangkau, dan pelayanan cepat dengan sistem digital."),
                          _buildInfoCard(
                              Icons.fitness_center,
                              "Pentingnya Sarapan Pagi",
                              "Sarapan pagi membantu meningkatkan konsentrasi dan memberi energi untuk beraktivitas."),
                          _buildInfoCard(
                              Icons.local_florist,
                              "Makanan Organik vs Non-Organik",
                              "Makanan organik bebas pestisida dan lebih sehat untuk tubuh."),
                          _buildInfoCard(
                              Icons.access_time,
                              "Kapan Waktu Terbaik Makan?",
                              "Pagi untuk energi, siang untuk nutrisi, dan malam tidak terlalu berat untuk pencernaan."),
                          _buildInfoCard(
                              Icons.local_drink,
                              "Pentingnya Minum Air Putih",
                              "Air putih menjaga keseimbangan cairan tubuh dan membantu metabolisme."),
                        ],
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

  // Fungsi untuk menampilkan notifikasi
  void _showNotification() {
    print("Notifikasi ditekan!");
  }

  // Widget untuk Card Informasi
  Widget _buildInfoCard(IconData icon, String title, String description) {
    return FadeInUp(
      duration: Duration(milliseconds: 500),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.deepOrange, size: 30),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

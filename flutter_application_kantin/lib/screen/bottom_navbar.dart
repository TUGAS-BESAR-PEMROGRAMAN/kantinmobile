import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/about_kantin.dart';
import 'package:flutter_application_1/screen/dashboard_user.dart';
import 'package:flutter_application_1/screen/home.dart';

class DynamicBottomNavbar extends StatefulWidget {
  @override
  _DynamicBottomNavbarState createState() => _DynamicBottomNavbarState();
}

class _DynamicBottomNavbarState extends State<DynamicBottomNavbar> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomeScreenProduk(),
    DashboardUser(),
    AboutKantin()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex], // Menampilkan halaman sesuai index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.orange.shade700,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,
                size: 32, color: Colors.blue), // Perbesar & beri warna biru
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(left: 10), // Mendekatkan ke tengah
              child: Icon(Icons.info, size: 24),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

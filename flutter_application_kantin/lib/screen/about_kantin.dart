import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutKantin extends StatefulWidget {
  @override
  _AboutKantinState createState() => _AboutKantinState();
}

class _AboutKantinState extends State<AboutKantin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                "https://media.istockphoto.com/id/1199215257/id/vektor/anak-anak-di-kantin-membeli-dan-makan-siang-kembali-ke-sekolah-kartun-vektor-terisolasi.jpg?s=612x612&w=0&k=20&c=z32HXhBGfeFGHUL7bhx9b7YHO1ZlGDOePT09WF5PFuY=",
              ),
              SizedBox(height: 20),
              Text(
                'Kantin Modern',
                style: GoogleFonts.pacifico(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Kantin Modern didirikan pada tahun 2021. Kantin ini menyediakan berbagai macam makanan dan minuman yang lezat.',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 30),
              Text(
                'Pencetus Kantin Modern',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Image.network(
                    "https://github.com/qintharganteng.png",
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sang Visioner di Balik Kantin Modern',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Image.network(
                    "https://github.com/serlip06.png",
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pencetus Ide Kantin Modern',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 30),
              ExpansionTile(
                title: Text(
                  'Fasilitas Kami',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Image.network(
                            "https://arsitagx-master-article.s3.ap-southeast-1.amazonaws.com/article-photo/351/3c0e7ce80b321cee01a6812c3b852610.jpg"),
                        SizedBox(height: 10),
                        Image.network(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSis-6oXba9l14V7jIu-Vy4pnj2H8DznfGPDDLNHPldSoOP3MJmjFAOOo7_CwM4LbOKH3c&usqp=CAU"),
                        SizedBox(height: 10),
                        Image.network(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAS2KC1zIZpMfmdXF1TbeLR0ZBtDIcsWGGH7IK4ak-EprwtiqDvul506-8FuwiNCNTYL0&usqp=CAU"),
                        SizedBox(height: 10),
                        Image.network(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0Gr74Cr3SELYcWWKXRtS51XrU-h4Ab-sY2a2hV5o6E15JJj5eejJfA6PiaE3PlZfj3ac&usqp=CAU"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

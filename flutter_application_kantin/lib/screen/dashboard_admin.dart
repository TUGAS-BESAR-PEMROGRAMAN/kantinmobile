import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/model/add_produk.dart';
import 'package:flutter_application_1/service/add_produk_service.dart';
import 'package:flutter_application_1/service/update_delete_produk_service.dart';
// import 'package:flutter_application_1/model/delete_update.produk.dart';

import 'package:flutter_application_1/model/delete_update.produk.dart'
    as UpdateDeleteProduct; // Alias untuk Product dari delete_update.produk.dart

class DashboardAdmin extends StatelessWidget {
  final ProductService productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 191, 42),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 170, 9),
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut, color: Colors.white),
            onPressed: () {
              // Tambahkan fungsi logout di sini
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Manage Your Products',
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 3, 3, 3)),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  children: [
                    _buildCard('', LucideIcons.layout,
                        const Color.fromARGB(255, 0, 140, 255)),
                    _buildCard('Add Product', LucideIcons.plusCircle,
                        const Color.fromARGB(255, 149, 164, 176), context),
                    _buildCard('', LucideIcons.layout, Colors.blue.shade600),
                    _buildCard('', LucideIcons.layout, Colors.blue.shade600),
                  ],
                ),
              ),
            ),
          ),
          // Tambahkan tombol untuk navigasi ke ProductListWidget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print("Navigating to Product List directly");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListWidget(ProdukServices()),
                  ),
                );
              },
              child: Text("Go to Product List"),
            ),
          ),
        ],
      ),
    );
  }
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Text(
  //             'Effortless product management at your fingertips!',
  //             style: GoogleFonts.poppins(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 16,
  //                 color: const Color.fromARGB(255, 0, 0, 0)),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCard(String title, IconData icon, Color color,
      [BuildContext? context]) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color,
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (title == 'Add Product' && context != null) {
            _showAddProductForm(context);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductForm(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController deskripsiController = TextEditingController();
    final TextEditingController hargaController = TextEditingController();
    final TextEditingController gambarController = TextEditingController();
    final TextEditingController stokController = TextEditingController();
    String kategori = 'Makanan';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Product', style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(namaController, 'Nama Produk'),
              _buildTextField(deskripsiController, 'Deskripsi'),
              _buildTextField(hargaController, 'Harga', TextInputType.number),
              _buildTextField(gambarController, 'Gambar URL'),
              _buildTextField(stokController, 'Stok', TextInputType.number),
              DropdownButtonFormField<String>(
                value: kategori,
                items: ['Makanan', 'Minuman']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    kategori = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaController.text.isEmpty ||
                  deskripsiController.text.isEmpty ||
                  hargaController.text.isEmpty ||
                  gambarController.text.isEmpty ||
                  stokController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua kolom harus diisi!')),
                );
                return;
              }

              Product newProduct = Product(
                namaProduk: namaController.text,
                deskripsi: deskripsiController.text,
                harga: double.tryParse(hargaController.text) ?? 0.0,
                gambar: gambarController.text,
                stok: int.tryParse(stokController.text) ?? 0,
                kategori: kategori,
              );

              bool success = await productService.addProduct(newProduct);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Produk "${newProduct.namaProduk}" berhasil ditambahkan! 🎉'
                      : 'Gagal menambahkan produk: ${newProduct.namaProduk}. Pastikan data benar dan coba lagi! ❌'),
                  backgroundColor: success ? Colors.green : Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

// ujicoba

class ProductListWidget extends StatefulWidget {
  final ProdukServices produkService;

  ProductListWidget(this.produkService);

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

// class widgetnya
class _ProductListWidgetState extends State<ProductListWidget> {
  late Future<List<UpdateDeleteProduct.Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = widget.produkService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UpdateDeleteProduct.Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No products available.'));
        }

        List<UpdateDeleteProduct.Product> products = snapshot.data!;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            UpdateDeleteProduct.Product product = products[index];
            return Card(
              child: ListTile(
                leading: Image.network(product.gambar),
                title: Text(product.namaProduk),
                subtitle: Text(product.deskripsi),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditProductForm(context, product);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        widget.produkService
                            .deleteProduct(product.id)
                            .then((success) {
                          if (success) {
                            setState(() {
                              _productsFuture = widget.produkService
                                  .getProducts(); // Refresh data
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Produk berhasil dihapus!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Gagal menghapus produk!')),
                            );
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // untuk form editnya
  void _showEditProductForm(
      BuildContext context, UpdateDeleteProduct.Product product) {
    final TextEditingController namaController =
        TextEditingController(text: product.namaProduk);
    final TextEditingController deskripsiController =
        TextEditingController(text: product.deskripsi);
    final TextEditingController hargaController =
        TextEditingController(text: product.harga.toString());
    final TextEditingController gambarController =
        TextEditingController(text: product.gambar);
    final TextEditingController stokController =
        TextEditingController(text: product.stok.toString());
    String kategori = product.kategori;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Product', style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(namaController, 'Nama Produk'),
              _buildTextField(deskripsiController, 'Deskripsi'),
              _buildTextField(hargaController, 'Harga', TextInputType.number),
              _buildTextField(gambarController, 'Gambar URL'),
              _buildTextField(stokController, 'Stok', TextInputType.number),
              DropdownButtonFormField<String>(
                value: kategori,
                items: ['Makanan', 'Minuman']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    kategori = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaController.text.isEmpty ||
                  deskripsiController.text.isEmpty ||
                  hargaController.text.isEmpty ||
                  gambarController.text.isEmpty ||
                  stokController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua kolom harus diisi!')),
                );
                return;
              }

              UpdateDeleteProduct.Product updatedProduct =
                  UpdateDeleteProduct.Product(
                id: product.id,
                namaProduk: namaController.text,
                deskripsi: deskripsiController.text,
                harga: double.tryParse(hargaController.text) ?? 0.0,
                gambar: gambarController.text,
                stok: int.tryParse(stokController.text) ?? 0,
                kategori: kategori,
              );

              bool success =
                  await widget.produkService.updateProduct(updatedProduct);

              // Tampilkan dialog setelah proses update
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Update Produk', style: GoogleFonts.poppins()),
                    content: Text(
                      success
                          ? 'Produk "${updatedProduct.namaProduk}" berhasil diperbarui! 🎉'
                          : 'Gagal memperbarui produk: ${updatedProduct.namaProduk}. Pastikan data benar dan coba lagi! ❌',
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup dialog
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );

                if (success) {
                  setState(() {
                    _productsFuture =
                        widget.produkService.getProducts(); // Refresh data
                  });
                }
              });
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(BuildContext context, String productId) {
    // Debugging: Pastikan fungsi delete dipanggil
    print("Deleting product with id: $productId");

    widget.produkService.deleteProduct(productId).then((success) {
      // Debugging: Pastikan status success atau gagal
      print("Delete success: $success");

      // Tampilkan dialog setelah proses delete selesai
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pop(context); // Tutup dialog delete jika ada

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Produk', style: GoogleFonts.poppins()),
            content: Text(
              success
                  ? 'Produk berhasil dihapus! 🎉'
                  : 'Gagal menghapus produk! ❌',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Jika berhasil, refresh data produk di UI
        if (success) {
          setState(() {
            _productsFuture =
                widget.produkService.getProducts(); // Refresh data
          });
        }
      });
    }).catchError((e) {
      print("Error deleting product: $e"); // Menangani error jika ada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat menghapus produk!')),
      );
    });
  }

  // Menambahkan fungsi _buildTextField di luar _showEditProductForm
  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

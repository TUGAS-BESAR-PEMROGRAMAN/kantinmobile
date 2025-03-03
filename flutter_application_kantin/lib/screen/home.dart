import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenProduk extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenProduk>
    with SingleTickerProviderStateMixin {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  late TabController _tabController;
  String loggedInUsername = "User";
  ValueNotifier<int> cartCountNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(filterProducts);
    _loadUsername();
    _loadCartCount();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUsername = prefs.getString('username') ?? "User";
    });
  }

  Future<void> _loadCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];
    cartCountNotifier.value = cart.length;
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'https://ats-714220023-serlipariela-38bba14820aa.herokuapp.com/produk'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        products = jsonData["data"];
        filterProducts();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterProducts() {
    if (!mounted) return;
    String kategoriDipilih = _tabController.index == 0 ? "Makanan" : "Minuman";
    setState(() {
      filteredProducts = products
          .where((item) => item["kategori"] == kategoriDipilih)
          .toList();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(filterProducts);
    _tabController.dispose();
    cartCountNotifier.dispose();
    super.dispose();
  }

  // Show Cart Modal (Popup)
  void _showCartPopup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Your Cart"),
          content: Container(
            width: double.maxFinite,
            height: 300, // Set a fixed height for the list
            child: cart.isEmpty
                ? Center(child: Text("Your cart is empty."))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      var product = jsonDecode(cart[index]);
                      return ListTile(
                        leading: Image.network(
                          product["gambar"],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product["nama_produk"]),
                        subtitle: Text("Rp ${product["harga"]}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            cart.removeAt(index);
                            await prefs.setStringList('cart', cart);
                            cartCountNotifier.value = cart.length;
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hi, $loggedInUsername",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.orange.shade700,
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: cartCountNotifier,
            builder: (context, cartCount, _) {
              return IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.shopping_cart),
                    if (cartCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$cartCount',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: _showCartPopup, // Show cart popup
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://st.depositphotos.com/30046358/54948/v/1600/depositphotos_549486786-stock-illustration-happy-kids-dining-table-semi.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.orange.shade700,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: Colors.orange.shade700,
                    tabs: [
                      Tab(text: "Makanan 🍛"),
                      Tab(text: "Minuman 🥤"),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        var product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onCartUpdated: _loadCartCount,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onCartUpdated;

  ProductCard({required this.product, required this.onCartUpdated});

  Future<void> _addToCart(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];
    cart.add(jsonEncode(product));
    await prefs.setStringList('cart', cart);

    onCartUpdated(); // Update the cart count when an item is added

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product["nama_produk"]} ditambahkan ke keranjang!"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              product["gambar"],
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 120),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product["nama_produk"],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  "Rp ${product["harga"]}",
                  style: GoogleFonts.poppins(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.orange.shade700),
            onPressed: () => _addToCart(context),
          ),
        ],
      ),
    );
  }
}

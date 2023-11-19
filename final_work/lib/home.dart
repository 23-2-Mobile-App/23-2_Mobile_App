import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'model/model_item_provider.dart';
import 'model/model_product.dart';
import 'model/model_wish.dart';
import 'model/model_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {

  FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider();

  String _selectedOrder = 'asc'; // Default to ascending order
  List<Product> products = [];
  bool _isMounted = false; // Add this variable


  @override
  void initState() {
    super.initState();
    _isMounted = true;

    // Listen to changes in authentication state
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // If the authentication state changes and the widget is still mounted, rebuild the widget
      if (_isMounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false; // Set it to false when the widget is disposed
    super.dispose();
  }

  Future<List<Widget>> _buildGridCards(BuildContext context) async {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    List<Product> products = await productProvider.fetchProducts(_selectedOrder);
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

    if (products.isEmpty) {
      return <Widget>[]; // 빈 리스트를 반환합니다.
    }
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    List<Widget> cards = [];
    for (Product product in products) {
      bool isInWishlist = await wishlistProvider.isItemInWishlist(product.id, _firebaseAuthProvider.currentUser?.uid ?? '');
      Widget card = Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 18 / 11,
                  child: Image.network(product.imgUrl),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        product.description,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatter.format(product.price),
                      style: TextStyle(fontSize: 14),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detailPage',
                          arguments: product,
                        );
                      },
                      child: Text(
                        'more',
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: isInWishlist
                  ? Icon(
                Icons.check_box,
                color: Colors.green,
              )
                  : SizedBox(), // Display checkbox only if the item is in the wishlist
            ),
          ],
        ),
      );
      cards.add(card); // 생성된 Card 위젯을 리스트에 추가합니다.
    }
    return cards; // Card 위젯이 담긴 리스트를 반환합니다.
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context,productProvider, child) {
        return Consumer<WishlistProvider>(
          builder: (context,wishlistProvider,child) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.account_circle, // 프로필 아이콘
                          semanticLabel: 'profile',
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/profilePage');
                        },
                      ),
                      SizedBox(width: 130,),
                      Text('Main'),
                    ],
                  ),
                  actions: <Widget>[
                    // DropdownButton for selecting sort order
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/wishlistPage');
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, '/addPage');
                        Navigator.pushNamed(context, '/map');
                      },
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    DropdownButton<String>(
                      value: _selectedOrder,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOrder = newValue!;
                        });
                      },
                      items: <String>['asc', 'desc']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('Price $value'),
                        );
                      }).toList(),
                    ),
                   Expanded(
                      child: FutureBuilder<List<Widget>>(
                        future: _buildGridCards(context),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            // Handle the error
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Return a loading indicator while waiting for the data
                            return CircularProgressIndicator();
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            // Return an empty state if there's no data
                            return Text('No data available');
                          }
                          // Return the GridView with the data
                          return Consumer<FirebaseAuthProvider>(
                            builder: (context,provider,child) {
                              return Consumer<ProductProvider>(
                                builder: (context,productProvider,child) {
                                  return Consumer<WishlistProvider>(
                                    builder: (context,wishlistProvider,_) {
                                      return GridView.count(
                                        crossAxisCount: 2,
                                        padding: const EdgeInsets.all(16.0),
                                        childAspectRatio: 8.0 / 9.0,
                                        children: snapshot.data!,
                                      );
                                    }
                                  );
                                }
                              );
                            }
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
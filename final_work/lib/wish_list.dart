import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/model_product.dart';
import 'model/model_wish.dart';




class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  _WishListPageState createState() => _WishListPageState();
}
class _WishListPageState extends State<WishListPage> {
  @override
  Widget build(BuildContext context) {
    const title = 'Favorite Hotels';
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('WIshList'),
    leading: IconButton(
    icon: Icon(Icons.cancel),
    onPressed: () {
    Navigator.of(context).pop(); // 뒤로 가기 기능 추가

    },
    )
      ),
      body: FutureBuilder<List<Product>>(
        future: wishlistProvider.loadWishlistProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items in wishlist'));
          } else {
            return Consumer<WishlistProvider>(
              builder: (context,wishlistProvider,_) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Product product = snapshot.data![index];
                    return ListTile(
                      leading: Image.network(product.imgUrl),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(product.name),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await wishlistProvider.removeFromWishlist(product.id);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(product.description),
                    );
                  },
                );
              }
            );
          }
        },
      ),
    );
  }
}

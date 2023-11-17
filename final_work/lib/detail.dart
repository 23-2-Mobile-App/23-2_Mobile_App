import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'model/model_product.dart';
import 'model/model_item_provider.dart';
import 'model/model_auth.dart';
import 'model/model_wish.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorited = false;
  bool _likeButtonEnabled = true;
  bool _isInWishlist = false;
  int flag = 0;

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)!.settings.arguments as Product;

    // final productProvider = context.read<ProductProvider>();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final firebaseAuthProvider = context.read<FirebaseAuthProvider>();
    // final wishlistProvider = context.read<WishlistProvider>();
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

    User? currentUser = firebaseAuthProvider.currentUser;

    Future<bool> checkIfUserLikedProduct(String productId, String userId) async {
      try {
        DocumentSnapshot likeDocument = await FirebaseFirestore.instance
            .collection('product')
            .doc(productId)
            .collection('like_list')
            .doc(userId)
            .get();

        return likeDocument.exists;
      } catch (e) {
        print('Error checking if user liked product: $e');
        // 에러 처리 또는 사용자에게 메시지를 보여줄 수 있습니다.
        throw e;
      }
    }

    Future<void> _updateFavoriteState() async {
      final userId = context.read<FirebaseAuthProvider>().currentUser?.uid ?? '';
      bool userLikedProduct = await checkIfUserLikedProduct(product.id, userId);
      if(mounted){
        setState(() {
          _isFavorited = userLikedProduct;
        });
      }
    }

    Future<void> _toggleFavorite() async {
      if (_likeButtonEnabled) {
        final userId = context.read<FirebaseAuthProvider>().currentUser?.uid ?? '';

        if (await checkIfUserLikedProduct(product.id, userId)) {
          if(mounted){
            setState(() {
              _isFavorited = true;
            });
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You can only do it once!')),
          );
        } else {
          try {
            // If the user has not liked the product yet, add the like and update the like list
            product.like += 1;
            _isFavorited = true;

            // Update the product's like count
            await FirebaseFirestore.instance
                .collection('product')
                .doc(product.id)
                .update({'like': product.like});

            // Add the user's ID to the like_list collection
            await FirebaseFirestore.instance
                .collection('product')
                .doc(product.id)
                .collection('like_list')
                .doc(userId)
                .set({'user_id': userId});
            if(mounted){
              setState(() {
                _isFavorited = true;
              });
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('I LIKE IT!')),
            );
          } catch (e) {
            print('Error toggling favorite: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to like the product')),
            );
          }
        }
      }
    }

    void _editProduct() {
      if (currentUser?.uid == product.uid) {
        Navigator.pushNamed(
          context,
          '/editPage',
          arguments: product,
        );
      }
    }


    void _deleteProduct() async {
      if (currentUser?.uid == product.uid) {
        try {
          await context.read<ProductProvider>().deleteProduct(product.id);
          Navigator.pop(context);
        } catch (e) {
          print('Error deleting product: $e');
          // Handle the error as needed
        }
      }
    }

    String formatDate(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }

    Future<void> _toggleWishlist() async {
      try {
        bool isInWishlist = await wishlistProvider.checkIfUserInWishlist(product.id);
        print(isInWishlist);
        if (isInWishlist) {
          wishlistProvider.removeFromWishlist(product.id);
        } else {
          wishlistProvider.addToWishlist(product.id);
        }

        setState(() {
          _isInWishlist = !isInWishlist;
        });
      } catch (e) {
        print('Error toggling wishlist: $e');
        // Handle the error as needed
      }
    }

    Future<void> _updateWishList_state() async {
       _isInWishlist = await wishlistProvider.checkIfUserInWishlist(product.id);
    }

    if(flag == 0){
      _updateFavoriteState();
      _updateWishList_state();
      print("init");
      flag = 1;
    }
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Detail'),
              SizedBox(width: 8.0),
              // Edit 아이콘 추가
              if (currentUser?.uid == product.uid)
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _editProduct,
                ),
              // Delete 아이콘 추가
              if (currentUser?.uid == product.uid)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteProduct,
                ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(
          children: [
            Image.network(product.imgUrl),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.centerRight,
                          icon: (_isFavorited
                              ? const Icon(Icons.thumb_up, color: Colors.red)
                              : const Icon(Icons.thumb_up, color: Colors.blue)),
                          color: Colors.yellow[500],
                          onPressed: () {
                            _toggleFavorite();
                          },
                        ),
                        Text(
                          '${product.like}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    Text(
                      product.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Price: ${product.price}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Description: ${product.description}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'creater: ${product.uid}',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '${formatDate(product.date)} created',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 8.0),
                    if (product.modified_date != '')
                      Text(
                        '${formatDate(product.modified_date)} Modified',
                        style: TextStyle(fontSize: 15),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleWishlist,
        child: _isInWishlist
            ? Icon(Icons.check) // Icon when in wishlist
            : Icon(Icons.shopping_cart), // Icon when not in wishlist
      ),
      );
  }

}

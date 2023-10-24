import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hotelprovider.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hotelProvider = Provider.of<HotelProvider>(context);
    final favoriteHotels = hotelProvider.hotels.where((hotel) => hotel.isSaved).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Favorite Hotels',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: favoriteHotels.length,
        itemBuilder: (context, index) {
          final hotel = favoriteHotels[index];
          return Dismissible(
            key: Key(hotel.id.toString()), // Use a unique key for each item
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onDismissed: (direction) {
              hotel.isSaved = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${hotel.name} removed from favorites"),
                ),
              );
            },
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 16.0), // Add left padding
                child: Text(
                  hotel.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Make text bold
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

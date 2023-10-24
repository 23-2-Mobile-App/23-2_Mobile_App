import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'hotelprovider.dart';
import 'model/product.dart';

class HotelDetailPage extends StatelessWidget {
  final Hotel hotel;

  HotelDetailPage({required this.hotel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hotelProvider = context.watch<HotelProvider>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onDoubleTap: () => hotelProvider.toggleFavoriteStatus(hotel.id),
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Hero(
                    tag: 'hotel_image_${hotel.id}',
                    child: Image.asset(
                      hotel.imageUrl,
                      fit: BoxFit.cover,
                      height: 300.0,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16, right: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        hotelProvider.favoriteStatus(hotel.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 24.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 15.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: List.generate(
                      hotel.starRating.round(),
                          (index) => Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 24.0,
                      ),
                    ),
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  const SizedBox(height: 10.0),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        hotel.name,
                        textStyle: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 8.0),
                      Text(hotel.location),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.phone, color: Colors.blue),
                      const SizedBox(width: 8.0),
                      Text(hotel.phoneNumber ?? ''), // Handle null value gracefully
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                      height: 2.0,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${hotel.description}',
                    style: const TextStyle(fontSize: 16.0),
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

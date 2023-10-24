import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'hotelprovider.dart';
import 'model/product.dart';
import 'model/products_repository.dart';

class MyPagePage extends StatelessWidget {
  final String name = "Youngkwan Cho";
  final String studentID = "21900706";
  List<Hotel> allHotels = ProductsRepository.loadHotels();

  @override
  Widget build(BuildContext context) {
    final hotelProvider = Provider.of<HotelProvider>(context);
    final favoriteHotels =
    hotelProvider.hotels.where((hotel) => hotel.isSaved).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'My Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipOval(
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      child: Lottie.asset('assets/me1.json'),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    '$name',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('$studentID'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Favorite Hotel List',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: favoriteHotels.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: favoriteHotels[index]);
                  },
                  child: Card(
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          favoriteHotels[index].imageUrl,
                          fit: BoxFit.cover,
                          height: 200.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.black54,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favoriteHotels[index].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                favoriteHotels[index].location,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

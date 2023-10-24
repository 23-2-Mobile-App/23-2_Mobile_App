import 'package:flutter/material.dart';
import 'model/product.dart';
import 'model/products_repository.dart';

class HotelProvider with ChangeNotifier {
  final List<Hotel> _hotels = ProductsRepository.loadHotels();

  List<Hotel> get hotels => _hotels;

  void toggleFavoriteStatus(int hotelId) {
    final hotel = _hotels.firstWhere((h) => h.id == hotelId);
    hotel.isSaved = !hotel.isSaved;
    notifyListeners();
  }

  bool favoriteStatus(int hotelId) {
    final hotel = _hotels.firstWhere((h) => h.id == hotelId);
    return hotel.isSaved;
  }
}
class Hotel {
  final int id;
  final String imageUrl;
  final String name;
  final double starRating;
  final String location;
  final String description;
  final String phoneNumber;
  bool isSaved;

  Hotel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.starRating,
    required this.location,
    required this.description,
    required this.phoneNumber,
    required this.isSaved,
  });
}

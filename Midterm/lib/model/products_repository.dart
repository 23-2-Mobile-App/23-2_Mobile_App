import 'package:shrine/model/product.dart';

class ProductsRepository {
  static List<Hotel> loadHotels() {
    return <Hotel>[
      Hotel(
        id: 0,
        name: 'Hotel A',
        starRating: 4.5,
        location: 'Location A', isSaved: false,
        imageUrl: 'assets/a.jpeg', description: 'O say can you see, by the dawn’s early light, What so proudly we hail’d at the twilight’s last gleaming, Whose broad stripes and bright stars through the perilous fight O’er the ramparts we watch’d were so gallantly streaming? And the rocket’s red glare, the bombs bursting in air, Gave proof through the night that our flag was still there, O say does that star-spangled banner yet wave O’er the land of the free and the home of the brave?', phoneNumber: '01012345678',
      ),
      Hotel(
        id: 1,
        name: 'Hotel B',
        starRating: 3.8,
        location: 'Location B', isSaved: false,
        imageUrl: 'assets/b.jpeg', description: 'O say can you see, by the dawn’s early light, What so proudly we hail’d at the twilight’s last gleaming, Whose broad stripes and bright stars through the perilous fight O’er the ramparts we watch’d were so gallantly streaming? And the rocket’s red glare, the bombs bursting in air, Gave proof through the night that our flag was still there, O say does that star-spangled banner yet wave O’er the land of the free and the home of the brave?', phoneNumber: '01012345678',
      ),
      Hotel(
        id: 2,
        name: 'Hotel C',
        starRating: 4.5,
        location: 'Location C', isSaved: false,
        imageUrl: 'assets/c.jpeg', description: 'O say can you see, by the dawn’s early light, What so proudly we hail’d at the twilight’s last gleaming, Whose broad stripes and bright stars through the perilous fight O’er the ramparts we watch’d were so gallantly streaming? And the rocket’s red glare, the bombs bursting in air, Gave proof through the night that our flag was still there, O say does that star-spangled banner yet wave O’er the land of the free and the home of the brave?', phoneNumber: '01012345678',
      ),
      Hotel(
        id: 3,
        name: 'Hotel D',
        starRating: 4.5,
        location: 'Location D', isSaved: false,
        imageUrl: 'assets/d.jpeg', description: 'O say can you see, by the dawn’s early light, What so proudly we hail’d at the twilight’s last gleaming, Whose broad stripes and bright stars through the perilous fight O’er the ramparts we watch’d were so gallantly streaming? And the rocket’s red glare, the bombs bursting in air, Gave proof through the night that our flag was still there, O say does that star-spangled banner yet wave O’er the land of the free and the home of the brave?', phoneNumber: '01012345678',
      ),
      Hotel(
        id: 4,
        name: 'Hotel E',
        starRating: 4.5,
        location: 'Location E', isSaved: false,
        imageUrl: 'assets/e.jpg', description: 'O say can you see, by the dawn’s early light, What so proudly we hail’d at the twilight’s last gleaming, Whose broad stripes and bright stars through the perilous fight O’er the ramparts we watch’d were so gallantly streaming? And the rocket’s red glare, the bombs bursting in air, Gave proof through the night that our flag was still there, O say does that star-spangled banner yet wave O’er the land of the free and the home of the brave?', phoneNumber: '01012345678',
      ),
      Hotel(
        id: 5,
        name: 'Hotel F',
        starRating: 4.5,
        location: 'Location F', isSaved: false,
        imageUrl: 'assets/f.jpg', description: 'O say can you see, by the dawn’s early light, What so proudly we hail’d at the twilight’s last gleaming, Whose broad stripes and bright stars through the perilous fight O’er the ramparts we watch’d were so gallantly streaming? And the rocket’s red glare, the bombs bursting in air, Gave proof through the night that our flag was still there, O say does that star-spangled banner yet wave O’er the land of the free and the home of the brave?', phoneNumber: '01012345678',
      ),
    ];
  }
}

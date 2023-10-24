import 'package:flutter/material.dart';
import 'model/product.dart';
import 'model/products_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGridView = true;

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Hotel> hotels = ProductsRepository.loadHotels();
    final ThemeData theme = Theme.of(context);
    List<bool> isSelected = [_isGridView, !_isGridView];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                semanticLabel: 'menu',
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Main',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.language,
              semanticLabel: 'language',
              color: Colors.white,
            ),
            onPressed: () {
              _launchURL('https://www.handong.edu');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: const Center(
                child: Text(
                  'Pages',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
            ),
            _buildDrawerTile(Icons.home, 'Home', '/home'),
            _buildDrawerTile(Icons.search, 'Search', '/search'),
            _buildDrawerTile(Icons.location_city, 'Favorite Hotels', '/favorite'),
            _buildDrawerTile(Icons.person, 'My Page', '/mypage'),
            _buildDrawerTile(Icons.logout, 'Logout', '/login'),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ToggleButtons(
                children: const <Widget>[
                  Icon(Icons.list_outlined),
                  Icon(Icons.grid_view),
                ],
                isSelected: [!_isGridView, _isGridView],
                onPressed: (int index) {
                  setState(() {
                    _isGridView = index == 1;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: OrientationBuilder(
              builder: (context, orientation) {
                final int crossAxisCount =
                orientation == Orientation.portrait ? 2 : 3;
                return isSelected[0]
                    ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 8.0 / 9.0,
                  ),
                  itemBuilder: (context, index) {
                    return _buildCard(
                      theme,
                      hotels[index],
                    );
                  },
                  itemCount: hotels.length,
                )
                    : ListView.builder(
                  itemBuilder: (context, index) {
                    return _buildCard(
                      theme,
                      hotels[index],
                    );
                  },
                  itemCount: hotels.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
ListTile _buildDrawerTile(IconData icon, String title, String route) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.pop(context);
      Navigator.pushNamed(context, route);
    },
  );
}
Widget _buildCard(ThemeData theme, Hotel hotel) {
  if (_isGridView) {
    // Return the Card for GridView
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Hero(
                tag: 'hotel_image_${hotel.id}',
                child: Image.asset(
                  hotel.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 18,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 8.0),
                        Row(
                          children: List.generate(
                            hotel.starRating.round(),
                                (index) => Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          hotel.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          hotel.location,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: const Text(
                    "more",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: hotel);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } else {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Hero(
                tag: 'hotel_image_${hotel.id}',
                child: Image.asset(
                  hotel.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: List.generate(
                        hotel.starRating.round(),
                            (index) => Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      hotel.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      hotel.location,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        child: const Text(
                          "more",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/detail', arguments: hotel);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
}
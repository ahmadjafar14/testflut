import 'package:flutter/material.dart';
// import 'package:testflutter/widgets/ProfilePage.dart';
import '../widgets/ProfilePage.dart';
import '../widgets/MakananPage.dart';
import '../widgets/MinumanPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Remove 'const' from the List of pages
  static List<Widget> _pages = <Widget>[
    // Makanan Page with a ListView
    Center(
      child: MakananPage(),
    ),
    Center(child: MinumanPage()),
    Center(child: Profilepage()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('ssddd',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text('email@exampsdaaaaaaaaaaaaaaaale.com',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ExpansionTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              children: [
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Privacy'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Language'),
                  onTap: () {},
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal_sharp),
            label: 'Makanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink_sharp),
            label: 'Minuman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:testflutter/models/Menus.dart';
import 'package:testflutter/services/ApiService.dart';

class MinumanPage extends StatefulWidget {
  @override
  _MinumanPageState createState() => _MinumanPageState();
}

class _MinumanPageState extends State<MinumanPage> {
  List<Menu> _minumanItems = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _loadMakanan();
  }

  Future<void> _loadMakanan() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      if (!mounted) return;
      final data = await ApiService().fetchMenus("makanan");
      setState(() {
        _minumanItems = data;
        _loading = false;
      });
    } catch (e) {
      print("Error fetching makanan: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 10.0, // Horizontal spacing between items
        mainAxisSpacing: 10.0, // Vertical spacing between items
      ),
      itemCount: _minumanItems.length,
      itemBuilder: (context, index) {
        final menu = _minumanItems[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content horizontally
            children: [
              Icon(
                Icons.local_drink,
                size: 50, // Set the size of the icon
                color: Colors.blue, // Change the color of the icon
              ),
              SizedBox(
                  height: 8.0), // Add some spacing between the icon and text
              Text(
                menu.name,
                style: TextStyle(
                  fontSize: 16, // Set font size for the text
                  fontWeight: FontWeight.bold, // Make the text bold
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

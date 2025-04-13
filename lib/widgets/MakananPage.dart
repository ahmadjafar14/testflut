import 'package:flutter/material.dart';
import 'package:testflutter/models/Menus.dart';
import 'package:testflutter/services/ApiService.dart';

class MakananPage extends StatefulWidget {
  @override
  _MakananPageState createState() => _MakananPageState();
}

class _MakananPageState extends State<MakananPage> {
  List<Menu> _makananItems = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _loadMakanan();
  }

  Future<void> _loadMakanan() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      if (!mounted) return; // Penting: cek kalau widget masih aktif
      final data = await ApiService().fetchMenus("makanan");
      setState(() {
        _makananItems = data;
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
    return ListView.builder(
      itemCount: _makananItems.length,
      itemBuilder: (context, index) {
        final menu = _makananItems[index];
        return ListTile(
          leading: Image.network(
            menu.img,
            width: 50,
            height: 50,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child; // Menampilkan gambar jika sudah selesai dimuat
              } else {
                return Center(
                    child:
                        CircularProgressIndicator()); // Menampilkan progress saat gambar dimuat
              }
            },
            errorBuilder: (context, error, stackTrace) => Icon(Icons.fastfood),
          ),
          title: Text(menu.name),
          onTap: () {
            // Handle tap
          },
        );
      },
    );
  }
}

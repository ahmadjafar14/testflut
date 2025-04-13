class Menu {
  final int id;
  final String name;
  final String kategori;
  final String img;

  Menu({required this.id, required this.name, required this.kategori, required this.img});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      kategori: json['kategori'],
      img: json['img'],
    );
  }
}

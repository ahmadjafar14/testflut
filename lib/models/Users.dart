class Users {
  final String username;
  final String password;
  final String fullname;
  final String email;
  final String tgllahir;
  final String gender;
  final String nohp;
  final String alamat;

  Users({
    required this.username,
    required this.password,
    required this.fullname,
    required this.email,
    required this.tgllahir,
    required this.gender,
    required this.nohp,
    required this.alamat,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "password_confirmation": password,
      "fullname": fullname,
      "email": email,
      "tgllahir": tgllahir,
      "gender": gender,
      "nohp": nohp,
      "alamat": alamat,
    };
  }
}

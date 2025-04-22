import 'package:dio/dio.dart';
import 'package:testflutter/models/Menus.dart';
import 'package:testflutter/models/Users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api/'));

  Future<Response> fetchUserData(String token) async {
    try {
      _dio.options.headers = {'Authorization': 'Bearer $token'};
      final response = await _dio.get('user');
      return response;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<List<Menu>> fetchMenus(String type) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        throw Exception('No token found. Please login first.');
      }
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('menus');
      List<Menu> allMenus =
          (response.data as List).map((item) => Menu.fromJson(item)).toList();
      return allMenus.where((menu) => menu.kategori == type).toList();
      // return menus;
    } catch (e) {
      throw Exception('Failed to load menus: $e');
    }
  }

  Future<Response> registerUser(Users user) async {
    try {
      final response = await _dio.post(
        'register',
        data: user.toJson(),
      );
      return response;
    } on DioException catch (e) {
      return e.response ??
          Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 500,
            data: {"message": "Terjadi kesalahan"},
          );
    }
  }

  Future<Response> loginUser(String email, String password) async {
    try {
      final response = await _dio.post(
        'login',
        data: {
          'email': email,
          'password': password,
        },
      );
      // print(response.data['token']);
      // print(response.statusCode);

      return response;
    } on DioException catch (e) {
      // Jika terjadi error pada saat request, lempar exception atau kembalikan error
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage: 'Error saat login: ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<Response?> logoutUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        print("User is not logged in");
        return null;
      }
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await _dio.post('logout');
      return response;
    } on DioException catch (e) {
      // Jika terjadi error pada saat request, lempar exception atau kembalikan error
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage: 'Error saat login: ${e.response?.data ?? e.message}',
      );
    }
  }
}

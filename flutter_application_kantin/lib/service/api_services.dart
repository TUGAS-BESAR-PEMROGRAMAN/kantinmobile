import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/handler_model.dart'; // import model login dan register

class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl =
      'https://ats-714220023-serlipariela-38bba14820aa.herokuapp.com';

  // Fungsi untuk login
  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await dio.post(
        '$_baseUrl/login',
        data: login.toJson(),
      );

      if (response.statusCode == 200 &&
          response.data['message'] == 'Login successful') {
        return LoginResponse.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return LoginResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Fungsi untuk register
  Future<RegisterResponse?> register(RegisterInput registerInput) async {
    try {
      final response = await dio.post(
        '$_baseUrl/register',
        data: registerInput.toJson(),
      );

      if (response.statusCode == 201 &&
          response.data['message'] == 'Registration successful') {
        return RegisterResponse.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 201) {
        debugPrint('Client error - the request cannot be fulfilled');
        return RegisterResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert'; 
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'is_logged_in'; 
  static const String _keyUsername = 'username'; 
  static const String _keyPassword = 'password'; 

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password); 
    return sha256.convert(bytes).toString();
  } 

  // register
  static Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance(); 

    final cekUser = prefs.getString(_keyUsername); 
    if(cekUser != null) 
    {
      return false;
    } 

    await prefs.setString(_keyUsername, username); 
    await prefs.setString(_keyPassword, _hashPassword(password));
    return true;
  } 
  // login 
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance(); 

    final savedUsername = prefs.getString(_keyUsername);
    final savedPassword = prefs.getString(_keyPassword); 

    if(savedUsername == username && savedPassword == _hashPassword(password)) {
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    }
    return false;
  }
  // logout 
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance(); 
    await prefs.setBool(_keyIsLoggedIn, false);
  }
  // cek login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance(); 
    return prefs.getBool(_keyIsLoggedIn)??false;
  }
  // get usn
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance(); 
    return prefs.getString(_keyUsername);
  }
}
import 'package:notchy/models/address_model.dart';
import 'package:notchy/models/name_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  int? id;
  String? email;
  String? phone;
  String? phoneCode;
  String? username;
  NameModel? name;
  AddressModel? address;

  UserModel(
      {this.phone,
      this.id,
      this.name,
      this.email,
      this.address,
      this.phoneCode,
      this.username});

  UserModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    phone = json['phone'];
    email = json['email'];
    address = AddressModel.fromMap(json['address']);
    name = NameModel.fromMap(json['name']);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'phone': phone,
      'email': email,
      'name': name?.toMap(),
      'address': address?.toMap(),
    };
  }

  static Future<String?> get getToken async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
}

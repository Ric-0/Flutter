import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<Map<String, dynamic>> _userData;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _pseudoContoller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userData = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> cartDataList = jsonData['users'];
      final cartData = cartDataList[Random().nextInt(cartDataList.length)];
      return cartData;
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _pseudoContoller.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon compte"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data!;
            _firstNameController.text = userData['firstName'];
            _lastNameController.text = userData['lastName'];
            _pseudoContoller.text = userData['username'];
            _emailController.text = userData['email'];
            _phoneController.text = userData['phone'];
            _addressController.text = userData['address']['address'];
            _postalCodeController.text = userData['address']['postalCode'];
            _cityController.text = userData['address']['city'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Mon compte",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        userData['image'],
                        width: 300,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: TextField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'Prénom',
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: TextField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Nom',
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: TextField(
                                controller: _pseudoContoller,
                                decoration: InputDecoration(
                                  labelText: 'Pseudo',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: TextField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  labelText: 'Numéro de téléphone',
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 32),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: TextField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                  labelText: 'Adresse',
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: TextField(
                                controller: _postalCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Code Postal',
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: TextField(
                                controller: _cityController,
                                decoration: InputDecoration(
                                  labelText: 'Ville',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

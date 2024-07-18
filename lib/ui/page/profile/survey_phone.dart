import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurveyPhonePage_ extends StatefulWidget {
  @override
  _SurveyPhonePageState createState() => _SurveyPhonePageState();
}

class _SurveyPhonePageState extends State<SurveyPhonePage_> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final url = Uri.parse('http://localhost:8080/api/users/1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _phoneController.text = data['emergencyContact'] ?? '';
      });
    } else {
      print('Failed to load user data.');
    }
  }

  Future<void> _updateEmergencyContact() async {
    final url = Uri.parse(
      'http://localhost:8080/api/users/1?fieldName=emergencyContact&fieldValue=${_phoneController.text}',
    );
    final response = await http.patch(url);

    if (response.statusCode == 200) {
      print('Emergency contact updated successfully.');
    } else {
      print('Failed to update emergency contact.');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '긴급 연락처 수정하기',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '부모님 연락처나 긴급 연락처를 알려주세요.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: '전화번호를 입력하세요',
              ),
            ),
            SizedBox(height: 16),
            PrimaryButton(
              text: '수정',
              onPressed: () {
                _updateEmergencyContact();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

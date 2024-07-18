import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurveyBirthPage_ extends StatefulWidget {
  @override
  _SurveyBirthPageState createState() => _SurveyBirthPageState();
}

class _SurveyBirthPageState extends State<SurveyBirthPage_> {
  final TextEditingController _birthController = TextEditingController();

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
        _birthController.text = data['birthdate'] ?? '';
      });
    } else {
      print('Failed to load user data.');
    }
  }

  Future<void> _updateBirthdate() async {
    final url = Uri.parse(
      'http://localhost:8080/api/users/1?fieldName=birthdate&fieldValue=${_birthController.text}',
    );
    final response = await http.patch(url);

    if (response.statusCode == 200) {
      print('Birthdate updated successfully.');
    } else {
      print('Failed to update birthdate.');
    }
  }

  @override
  void dispose() {
    _birthController.dispose();
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
              '생년월일 수정하기',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '생년월일이 언제인가요?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _birthController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'XXXX년 XX월 XX일',
              ),
            ),
            SizedBox(height: 16),
            PrimaryButton(
              text: '수정',
              onPressed: () {
                _updateBirthdate();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

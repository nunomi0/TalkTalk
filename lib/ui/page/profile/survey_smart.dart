import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurveySmartPage_ extends StatefulWidget {
  @override
  _SurveySmartPageState createState() => _SurveySmartPageState();
}

class _SurveySmartPageState extends State<SurveySmartPage_> {
  final TextEditingController _smartController = TextEditingController();

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
        _smartController.text = data['educationLevel'] ?? '';
      });
    } else {
      print('Failed to load user data.');
    }
  }

  Future<void> _updateEducationLevel() async {
    final url = Uri.parse(
      'http://localhost:8080/api/users/1?fieldName=educationLevel&fieldValue=${_smartController.text}',
    );
    final response = await http.patch(url);

    if (response.statusCode == 200) {
      print('Education level updated successfully.');
    } else {
      print('Failed to update education level.');
    }
  }

  @override
  void dispose() {
    _smartController.dispose();
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
              '학습 수준 수정하기',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '몇 학년 공부까지 이해하고 있나요?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _smartController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'ex) 초등학교 6학년',
              ),
            ),
            SizedBox(height: 16),
            PrimaryButton(
              text: '수정',
              onPressed: () {
                _updateEducationLevel();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

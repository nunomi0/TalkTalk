import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurveyLikePage_ extends StatefulWidget {
  @override
  _SurveyLikePageState createState() => _SurveyLikePageState();
}

class _SurveyLikePageState extends State<SurveyLikePage_> {
  final TextEditingController _likeController = TextEditingController();

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
        _likeController.text = data['interests'] ?? '';
      });
    } else {
      print('Failed to load user data.');
    }
  }

  Future<void> _updateInterests() async {
    final url = Uri.parse(
      'http://localhost:8080/api/users/1?fieldName=interests&fieldValue=${_likeController.text}',
    );
    final response = await http.patch(url);

    if (response.statusCode == 200) {
      print('Interests updated successfully.');
    } else {
      print('Failed to update interests.');
    }
  }

  @override
  void dispose() {
    _likeController.dispose();
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
              '관심사 수정하기',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '좋아하는 것을 입력해주세요.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _likeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'ex) 운동, 음악, 수학, 미술, 독서 ...',
              ),
            ),
            SizedBox(height: 16),
            PrimaryButton(
              text: '수정',
              onPressed: () {
                _updateInterests();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

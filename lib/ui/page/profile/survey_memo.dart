import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SurveyMemoPage_ extends StatefulWidget {
  @override
  _SurveyMemoPageState createState() => _SurveyMemoPageState();
}

class _SurveyMemoPageState extends State<SurveyMemoPage_> {
  final TextEditingController _memoController = TextEditingController();

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
        _memoController.text = data['additionalInfo'] ?? '';
      });
    } else {
      print('Failed to load user data.');
    }
  }

  Future<void> _updateAdditionalInfo() async {
    final url = Uri.parse(
      'http://localhost:8080/api/users/1?fieldName=additionalInfo&fieldValue=${_memoController.text}',
    );
    final response = await http.patch(url);

    if (response.statusCode == 200) {
      print('Additional info updated successfully.');
    } else {
      print('Failed to update additional info.');
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
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
              '기타 특이사항 수정하기',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '특별히 도움이 필요한 부분이 있나요? 자유롭게 알려주세요.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _memoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: '특이사항을 입력하세요',
              ),
            ),
            SizedBox(height: 16),
            PrimaryButton(
              text: '수정',
              onPressed: () {
                _updateAdditionalInfo();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

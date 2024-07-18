import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';

class SurveyPhonePage extends StatefulWidget {
  @override
  _SurveyPhonePageState createState() => _SurveyPhonePageState();
}

class _SurveyPhonePageState extends State<SurveyPhonePage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LinearProgressIndicator(value: 3/6, color: Color(0xFF006FFD)),
            SizedBox(height: 32),
            Text(
              '간단한 질문을 몇 가지 해볼게요.',
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
              text: '다음',
              onPressed: () {
                Navigator.pushNamed(context, '/survey_smart');
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';

class SurveyBirthPage extends StatefulWidget {
  @override
  _SurveyBirthPageState createState() => _SurveyBirthPageState();
}

class _SurveyBirthPageState extends State<SurveyBirthPage> {
  final TextEditingController _birthController = TextEditingController();

  @override
  void dispose() {
    _birthController.dispose();
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
            LinearProgressIndicator(value: 2/6, color: Color(0xFF006FFD)),
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
              text: '다음',
              onPressed: () {
                Navigator.pushNamed(context, '/survey_phone');
              },
            ),
          ],
        ),
      ),
    );
  }
}

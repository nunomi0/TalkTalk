import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';

class SurveySmartPage extends StatefulWidget {
  @override
  _SurveySmartPageState createState() => _SurveySmartPageState();
}

class _SurveySmartPageState extends State<SurveySmartPage> {
  final TextEditingController _smartController = TextEditingController();

  @override
  void dispose() {
    _smartController.dispose();
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
            LinearProgressIndicator(value: 4/6, color: Color(0xFF006FFD)),
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
              text: '다음',
              onPressed: () {
                Navigator.pushNamed(context, '/survey_like');
              },
            ),
          ],
        ),
      ),
    );
  }
}

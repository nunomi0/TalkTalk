import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';

class SurveyMemoPage extends StatefulWidget {
  @override
  _SurveyMemoPageState createState() => _SurveyMemoPageState();
}

class _SurveyMemoPageState extends State<SurveyMemoPage> {
  final TextEditingController _memoController = TextEditingController();

  @override
  void dispose() {
    _memoController.dispose();
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
            LinearProgressIndicator(value: 6/7, color: Color(0xFF006FFD)),
            SizedBox(height: 32),
            Text(
              '마지막 질문이에요!',
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
              text: '다음',
              onPressed: () {
                Navigator.pushNamed(context, '/survey_complete');
              },
            ),
          ],
        ),
      ),
    );
  }
}

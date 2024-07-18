import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';

class SurveyCompletePage_ extends StatefulWidget {
  @override
  _SurveyCompletePageState createState() => _SurveyCompletePageState();
}

class _SurveyCompletePageState extends State<SurveyCompletePage_> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LinearProgressIndicator(value: 7/7, color: Color(0xFF006FFD)),
            SizedBox(height: 32),
            Text(
              '수고했어요, 답변을 완료했어요!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '답변은 내 정보에서 다시 확인하고 수정할 수 있어요.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            PrimaryButton(
              text: '홈으로 이동',
              onPressed: () {
                Navigator.pop(context);
                },
            ),
          ],
        ),
      ),
    );
  }
}

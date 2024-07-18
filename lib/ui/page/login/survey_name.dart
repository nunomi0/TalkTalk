import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/widgets/button/primary_button.dart';

class SurveyNamePage extends StatefulWidget {
  @override
  _SurveyNamePageState createState() => _SurveyNamePageState();
}

class _SurveyNamePageState extends State<SurveyNamePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
            LinearProgressIndicator(value: 1/6, color: Color(0xFF006FFD)),
            SizedBox(height: 32),
            Text(
              '환영합니다!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '이름을 알려주세요.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: '자신의 이름을 입력하세요',
              ),
            ),
            SizedBox(height: 16),
            PrimaryButton(
              text: '다음',
              onPressed: () {
                Navigator.pushNamed(context, '/survey_birth');
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:talktalk/resource/config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleSignIn() async {
    final url = '${Config.baseUrl}/oauth2/authorization/google';
    try {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: false,
          forceWebView: false,
        );
        // 로그인 완료 후에 설문 페이지로 이동
        // 실제로는 로그인 완료 콜백을 처리하는 로직이 추가되어야 합니다.
        // 여기서는 예시로 간단하게 딜레이를 주고 이동하는 방식으로 처리합니다.
        await Future.delayed(Duration(seconds: 5));
        Navigator.pushReplacementNamed(context, '/survey_name');
      } else {
        throw 'Could not launch $url';
      }
    } catch (error) {
      print('Error initiating Google Sign-In: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.highlightDarkest,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '톡톡이',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '톡톡이와 함께, 매일 즐겁게 성장해요!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Image.asset('assets/images/google.png', height: 24), // Add Google icon
                label: Text(
                  'Google 로그인',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                onPressed: _handleSignIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

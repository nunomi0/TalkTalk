import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';
import 'package:talktalk/widgets/text_field.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:talktalk/widgets/button/secondary_button.dart';
import 'package:talktalk/ui/page/login/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktalk/resource/config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _errorMessage = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var url = Uri.parse('${Config.baseUrl}/api/v1/users/login');

      var requestBody = jsonEncode(<String, String>{
        'email': _username,
        'password': _password
      });

      print('Request URL: $url');
      print('Request Headers: {\'Content-Type\': \'application/json; charset=UTF-8\'}');
      print('Request Body (UTF-8): ${utf8.decode(requestBody.codeUnits)}');

      try {
        var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestBody,
        );

        var decodedResponse = utf8.decode(response.bodyBytes);
        print('Response Status Code: ${response.statusCode}');
        print('Response Body (UTF-8): $decodedResponse');

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(decodedResponse);
          String accessToken = jsonResponse['data']['accessToken'] ?? '';

          if (accessToken.isNotEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('accessToken', accessToken);

            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          } else {
            setState(() {
              _errorMessage = 'Invalid access token received.';
            });
          }
        } else {
          var jsonResponse = jsonDecode(decodedResponse);
          setState(() {
            _errorMessage = jsonResponse['msg'];
          });
          print('Login failed: ${jsonResponse['msg']}');
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred: $e';
        });
        print('An error occurred: $e');
      }
    }
  }

  void _navigateToRegister() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인', style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '로그인',
                        style: AppTextStyles.headingH1.copyWith(color: AppColors.neutralDarkDarkest),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Log in to TalkTalk',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
                      ),
                      SizedBox(height: 32.0),
                      CustomTextField(
                        controller: TextEditingController(),
                        label: '아이디',
                        hint: '이메일 형식의 아이디를 입력하세요',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        onSaved: (value) => _username = value!,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: TextEditingController(),
                        label: '비밀번호',
                        hint: '비밀번호를 입력하세요',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),
                      SizedBox(height: 16),
                      if (_errorMessage.isNotEmpty) ...[
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                      ],
                      SizedBox(height: 32),
                      PrimaryButton(
                        text: '로그인',
                        onPressed: _login,
                      ),
                      SecondaryButton(
                        text: '회원가입',
                        onPressed: _navigateToRegister,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
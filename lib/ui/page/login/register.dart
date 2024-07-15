import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';
import 'package:talktalk/widgets/text_field.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:talktalk/ui/page/login/login.dart';
import 'package:talktalk/resource/config.dart';
import 'package:talktalk/widgets/dialog.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var url = Uri.parse('${Config.baseUrl}/api/v1/users/new');

      var requestBody = jsonEncode(<String, String>{
        'nickName': _nicknameController.text,
        'email': _usernameController.text,
        'password': _passwordController.text,
        'role': 'ADMIN'
      });

      // Log the request in UTF-8
      print('Request URL: $url');
      print('Request Headers: {\'Content-Type\': \'application/json; charset=UTF-8\'}');
      print('Request Body (UTF-8): ${utf8.decode(requestBody.codeUnits)}');

      var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      // Log the response in UTF-8
      var decodedResponse = utf8.decode(response.bodyBytes);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body (UTF-8): $decodedResponse');

      var jsonResponse = jsonDecode(decodedResponse);

      if (response.statusCode == 200) {
        CustomAlertDialog.showCustomDialog(
          context: context,
          title: '회원가입 완료',
          content: '회원가입을 완료하였습니다. 로그인 페이지로 이동합니다.',
          cancelButtonText: '',
          confirmButtonText: '확인',
          onConfirm: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        );
      } else {
        CustomAlertDialog.showCustomDialog(
          context: context,
          title: '회원가입 실패 ',
          content: '${jsonResponse['message'] ?? '오류가 발생하였습니다.'}',
          cancelButtonText: '',
          confirmButtonText: '재시도',
          onConfirm: () {
          },
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                '회원가입',
                style: AppTextStyles.headingH1.copyWith(color: AppColors.neutralDarkDarkest),
                textAlign: TextAlign.center, // Center text
              ),
              SizedBox(height: 10),
              Text(
                'Sign up for TalkTalk',
                textAlign: TextAlign.center, // Center text alignment
                style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
              ),
              SizedBox(height: 32),
              CustomTextField(
                controller: _nicknameController,
                label: '이름 (닉네임)',
                hint: '닉네임 입력',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your nickname';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _usernameController,
                label: '아이디',
                hint: '이메일 형식의 아이디를 입력하세요',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                label: '비밀번호',
                hint: '비밀번호를 입력하세요',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해야 합니다';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _confirmPasswordController,
                label: '비밀번호 확인',
                hint: '비밀번호를 다시 입력하세요',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호 확인을 입력하세요';
                  } else if (_passwordController.text != value) {
                    return '비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              PrimaryButton(
                text: '회원가입',
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
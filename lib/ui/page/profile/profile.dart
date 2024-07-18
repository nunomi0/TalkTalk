import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';
import 'package:talktalk/widgets/dialog.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:talktalk/widgets/button/secondary_button.dart';
import 'package:talktalk/ui/page/login/login.dart';
import 'package:talktalk/ui/page/profile/survey_name.dart';
import 'package:talktalk/ui/page/profile/survey_birth.dart';
import 'package:talktalk/ui/page/profile/survey_phone.dart';
import 'package:talktalk/ui/page/profile/survey_smart.dart';
import 'package:talktalk/ui/page/profile/survey_like.dart';
import 'package:talktalk/ui/page/profile/survey_memo.dart';
import 'package:talktalk/ui/page/profile/survey_complete.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:talktalk/resource/config.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = true;
  String nickname = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetailsById(1); // ID 1의 사용자 정보 가져오기
  }

  Future<void> _fetchUserDetailsById(int id) async {
    try {
      var url = Uri.parse('${Config.baseUrl}/api/users/$id');
      var response = await http.get(url);

      print('Request URL: $url');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        print('User Details: $jsonResponse');
        setState(() {
          nickname = jsonResponse['name'];
        });
      } else {
        print('Failed to load user details for ID $id');
      }
    } catch (e) {
      print('Error fetching user details for ID $id: $e');
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', 'guest');
    setState(() {
      isLoggedIn = false;
      nickname = '';
    });
  }

  void _showLogoutDialog(BuildContext context) {
    CustomAlertDialog.showCustomDialog(
      context: context,
      title: '로그아웃',
      content: '로그아웃 하시겠습니까? 앱을 이용하기 위해선 다시 로그인 해야합니다.',
      cancelButtonText: '취소',
      confirmButtonText: '로그아웃',
      onConfirm: () {
        _logout();
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 정보',
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: SvgPicture.asset(
                    'assets/icons/avatar.svg',
                    width: 80,
                    height: 80,
                  ),
                ),
                Text(
                  '환영합니다!',
                  style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest),
                ),
                Text(
                  nickname,
                  style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                ),
              ],
            ),
          ),
          _buildTile(context, '생년월일', SurveyBirthPage_()),
          _buildTile(context, '긴급 연락처', SurveyPhonePage_()),
          _buildTile(context, '학습 수준', SurveySmartPage_()),
          _buildTile(context, '관심사', SurveyLikePage_()),
          _buildTile(context, '기타 특이사항', SurveyMemoPage_()),
          ListTile(
            title: Text('로그아웃', style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest)),
            trailing: SvgPicture.asset(
              'assets/icons/arrow_right.svg',
              width: 12,
              height: 12,
              color: AppColors.neutralDarkLightest,
            ),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, Widget destinationPage) {
    return ListTile(
      title: Text(title, style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest)),
      trailing: SvgPicture.asset(
          'assets/icons/arrow_right.svg',
          width: 12,
          height: 12,
          color: AppColors.neutralDarkLightest),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => destinationPage));
      },
    );
  }
}

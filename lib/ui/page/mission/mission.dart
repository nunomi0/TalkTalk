import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';
import 'package:talktalk/widgets/card.dart';
import 'package:talktalk/ui/page/chat/chat.dart';
import 'package:talktalk/ui/page/mission/sort_dropdown.dart';
import 'package:talktalk/widgets/list_item.dart';
import 'package:talktalk/widgets/mission_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:talktalk/resource/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktalk/widgets/dialog.dart';

class MissionPage extends StatefulWidget {
  final String pageTitle;

  const MissionPage({
    Key? key,
    this.pageTitle = '미션',
  }) : super(key: key);

  @override
  _MissionPageState createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  List<dynamic> _missions = [];
  bool _isLoading = true;
  int userId = 0;

  int currentStep1 = 2;
  int currentStep2 = 0;
  int currentStep3 = 1;

  final String missionDescription1 = "커피포트의 전원 플러그를 끈 후 물을 1/3 정도 넣고 버튼을 눌러 끓이세요.";
  final String missionDescription2 = "친구들에게 친절히 대하고 대화를 나누어 보세요.";
  final String missionDescription3 = "국어 숙제를 완성하세요.";

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken != null && accessToken.isNotEmpty && accessToken != 'guest') {
      try {
        var url = Uri.parse('${Config.baseUrl}/api/v1/users/myPage');
        var response = await http.get(url, headers: {
          'Authorization': 'Bearer $accessToken',
        });

        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${utf8.decode(response.bodyBytes)}');

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
          setState(() {
            userId = jsonResponse['data']['userId'];
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error fetching user details: $e');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMissionCard(String title, String description, int currentStep, int totalSteps, int missionId, VoidCallback onComplete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MissionCard(
          missionTitle: title,
          missionDescription: description,
          currentStep: currentStep,
          totalSteps: totalSteps,
          missionId: missionId,
          onComplete: onComplete,
        );
      },
    );
  }

  void _showCongratulatoryPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('축하합니다!'),
          content: Text('모든 단계를 완료했습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _completeMissionStep(int missionId, String title, List<String> descriptions, int currentStep) {
    int stepsRemaining = 3 - currentStep;

    for (int i = 0; i < stepsRemaining; i++) {
      _showMissionCard(
        title,
        descriptions[currentStep],
        currentStep+i+1,
        3,
        missionId,
            () {
          setState(() {
            if (currentStep + i + 1 < 3) {
              currentStep++;
            } else {
              _showCongratulatoryPopup();
            }
            Navigator.of(context).pop(); // 팝업 닫기
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pageTitle,
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            ContentSwitcher(),
            SizedBox(height: 20),
            ListItem(
              title: '컵라면 끓이기',
              subtitle: '$currentStep1/3 완료',
              onTap: () => _completeMissionStep(
                1,
                '컵라면 끓이기',
                [missionDescription1, missionDescription1, missionDescription1],
                currentStep1,
              ),
            ),
            ListItem(
              title: '친구들과 친하게 지내기',
              subtitle: '$currentStep2/3 완료',
              onTap: () => _completeMissionStep(
                2,
                '친구들과 친하게 지내기',
                [missionDescription2, missionDescription2, missionDescription2],
                currentStep2,
              ),
            ),
            ListItem(
              title: '국어 숙제하기',
              subtitle: '$currentStep3/3 완료',
              onTap: () => _completeMissionStep(
                3,
                '국어 숙제하기',
                [missionDescription3, missionDescription3, missionDescription3],
                currentStep3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentSwitcher extends StatefulWidget {
  @override
  _ContentSwitcherState createState() => _ContentSwitcherState();
}

class _ContentSwitcherState extends State<ContentSwitcher> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5FA), // 바깥쪽 배경색
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _buildSegmentButton("진행 중", 0)),
          Expanded(child: _buildSegmentButton("완료", 1)),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String text, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Color(0xFFF5F5FA), // 선택된 경우 배경색
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.transparent)
              : Border.all(color: Color(0xFFF5F5FA)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

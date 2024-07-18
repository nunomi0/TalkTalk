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
        return Dialog(
          child: Container(
            width: 400,
            height: 400,
            child: MissionCard(
              missionTitle: title,
              missionDescription: description,
              currentStep: currentStep,
              totalSteps: totalSteps,
              missionId: missionId,
              onComplete: onComplete,
            ),
          ),
        );
      },
    );
  }

  void _showCongratulatoryPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 200,
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('축하합니다!', style: AppTextStyles.headingH4),
                SizedBox(height: 16.0),
                Text('모든 단계를 완료했습니다.', textAlign: TextAlign.center),
                SizedBox(height: 24.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 팝업 닫기
                  },
                  child: Text('확인'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _completeMissionStep(int missionId, String title, List<String> descriptions, int currentStep) {
    int stepsRemaining = 3 - currentStep;

    for (int i = stepsRemaining; i >= 0; i--) {
      print(3-i);
      print('#');
      _showMissionCard(
        title,
        descriptions[currentStep+i-1],
        currentStep+i,
        3,
        missionId,
            () {
            Navigator.of(context).pop();
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
              title: '학교 숙제를 어떻게 해야 할지 모르겠어요.',
              subtitle: '$currentStep1/3 완료',
              onTap: () => _completeMissionStep(
                1,
                '학교 숙제하기',
                ['숙제 문제를 천천히 읽고, 이해되지 않는 부분에 밑줄을 그으세요.\n모르는 단어는 사전을 사용해 보세요.', '표시한 부분을 선생님이나 부모님께 보여드리고, 설명을 부탁하세요.\n인터넷 검색을 통해 추가 자료를 찾아보는 것도 도움이 됩니다.', '숙제를 작은 부분으로 나누어, 한 번에 하나씩 해결하세요.\n문제를 풀 때 필요한 도구(연필, 지우개, 참고서 등)를 준비하세요.'],
                currentStep1,
              ),
            ),
            ListItem(
              title: '친구와 싸웠을 때 어떻게 해야 하나요?',
              subtitle: '$currentStep2/3 완료',
              onTap: () => _completeMissionStep(
                2,
                '친구들과 싸웠을 때',
                ['친구에게 다가가 "미안해"라고 진심으로 사과하세요.\n상황이 어렵다면 먼저 편지로 마음을 전하는 것도 좋습니다.', '싸운 이유를 차분히 설명하고, 친구의 이야기를 들어주세요.\n서로의 입장을 이해하려고 노력하세요.', '서로의 감정을 존중하고, 함께 해결책을 찾아보세요.\n좋아하는 활동인 게임을 같이 하면서 화해해보세요.'],
                currentStep2,
              ),
            ),
            ListItem(
              title: '무서운 꿈을 꿨어요, 어떻게 해야 해요?',
              subtitle: '$currentStep3/3 완료',
              onTap: () => _completeMissionStep(
                3,
                '무서운 꿈을 꾼 후',
                ['잠에서 깬 후, 무서운 꿈은 현실이 아니며 금방 사라질 것이라고 생각하세요.\n창문을 열어 환기를 시키면 기분이 나아질 수 있어요.', '좋아하는 해리포터 시리즈를 읽거나, 평소 듣던 재즈 음악을 들으며 마음을 진정시키세요.\n깊게 숨을 들이쉬고 천천히 내쉬는 호흡법을 사용해보세요.', '부모님이나 믿을 수 있는 사람에게 꿈 이야기를 하세요. 정민이가 적절할 수도 있겠네요.\n이야기를 나누면 불안감이 줄어들고, 더 편안해질 수 있습니다.'],
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

import 'package:flutter/material.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';
import 'package:talktalk/widgets/card.dart';
import 'package:talktalk/ui/page/chat/chat.dart';
import 'package:talktalk/ui/page/mission/sort_dropdown.dart';
import 'package:talktalk/widgets/list_item.dart';
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
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<MissionPage> {
  late String _sortingCriteria;
  List<String> _sortingOptions = ['최신순'];

  List<dynamic> _recipes = [];
  bool _isLoading = true;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _sortingCriteria = '최신순';
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
          fetchRecipes(accessToken);
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

  Future<void> fetchRecipes(String accessToken) async {
    String endpoint = '${Config.baseUrl}/api/v1/recipes/all';

    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      String responseBody = utf8.decode(response.bodyBytes);
      print(responseBody);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        List<dynamic> recipes = jsonResponse['data'];

        if (_sortingCriteria == '최신순') {
          recipes.sort((a, b) {
            DateTime dateA = DateTime(a['createdAt'][0], a['createdAt'][1], a['createdAt'][2], a['createdAt'][3], a['createdAt'][4], a['createdAt'][5], a['createdAt'][6]);
            DateTime dateB = DateTime(b['createdAt'][0], b['createdAt'][1], b['createdAt'][2], b['createdAt'][3], b['createdAt'][4], b['createdAt'][5], b['createdAt'][6]);
            return dateB.compareTo(dateA);
          });
        } else if (_sortingCriteria == '좋아요순') {
          recipes.sort((a, b) => b['likes'].compareTo(a['likes']));
        }

        setState(() {
          _recipes = recipes;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching recipes: $e');
    }
  }

  void _showDialog(String title, String content) {
    CustomAlertDialog.showCustomDialog(
      context: context,
      title: title,
      content: content,
      cancelButtonText: '취소',
      confirmButtonText: '확인',
      onConfirm: () {
        print('Confirmed!');
      },
    );
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
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SortingDropdown(
                    value: _sortingCriteria,
                    options: _sortingOptions,
                    onChanged: (newValue) {
                      setState(() {
                        _sortingCriteria = newValue!;
                        _isLoading = true;
                        SharedPreferences.getInstance().then((prefs) {
                          String? accessToken = prefs.getString('accessToken');
                          if (accessToken != null && accessToken.isNotEmpty) {
                            fetchRecipes(accessToken);
                          }
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListItem(
              title: '컵라면 끓이기',
              subtitle: '1/3 완료',
              onTap: () => _showDialog('컵라면 끓이기', '컵라면 끓이기를 선택하셨습니다.'),
            ),
            ListItem(
              title: '친구들과 친하게 지내기',
              subtitle: '0/3 완료',
              onTap: () => _showDialog('친구들과 친하게 지내기', '친구들과 친하게 지내기를 선택하셨습니다.'),
            ),
            ListItem(
              title: '국어 숙제하기',
              subtitle: '0/3 완료',
              onTap: () => _showDialog('국어 숙제하기', '국어 숙제하기를 선택하셨습니다.'),
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

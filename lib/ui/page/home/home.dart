import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';
import 'package:talktalk/widgets/button/primary_button.dart';
import 'package:talktalk/resource/config.dart';
import 'package:talktalk/widgets/dialog.dart';
import 'package:talktalk/ui/page/chat/chat.dart';
import 'package:talktalk/ui/page/mission/mission.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:talktalk/widgets/card.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToPage;
  HomeScreen({Key? key, this.onNavigateToPage}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(viewportFraction: 1);
  double _currentPage = 0;
  final _bannerImages = [
    'assets/banners/banner1.png',
    'assets/banners/banner2.png',
    'assets/banners/banner3.png'
  ];
  List<dynamic> _recipes = [];
  List<Map<String, dynamic>> _fridgeItems = [];
  bool _isLoadingRecipes = true;
  bool _isLoadingFridge = true;
  bool _isErrorRecipes = false;
  bool _isErrorFridge = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!;
        });
      }
    });
    fetchRecipes();
    fetchFridgeItems();
  }

  Future<void> fetchRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/v1/recipes/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> recipes =
        json.decode(utf8.decode(response.bodyBytes))['data'];
        recipes.sort((a, b) {
          DateTime dateA = DateTime(
              a['createdAt'][0],
              a['createdAt'][1],
              a['createdAt'][2],
              a['createdAt'][3],
              a['createdAt'][4],
              a['createdAt'][5],
              a['createdAt'][6]);
          DateTime dateB = DateTime(
              b['createdAt'][0],
              b['createdAt'][1],
              b['createdAt'][2],
              b['createdAt'][3],
              b['createdAt'][4],
              b['createdAt'][5],
              b['createdAt'][6]);
          return dateB.compareTo(dateA);
        });
        setState(() {
          _recipes = recipes.take(5).toList();
          _isLoadingRecipes = false;
        });
      } else {
        setState(() {
          _isErrorRecipes = true;
          _isLoadingRecipes = false;
        });
      }
    } catch (e) {
      setState(() {
        _isErrorRecipes = true;
        _isLoadingRecipes = false;
      });
    }
  }

  Future<void> fetchFridgeItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/v1/ingredients/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        List<dynamic> ingredients = jsonResponse['data'];
        setState(() {
          _fridgeItems = ingredients.map((ingredient) {
            return {
              "id": ingredient['id'],
              "title": ingredient['name'] ?? 'Unknown',
              "expiryDate": ingredient['expirationDate'] ?? 'Unknown',
              "quantity": ingredient['quantity'] ?? 'Unknown',
              "imageUrl": ingredient['imageURL'] ?? 'assets/images/img.png',
            };
          }).toList();
          _isLoadingFridge = false;
        });
      } else {
        setState(() {
          _isErrorFridge = true;
          _isLoadingFridge = false;
        });
      }
    } catch (e) {
      setState(() {
        _isErrorFridge = true;
        _isLoadingFridge = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '톡톡이(TalkTalk)',
          style:
          AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _bannerImages.length,
                itemBuilder: (context, index) => Image.asset(
                  _bannerImages[index],
                  fit: BoxFit.cover,
                ),
                physics: ClampingScrollPhysics(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DotsIndicator(
                dotsCount: _bannerImages.length,
                position: _currentPage.round(),
                decorator: DotsDecorator(
                  activeColor: AppColors.highlightDarkest,
                ),
              ),
            ),
            SizedBox(height: 32),
            _buildSectionTitle(context, '톡톡이에게 질문하기', ChatPage(),
                onTap: () {
                  widget.onNavigateToPage?.call(1);
                }),
            _isLoadingFridge
                ? Center(child: CircularProgressIndicator())
                : _fridgeItems.isEmpty
                ? _buildHorizontalListForFridge()
                : _buildHorizontalListForFridgeFromAPI(),
            SizedBox(height: 32),
            _buildSectionTitle(context, '진행 중인 미션', MissionPage(),
                onTap: () {
                  widget.onNavigateToPage?.call(2);
                }),
            _isLoadingRecipes
                ? Center(child: CircularProgressIndicator())
                : _recipes.isEmpty
                ? _buildHorizontalListForRecipe()
                : _buildHorizontalListForRecipeFromAPI(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Widget destinationPage, {Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
          ),
          GestureDetector(
            onTap: onTap ?? () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => destinationPage));
            },
            child: Text(
              '더보기',
              style: AppTextStyles.actionM.copyWith(color: AppColors.highlightDarkest),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListForRecipe() {
    return Container(
      height: 189,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5 + 2,
        itemBuilder: (context, index) {
          if (index == 0 || index == 6) {
            return SizedBox(width: 8);
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(),
                ),
              );
            },
            child: SizedBox(
              width: 189,
              height: 189,
              child: CustomCard(
                title: '임시타이틀',
                subtitle: '부제목',
                imageUrl: 'assets/images/img.png',
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 8),
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  Widget _buildHorizontalListForRecipeFromAPI() {
    return Container(
      height: 189,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _recipes.length + 2,
        itemBuilder: (context, index) {
          if (index == 0 || index == _recipes.length + 1) {
            return SizedBox(width: 4);
          }
          var recipe = _recipes[index - 1];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 189,
              height: 189,
              child: CustomCard(
                title: recipe['name'] ?? '제목 없음',
                subtitle: recipe['content'] ?? '설명 없음',
                imageUrl: recipe['imageURL'] ?? 'assets/images/img.png',
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 8),
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  Widget _buildHorizontalListForFridge() {
    return Container(
      height: 189,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5+2,
        itemBuilder: (context, index) {
          if (index == 0 || index == 6) {
            return SizedBox(width: 4);
          }
          return GestureDetector(
            child: SizedBox(
              width: 189,
              height: 189,
              child: CustomCard(
                title: '임시 질문',
                subtitle: '질문하러가기',
                imageUrl: 'assets/images/img.png',
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 8),
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  Widget _buildHorizontalListForFridgeFromAPI() {
    final latestFridgeItems = _fridgeItems.reversed.take(5).toList();
    return Container(
      height: 189,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: latestFridgeItems.length + 2,
        itemBuilder: (context, index) {
          if (index == 0 || index == latestFridgeItems.length + 1) {
            return SizedBox(width: 4);
          }
          var item = latestFridgeItems[index - 1];
          return GestureDetector(
            child: SizedBox(
              width: 189,
              height: 189,
              child: CustomCard(
                title: '소비기한 : ${item['expiryDate']}',
                subtitle: '${item['title']} ${item['quantity']}',
                imageUrl: item['imageUrl'] ?? 'assets/images/mushroom.jpg',
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 8),
        physics: ClampingScrollPhysics(),
      ),
    );
  }
}
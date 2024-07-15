import 'package:flutter/material.dart';
import 'package:talktalk/ui/page/chat/chat.dart';
import 'package:talktalk/ui/page/home/home.dart';
import 'package:talktalk/ui/page/login/login.dart';
import 'package:talktalk/ui/page/mission/mission.dart';
import 'package:talktalk/ui/page/profile/profile.dart';
import 'package:talktalk/ui/theme/color.dart';
import 'package:talktalk/ui/theme/text_styles.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:talktalk/ui/page/chat/chat_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: 'assets/config/.env');
    print("환경 변수가 로드되었습니다");
    print("Loaded API Key: ${dotenv.env['OPENAI_API_KEY']}");
    print("Loaded API Key: ${dotenv.env['BASE_URL']}");
    runApp(MyApp());
  } catch (e) {
    print("Failed to load .env file: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatController()),
      ],
      child: MaterialApp(
        title: '톡톡이(TalkTalk)',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: AppColors.highlightDarkest,
          splashColor: Colors.transparent,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/login': (context) => LoginPage(),
          '/profile': (context) => ProfilePage(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> _getWidgetOptions() {
    return [
      HomeScreen(onNavigateToPage: (index) {
        _onItemTapped(index);
      }),
      ChatPage(),
      MissionPage(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getWidgetOptions().elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '메인',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: '미션',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '내 정보',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.highlightDarkest,
        unselectedItemColor: AppColors.neutralLightDark,
        selectedLabelStyle: TextStyle(color: AppColors.neutralDarkDarkest),
        unselectedLabelStyle: TextStyle(color: AppColors.neutralDarkLight),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

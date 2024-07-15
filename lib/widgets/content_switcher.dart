import 'package:flutter/material.dart';

class ContentSwitcher extends StatefulWidget {
  @override
  _ContentSwitcherState createState() => _ContentSwitcherState();
}

class _ContentSwitcherState extends State<ContentSwitcher> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5FA), // 바깥쪽 배경색
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSegmentButton("진행 중", 0),
          _buildSegmentButton("미션", 1),
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
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Content Switcher',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Content Switcher Example'),
        ),
        body: Center(
          child: ContentSwitcher(),
        ),
      ),
    );
  }
}






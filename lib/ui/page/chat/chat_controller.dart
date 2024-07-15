import 'package:flutter/material.dart';
import 'package:talktalk/ui/page/chat/chat_contents.dart';

class ChatController extends ChangeNotifier {
  /* Variables */
  List<Chat> chatList = Chat.generate();

  /* Controllers */
  late final ScrollController scrollController = ScrollController();
  late final TextEditingController textEditingController = TextEditingController();
  late final FocusNode focusNode = FocusNode();

  /* Intents */
  Future<void> onFieldSubmitted() async {
    if (!isTextFieldEnable) return;

    // 1. chat list에 첫 번째 배열 위치에 put
    chatList = [
      ...chatList,
      Chat.sent(message: textEditingController.text),
    ];

    // 2. 스크롤 최적화 위치
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    textEditingController.text = '';
    notifyListeners();
  }

  void onFieldChanged(String term) {
    notifyListeners();
  }

  /* Getters */
  bool get isTextFieldEnable => textEditingController.text.isNotEmpty;
}

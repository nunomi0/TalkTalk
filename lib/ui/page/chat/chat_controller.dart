import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talktalk/ui/page/chat/chat_contents.dart';
import 'package:talktalk/ui/page/chat/chat_message_type.dart';
import 'package:talktalk/resource/config.dart';

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

    final message = textEditingController.text.trim();
    textEditingController.clear();
    notifyListeners();

    // Add user's message to chat list
    chatList = [
      ...chatList,
      Chat.sent(message: message),
    ];

    // Scroll to the latest message
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();

    // Send message to chatbot and handle the response
    await _sendMessageToChatBot(message);
  }

  void onFieldChanged(String term) {
    notifyListeners();
  }

  /* Getters */
  bool get isTextFieldEnable => textEditingController.text.isNotEmpty;

  Future<void> _sendMessageToChatBot(String message) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/openai?prompt=$message&userId=1'),
      );

      if (response.statusCode == 200) {
        final body = response.body;

        if (body.contains('Type: Chat')) {
          // Extract content after "Content: "
          final contentIndex = body.indexOf('Content: ');
          if (contentIndex != -1) {
            var content = body.substring(contentIndex + 9).trim();

            // Truncate at " Mission1:" if present
            final missionIndex = content.indexOf(' Mission1:');
            if (missionIndex != -1) {
              content = content.substring(0, missionIndex).trim();
            }

            chatList = [
              ...chatList,
              Chat(
                message: content,
                type: ChatMessageType.received,
                time: DateTime.now(),
              ),
            ];
          } else {
            chatList = [
              ...chatList,
              Chat(
                message: 'Error: Content not found',
                type: ChatMessageType.received,
                time: DateTime.now(),
              ),
            ];
          }
        } else if (body.contains('Type: Mission')) {
          final contentIndex = body.indexOf('Content: ');
          if (contentIndex != -1) {
            var content = body.substring(contentIndex + 9).trim();

            // Truncate at " Mission1:" if present
            final missionIndex = content.indexOf(' Mission1:');
            if (missionIndex != -1) {
              content = content.substring(0, missionIndex).trim();
            }

            chatList = [
              ...chatList,
              Chat(
                message: '[$content] 미션을 받았습니다. 미션 탭에서 확인해보세요!',
                type: ChatMessageType.received,
                time: DateTime.now(),
              ),
            ];
          } else {
            chatList = [
              ...chatList,
              Chat(
                message: 'Error: Content not found',
                type: ChatMessageType.received,
                time: DateTime.now(),
              ),
            ];
          }
        } else {
          chatList = [
            ...chatList,
            Chat(
              message: 'Error: Invalid response type',
              type: ChatMessageType.received,
              time: DateTime.now(),
            ),
          ];
        }
      } else {
        chatList = [
          ...chatList,
          Chat(
            message: 'Error: ${response.statusCode}',
            type: ChatMessageType.received,
            time: DateTime.now(),
          ),
        ];
      }
    } catch (e) {

      chatList = [
        ...chatList,
        Chat(
          message: 'Error: $e',
          type: ChatMessageType.received,
          time: DateTime.now(),
        ),
      ];
    }

    notifyListeners();

    // Scroll to the latest message
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

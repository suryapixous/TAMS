import 'package:flutter/material.dart';

class ChatDataStore {
  // Singleton pattern
  static final ChatDataStore _instance = ChatDataStore._internal();
  factory ChatDataStore() => _instance;
  ChatDataStore._internal();

  final Map<String, List<String>> _chats =
      {}; // Stores messages for each person

  void addMessage(String personName, String message) {
    if (_chats[personName] == null) {
      _chats[personName] = [];
    }
    _chats[personName]!.add(message);
  }

  List<String> getMessages(String personName) {
    return _chats[personName] ?? [];
  }

  Map<String, List<String>> getAllChats() {
    return _chats;
  }
}

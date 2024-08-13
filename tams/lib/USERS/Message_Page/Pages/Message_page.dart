import 'package:flutter/material.dart';
import '../../../chat_data_store.dart';

class MessagingPage extends StatefulWidget {
  final String personName;

  MessagingPage({required this.personName});

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  AnimationController? _animationController;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(Duration(seconds: 1)); // Simulate a delay

      ChatDataStore().addMessage(widget.personName, message);
      _messageController.clear();

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ChatDataStore().getMessages(widget.personName);
    final themeColor = _isDarkMode ? Colors.black : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final backButtonColor = _isDarkMode ? Colors.white : Colors.black;
    final nameColor = _isDarkMode ? Colors.white : Colors.black;
    final iconColor = _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: backButtonColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: textColor,
              child: Icon(
                Icons.person,
                color: themeColor,
                size: 24,
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.personName,
              style: TextStyle(color: nameColor),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: iconColor,
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: textColor,
                    child: Icon(
                      Icons.person,
                      color: themeColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    messages[index],
                    style: TextStyle(color: textColor),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DotLoadingIndicator(
                animationController: _animationController!,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: textColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: textColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: textColor),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: textColor,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: themeColor,
    );
  }
}

class DotLoadingIndicator extends StatelessWidget {
  final AnimationController animationController;

  const DotLoadingIndicator({required this.animationController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final opacity = Tween<double>(begin: 0.2, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Interval(
                  index * 0.33,
                  (index + 1) * 0.33,
                  curve: Curves.easeInOut,
                ),
              ),
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: FadeTransition(
                opacity: opacity,
                child: Dot(),
              ),
            );
          }),
        );
      },
    );
  }
}

class Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

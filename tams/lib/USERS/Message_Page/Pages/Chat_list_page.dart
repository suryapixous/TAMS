import 'package:flutter/material.dart';
import '../../../Public/MYcustomWidgets/Constant_page.dart';
import '../../../chat_data_store.dart';
import '../../People_List/Pages/People_list.dart';
import 'Message_page.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  Set<String> _selectedChats = {}; // To track selected chats
  bool _isEditing = false; // To track if we are in selection mode

  @override
  Widget build(BuildContext context) {
    final chats = ChatDataStore().getAllChats();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: appBarColor, // WhatsApp color
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          flexibleSpace: Center(
            child: Text(
              'Chats',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            if (_isEditing) ...[
              IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: _confirmDeleteSelectedChats,
              ),
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: _cancelSelection,
              ),
            ],
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshChatList,
        child: chats.isEmpty
            ? _buildEmptyChatList(context)
            : ListView.separated(
                itemCount: chats.keys.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final personName = chats.keys.elementAt(index);
                  final lastMessage = chats[personName]!.isNotEmpty
                      ? chats[personName]!.last
                      : 'No messages yet';

                  return _buildChatTile(context, personName, lastMessage);
                },
              ),
      ),
    );
  }

  Future<void> _refreshChatList() async {
    // Simulate network request
    await Future.delayed(Duration(seconds: 2));

    // Here you would typically make an API call to fetch updated data.
    // For this example, we just call setState to trigger a rebuild.
    setState(() {});
  }

  Widget _buildEmptyChatList(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            color: Colors.grey,
            size: 100.0,
          ),
          SizedBox(height: 20),
          Text(
            'No chats found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                _createPageTransition(
                  page: PeopleListPage(),
                ), // Replace with your PeopleListPage
              );
            },
            child: Text('Go to People List'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(
      BuildContext context, String personName, String lastMessage) {
    final isSelected = _selectedChats.contains(personName);

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isEditing = true;
          _selectedChats.add(personName);
        });
      },
      child: Container(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          title: Text(
            personName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            _truncateMessage(lastMessage),
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.green,
                ),
          onTap: () {
            if (_isEditing) {
              setState(() {
                if (isSelected) {
                  _selectedChats.remove(personName);
                } else {
                  _selectedChats.add(personName);
                }
              });
            } else {
              Navigator.push(
                context,
                _createPageTransition(
                  page: MessagingPage(personName: personName),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  String _truncateMessage(String message) {
    if (message.length > 50) {
      return message.substring(0, 50) + '...';
    } else {
      return message;
    }
  }

  void _confirmDeleteSelectedChats() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete the selected chats?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteSelectedChats();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSelectedChats() {
    setState(() {
      _selectedChats.forEach((personName) {
        ChatDataStore().getAllChats().remove(personName);
      });
      _selectedChats.clear();
      _isEditing = false;
    });
  }

  void _cancelSelection() {
    setState(() {
      _selectedChats.clear();
      _isEditing = false;
    });
  }

  PageRouteBuilder _createPageTransition({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

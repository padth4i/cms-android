import 'package:cms_android/screens/attendance.dart';
import 'package:cms_android/screens/profile/profile.dart';
import 'package:cms_android/screens/status_update.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatefulWidget {
  final Link url;
  final String username;
  const HomePage({Key key, this.username, this.url}) : super(key: key);
  @override
  _HomePage createState() => _HomePage(username, url);
}

class _HomePage extends State<HomePage> {
  int _currentIndex = 0;
  final String username;
  final Link url;

  _HomePage(this.username, this.url);
  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Attendance(),
      Profile(
        username: username,
      ),
      StatusUpdate()
    ];

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: url, cache: InMemoryCache()),
    );

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check),
              title: Text("Attendance"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Profile")),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_box), title: Text("Status")),
          ],
          onTap: onTabTapped,
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

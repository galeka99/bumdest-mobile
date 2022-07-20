import 'package:bumdest/views/main/explore.dart';
import 'package:bumdest/views/main/history.dart';
import 'package:bumdest/views/main/home.dart';
import 'package:bumdest/views/main/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          HomePage(),
          ExplorePage(),
          HistoryPage(),
          ProfilePage(),
        ],
        onPageChanged: (index) => setState(() {
          _index = index;
        }),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.25),
              offset: Offset(0, -5),
              blurRadius: 10,
            ),
          ],
        ),
        child: GNav(
          haptic: true,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: Colors.grey.shade600,
          activeColor: Theme.of(context).primaryColorDark,
          tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(.15),
          duration: Duration(milliseconds: 200),
          gap: 5,
          selectedIndex: _index,
          onTabChange: (index) => setState(() {
            _controller.jumpToPage(index);
            _index = index;
          }),
          tabs: [
            GButton(
              icon: Ionicons.home_outline,
              text: 'Home',
            ),
            GButton(
              icon: Ionicons.search_outline,
              text: 'Explore',
            ),
            GButton(
              icon: Ionicons.time_outline,
              text: 'History',
            ),
            GButton(
              icon: Ionicons.person_outline,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

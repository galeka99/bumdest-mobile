import 'package:bumdest/services/store.dart';
import 'package:bumdest/views/common/login.dart';
import 'package:bumdest/views/profile/update_profile.dart';
import 'package:bumdest/views/topup/history.dart';
import 'package:bumdest/views/withdraw/history.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nav/nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, dynamic>> _menus = [
    {
      'type': 1,
      'title': 'Update Profile',
      'icon': Ionicons.create_outline,
      'function': () => Nav.push(UpdateProfilePage()),
    },
    {
      'type': 1,
      'title': 'Top Up History',
      'icon': Ionicons.time_outline,
      'function': () => Nav.push(TopupHistoryPage()),
    },
    {
      'type': 1,
      'title': 'Withdraw History',
      'icon': Ionicons.time_outline,
      'function': () => Nav.push(WithdrawHistoryPage()),
    },
    {
      'type': 2,
      'title': 'Logout',
      'icon': Ionicons.exit_outline,
      'function': () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        store.user = null;
        store.token = null;

        Nav.clearAllAndPush(LoginPage());
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            fit: StackFit.loose,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .25,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).primaryColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(
                            Ionicons.person,
                            size: 30,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        store.user?.name ?? 'User',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        store.user?.email ?? 'john.doe@mail.com',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 25,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
              ),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 20,
            ),
            itemCount: _menus.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (_, i) {
              Map<String, dynamic> menu = _menus[i];

              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: menu['function'],
                leading: Icon(
                  menu['icon'],
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  menu['title'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: menu['type'] == 1 ? (Theme.of(context).textTheme.bodyText2?.color ?? Colors.grey.shade600) : Colors.red.shade600,
                  ),
                ),
                trailing: Icon(
                  Ionicons.chevron_forward_outline,
                  color: Colors.grey.shade400,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

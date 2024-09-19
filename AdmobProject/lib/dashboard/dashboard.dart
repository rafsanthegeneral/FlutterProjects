import 'package:email_validator/email_validator.dart';
import 'package:esyearn/dashboard/ads.dart';
import 'package:esyearn/dashboard/game.dart';
import 'package:esyearn/dashboard/home.dart';
import 'package:esyearn/dashboard/payment.dart';
import 'package:esyearn/dashboard/settings.dart';
import 'package:esyearn/lib/colorconst.dart';
import 'package:esyearn/lib/globalAds.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();

    loadAd();
  }

  static List<Widget> _pages = <Widget>[
    HomePage(),
    // SeeAds(),
    Game(),
    PaymentPage(),
    SettingsPage(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Easy Earn Dashboard',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..strokeWidth = 2
              ..color = Colors.blue[700]!,
            shadows: [
              Shadow(
                blurRadius: 1,
                color: Colors.blue[900]!,
                offset: Offset(1, 1),
              ),
            ],
            decoration: TextDecoration.none,
            fontFamily: 'Pacifico',
            // You can apply other styles like gradient, etc. here
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        physics:
            NeverScrollableScrollPhysics(), // Disable swiping between pages
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.games,
              color: Colors.black,
            ),
            label: 'Game',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.ads_click,
          //     color: Colors.black,
          //   ),
          //   label: 'See Ads',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.payment,
              color: Colors.black,
            ),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:dating_app/home/card_swipe.dart';
import 'package:dating_app/home/card_swipe.dart';
import 'package:dating_app/widgets/big_text.dart';
import 'package:dating_app/widgets/small_text.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:dating_app/pages/profile.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

Future fetchUsers() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/match'));

  if (response.statusCode == 200) {
    debugPrint('Success');
    final body = json.decode(response.body);
    debugPrint(body.toString());
  } else {
    debugPrint('Failed');
    throw Exception('Failed to load users');
  }
}

//Future usersFuture = fetchUsers();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ProfilePage profilePage;

  @override
  void initState() {
    super.initState();
    profilePage = ProfilePage();
  }

  final CardSwiperController controller = CardSwiperController();

  List<int> _leftCounter = [];
  List<int> _rightCounter = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
        'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top');
    switch (direction.name) {
      case 'left':
        debugPrint('LEEEEEEEFTT');

        setState(() {
          _leftCounter = List<int>.from(_leftCounter)..add(previousIndex);
        });

      case 'right':
        debugPrint('RIGGHTTTTTTTT');
        setState(() {
          _rightCounter = List<int>.from(_rightCounter)..add(previousIndex);
        });
    }
    return true;
  }

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home,size: 40,), label: 'SWIPE'),
              NavigationDestination(
                  icon: Icon(Icons.chat_bubble_rounded,size: 30), label: 'Chat'),
              NavigationDestination(
                  icon: Icon(Icons.explore,size: 30), label: 'Discover'),
              NavigationDestination(icon: Icon(Icons.person,size: 30), label: 'Profile'),
            ],
            selectedIndex: currentPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            }),
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.favorite),
              const Text('Meely')
            ],
          ),
        ),
        body: <Widget>[
        
          SwipeCard(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp, size: 30),
                    title: Text('Notification 1'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Notification 2'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Notification 1'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Notification 2'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
              ],
            ),
          ),
          ProfilePage()
        ][currentPageIndex]);
  }
}


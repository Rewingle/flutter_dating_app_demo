import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_empty/home/card_swipe.dart';
import 'package:flutter_empty/home/card_swipe.dart';
import 'package:flutter_empty/widgets/big_text.dart';
import 'package:flutter_empty/widgets/small_text.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
//import 'package:flutter_empty/pages/profile.dart';
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

Future usersFuture = fetchUsers();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dating App'),
        ),
        body: Column(
          children: [
             ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: Text('Profile'),
            ),
            
            Flexible(child: SwipeCard()),

            /*  BottomNavigationBar(
          
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushNamed(context, '/search');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/favorite');
            } else if (index == 3) {
               Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()),);
            }
          },
      /*     currentIndex: _selectedIndex,
          onTap: _onItemTapped, */
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.grey,size: 30),
              label: '1',
              backgroundColor: Colors.black
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.grey,size: 30),
              label: '2',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.grey,size: 30),
              label: '3',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.grey,size: 30),
              label: '4',
              
            ),
          ],
        ) */
          ],
        ));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

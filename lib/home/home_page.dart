import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_empty/home/card_swipe.dart';
import 'package:flutter_empty/home/page_body.dart';
import 'package:flutter_empty/widgets/big_text.dart';
import 'package:flutter_empty/widgets/small_text.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Album {
  int? userId;
  int? id;
  String? title;
  String? url;

  Album({this.userId, this.id, this.title, this.url});

  Album.fromJson(Map<String, dynamic> json) {
    userId = json['albumId'];
    id = json['id'];
    title = json['title'];
    url = json['url'];
  }
}

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final List body = json.decode(response.body);

    return body.map((e) => Album.fromJson(e)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Album>> albumsFuture = fetchAlbum();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final CardSwiperController controller = CardSwiperController();

  List<int> _leftCounter = [];
  List<int> _rightCounter = [];

/* 
  FutureBuilder<Album> cards = FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:  Colors.pink),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              });//[
       */

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
        debugPrint(albumsFuture.toString());
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
        body: Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 45, bottom: 15),
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    BigText(text: 'Istanbul', color: Color(0xFFFF4081)),
                    Row(
                      children: [
                        SmallText(text: 'Kadıköy', color: Colors.black54),
                        Icon(Icons.arrow_drop_down_rounded)
                      ],
                    )
                  ],
                ),
                Center(
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(90)),
                    child: Icon(
                      Icons.yard_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.pinkAccent),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )),
        SizedBox(height: 10),
        Flexible(
          child: SizedBox(
              height: 550,
              child: FutureBuilder<List<Album>>(
                future: albumsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Album> albums = snapshot.data!;

                    List<Container> cards = albums
                        .map(
                          (album) => Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.pink),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(album.url.toString(),
                                          fit: BoxFit.cover, height: 550)),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15)),
                                          color: Colors.black.withOpacity(0.3)),
                                          child: Padding(padding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(album.title!.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                              //Text('album.title!.toString()',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))
                                            ],
                                          ),),
                                    ),
                                    
                                  )
                                ],
                              )),
                        )
                        .toList();

                    return CardSwiper(
                        backCardOffset: Offset(0, -40),
                        duration: Duration(milliseconds: 100),
                        onSwipe: (previousIndex, currentIndex, direction) =>
                            _onSwipe(previousIndex, currentIndex, direction),
                        controller: controller,
                        numberOfCardsDisplayed: 2,
                        allowedSwipeDirection: AllowedSwipeDirection.only(
                            left: true, right: true, up: true),
                        cardsCount: cards.length,
                        cardBuilder: (context,
                                index,
                                horizontalOffsetPercentage,
                                verticalOffsetPercentage) =>
                            cards[index]);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ) /* CardSwiper(
              backCardOffset: Offset(0, -40),
              duration: Duration(milliseconds: 100),
              onSwipe: (previousIndex, currentIndex, direction) =>
                  _onSwipe(previousIndex, currentIndex, direction),
              controller: controller,
              numberOfCardsDisplayed: 2,
              cardsCount: 3,
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) =>
                      Stack(
                children: [
                  FutureBuilder<List<Album>>(
                      future: albumsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final albums = snapshot.data!;
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    index.isEven ? Colors.blue : Colors.pink),
                            child: Container(
                                child: Text(albums.title.toString())),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      }),
                ],
              ),
            ), */
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () => controller.swipe(CardSwiperDirection.left),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.white),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 32,
                )),
            /*   FloatingActionButton(
              onPressed: () => controller.swipe(CardSwiperDirection.left),
              child: const Icon(Icons.cancel),
            ), */
            FloatingActionButton(
              onPressed: controller.undo,
              child: const Icon(Icons.rotate_left),
            ),
            FloatingActionButton(
              onPressed: () => controller.swipe(CardSwiperDirection.top),
              child: const Icon(Icons.keyboard_arrow_up),
            ),
            ElevatedButton(
                onPressed: () => controller.swipe(CardSwiperDirection.right),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.white),
                child: const Icon(Icons.favorite, color: Colors.red, size: 32)),
          ],
        ),
        Text('Left ${_leftCounter.length}'),
        Text('Right ${_rightCounter.length}')
        /* Expanded(
            child: Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 15),
                child: SegmentedButton(segments: <ButtonSegment<String>>[
                  ButtonSegment(
                      value: 'home',
                      label: Icon(Icons.home_filled),
                      enabled: true),
                  ButtonSegment(
                      value: 'find', label: Text("Find"), enabled: false),
                  ButtonSegment(
                      value: 'profile', label: Text("Profile"), enabled: false)
                ], selected: _selected))) */
      ],
    ));
  }
}

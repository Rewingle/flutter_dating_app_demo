import 'dart:async';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_empty/widgets/big_text.dart';
import 'package:flutter_empty/widgets/small_text.dart';

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

class SwipeCard extends StatefulWidget {
  @override
  SwipeCardState createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard> {
  @override
  void initState() {
    super.initState();
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

  void _onDirectionChange(double horizontalDirection){}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              album.title!.toString(),
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            //Text('album.title!.toString()',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                        .toList();

                    return CardSwiper(
                        backCardOffset: Offset(0, -40),
                        duration: Duration(milliseconds: 100),
                        isLoop: false,
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
              )),
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
        Text('Right ${_rightCounter.length}'),
        
      ],
    );
  }
}

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CardSwiperController controller = CardSwiperController();

  final StreamController<List<int>> _streamController = StreamController<List<int>>();

  Stream<List<int>> get userStream => _streamController.stream;


  List<int> _leftCounter = [];
  List<int> _rightCounter = [];

  List<int> _people = [1, 2, 3];

  List<Container> cards = //[
    List<Container>.generate(5, (index) => Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: index.isEven?Colors.blue:Colors.pink),
      child: Text(index.toString()),
    ));
    
    /* Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.red),
      child: const Text('2'),
    ),
    Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.purple),
      child: const Text('3'),
    )
  ]; */
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
            child: CardSwiper(
              backCardOffset: Offset(0, -40),
              duration: Duration(milliseconds: 100),
              onSwipe: (previousIndex, currentIndex, direction) =>
                  _onSwipe(previousIndex, currentIndex, direction),
              controller: controller,
              numberOfCardsDisplayed: 2,
              cardsCount: cards.length,
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) =>
                      cards[index],
            ),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_empty/home/card_swipe.dart';
import 'package:flutter_empty/widgets/big_text.dart';
import 'package:flutter_empty/widgets/small_text.dart';
import 'dart:math';

class PageBody extends StatefulWidget {
  const PageBody({super.key});

  @override
  State<PageBody> createState() => _PageBodyState();
}


class _PageBodyState extends State<PageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);

  final _swipeController = ScrollController();

  final _peopleList = <int>[1, 2, 3];
  var rng = Random();

  var currPageValue = 0.8;
  double scaleFactor = 0.8;
  double _height = 140;

  int _currIndex = 19;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _swipeController.dispose();
    pageController.dispose();
  }

  void _loadMore(){
if(_peopleList.length == 1){
  setState(() {
    _peopleList.insert(0,rng.nextInt(100));
  });
}
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = 350;
    double cardHeight = 500;

    List<int> _peopleStack = [];

    List<int> swipedRight = [];
    List<int> swipedLeft = [];
  

    return SizedBox(
        height: 550,
        child: Center(
            child: Column(
          children: [
            Container(
              width: cardWidth,
              height: cardHeight,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Stack(
                  children: _peopleList
                      .map((i) => Transform.translate(
                          offset: Offset(
                              0,
                              i == 1
                                  ? -25
                                  : i == 2
                                      ? -15
                                      : 0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: i == 1
                                  ? cardWidth - 40
                                  : i == 2
                                      ? cardWidth - 20
                                      : cardWidth,
                              child: SwipeCard(
                                  onPositionChanged: (details) =>
                                      {print('Details: $details')},
                                  onSwipeEnd: (position, details) =>
                                      setState(() {
                                        _peopleList.removeLast();
                                        _peopleList.insert(0,rng.nextInt(100));
                                       
                                      }),
                                  onSwipeRight: ((finalPosition) =>
                                      setState(() {
                                        //swipedRight.add(i);
                                      })),
                                  onSwipeLeft: ((finalPosition) => setState(() {
                                        //swipedLeft.add(i);
                                      })),
                                  child: Container(
                                      width: cardWidth,
                                      height: cardHeight,
                                      margin: EdgeInsets.only(
                                          top: _currIndex == i ? 10 : 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    "https://i.pravatar.cc/250?u=+$i"))),
                                      ))),
                            ),
                          )))
                      .toList()),
            ),
            Text('data $_peopleList')
          ],
        )));
  }

  Widget _buildPageItem(int index) {
    const location = '10km away';
    const name = '🇹🇷 Mehmet';

    Matrix4 matrix = new Matrix4.identity();

    if (index == currPageValue.floor()) {
      var currScale = 1 - (currPageValue - index) * (1 - scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currPageValue.floor() + 1) {
      var currScale =
          scaleFactor + (currPageValue - index + 1) * (1 - scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currPageValue.floor() - 1) {
      var currScale = 1 - (currPageValue - index) * (1 - scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - scaleFactor) / 2, 0);
    }

    var skills = [
      'Car',
      'Boat',
      'Plane',
      '+3',
    ];

    return Transform(
      transform: matrix,
      child: Stack(children: [
        Container(
          height: 420,
          margin: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      NetworkImage('https://picsum.photos/seed/za/400/600'))),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              height: _height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 255, 245, 252)),
              child: Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(
                                  text: '$name', overFlow: TextOverflow.fade),
                              Row(children: [
                                Icon(
                                  Icons.pin_drop,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                SmallText(text: '$location')
                              ]),
                              SizedBox(height: 5),
                              Row(children: [
                                Wrap(
                                    children: List.generate(
                                        5,
                                        (index) => Icon(
                                              Icons.star_border_sharp,
                                              color: Colors.red,
                                              size: 15,
                                            ))),
                                SizedBox(width: 10),
                                SmallText(text: '3.5'),
                              ]),
                              Expanded(
                                  child: Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Wrap(
                                              spacing: 4,
                                              children: skills
                                                  .map((title) => Container(
                                                      padding: EdgeInsets.only(
                                                          left: 4,
                                                          right: 4,
                                                          top: 4,
                                                          bottom: 4),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Color(
                                                                      0xFF69c5df)),
                                                              top: BorderSide(
                                                                  color: Color(
                                                                      0xFF69c5df)),
                                                              left: BorderSide(
                                                                  color: Color(0xFF69c5df)),
                                                              right: BorderSide(color: Color(0xFF69c5df))),
                                                          borderRadius: BorderRadius.circular(15)),
                                                      child: SmallText(text: title)))
                                                  .toList()))))
                            ],
                          )),
                      Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(left: 10),
                              child: BigText(text: '18'))
                        ],
                      )
                    ],
                  ))),
        ),
      ]),
    );
  }
}

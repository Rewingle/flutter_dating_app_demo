import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_empty/home/card_swipe.dart';
import 'package:flutter_empty/home/page_body.dart';
import 'package:flutter_empty/widgets/big_text.dart';
import 'package:flutter_empty/widgets/small_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<String> _selected = {'Home'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          child: Container(
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
                      child: Icon(
                        Icons.yard_rounded,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(90)),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.pinkAccent),
                    ),
                  )
                ],
              )),
        ),
        PageBody(),
        Expanded(
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
                ], selected: _selected)))
      ],
    ));
  }
}

import 'package:flutter/material.dart';

class CardSwipeDemo extends StatefulWidget {
  @override
  _CardSwipeDemoState createState() => _CardSwipeDemoState();
}

class _CardSwipeDemoState extends State<CardSwipeDemo> {
  List<String> images = [
    "https://via.placeholder.com/300",
    "https://via.placeholder.com/300",
    "https://via.placeholder.com/300",
    "https://via.placeholder.com/300",
    "https://via.placeholder.com/300",
  ];
  int currentIndex = 0;

  void nextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % images.length;
    });
  }

  void previousImage() {
    setState(() {
      currentIndex = (currentIndex - 1) % images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx > 0) {
                nextImage();
              } else if (details.delta.dx < 0) {
                previousImage();
              }
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: GestureDetector(
                onTap: nextImage,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      images[currentIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.6 + 50,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: previousImage,
                icon: Icon(Icons.arrow_back),
                iconSize: 30,
              ),
              IconButton(
                onPressed: nextImage,
                icon: Icon(Icons.arrow_forward),
                iconSize: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
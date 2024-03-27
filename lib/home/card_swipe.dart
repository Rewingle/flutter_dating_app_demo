import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class SwipeCard extends StatefulWidget {
  final Widget child;

  final void Function(DragStartDetails details)? onSwipeStart;

  final void Function(DragUpdateDetails details)? onPositionChanged;

  final void Function(Offset position, DragEndDetails details)? onSwipeCancel;

  final void Function(Offset position, DragEndDetails details)? onSwipeEnd;

  final void Function(Offset finalPosition)? onSwipeRight;

  final void Function(Offset finalPosition)? onSwipeLeft;

  final void Function(Offset finalPosition)? onSwipeUp;

  final void Function(Offset finalPosition)? onSwipeDown;

  final Stream<double>? swipe;

  final int animationDuration;

  final Curve animationCurve;

  final double threshold;

  const SwipeCard({
    required this.child,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onSwipeDown,
    this.onSwipeUp,
    this.onPositionChanged,
    this.onSwipeStart,
    this.onSwipeCancel,
    this.onSwipeEnd,
    this.swipe,
    this.animationDuration = 250,
    this.animationCurve = Curves.easeInOut,
    this.threshold = 0.4,
    Key? key,
  }) : super(key: key);

  @override
  SwipeCardState createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard> {
  double _positionY = 0;
  double _positionX = 0;

  int _duration = 0;

  StreamSubscription? _swipeSub;

  @override
  void initState() {
    super.initState();

    if (widget.swipe != null) {
      _swipeSub = widget.swipe?.listen((angle) {
        _swipeSub?.cancel();
        _animate(angle);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onPanStart: _onPanStart,
        onPanEnd: _onPanEnd,
        onPanUpdate: _onPanUpdate,
        child: Stack(
          
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
                duration: Duration(milliseconds: _duration),
                top: _positionY,
                left: _positionX,
                child: Container(constraints: BoxConstraints(maxHeight: constraints.maxHeight, maxWidth: constraints.maxWidth), child: widget.child))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _swipeSub?.cancel();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _positionX += details.delta.dx;
      _positionY += details.delta.dy;
    });

    widget.onPositionChanged?.call(details);
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _duration = 0;
    });

    widget.onSwipeStart?.call(details);
  }

  void _onPanEnd(DragEndDetails details) {
    var newX = 0.0;
    var newY = 0.0;

    // Get screen dimensions.
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final potentialX = _positionX + (details.velocity.pixelsPerSecond.dx * widget.threshold);
    final potentialY = _positionY + (details.velocity.pixelsPerSecond.dy * widget.threshold);

    final currentPosition = Offset(_positionX, _positionY);

    final shouldSwipe = potentialX.abs() >= width || potentialY <= -height;

    if (shouldSwipe) {
      // horizontal speed or vertical speed is enough to make the card disappear in _duration ms.
      newX = potentialX;
      newY = potentialY;

      widget.onSwipeEnd?.call(currentPosition, details);
    } else {
      newX = 0;
      newY = 0;

      widget.onSwipeCancel?.call(currentPosition, details);
    }

    setState(() {
      _positionX = newX;
      _positionY = newY;
      _duration = widget.animationDuration;
    });

    if (shouldSwipe) {
      Future.delayed(Duration(milliseconds: widget.animationDuration), () {
        // Clock wise radian angle of the velocity
        final angle = details.velocity.pixelsPerSecond.direction;
        final finalPosition = Offset(newX, newY);
        if (angle.abs() <= (math.pi / 4)) {
          widget.onSwipeRight?.call(finalPosition);
        } else if (angle.abs() > (3 * math.pi / 4)) {
          widget.onSwipeLeft?.call(finalPosition);
        } else if (angle >= 0) {
          widget.onSwipeDown?.call(finalPosition);
        } else {
          widget.onSwipeUp?.call(finalPosition);
        }
      });
    }
  }

  void _animate(double? angle) {
    if (angle == null || angle < -math.pi || angle > math.pi) {
      throw Exception('Angle must be between -π and π (inclusive).');
    }

    widget.onSwipeStart?.call(DragStartDetails());

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Horizontal distance to arrive to the final X.
    double remainingX;
    // Vertical distance to arrive to the final Y.
    double remainingY;

    if (angle.abs() <= math.pi / 4) {
      // Swiping right
      remainingX = width - _positionX;
      remainingY = 0;
    } else if (angle.abs() > 3 * math.pi / 4) {
      // Swiping left
      remainingX = -width - _positionX;
      remainingY = 0;
    } else if (angle >= 0) {
      // Swiping down
      remainingX = 0;
      remainingY = height - _positionY;
    } else {
      // Swiping up
      remainingX = 0;
      remainingY = -height - _positionY;
    }

    // Calculating velocity so the card arrives at it's final position when the animation ends.
    final velocity = Velocity(pixelsPerSecond: Offset(remainingX / widget.threshold, remainingY / widget.threshold));
    final details = DragEndDetails(velocity: velocity);
    _onPanEnd(details);
  }
}
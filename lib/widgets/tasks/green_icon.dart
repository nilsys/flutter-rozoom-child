import 'package:flutter/material.dart';

class GreenAnimatedIcon extends StatefulWidget {
  GreenAnimatedIcon({this.key});
  final key;
  @override
  GreenAnimatedIconState createState() => GreenAnimatedIconState();
}

class GreenAnimatedIconState extends State<GreenAnimatedIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _greenColorAnimation;
  Animation<double> _sizeAnimation;
  Animation _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);
    _greenColorAnimation =
        ColorTween(begin: Colors.black54, end: Colors.greenAccent)
            .animate(_controller);

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 30, end: 80), weight: 30),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 80, end: 30), weight: 30),
    ]).animate(_curve);

    _sizeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void getAnimationFromChild() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return IconButton(
          onPressed: () {
            _controller.forward();
          },
          icon: Icon(
            Icons.check,
            color: _greenColorAnimation.value,
            size: _sizeAnimation.value,
          ),
        );
      },
    );
  }
}

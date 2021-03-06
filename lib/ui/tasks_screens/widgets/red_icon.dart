import 'package:flutter/material.dart';

class RedAnimatedIcon extends StatefulWidget {
  RedAnimatedIcon({this.key});
  final key;
  @override
  RedAnimatedIconState createState() => RedAnimatedIconState();
}

class RedAnimatedIconState extends State<RedAnimatedIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _redColorAnimation;
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
    _redColorAnimation =
        ColorTween(begin: Colors.black54, end: Colors.redAccent)
            .animate(_controller);
    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 24, end: 60), weight: 30),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 60, end: 24), weight: 30),
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
            Icons.close,
            // size: 24,
            color: _redColorAnimation.value,
            size: _sizeAnimation.value,
          ),
        );
      },
    );
  }
}

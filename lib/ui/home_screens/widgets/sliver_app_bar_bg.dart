import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/edit_profile_provider.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';

class HomeSliverAppBar extends StatelessWidget {
  final double defaultSize = SizeConfig.defaultSize;
  final double screenWidth = SizeConfig.screenWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(width: 0, color: blueRozoomColor),
        //     color: blueRozoomColor,
        //   ),
        //   width: screenWidth,
        //   height: defaultSize * 3,
        // ),
        SizedBox(
          // color: Colors.yellow,
          height: defaultSize * 24,
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: CustomShape(),
                child:
                    Container(height: defaultSize * 19, color: blueRozoomColor),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Consumer<Profile>(
                      builder: (context, profile, child) => Container(
                        height: defaultSize * 14,
                        width: defaultSize * 14,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white, width: defaultSize * 0.8),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(profile
                                    .profileItems['avatarUrl'].avatarUrl))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

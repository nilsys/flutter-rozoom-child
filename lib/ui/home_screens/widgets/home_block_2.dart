import 'package:flutter/material.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/widgets/fade-animation.dart';


class HomeBlock2 extends StatelessWidget {
  const HomeBlock2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
                      3.2,
                      Container(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            makeItem(context,
                                image: 'assets/images/index/11.png',
                                title: 'МоЇ нагороди', 
                                path: '/achievements'),
                            makeItem(context,
                                image: 'assets/images/index/12.png',
                                title: 'МоЇ картки', 
                                path: '/cards'),
                            makeItem(context,
                                image: 'assets/images/index/13.png',
                                title: 'МоЇ гроші'),
                          ],
                        ),
                      ));
  }
}
Widget makeItem(BuildContext context, {image, title, String path}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(path);
      },
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          elevation: 1.5,
          child: Container(
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey[300], width: 1),
              // borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(image),
                // fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 18.0,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey[800],
                        // fontFamily: 'bip',
                        fontSize: 17,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                      // gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                      // Theme.of(context).primaryColor.withOpacity(.6),
                      // Theme.of(context).primaryColor.withOpacity(.1),
                      // ])
                      ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    // child: Text(
                    //   title,
                    //   style: TextStyle(
                    //       color: Theme.of(context).primaryColor, fontSize: 20),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
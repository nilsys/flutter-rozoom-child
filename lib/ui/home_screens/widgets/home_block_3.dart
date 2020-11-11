import 'package:flutter/material.dart';
import 'package:rozoom_app/shared/constants.dart';


class HomeBlock3 extends StatelessWidget {
  const HomeBlock3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          HomeBlock3Card(
            image: "assets/images/index/21.png",
            title: "Цілі",
            country: "",
            price: 1,
            press: () {},
          ),
          HomeBlock3Card(
            image: "assets/images/index/22.png",
            title: "Магазин ",
            country: "за гривні",
            price: 2,
            press: () {},
          ),
          HomeBlock3Card(
            image: "assets/images/index/23.png",
            title: "Уроки ",
            country: "від вчителя",
            price: 3,
            press: () {},
          ),
          HomeBlock3Card(
            image: "assets/images/index/24.png",
            title: "Відео ролики",
            country: "",
            price: 4,
            press: () {},
          ),
          HomeBlock3Card(
            image: "assets/images/index/25.png",
            title: "ЗНО",
            country: "",
            price: 4,
            press: () {},
          ),
        ],
      ),
    );
  }
}

class HomeBlock3Card extends StatelessWidget {
  const HomeBlock3Card({
    Key key,
    this.image,
    this.title,
    this.country,
    this.price,
    this.press,
  }) : super(key: key);

  final String image, title, country;
  final int price;
  final Function press;
  final double kDefaultPadding = 20.0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        print('tap');
      },
      child: Container(
        padding: EdgeInsets.only(top: 5),
        margin: EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding * 2.5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 12,
              color: textRozoomColor.withOpacity(0.23),
            ),
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          // border: Border.all(width: 1, color: Colors.grey.withOpacity(0.7)),
        ),
        width: size.width * 0.4,
        // height: size.height * 0.6,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,

                // border: Border.all(width: 1, color: Colors.grey.withOpacity(0.7)),
              ),
              child: Image.asset(
                image,
                height: 150,
                width: size.width * 0.4,
              ),
            ),
            Container(
              padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                // border: Border.all(
                //     width: 1, color: blueRozoomColor.withOpacity(0.7)),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                // boxShadow: [
                //   BoxShadow(
                //     offset: Offset(0, 10),
                //     blurRadius: 50,
                //     color: textRozoomColor.withOpacity(0.23),
                //   ),
                // ],
              ),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "$title\n".toUpperCase(),
                            style: Theme.of(context).textTheme.button),
                        TextSpan(
                          text: "$country".toUpperCase(),
                          style: TextStyle(
                            color: textRozoomColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    '',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: textRozoomColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

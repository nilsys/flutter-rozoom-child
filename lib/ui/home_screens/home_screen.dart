import 'package:flutter/material.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:flutter/cupertino.dart';

class AppColors {
  static final lightGreenColor = Color.fromRGBO(104, 167, 175, 1);
  static final lightRedColor = Color.fromRGBO(173, 90, 74, 1);
  static final lightTextColor = Color.fromRGBO(95, 102, 97, 1);
  static final veryLightTextColor = Color.fromRGBO(170, 170, 180, 1);
  static final darkTextColor = Color.fromRGBO(34, 64, 67, 1);
  static final greyBackground = Color.fromRGBO(247, 247, 250, 1);
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                // backgroundColor: pinkRozoomColor,
                automaticallyImplyLeading: false,
                expandedHeight: defaultSize * 29,
                floating: true,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: SliverAppBarTitle(),
                    background: HomeSliverAppBar()),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              margin: EdgeInsets.all(20),
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10),
                    child: Center(
                      child: Text(
                        'НАВЧАННЯ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: pinkRozoomColor,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  RecomendsPlants(),
                  // Divider(),
                  SizedBox(height: 20),
                  RecomendsPlants(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecomendsPlants extends StatelessWidget {
  const RecomendsPlants({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          RecomendPlantCard(
            image: "assets/images/index/21.png",
            title: "Цілі",
            country: "",
            price: 1,
            press: () {},
          ),
          RecomendPlantCard(
            image: "assets/images/index/22.png",
            title: "Магазин ",
            country: "за гривні",
            price: 2,
            press: () {},
          ),
          RecomendPlantCard(
            image: "assets/images/index/23.png",
            title: "Уроки ",
            country: "від вчителя",
            price: 3,
            press: () {},
          ),
          RecomendPlantCard(
            image: "assets/images/index/24.png",
            title: "Відео ролики",
            country: "",
            price: 4,
            press: () {},
          ),
          RecomendPlantCard(
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

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard({
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

class SliverAppBarTitle extends StatelessWidget {
  const SliverAppBarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'My Name',
          style: TextStyle(
              fontSize: defaultSize * 1.35,
              color: textRozoomColor.withOpacity(0.9)),
        ),
        SizedBox(
          height: defaultSize / 3,
        ),
        Text(
          'email@gmail.com',
          style: TextStyle(
              fontSize: defaultSize, color: textRozoomColor.withOpacity(0.7)),
        ),
        SizedBox(
          height: defaultSize / 3,
        ),
        // Text(
        //   '+380123456789',
        //   style: TextStyle(
        //       fontSize: defaultSize, color: textRozoomColor.withOpacity(0.7)),
        // ),
        // SizedBox(
        //   height: defaultSize / 2,
        // ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/stats/coin.png',
                scale: 0.9,
              ),
              SizedBox(width: defaultSize / 3),
              Text('222',
                  style: TextStyle(color: Colors.black, fontSize: defaultSize)),
              SizedBox(width: defaultSize),
              Image.asset(
                'assets/images/stats/uah.png',
                scale: 5,
              ),
              SizedBox(width: defaultSize / 3),
              Text('11',
                  style: TextStyle(color: Colors.black, fontSize: defaultSize)),
            ],
          ),
        ),
      ],
    );
  }
}

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
                    Container(
                      height: defaultSize * 14,
                      width: defaultSize * 14,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white, width: defaultSize * 0.8),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://www.cbc.ca/parents/content/imgs/CultureNotYourHalloweenCostume_DavidRobertson_lead.jpg'))),
                    ),
                  ],
                ),
              )
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

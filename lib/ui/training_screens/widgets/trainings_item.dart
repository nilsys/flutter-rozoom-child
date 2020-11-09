import 'package:flutter/material.dart';

import 'package:rozoom_app/ui/training_screens/training_preview_screen.dart';
import 'package:rozoom_app/shared/size_config.dart';

class TrainingsItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;

  TrainingsItem(this.id, this.name, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(TrainingPreviewScreen.routeName,
            arguments: {
              'trainingId': id,
              'trainingName': name,
              'trainingImageUrl': imageUrl
            });
      },
      child: Container(
        width: defaultSize * 14.5, //145
        decoration: BoxDecoration(
          // color: Colors.grey[100],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.6,
                child: Hero(
                  tag: id,
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/gifs/spinner.gif",
                    image: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultSize),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: defaultSize * 1.5, //16
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: defaultSize / 2),
              // Text("sometext"),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

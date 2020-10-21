import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';

class TaskQuestion extends StatefulWidget {
  @override
  _TaskQuestionState createState() => _TaskQuestionState();
}

class _TaskQuestionState extends State<TaskQuestion> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool playing = false;

  void playAudio(url) async {
    if (playing) {
      var res = await audioPlayer.stop();
      if (res == 1) {
        setState(() {
          playing = false;
        });
      }
    } else {
      var res = await audioPlayer.play(url);
      if (res == 1) {
        setState(() {
          playing = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (ctx, task, child) => Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        width: double.infinity,
        // height: 200,
        child: Card(
          elevation: 3,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ClipRRect(
                  child: FadeInImage(
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.fill,
                    image: NetworkImage(task.imageUrl),
                    // fadeInDuration: Duration(seconds: 3),
                    // fadeOutDuration: Duration(seconds: 1),
                    placeholder: AssetImage('assets/images/brand.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 20, left: 20),
                child: Container(
                  // height: 30,
                  child: Center(
                    child: Text(
                      task.question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              task.audioQuestion == 'no audio'
                  ? Text('')
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 20, left: 20),
                      child: Container(
                        // height: 30,
                        child: Center(
                          child: InkWell(
                            onTap: () async {
                              playAudio(task.audioQuestion);
                            },
                            child: Icon(
                              playing == false
                                  ? Icons.play_circle_outline
                                  : Icons.pause_circle_outline,
                              color: Color(0xFF74bec9),
                              size: 34,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

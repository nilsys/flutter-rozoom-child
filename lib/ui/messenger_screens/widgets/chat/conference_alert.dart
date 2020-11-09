import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';

class ConferenceAlert extends StatefulWidget {
  ConferenceAlert(this.roomName, this.friendName);
  final String roomName;
  final String friendName;
  @override
  _ConferenceAlertState createState() => _ConferenceAlertState();
}

class _ConferenceAlertState extends State<ConferenceAlert> {
  // static String _roomText;
  // var room = Right(room);
  final serverText = TextEditingController(text: 'https://conf.rozoom.CO.ua/');
  // final roomText = TextEditingController();
  final subjectText = TextEditingController(text: "");
  final nameText = TextEditingController(text: "");
  final emailText = TextEditingController(text: "");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0074bec9"); //transparent blue

  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;
  int currentIndex = 2;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text(
        "Ні",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Так",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _joinMeeting();
        Navigator.pop(context);
      },
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Plugin example app'),
      // ),
      body: AlertDialog(
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 16.0,
        // ),
        title: Text(
          '${widget.friendName} створив відеочат! Приєднаєшся?',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 24,
        backgroundColor: Colors.blue,
        // shape: CircleBorder(),
        actions: [
          cancelButton,
          continueButton,
        ],
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 24.0,
              ),
              // TextField(
              //   controller: serverText,
              //   decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: "Server URL",
              //       hintText: "По умолчанию meet.jitsi.si"),
              // ),
              // SizedBox(
              //   height: 16.0,
              // ),
              // TextField(
              //   cursorColor: Color(0xFF74bec9),
              //   // style: TextStyle(color: Color(0xFF74bec9)),
              //   controller: roomText,

              //   decoration: InputDecoration(
              //     fillColor: Colors.yellow,
              //     focusColor: Colors.yellow,
              //     hoverColor: Colors.yellow,
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.yellow,
              //       ),
              //     ),
              //     labelText: "Название комнаты",
              //   ),
              //   onChanged: (value) {
              //     setState(() {
              //       _roomText = value;
              //       print(
              //           '***********************************************************************$_roomText');
              //     });
              //   },
              // ),
              // Text(''),
              // SizedBox(
              //   height: 16.0,
              // ),
              // TextField(
              //   controller: subjectText,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: "Тема звонка",
              //   ),
              // ),
              // SizedBox(
              //   height: 16.0,
              // ),
              // TextField(
              //   controller: nameText,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: "Имя пользователя",
              //   ),
              // ),
              // SizedBox(
              //   height: 16.0,
              // ),
              // TextField(
              //   controller: emailText,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: "Email",
              //   ),
              // ),
              // SizedBox(
              //   height: 16.0,
              // ),
              // TextField(
              //   controller: iosAppBarRGBAColor,
              //   decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: "AppBar Color(IOS only)",
              //       hintText: "Hint: This HAS to be in HEX RGBA format"),
              // ),
              // SizedBox(
              //   height: 16.0,
              // ),
              // CheckboxListTile(
              //   title: Text("Только звук"),
              //   value: isAudioOnly,
              //   onChanged: _onAudioOnlyChanged,
              // ),
              // SizedBox(
              //   height: 16.0,
              // ),
              // CheckboxListTile(
              //   title: Text("Приглушить звук"),
              //   value: isAudioMuted,
              //   onChanged: _onAudioMutedChanged,
              // ),
              // SizedBox(
              //   height: 16.0,
              // ),
              // CheckboxListTile(
              //   title: Text("Приглушить видео"),
              //   value: isVideoMuted,
              //   onChanged: _onVideoMutedChanged,
              // ),
              // Divider(
              //   height: 48.0,
              //   thickness: 2.0,
              // ),
              // SizedBox(
              //   height: 64.0,
              //   width: double.maxFinite,
              //   child: RaisedButton(
              //     onPressed: () {
              //       _sendToFirestore();
              //       _joinMeeting();
              //     },
              //     child: Text(
              //       "Присоединиться",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     color: Colors.blue,
              //   ),
              // ),
              // SizedBox(
              //   height: 48.0,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // _sendToFirestore() async {
  //   var _user = await FirebaseAuth.instance.currentUser();
  //   var _usernameData =
  //       await Firestore.instance.collection('users').document(_user.uid).get();
  //   await Firestore.instance
  //       .collection('confs')
  //       .document(_user.uid + Timestamp.now().toString())
  //       .setData({
  //     'email': _user.email,
  //     'displayName': _user.displayName,
  //     'username': _usernameData['name'],
  //     'id': _user.uid,
  //     'roomName': widget.roomName,
  //   });
  //   print('**********************ok***********************');
  // }

  // _onAudioOnlyChanged(bool value) {
  //   setState(() {
  //     isAudioOnly = value;
  //   });
  // }

  // _onAudioMutedChanged(bool value) {
  //   setState(() {
  //     isAudioMuted = value;
  //   });
  // }

  // _onVideoMutedChanged(bool value) {
  //   setState(() {
  //     isVideoMuted = value;
  //   });
  // }

  _joinMeeting() async {
    String serverUrl = 'https://conf.rozoom.CO.ua/';

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = widget.roomName
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Название комнаты не должно превышать 30 символов."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Эти символы нельзя использовать в названии комнаты."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/api/api.dart';
import 'package:rozoom_app/models/Provider.dart';
import 'package:rozoom_app/providers/video_chat_provider.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  // final serverText = TextEditingController(text: 'https://conf.tables.co.ua');
  final serverText = TextEditingController(text: 'https://conf.rozoom.CO.ua/');
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

  inviteToConf() async {
    var data = {};
    try {
      final _token = Provider.of<TokenData>(context, listen: false);
      var resChat = await CallApi()
          .postData(data, 'me/chat?api_token=${_token.getTokenData}');
      var _chatData = resChat.body;
      // print('---------------------$loadedFriends');
      List _extractedData = json.decode(_chatData)['friends'];
      final List loadedFriends = [];
      for (var i = 0; i < _extractedData.length; i++) {
        loadedFriends.add(
          _extractedData[i]['id'].toString(),
        );
        print('---------------------$loadedFriends');
      }
      for (var i = 0; i < loadedFriends.length; i++) {
        print('---------------------${loadedFriends[i]}');
        var data = {'to_id': loadedFriends[i], 'body': 'Заходи в видеочат!'};
        var resChat = await CallApi()
            .postData(data, 'me/chat/send?api_token=${_token.getTokenData}');
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      padding: const EdgeInsets.only(
          top: 56.0, bottom: 26.0, right: 30.0, left: 30.0),
      child: SizedBox(
        height: 44.0,
        width: 180,
        child: RaisedButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            // _sendToFirestore();
            _joinMeeting();
            inviteToConf();
          },
          icon: Icon(
            Icons.child_care,
            color: Colors.white,
          ),
          label: const Text(
            "Відеочат",
            style: TextStyle(color: Colors.white),
          ),
          color: Color(0xFFf06388),
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
  //     // 'roomName': widget.roomName,
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
    Provider.of<VideoChat>(context, listen: false).getVideoChatName();
    await new Future.delayed(const Duration(seconds: 5));
    // String serverUrl =
    //     serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;
    String serverUrl = 'https://conf.rozoom.CO.ua/';
    try {
      // Get video chat name

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
      final String _videoChatName =
          Provider.of<VideoChat>(context, listen: false).videoChatName;

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = _videoChatName
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

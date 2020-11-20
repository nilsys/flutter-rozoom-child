import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/friends_provider.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/shared/widgets/loader_screen.dart';
import 'package:rozoom_app/ui/friends_screens/widgets/chat_input.dart';
import 'package:rozoom_app/ui/friends_screens/widgets/chat_item.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      // print('set state true');
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero).then((value) {
        _getFriendChat(context).then((value) => setState(() {
              _isLoading = false;
              // print('set state false');
            }));
      });
    });
  }

  Future<void> _getFriendChat(context) async {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String id = args['id'];
    await Provider.of<Friends>(context, listen: false).readAllMessages(id);
    await Provider.of<Friends>(context, listen: false)
        .apiGetFriendsInfo(friendId: id);
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final String name = args['name'];
    final String avatarUrl = args['avatarUrl'];
    final String id = args['id'];

    return Consumer<Friends>(
      builder: (context, friend, child) => _isLoading
          ? MyLoaderScreen()
          : Scaffold(
              appBar: AppBar(
                // backgroundColor: Colors.grey.withOpacity(0.2),
                elevation: 0,
                leading: FlatButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await Provider.of<Friends>(context, listen: false)
                          .readAllMessages(id);
                      await Provider.of<Friends>(context, listen: false)
                          .apiGetFriendsInfo(friendId: id)
                          .then((value) => {Navigator.pop(context)});
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      // color: blueRozoomColor,
                    )),
                title: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(avatarUrl),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7)),
                        ),
                        // SizedBox(
                        //   height: 3,
                        // ),
                        // Text(
                        //   "Active now",
                        //   style: TextStyle(
                        //       color: Colors.black.withOpacity(0.4), fontSize: 14),
                        // )
                      ],
                    )
                  ],
                ),
                actions: <Widget>[
                  Icon(
                    Icons.phone,
                    color: Colors.green,
                    size: defaultSize * 2.5,
                  ),
                  SizedBox(
                    width: defaultSize * 2,
                  ),
                  // Container(
                  //   width: 13,
                  //   height: 13,
                  //   decoration: BoxDecoration(
                  //       color: Colors.green,
                  //       shape: BoxShape.circle,
                  //       border: Border.all(color: Colors.white38)),
                  // ),
                  // SizedBox(
                  //   width: 15,
                  // ),
                ],
              ),
              body: ChatItem(avatarUrl: avatarUrl),
              bottomSheet: ChatInput(id: id),
            ),
    );
  }
}

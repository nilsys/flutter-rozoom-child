import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/core/providers/friends_provider.dart';
import 'package:rozoom_app/shared/constants.dart';
import 'package:rozoom_app/shared/size_config.dart';
import 'package:rozoom_app/ui/friends_screens/chat_screen.dart';

class FriendsList extends StatefulWidget {
  final String id;
  FriendsList({this.id});

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  // @override
  // void didChangeDependencies() {

  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Friends>(context, listen: false)
  //         .apiGetFriendsInfo()
  //         .then((_) {
  //       Provider.of<Friends>(context, listen: false).initPusher(widget.id);
  //     });
  //   });

  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero).then((value) {
        Provider.of<Friends>(context, listen: false).apiGetFriendsInfo().then(
            (value) => Provider.of<Friends>(context, listen: false)
                .initPusher(widget.id));
      });
    });
    super.initState();
  }

  Future<void> _getFriendList(context) async {
    await Provider.of<Friends>(context, listen: false).apiGetFriendsInfo();
    await Provider.of<Friends>(context, listen: false).initPusher(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Expanded(
        flex: 6,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                top: defaultSize,
                bottom: defaultSize,
                left: defaultSize,
                right: defaultSize),
            child: FriendItem(),
            // color: blueRozoomColor,
          ),
        ));
  }
}

class FriendItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Consumer<Friends>(
      builder: (context, friend, child) => friend.friendList.length == 0
          ? Center(
              child: Text(
                'Шукати друзів',
                style: TextStyle(fontSize: defaultSize * 2.2),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: friend.friendList.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Container(
                        width: 75,
                        height: 75,
                        child: Stack(
                          children: <Widget>[
                            true
                                ? Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: blueRozoomColor, width: 3)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(friend
                                                    .friendList[i].avatarUrl),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://i1.wp.com/www.additudemag.com/wp-content/uploads/2016/11/Parent_Life_Positive-reinforcement-for-ADHD-children_Article_812_girl-thumbs-up_ts_505175324-1-scaled.jpg'),
                                            fit: BoxFit.cover)),
                                  ),
                            true
                                ? Positioned(
                                    top: 48,
                                    left: 52,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.greenAccent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 3)),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            friend.friendList[i].name,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FittedBox(
                            child: Text(
                              friend.friendList[i].lastMessage.length > 21
                                  ? friend.friendList[i].lastMessage
                                      .substring(0, 21)
                                  : friend.friendList[i].lastMessage,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: FittedBox(
                        child: Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.info_outline,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  print('info');
                                }),
                            Stack(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.message,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          ChatScreen.routeName,
                                          arguments: {
                                            'id': friend.friendList[i].id,
                                            'name': friend.friendList[i].name,
                                            'avatarUrl':
                                                friend.friendList[i].avatarUrl
                                          });
                                    }),
                                friend.friendList[i].unreadMessages != 0
                                    ? Positioned(
                                        right: 0,
                                        top: 0,
                                        child: new Container(
                                          padding: EdgeInsets.all(1),
                                          decoration: new BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(7.5),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 15,
                                            minHeight: 15,
                                          ),
                                          child: Text(
                                            friend.friendList[i].unreadMessages
                                                .toString(),
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.greenAccent,
                                ),
                                onPressed: () {
                                  print('call');
                                }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

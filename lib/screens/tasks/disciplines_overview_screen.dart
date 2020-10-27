import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/edit_profile_provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/screens/edit_profile_screen.dart';
import 'package:rozoom_app/screens/index_screen.dart';
import 'package:rozoom_app/widgets/tasks/discipline_item.dart';

enum FilterOptions {
  EditProfile,
  Logout,
}

class DisciplinesOverviewScreen extends StatefulWidget {
  static const routeName = '/disciplines-overview';

  @override
  _DisciplinesOverviewScreenState createState() =>
      _DisciplinesOverviewScreenState();
}

class _DisciplinesOverviewScreenState extends State<DisciplinesOverviewScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Disciplines>(context, listen: false)
        .fetchAndSetDisciplines()
        .then((_) =>
            Provider.of<Profile>(context, listen: false).getProfileInfo())
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final disciplines = Provider.of<Disciplines>(context).disciplineItems;
    return Scaffold(
      // backgroundColor: Colors.blue.withOpacity(0.2),
      // backgroundColor: Color(0XFFFEF9EB),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(IndexScreen.routeName);
          },
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.EditProfile) {
                  Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                  // _showOnlyFavorites = true;
                } else {
                  // _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Профайл'),
                value: FilterOptions.EditProfile,
              ),
              PopupMenuItem(
                child: Text('Вийти'),
                value: FilterOptions.Logout,
              ),
            ],
          ),
        ],
        title: _isLoading
            ? Text('')
            : Consumer<Profile>(
                builder: (ctx, profile, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Text(
                    //   'Дісципліни',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    SizedBox(
                      width: 35,
                    ),
                    Image.asset(
                      'assets/images/stats/coin.png',
                      // height: 300,
                      scale: 0.55,
                      // width: 50,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      profile.balance,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/stats/uah.png',
                      height: 30,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      profile.certificates,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Color(0xFF74bec9),
                    ),
                    onPressed: () {
                      // Navigator.pop(context);
                    },
                  ),
                  Text(
                    '/ ',
                    style: TextStyle(color: Color(0xFF74bec9), fontSize: 16),
                  ),
                  Text(
                    ' Оберіть дисципліну',
                    style: TextStyle(color: Color(0xFF74bec9), fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: disciplines.length,
              itemBuilder: (ctx, i) => DisciplineItem(
                disciplines[i].id,
                disciplines[i].titleUa,
                disciplines[i].imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

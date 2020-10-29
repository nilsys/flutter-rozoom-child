import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/models/http_exception.dart';
import 'package:rozoom_app/providers/auth_provider.dart';
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
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        getUserProfile();
        Provider.of<Disciplines>(context, listen: false)
            .fetchAndSetDisciplines()
            // )
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } on HttpException catch (error) {
        var errorMessage = error.toString();
        _showErrorDialog(errorMessage);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  getUserProfile() async {
    try {
      await Provider.of<Profile>(context, listen: false).getProfileInfo();
    } on HttpException catch (error) {
      var errorMessage = error.toString();

      _showErrorDialog(errorMessage);

      return;
    } catch (error) {}
  }

  // @override
  // void initState() {
  //   _isLoading = true;
  //   Provider.of<Profile>(context, listen: false)
  //       .getProfileInfo()
  //       .then((_) => Provider.of<Disciplines>(context, listen: false)
  //           .fetchAndSetDisciplines())
  //       .then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // isAuthTokenValid();
    final disciplines =
        Provider.of<Disciplines>(context, listen: false).disciplineItems;
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
                } else {
                  Provider.of<Auth>(context, listen: false).logout();
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey,
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
                    SizedBox(width: 35),
                    Image.asset('assets/images/stats/coin.png', scale: 0.55),
                    SizedBox(width: 5),
                    Text(profile.getBalance,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    SizedBox(width: 10),
                    Image.asset('assets/images/stats/uah.png', height: 30),
                    SizedBox(width: 5),
                    Text(profile.getCertificates,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
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
                      Navigator.of(context)
                          .pushReplacementNamed(IndexScreen.routeName);
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF74bec9).withOpacity(0.6),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFFf06388)),
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          '',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ОК',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}

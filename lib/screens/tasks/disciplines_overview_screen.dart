import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/widgets/tasks/discipline_item.dart';

class DisciplinesOverviewScreen extends StatefulWidget {
  static const routeName = '/disciplines-overview';

  @override
  _DisciplinesOverviewScreenState createState() =>
      _DisciplinesOverviewScreenState();
}

class _DisciplinesOverviewScreenState extends State<DisciplinesOverviewScreen> {
  @override
  void initState() {
    Provider.of<Disciplines>(context, listen: false).fetchAndSetDisciplines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final disciplines = Provider.of<Disciplines>(context).disciplineItems;
    return Scaffold(
      // backgroundColor: Colors.blue.withOpacity(0.2),
      backgroundColor: Color(0XFFFEF9EB),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: null,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            onPressed: () {
              // Navigator.pop(context);
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Дісципліни',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: 35,
            ),
            SvgPicture.asset(
              'assets/images/coin.svg',
              height: 30,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '364.60',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(
              width: 10,
            ),
            SvgPicture.asset(
              'assets/images/uah.svg',
              height: 40,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '9',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
      body: GridView.builder(
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
    );
  }
}

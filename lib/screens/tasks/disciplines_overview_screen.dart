import 'package:flutter/material.dart';
import 'package:rozoom_app/providers/task_provider.dart';
import 'package:rozoom_app/widgets/tasks/discipline_item.dart';

class DisciplinesOverviewScreen extends StatelessWidget {
  final List<Discipline> loadedDiscipline = [
    Discipline(
      id: 1,
      title: 'Математика',
      titleUa: 'Математика',
      imageUrl: 'https://rozoom.com.ua/new/img/disciplines/math.svg',
    ),
    Discipline(
      id: 3,
      title: 'Английский язык',
      titleUa: 'Англiйська мова',
      imageUrl: 'https://rozoom.com.ua/new/img/disciplines/english.svg',
    ),
    Discipline(
      id: 4,
      title: 'Украинский язык',
      titleUa: 'Українська мова',
      imageUrl: 'https://rozoom.com.ua/new/img/disciplines/ukraine.svg',
    ),
    Discipline(
        id: 5,
        title: 'Физика',
        titleUa: 'Фiзика',
        imageUrl: 'https://rozoom.com.ua/new/img/disciplines/physics.svg'),
    Discipline(
        id: 6,
        title: 'Логика',
        titleUa: 'Логiка',
        imageUrl: 'https://rozoom.com.ua/new/img/disciplines/logic.svg'),
    Discipline(
      id: 0,
      title: '404 изображение',
      titleUa: '404 зображення',
      imageUrl: 'https://rozoom.com.ua/images/design/brand.svg',
    ),
    // Discipline(
    //     id: 0,
    //     title: 'null изображение',
    //     titleUa: 'null зображення',
    //     imageUrl: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        //   onPressed: null,
        // ),
        title: Text('Дісципліни'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: loadedDiscipline.length,
        itemBuilder: (ctx, i) => DisciplineItem(loadedDiscipline[i].id,
            loadedDiscipline[i].titleUa, loadedDiscipline[i].imageUrl),
      ),
    );
  }
}

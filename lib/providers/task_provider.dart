import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Discipline {
  final int id;
  final String title;
  final String titleUa;
  final String imageUrl;
  final String label;
  final String titleRu;

  Discipline({
    @required this.id,
    @required this.title,
    @required this.titleUa,
    @required this.imageUrl,
    this.label,
    this.titleRu,
  });
}

class Disciplines with ChangeNotifier {
  List<Discipline> _disciplineItems = [];

  List<Discipline> get disciplineItems {
    return [..._disciplineItems];
  }

  Future<void> fetchAndSetDisciplines() async {
    final token =
        'ZTXaUwNQp46vnzEEejS2KLE38KZNZsBMVjG3ZLMGBum8t8Y5ehmwBxakxnJFR0lG8bDKoc3Pc0F1HCcH';
    final url = 'https://rozoom.com.ua/api/mobile/disciplines?api_token=';
    try {
      final response = await http.post(url + token);
      var extractedData = json.decode(response.body)['disciplines'];
      final List<Discipline> loadedDisciplines = [];

      for (var i = 0; i < extractedData.length; i++) {
        loadedDisciplines.add(
          Discipline(
            id: extractedData[i]['id'],
            title: extractedData[i]['title'],
            titleUa: extractedData[i]['label'],
            imageUrl: extractedData[i]['image_url'],
          ),
        );
      }
      _disciplineItems = loadedDisciplines;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

class Theme {
  final int disciplineId;
  final int id;
  final String name;
  final String imageUrl;
  final String klass;
  final String tasksCount;

  Theme(
      {this.disciplineId,
      @required this.id,
      @required this.name,
      @required this.imageUrl,
      @required this.klass,
      @required this.tasksCount});
}

class Themes with ChangeNotifier {
  List<Theme> _themeItems = [];

  List<Theme> get themeItems {
    return [..._themeItems];
  }

  Future<void> nullThemeImages() async {
    print(_themeItems);
    _themeItems = [];
    print(_themeItems);
    return _themeItems;
  }

  Future<void> fetchandSetThemes(disciplineId) async {
    final token =
        'ZTXaUwNQp46vnzEEejS2KLE38KZNZsBMVjG3ZLMGBum8t8Y5ehmwBxakxnJFR0lG8bDKoc3Pc0F1HCcH';
    final url =
        'https://rozoom.com.ua/api/mobile/themes?discipline_id=$disciplineId&api_token=';
    try {
      final response = await http.post(url + token);
      // print(url + token);
      var extractedData = json.decode(response.body)['themes'];
      // print(extractedData);
      final List<Theme> loadedTasks = [];
      for (var i = 0; i < extractedData.length; i++) {
        loadedTasks.add(Theme(
            id: extractedData[i]['id'],
            name: extractedData[i]['name'],
            imageUrl:
                'https://rozoom.com.ua/uploads/' + extractedData[i]['image'],
            klass: extractedData[i]['class'],
            tasksCount: extractedData[i]['tasks_count']));
      }
      _themeItems = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetTask(themeId) async {
    final token =
        'ZTXaUwNQp46vnzEEejS2KLE38KZNZsBMVjG3ZLMGBum8t8Y5ehmwBxakxnJFR0lG8bDKoc3Pc0F1HCcH';
    final url = 'https://rozoom.com.ua/task/start/$themeId?api_token=';
    try {
      var headers = {'Accept': 'text/json'};
      final response = await http.get(url + token, headers: headers);
      print(url + token);
      print(response);
      var extractedData = json.decode(response.body);
      print(extractedData);
      // final List<Theme> loadedTasks = [];
      // for (var i = 0; i < extractedData.length; i++) {
      //   loadedTasks.add(Theme(
      //       id: extractedData[i]['id'],
      //       name: extractedData[i]['name'],
      //       imageUrl:
      //           'https://rozoom.com.ua/uploads/' + extractedData[i]['image'],
      //       klass: extractedData[i]['class'],
      //       tasksCount: extractedData[i]['tasks_count']));
      // }
      // _themeItems = loadedTasks;
      // notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

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
            imageUrl: extractedData[i]['image_url'] != null
                ? extractedData[i]['image_url']
                : 'https://rozoom.com.ua/images/design/brand.svg',
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
            imageUrl: extractedData[i]['image'] != null
                ? 'https://rozoom.com.ua/uploads/' + extractedData[i]['image']
                : 'https://rozoom.com.ua/images/design/brand.svg',
            klass: extractedData[i]['class'] != null
                ? extractedData[i]['class']
                : 'ထ',
            tasksCount: extractedData[i]['tasks_count']));
      }
      _themeItems = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

class TaskModel {
  bool continueOrFinish;
  String rightAnswersCount;
  String wrongAnswersCount;
  String rewardAmount;
  String currentQuestionNumber;
  String totalQuestionCount;
  String imageUrl;
  String question;
  String answerIdForApi;
  List answerVariants;
  String rightAnswerListElementNumber;
  String rightAnswerStringValue;
  String answerType;
  String resultPoints;

  TaskModel({
    this.continueOrFinish,
    this.rightAnswersCount,
    this.wrongAnswersCount,
    this.rewardAmount,
    this.currentQuestionNumber,
    this.totalQuestionCount,
    this.imageUrl,
    this.question,
    this.answerIdForApi,
    this.answerVariants,
    this.rightAnswerListElementNumber,
    this.rightAnswerStringValue,
    this.answerType,
    this.resultPoints,
  });
}

class Task with ChangeNotifier {
  List<TaskModel> _taskItems = [];

  List<TaskModel> get taskItems {
    return [..._taskItems];
  }

  Future<void> nullTaskData() async {
    print(_taskItems);
    _taskItems = [];
    print(_taskItems);
    return _taskItems;
  }

  Future<void> startTask(themeId) async {
    final token =
        'ZTXaUwNQp46vnzEEejS2KLE38KZNZsBMVjG3ZLMGBum8t8Y5ehmwBxakxnJFR0lG8bDKoc3Pc0F1HCcH';
    final url = 'https://rozoom.com.ua/task/start/$themeId?api_token=';
    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + token, headers: headers);
      print(url + token);
      // print(response);
      final extractedData = json.decode(response.body);
      print(extractedData);
      if (extractedData == null) {
        return;
      }

      final List<TaskModel> loadedTaskList = [];
      loadedTaskList.add(TaskModel(
        continueOrFinish: extractedData['result'],
        rightAnswersCount: extractedData['session']['rights'].toString(),
        wrongAnswersCount:
            (int.tryParse(extractedData['session']['completed']) -
                    int.tryParse(extractedData['session']['rights']))
                .toString(),
        rewardAmount: extractedData['session']['reward'].toString(),
        currentQuestionNumber:
            (int.tryParse(extractedData['session']['completed']) + 1)
                .toString(),
        totalQuestionCount: extractedData['session']['limit'].toString(),
        imageUrl: 'https://rozoom.com.ua/uploads/' +
            extractedData['task']['image'].toString(),
        question: extractedData['task']['question'].toString(),
        answerIdForApi: extractedData['answer']['id'].toString(),
        answerVariants: extractedData['answer']['variants'],
        rightAnswerListElementNumber:
            extractedData['answer']['right_idx'].toString(),
        rightAnswerStringValue: extractedData['task']['answer'].toString(),
        answerType: extractedData['task']['type_id'].toString(),
        resultPoints: 'no points',
      ));
      _taskItems = loadedTaskList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> answerTask(answerIdForApi, answerListElementNumber) async {
    final token =
        'ZTXaUwNQp46vnzEEejS2KLE38KZNZsBMVjG3ZLMGBum8t8Y5ehmwBxakxnJFR0lG8bDKoc3Pc0F1HCcH';
    final url =
        'https://rozoom.com.ua/task/answer/$answerIdForApi/$answerListElementNumber?api_token=';
    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + token, headers: headers);
      print(url + token);
      // print(response);
      var extractedData = json.decode(response.body);
      print(extractedData);
      if (extractedData == null) {
        return;
      }
      final sessionId = extractedData['session']['id'];
      final List<TaskModel> loadedTaskList = [];
      if (extractedData['result'] == false) {
        print('result false -------------------------------------------------');

        final url = 'https://rozoom.com.ua/task/result/$sessionId?api_token=';
        final headers = {'Accept': 'text/json'};
        final response = await http.get(url + token, headers: headers);
        print(url + token);
        var extractedData = json.decode(response.body);
        // print(extractedData);
        final List<TaskModel> loadedTaskList = [];
        loadedTaskList.add(TaskModel(
          continueOrFinish: false,
          rightAnswersCount: extractedData['session']['rights'].toString(),
          wrongAnswersCount:
              (int.tryParse(extractedData['session']['completed']) -
                      int.tryParse(extractedData['session']['rights']))
                  .toString(),
          rewardAmount: extractedData['session']['reward'].toString(),
          resultPoints: extractedData['points'].toString(),
          imageUrl: extractedData['task']['image'] != null
              ? 'https://rozoom.com.ua/uploads/' +
                  extractedData['task']['image']
              : 'https://rozoom.com.ua/images/design/brand.svg',
        ));
        _taskItems = loadedTaskList;
        print(
            'rrrrrrrrrrrrrrrrrrrreeeeeeeeeeeeeeeeeeeeeee ${_taskItems[0].continueOrFinish}');
        notifyListeners();
        // loadedTaskList.add(TaskModel(
        //   continueOrFinish: false,
        //   rightAnswersCount: extractedData['session']['rights'].toString(),
        //   wrongAnswersCount:
        //       (int.tryParse(extractedData['session']['completed']) -
        //               int.tryParse(extractedData['session']['rights']))
        //           .toString(),
        //   rewardAmount: extractedData['session']['reward'].toString(),
        // ));
        // final sessionId = extractedData['session']['id'];
        // _taskItems = loadedTaskList;
        // resultTask(sessionId);
        // notifyListeners();
        return;
      } else {
        loadedTaskList.add(TaskModel(
          continueOrFinish: extractedData['result'],
          rightAnswersCount: extractedData['session']['rights'].toString(),
          wrongAnswersCount:
              (int.tryParse(extractedData['session']['completed']) -
                      int.tryParse(extractedData['session']['rights']))
                  .toString(),
          rewardAmount: extractedData['session']['reward'].toString(),
          currentQuestionNumber:
              (int.tryParse(extractedData['session']['completed']) + 1)
                  .toString(),
          totalQuestionCount: extractedData['session']['limit'].toString(),
          imageUrl: 'https://rozoom.com.ua/uploads/' +
              extractedData['task']['image'].toString(),
          question: extractedData['task']['question'].toString(),
          answerIdForApi: extractedData['answer']['id'].toString(),
          answerVariants: extractedData['answer']['variants'],
          rightAnswerListElementNumber:
              extractedData['answer']['right_idx'].toString(),
          rightAnswerStringValue: extractedData['task']['answer'].toString(),
          answerType: extractedData['task']['type_id'].toString(),
          resultPoints: 'no points',
        ));
        _taskItems = loadedTaskList;
        notifyListeners();
        return;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> resultTask(sessionId) async {
    final token =
        'ZTXaUwNQp46vnzEEejS2KLE38KZNZsBMVjG3ZLMGBum8t8Y5ehmwBxakxnJFR0lG8bDKoc3Pc0F1HCcH';
    final url = 'https://rozoom.com.ua/task/result/$sessionId?api_token=';
    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + token, headers: headers);
      print(url + token);
      var extractedData = json.decode(response.body);
      // print(extractedData);
      final List<TaskModel> loadedTaskList = [];
      loadedTaskList.add(TaskModel(
        continueOrFinish: false,
        rightAnswersCount: extractedData['session']['rights'].toString(),
        wrongAnswersCount:
            (int.tryParse(extractedData['session']['completed']) -
                    int.tryParse(extractedData['session']['rights']))
                .toString(),
        rewardAmount: extractedData['session']['reward'].toString(),
        resultPoints: extractedData['points'].toString(),
        imageUrl: extractedData['task']['image'] != null
            ? 'https://rozoom.com.ua/uploads/' + extractedData['task']['image']
            : 'https://rozoom.com.ua/images/design/brand.svg',
      ));
      _taskItems = loadedTaskList;
      print(
          'rrrrrrrrrrrrrrrrrrrreeeeeeeeeeeeeeeeeeeeeee ${_taskItems[0].continueOrFinish}');
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

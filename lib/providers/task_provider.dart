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
}

class Tasks with ChangeNotifier {
  bool result;
  var rightCount;
  var wrongCount;
  var reward;
  var currentCount;
  var totalCount;
  var imageUrl;
  var question;
  var answerId;
  List answers;
  var rightAnswer;
  var rightAnswerValue;
  String points;
  String answerType;

  Tasks(
      {this.result,
      this.rightCount,
      this.wrongCount,
      this.reward,
      this.currentCount,
      this.totalCount,
      this.imageUrl,
      this.question,
      this.answerId,
      this.answers,
      this.rightAnswer,
      this.rightAnswerValue,
      this.points,
      this.answerType});

  Future<void> nullTaskData() async {
    result = false;
    rightCount = '';
    wrongCount = '';
    reward = '';
    currentCount = '';
    totalCount = '';
    print('-------> image url: $imageUrl');
    imageUrl = '';
    question = '';
    answerId = '';
    answers = [];
    rightAnswer = '';
    rightAnswerValue = '';
    print('ooooooook -------> image url: $imageUrl');
  }

  get getResult => result;
  get getRightCount => rightCount;
  get getWrongCount => wrongCount;
  get getReward => reward;
  get getcurrentCount => currentCount;
  get getTotalCount => totalCount;
  get getImageUrl => imageUrl;
  get getQuestion => question;
  get getAnswerId => answerId;
  List get getAnswers {
    return [...answers];
  }

  get getRightAnswer => rightAnswer;
  get getRightAnswerValue => rightAnswerValue;
  get getPoints => points;
  get getAnswerType => answerType;

  Future<void> startTask(themeId) async {
    final token =
        'ZTXaUwNQp46vnzEEejS2KLE38KZNZsBMVjG3ZLMGBum8t8Y5ehmwBxakxnJFR0lG8bDKoc3Pc0F1HCcH';
    final url = 'https://rozoom.com.ua/task/start/$themeId?api_token=';
    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + token, headers: headers);
      print(url + token);
      print(response);

      var extractedData = json.decode(response.body);
      print(extractedData);
      result = extractedData['result'];

      rightCount = extractedData['session']['rights'];
      // print(
      //     'rightAnswer type ${extractedData['session']['rights'].runtimeType}');
      // print('rightAnswer $rightAnswer');
      wrongCount = (int.tryParse(extractedData['session']['completed']) -
              int.tryParse(extractedData['session']['rights']))
          .toString();
      // print('wrongCount type ${extractedData['session']['fix'].runtimeType}');
      // print('wrongCount $wrongCount');
      reward = extractedData['session']['reward'];
      // print('reward type ${extractedData['session']['reward'].runtimeType}');
      // print('reward $reward');

      currentCount =
          (int.tryParse(extractedData['session']['completed']) + 1).toString();
      // print(
      //     'currentCount type ${extractedData['session']['completed'].runtimeType}');
      // print('currentCount $currentCount');
      totalCount = extractedData['session']['limit'];
      // print('totalCount type ${extractedData['session']['limit'].runtimeType}');
      // print('totalCount $totalCount');
      imageUrl =
          'https://rozoom.com.ua/uploads/' + extractedData['task']['image'];
      // print('imageUrl type ${extractedData['task']['image'].runtimeType}');
      print('imageUrl $imageUrl');
      question = extractedData['task']['question'];
      // print('question type ${extractedData['task']['question'].runtimeType}');
      // print('question $question');
      //
      answerId = extractedData['answer']['id'];
      // print('answerId type ${extractedData['answer']['id'].runtimeType}');
      // print('answerId $answerId');
      answers = extractedData['answer']['variants'];
      // print('answers type ${extractedData['answer']['variants'].runtimeType}');
      // print(
      //     'answers element type ${extractedData['answer']['variants'][0].runtimeType}');
      // print('answers $answers');
      rightAnswer = extractedData['answer']['right_idx'];
      // print(
      //     'rightAnswer type ${extractedData['answer']['right_idx'].runtimeType}');
      // print('rightAnswer $rightAnswer');
      rightAnswerValue = extractedData['task']['answer'];
      // print('rightAnswerValue $rightAnswerValue');
      answerType = extractedData['task']['type_id'];
      print('answerType type ${extractedData['task']['type_id'].runtimeType}');
      print('answerType $answerType');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> answerTask(answerIdReq, answerPosition) async {
    print('answer task okkkkkkkkkkkkkkkkkkkkkkkkkkkkk!');
    final token =
        'ZTXaUwNQp46vnzEEejS2KLE38KZNZsBMVjG3ZLMGBum8t8Y5ehmwBxakxnJFR0lG8bDKoc3Pc0F1HCcH';
    final url =
        'https://rozoom.com.ua/task/answer/$answerId/$answerPosition?api_token=';
    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + token, headers: headers);
      print(url + token);
      print(response);
      var extractedData = json.decode(response.body);
      print(extractedData);

      //
      rightCount = extractedData['session']['rights'];
      // print(
      //     'rightAnswer type ${extractedData['session']['rights'].runtimeType}');
      // print('rightAnswer $rightAnswer');
      wrongCount = (int.tryParse(extractedData['session']['completed']) -
              int.tryParse(extractedData['session']['rights']))
          .toString();
      // print('wrongCount type ${extractedData['session']['fix'].runtimeType}');
      // print('---------------->wrongCount $wrongCount');
      reward = extractedData['session']['reward'];
      // print('reward type ${extractedData['session']['reward'].runtimeType}');
      // print('reward $reward');

      if (extractedData['result'] == false) {
        final sessionId = extractedData['session']['id'];
        result = false;
        print('-----------result: $result');
        resultTask(sessionId);
        notifyListeners();
        return;
      }

      currentCount =
          (int.tryParse(extractedData['session']['completed']) + 1).toString();
      // print(
      //     'currentCount type ${extractedData['session']['completed'].runtimeType}');
      // print('currentCount $currentCount');
      totalCount = extractedData['session']['limit'];
      // print('totalCount type ${extractedData['session']['limit'].runtimeType}');
      // print('totalCount $totalCount');
      imageUrl =
          'https://rozoom.com.ua/uploads/' + extractedData['task']['image'];
      // print('imageUrl type ${extractedData['task']['image'].runtimeType}');
      print('imageUrl $imageUrl');
      question = extractedData['task']['question'];
      // print('question type ${extractedData['task']['question'].runtimeType}');
      // print('question $question');
      //
      answerId = extractedData['answer']['id'];
      // print('answerId type ${extractedData['answer']['id'].runtimeType}');
      // print('answerId $answerId');
      answers = extractedData['answer']['variants'];
      // print('answers type ${extractedData['answer']['variants'].runtimeType}');
      // print(
      //     'answers element type ${extractedData['answer']['variants'][0].runtimeType}');
      // print('answers $answers');
      rightAnswer = extractedData['answer']['right_idx'];
      // print(
      //     'rightAnswer type ${extractedData['answer']['right_idx'].runtimeType}');
      // print('rightAnswer $rightAnswer');
      rightAnswerValue = extractedData['task']['answer'];
      // print('rightAnswerValue $rightAnswerValue');
      answerType = extractedData['task']['type_id'];
      print('answerType type ${extractedData['task']['type_id'].runtimeType}');
      print('answerType $answerType');

      notifyListeners();
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
      print(response);
      var extractedData = json.decode(response.body);
      print(extractedData);
      points = extractedData['points'];
      print('--points----------------------------$points');
      print('-------------------> result: $result');

      // //
      // rightCount = extractedData['session']['rights'];
      // print(
      //     'rightAnswer type ${extractedData['session']['rights'].runtimeType}');
      // print('rightAnswer $rightAnswer');
      // wrongCount = extractedData['session']['fix'];
      // print('wrongCount type ${extractedData['session']['fix'].runtimeType}');
      // print('wrongCount $wrongCount');
      // reward = extractedData['session']['reward'];
      // print('reward type ${extractedData['session']['reward'].runtimeType}');
      // print('reward $reward');

      // currentCount =
      //     (int.tryParse(extractedData['session']['completed']) + 1).toString();
      // print(
      //     'currentCount type ${extractedData['session']['completed'].runtimeType}');
      // print('currentCount $currentCount');
      // totalCount = extractedData['session']['limit'];
      // print('totalCount type ${extractedData['session']['limit'].runtimeType}');
      // print('totalCount $totalCount');
      // imageUrl =
      //     'https://rozoom.com.ua/uploads/' + extractedData['task']['image'];
      // print('imageUrl type ${extractedData['task']['image'].runtimeType}');
      // print('imageUrl $imageUrl');
      // question = extractedData['task']['question'];
      // print('question type ${extractedData['task']['question'].runtimeType}');
      // print('question $question');
      // //
      // answerId = extractedData['answer']['id'];
      // print('answerId type ${extractedData['answer']['id'].runtimeType}');
      // print('answerId $answerId');
      // answers = extractedData['answer']['variants'];
      // print('answers type ${extractedData['answer']['variants'].runtimeType}');
      // print(
      //     'answers element type ${extractedData['answer']['variants'][0].runtimeType}');
      // print('answers $answers');
      // rightAnswer = extractedData['answer']['right_idx'];
      // print(
      //     'rightAnswer type ${extractedData['answer']['right_idx'].runtimeType}');
      // print('rightAnswer $rightAnswer');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

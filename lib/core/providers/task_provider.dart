import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rozoom_app/core/models/exceptions.dart';
import 'package:rozoom_app/shared/constants.dart';

class DisciplineModel {
  final String id;
  final String title;
  final String titleUa;
  final String imageUrl;
  final String label;
  final String titleRu;

  DisciplineModel({
    this.id,
    this.title,
    this.titleUa,
    this.imageUrl,
    this.label,
    this.titleRu,
  });
}

class Disciplines with ChangeNotifier {
  String authToken;
  Disciplines(this.authToken, this._disciplineItems);

  List<DisciplineModel> _disciplineItems = [];

  List<DisciplineModel> get disciplineItems {
    return [..._disciplineItems];
  }

  bool _isLoadingScreen = false;
  bool get isLoadingScreen => _isLoadingScreen;
  bool _isLoadingWidget = false;
  bool get isLoadingWidget => _isLoadingWidget;

  Map<String, String> get headers =>
      {'Accept': 'text/json', 'Authorization': 'Bearer $authToken'};

  Future<void> fetchAndSetDisciplines() async {
    const urlSegment = '/api/mobile/disciplines';
    final url = rozoomBaseUrl + urlSegment;
    try {
      _isLoadingScreen = true;
      final response = await http.post(url, headers: headers);
      var extractedData = json.decode(response.body)['disciplines'];

      final List<DisciplineModel> loadedDisciplines = [];

      for (var i = 0; i < extractedData.length; i++) {
        loadedDisciplines.add(
          DisciplineModel(
            id: extractedData[i]['id'].toString(),
            title: extractedData[i]['title'],
            titleUa: extractedData[i]['label'],
            imageUrl:
                'assets/images/disciplines/${extractedData[i]['id'].toString()}.png',
          ),
        );
      }
      _disciplineItems = loadedDisciplines;
      _isLoadingScreen = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

class ThemeModel with ChangeNotifier {
  final String disciplineId;
  final String id;
  final String name;
  final String imageUrl;
  final String klass;
  final String tasksCount;

  ThemeModel(
      {this.disciplineId,
      this.id,
      this.name,
      this.imageUrl,
      this.klass,
      this.tasksCount});
}

class Themes with ChangeNotifier {
  String authToken;
  Themes(this.authToken, this._themeItems);
  List<ThemeModel> _themeItems = [];

  List<ThemeModel> get themeItems {
    return [..._themeItems];
  }

  Future<void> nullThemeImages() async {
    _themeItems = [];
    return _themeItems;
  }

  Future<void> fetchandSetThemes(disciplineId) async {
    // print('theme auth token ---------------------------- $authToken');
    final url =
        '$rozoomBaseUrl/api/mobile/themes?discipline_id=$disciplineId&api_token=';
    try {
      final response = await http.post(url + authToken);
      // print(url + token);
      var extractedData = json.decode(response.body)['themes'];
      // print(extractedData);
      final List<ThemeModel> loadedTasks = [];
      for (var i = 0; i < extractedData.length; i++) {
        loadedTasks.add(ThemeModel(
            id: extractedData[i]['id'].toString(),
            name: extractedData[i]['name'],
            imageUrl: extractedData[i]['image'] != null
                ? 'https://rozoom.com.ua/uploads/' + extractedData[i]['image']
                : '',
            klass: extractedData[i]['class'] != null
                ? extractedData[i]['class'].toString()
                : 'ထ',
            tasksCount: extractedData[i]['tasks_count'].toString()));
      }
      _themeItems = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

class TaskModel with ChangeNotifier {
  String authToken;
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
  String explainText;
  String cardTitle;
  String cardUrl;
  String audioQuestion;
  String audioAnswer_0;
  String audioAnswer_1;
  String audioAnswer_2;
  String audioAnswer_3;
  List audioAnswer;
  String fixCount;
  String fixedCount;

  TaskModel(this.authToken,
      {this.continueOrFinish,
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
      this.explainText,
      this.cardTitle,
      this.cardUrl,
      this.audioQuestion,
      this.audioAnswer_0,
      this.audioAnswer_1,
      this.audioAnswer_2,
      this.audioAnswer_3,
      this.audioAnswer,
      this.fixCount,
      this.fixedCount});

  get getContinueOrFinish => continueOrFinish;
  get getRightAnswersCount => rightAnswersCount;
  get getWrongAnswersCount => wrongAnswersCount;
  get getRewardAmount => rewardAmount;
  get getCurrentQuestionNumber => currentQuestionNumber;
  get getTotalQuestionCount => totalQuestionCount;
  get getImageUrl => imageUrl;
  get getQuestion => question;
  get getAnswerIdForApi => answerIdForApi;
  get getAnswerVariants => answerVariants;
  get getRightAnswerListElementNumber => rightAnswerListElementNumber;
  get getRightAnswerStringValue => rightAnswerStringValue;
  get getAnswerType => answerType;
  get getResultPoints => resultPoints;
  get getAudioQuestion => audioQuestion;

  // Future<void> nullAudio() async {
  //   audioAnswer = ['no audio', 'no audio', 'no audio', 'no audio'];
  //   return audioAnswer;
  // }

  bool _isLoadingScreen = true;
  bool get isLoadingScreen => _isLoadingScreen;
  bool _isLoadingWidget = false;
  bool get isLoadingWidget => _isLoadingWidget;

  Future<void> getFixTaskInfo() async {
    final url = '$rozoomBaseUrl/tasks/fix?api_token=';
    print(url);

    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + authToken, headers: headers);
      final extractedData = json.decode(response.body);
      // print('fix data -------- $extractedData');
      fixCount = extractedData['fix_count'].toString();
      // print('fix count - $fixCount');
      fixedCount = extractedData['fixed_count'].toString();
      // print('fix count - $fixedCount');
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fixTasks() async {
    // print('start task auth token ---------------------------- $authToken');
    final url = '$rozoomBaseUrl/tasks/fix/start?api_token=';
    print(url);

    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + authToken, headers: headers);
      final extractedData = json.decode(response.body);
      print('fix task -------------- $extractedData');
      if (extractedData == null) {
        return;
      }
      if (extractedData['flash'] != null) {
        throw HttpException(extractedData['flash']['message']);
      }

      continueOrFinish = extractedData['result'];
      rightAnswersCount = extractedData['session']['rights'].toString();
      wrongAnswersCount = (extractedData['session']['completed'] -
              extractedData['session']['rights'])
          .toString();
      rewardAmount = extractedData['session']['reward'].toString();
      currentQuestionNumber =
          (extractedData['session']['completed'] + 1).toString();
      totalQuestionCount = extractedData['session']['limit'].toString();
      imageUrl = extractedData['task']['image'] != null
          ? 'https://rozoom.com.ua/uploads/' +
              extractedData['task']['image'].toString()
          : '';
      question = extractedData['task']['question'].toString();
      answerIdForApi = extractedData['answer']['id'].toString();
      answerVariants = extractedData['answer']['variants'];
      rightAnswerListElementNumber =
          extractedData['answer']['right_idx'].toString();
      rightAnswerStringValue = extractedData['task']['answer'].toString();
      answerType = extractedData['task']['type_id'].toString();
      extractedData['task']['explain_text'] == null
          ? explainText = ''
          : explainText = extractedData['task']['explain_text'].toString();
      if (extractedData['audios'] is List) {
        audioQuestion = 'no audio';
        audioAnswer_0 = 'no audio';
        audioAnswer_1 = 'no audio';
        audioAnswer_2 = 'no audio';
        audioAnswer_3 = 'no audio';
        audioAnswer = [
          audioAnswer_0,
          audioAnswer_1,
          audioAnswer_2,
          audioAnswer_3
        ];
      } else {
        extractedData['audios']['question'] == null
            ? audioQuestion = 'no audio'
            : audioQuestion = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['question'].toString();
        extractedData['audios']['answer_0'] == null
            ? audioAnswer_0 = 'no audio'
            : audioAnswer_0 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_0'].toString();
        extractedData['audios']['answer_1'] == null
            ? audioAnswer_1 = 'no audio'
            : audioAnswer_1 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_1'].toString();
        extractedData['audios']['answer_2'] == null
            ? audioAnswer_2 = 'no audio'
            : audioAnswer_2 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_2'].toString();
        extractedData['audios']['answer_3'] == null
            ? audioAnswer_3 = 'no audio'
            : audioAnswer_3 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_3'].toString();
        audioAnswer = [
          audioAnswer_0,
          audioAnswer_1,
          audioAnswer_2,
          audioAnswer_3
        ];
      }

      if (extractedData['card_title'] != false) {
        cardTitle = extractedData['card_title'];
        cardUrl =
            'https://rozoom.com.ua/uploads/' + extractedData['card']['image'];
      } else {
        cardTitle = 'no card';
        cardUrl = 'no cardUrl';
      }

      // print('cardTitle --------- $cardTitle');
      // print('cardUrl --------- $cardUrl');
      _isLoadingScreen = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> startTask(themeId) async {
    // print('start task auth token ---------------------------- $authToken');
    final url = '$rozoomBaseUrl/task/start/$themeId?api_token=';
    print(url);

    _isLoadingScreen = true;
    final headers = {'Accept': 'text/json'};
    final response = await http.get(url + authToken, headers: headers);
    final extractedData = json.decode(response.body);
    print('start task ---------- $extractedData');
    if (extractedData == null) {
      return;
    }
    if (extractedData['flash'] != null) {
      throw HttpException(extractedData['flash']['message']);
    }

    continueOrFinish = extractedData['result'];
    rightAnswersCount = extractedData['session']['rights'].toString();
    wrongAnswersCount = (extractedData['session']['completed'] -
            extractedData['session']['rights'])
        .toString();
    rewardAmount = extractedData['session']['reward'].toString();
    currentQuestionNumber =
        (extractedData['session']['completed'] + 1).toString();
    totalQuestionCount = extractedData['session']['limit'].toString();
    imageUrl = extractedData['task']['image'] != null
        ? 'https://rozoom.com.ua/uploads/' +
            extractedData['task']['image'].toString()
        : '';
    question = extractedData['task']['question'].toString();
    answerIdForApi = extractedData['answer']['id'].toString();
    answerVariants = extractedData['answer']['variants'];
    rightAnswerListElementNumber =
        extractedData['answer']['right_idx'].toString();
    rightAnswerStringValue = extractedData['task']['answer'].toString();
    answerType = extractedData['task']['type_id'].toString();
    extractedData['task']['explain_text'] == null
        ? explainText = ''
        : explainText = extractedData['task']['explain_text'].toString();
    if (extractedData['audios'] is List) {
      audioQuestion = 'no audio';
      audioAnswer_0 = 'no audio';
      audioAnswer_1 = 'no audio';
      audioAnswer_2 = 'no audio';
      audioAnswer_3 = 'no audio';
      audioAnswer = [
        audioAnswer_0,
        audioAnswer_1,
        audioAnswer_2,
        audioAnswer_3
      ];
    } else {
      extractedData['audios']['question'] == null
          ? audioQuestion = 'no audio'
          : audioQuestion = 'https://rozoom.com.ua/uploads/' +
              extractedData['audios']['question'].toString();
      extractedData['audios']['answer_0'] == null
          ? audioAnswer_0 = 'no audio'
          : audioAnswer_0 = 'https://rozoom.com.ua/uploads/' +
              extractedData['audios']['answer_0'].toString();
      extractedData['audios']['answer_1'] == null
          ? audioAnswer_1 = 'no audio'
          : audioAnswer_1 = 'https://rozoom.com.ua/uploads/' +
              extractedData['audios']['answer_1'].toString();
      extractedData['audios']['answer_2'] == null
          ? audioAnswer_2 = 'no audio'
          : audioAnswer_2 = 'https://rozoom.com.ua/uploads/' +
              extractedData['audios']['answer_2'].toString();
      extractedData['audios']['answer_3'] == null
          ? audioAnswer_3 = 'no audio'
          : audioAnswer_3 = 'https://rozoom.com.ua/uploads/' +
              extractedData['audios']['answer_3'].toString();
      audioAnswer = [
        audioAnswer_0,
        audioAnswer_1,
        audioAnswer_2,
        audioAnswer_3
      ];
    }

    if (extractedData['card_title'] != false) {
      cardTitle = extractedData['card_title'];
      cardUrl =
          'https://rozoom.com.ua/uploads/' + extractedData['card']['image'];
    } else {
      cardTitle = 'no card';
      cardUrl = 'no cardUrl';
    }

    // print('cardTitle --------- $cardTitle');
    // print('cardUrl --------- $cardUrl');
    _isLoadingScreen = false;

    notifyListeners();
  }

  Future<void> answerTask(answerId, answerListElementNumber) async {
    // print('answer task auth token ---------------------------- $authToken');
    final url =
        '$rozoomBaseUrl/task/answer/$answerId/$answerListElementNumber?api_token=';
    print(url);

    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + authToken, headers: headers);
      var extractedData = json.decode(response.body);
      // print(extractedData);
      if (extractedData == null) {
        return;
      }

      final sessionId = extractedData['session']['id'];
      continueOrFinish = extractedData['result'];
      if (extractedData['result'] == false) {
        // print(
        //     'result false auth token ---------------------------- $authToken');
        final url = '$rozoomBaseUrl/task/result/$sessionId?api_token=';
        print('result ------------------------- url ---------- $url');
        final headers = {'Accept': 'text/json'};
        final response = await http.get(url + authToken, headers: headers);
        var extractedData = json.decode(response.body);
        print('result data $extractedData');
        rightAnswersCount = extractedData['session']['rights'].toString();
        wrongAnswersCount = (extractedData['session']['completed'] -
                extractedData['session']['rights'])
            .toString();
        rewardAmount = extractedData['session']['reward'].toString();
        resultPoints = extractedData['points'].toString();

        notifyListeners();
        return;
      }
      continueOrFinish = extractedData['result'];
      rightAnswersCount = extractedData['session']['rights'].toString();
      wrongAnswersCount = (extractedData['session']['completed'] -
              extractedData['session']['rights'])
          .toString();
      rewardAmount = extractedData['session']['reward'].toString();
      currentQuestionNumber =
          (extractedData['session']['completed'] + 1).toString();
      totalQuestionCount = extractedData['session']['limit'].toString();
      imageUrl = extractedData['task']['image'] != null
          ? 'https://rozoom.com.ua/uploads/' +
              extractedData['task']['image'].toString()
          : '';

      question = extractedData['task']['question'].toString();
      answerIdForApi = extractedData['answer']['id'].toString();
      answerVariants = extractedData['answer']['variants'];
      rightAnswerListElementNumber =
          extractedData['answer']['right_idx'].toString();
      rightAnswerStringValue = extractedData['task']['answer'].toString();
      answerType = extractedData['task']['type_id'].toString();
      extractedData['task']['explain_text'] == null
          ? explainText = ''
          : explainText = extractedData['task']['explain_text'].toString();
      if (extractedData['audios'] is List) {
        audioQuestion = 'no audio';
        audioAnswer_0 = 'no audio';
        audioAnswer_1 = 'no audio';
        audioAnswer_2 = 'no audio';
        audioAnswer_3 = 'no audio';
        audioAnswer = [
          audioAnswer_0,
          audioAnswer_1,
          audioAnswer_2,
          audioAnswer_3
        ];
      } else {
        extractedData['audios']['question'] == null
            ? audioQuestion = 'no audio'
            : audioQuestion = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['question'].toString();
        extractedData['audios']['answer_0'] == null
            ? audioAnswer_0 = 'no audio'
            : audioAnswer_0 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_0'].toString();
        extractedData['audios']['answer_1'] == null
            ? audioAnswer_1 = 'no audio'
            : audioAnswer_1 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_1'].toString();
        extractedData['audios']['answer_2'] == null
            ? audioAnswer_2 = 'no audio'
            : audioAnswer_2 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_2'].toString();
        extractedData['audios']['answer_3'] == null
            ? audioAnswer_3 = 'no audio'
            : audioAnswer_3 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_3'].toString();
        audioAnswer = [
          audioAnswer_0,
          audioAnswer_1,
          audioAnswer_2,
          audioAnswer_3
        ];
      }

      if (extractedData['card_title'] != false) {
        cardTitle = extractedData['card_title'];
        cardUrl =
            'https://rozoom.com.ua/uploads/' + extractedData['card']['image'];
      } else {
        cardTitle = 'no card';
        cardUrl = 'no cardUrl';
      }

      // print('cardTitle --------- $cardTitle');
      // print('cardUrl --------- $cardUrl');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> answerTaskWithForm(answerId, answerText) async {
    // print(
    //     'answer form task auth token ---------------------------- $authToken');
    final url =
        '$rozoomBaseUrl/task/answer/$answerId/text?text=$answerText&api_token=';
    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + authToken, headers: headers);

      var extractedData = json.decode(response.body);
      // print(extractedData);
      if (extractedData == null) {
        return;
      }

      final sessionId = extractedData['session']['id'];
      continueOrFinish = extractedData['result'];
      if (extractedData['result'] == false) {
        // print(
        //     'result false form auth token ---------------------------- $authToken');
        final url = '$rozoomBaseUrl/task/result/$sessionId?api_token=';
        final headers = {'Accept': 'text/json'};
        final response = await http.get(url + authToken, headers: headers);
        var extractedData = json.decode(response.body);
        rightAnswersCount = extractedData['session']['rights'].toString();
        wrongAnswersCount = (extractedData['session']['completed'] -
                extractedData['session']['rights'])
            .toString();
        rewardAmount = extractedData['session']['reward'].toString();
        resultPoints = extractedData['points'].toString();

        notifyListeners();
        return;
      }
      continueOrFinish = extractedData['result'];
      rightAnswersCount = extractedData['session']['rights'].toString();
      wrongAnswersCount = (extractedData['session']['completed'] -
              extractedData['session']['rights'])
          .toString();
      rewardAmount = extractedData['session']['reward'].toString();
      currentQuestionNumber =
          (extractedData['session']['completed'] + 1).toString();
      totalQuestionCount = extractedData['session']['limit'].toString();
      imageUrl = extractedData['task']['image'] != null
          ? 'https://rozoom.com.ua/uploads/' +
              extractedData['task']['image'].toString()
          : '';

      question = extractedData['task']['question'].toString();
      answerIdForApi = extractedData['answer']['id'].toString();
      answerVariants = extractedData['answer']['variants'];
      rightAnswerListElementNumber =
          extractedData['answer']['right_idx'].toString();
      rightAnswerStringValue = extractedData['task']['answer'].toString();
      answerType = extractedData['task']['type_id'].toString();
      extractedData['task']['explain_text'] == null
          ? explainText = ''
          : explainText = extractedData['task']['explain_text'].toString();
      if (extractedData['audios'] is List) {
        audioQuestion = 'no audio';
        audioAnswer_0 = 'no audio';
        audioAnswer_1 = 'no audio';
        audioAnswer_2 = 'no audio';
        audioAnswer_3 = 'no audio';
        audioAnswer = [
          audioAnswer_0,
          audioAnswer_1,
          audioAnswer_2,
          audioAnswer_3
        ];
      } else {
        extractedData['audios']['question'] == null
            ? audioQuestion = 'no audio'
            : audioQuestion = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['question'].toString();
        extractedData['audios']['answer_0'] == null
            ? audioAnswer_0 = 'no audio'
            : audioAnswer_0 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_0'].toString();
        extractedData['audios']['answer_1'] == null
            ? audioAnswer_1 = 'no audio'
            : audioAnswer_1 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_1'].toString();
        extractedData['audios']['answer_2'] == null
            ? audioAnswer_2 = 'no audio'
            : audioAnswer_2 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_2'].toString();
        extractedData['audios']['answer_3'] == null
            ? audioAnswer_3 = 'no audio'
            : audioAnswer_3 = 'https://rozoom.com.ua/uploads/' +
                extractedData['audios']['answer_3'].toString();
        audioAnswer = [
          audioAnswer_0,
          audioAnswer_1,
          audioAnswer_2,
          audioAnswer_3
        ];
      }

      if (extractedData['card_title'] != false) {
        cardTitle = extractedData['card_title'];
        cardUrl =
            'https://rozoom.com.ua/uploads/' + extractedData['card']['image'];
      } else {
        cardTitle = 'no card';
        cardUrl = 'no cardUrl';
      }

      // print('cardTitle --------- $cardTitle');
      // print('cardUrl --------- $cardUrl');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

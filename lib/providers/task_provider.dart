import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisciplineModel {
  final int id;
  final String title;
  final String titleUa;
  final String imageUrl;
  final String label;
  final String titleRu;

  DisciplineModel({
    @required this.id,
    @required this.title,
    @required this.titleUa,
    @required this.imageUrl,
    this.label,
    this.titleRu,
  });
}

class Disciplines with ChangeNotifier {
  List<DisciplineModel> _disciplineItems = [];

  List<DisciplineModel> get disciplineItems {
    return [..._disciplineItems];
  }

  Future<void> fetchAndSetDisciplines() async {
    final token =
        'cq5BTzXGn4u0jzk3dXYIzayhJ5fR3HzIYcOzVr5NsxzGsvjHaWdbv00vI3x9rDi0R3STIMvNZhfR7O8a';
    final url = 'https://rozoom.com.ua/api/mobile/disciplines?api_token=';
    try {
      final response = await http.post(url + token);
      var extractedData = json.decode(response.body)['disciplines'];
      final List<DisciplineModel> loadedDisciplines = [];

      for (var i = 0; i < extractedData.length; i++) {
        loadedDisciplines.add(
          DisciplineModel(
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

class ThemeModel {
  final int disciplineId;
  final int id;
  final String name;
  final String imageUrl;
  final String klass;
  final String tasksCount;

  ThemeModel(
      {this.disciplineId,
      @required this.id,
      @required this.name,
      @required this.imageUrl,
      @required this.klass,
      @required this.tasksCount});
}

class Themes with ChangeNotifier {
  List<ThemeModel> _themeItems = [];

  List<ThemeModel> get themeItems {
    return [..._themeItems];
  }

  Future<void> nullThemeImages() async {
    _themeItems = [];
    return _themeItems;
  }

  Future<void> fetchandSetThemes(disciplineId) async {
    final token =
        'cq5BTzXGn4u0jzk3dXYIzayhJ5fR3HzIYcOzVr5NsxzGsvjHaWdbv00vI3x9rDi0R3STIMvNZhfR7O8a';
    final url =
        'https://rozoom.com.ua/api/mobile/themes?discipline_id=$disciplineId&api_token=';
    try {
      final response = await http.post(url + token);
      // print(url + token);
      var extractedData = json.decode(response.body)['themes'];
      // print(extractedData);
      final List<ThemeModel> loadedTasks = [];
      for (var i = 0; i < extractedData.length; i++) {
        loadedTasks.add(ThemeModel(
            id: extractedData[i]['id'],
            name: extractedData[i]['name'],
            imageUrl: extractedData[i]['image'] != null
                ? 'https://rozoom.com.ua/uploads/' + extractedData[i]['image']
                : 'https://png.pngtree.com/png-vector/20190119/ourmid/pngtree-pink-pink-brain-cartoon-cartoon-brain-png-image_473733.jpg',
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

class TaskModel with ChangeNotifier {
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

  TaskModel(
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
      this.audioAnswer});

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

  Future<void> startTask(themeId) async {
    final token =
        'cq5BTzXGn4u0jzk3dXYIzayhJ5fR3HzIYcOzVr5NsxzGsvjHaWdbv00vI3x9rDi0R3STIMvNZhfR7O8a';
    final url = 'https://rozoom.com.ua/task/start/$themeId?api_token=';
    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + token, headers: headers);
      final extractedData = json.decode(response.body);
      print(extractedData);
      if (extractedData == null) {
        return;
      }

      continueOrFinish = extractedData['result'];
      rightAnswersCount = extractedData['session']['rights'].toString();
      wrongAnswersCount = (int.tryParse(extractedData['session']['completed']) -
              int.tryParse(extractedData['session']['rights']))
          .toString();
      rewardAmount = extractedData['session']['reward'].toString();
      currentQuestionNumber =
          (int.tryParse(extractedData['session']['completed']) + 1).toString();
      totalQuestionCount = extractedData['session']['limit'].toString();
      imageUrl = extractedData['task']['image'] != null
          ? 'https://rozoom.com.ua/uploads/' +
              extractedData['task']['image'].toString()
          : 'https://png.pngtree.com/png-vector/20190119/ourmid/pngtree-pink-pink-brain-cartoon-cartoon-brain-png-image_473733.jpg';
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

      print('cardTitle --------- $cardTitle');
      print('cardUrl --------- $cardUrl');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> answerTask(answerId, answerListElementNumber) async {
    final token =
        'cq5BTzXGn4u0jzk3dXYIzayhJ5fR3HzIYcOzVr5NsxzGsvjHaWdbv00vI3x9rDi0R3STIMvNZhfR7O8a';
    final url =
        'https://rozoom.com.ua/task/answer/$answerId/$answerListElementNumber?api_token=';
    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + token, headers: headers);
      var extractedData = json.decode(response.body);
      print(extractedData);
      if (extractedData == null) {
        return;
      }

      final sessionId = extractedData['session']['id'];
      continueOrFinish = extractedData['result'];
      if (extractedData['result'] == false) {
        final url = 'https://rozoom.com.ua/task/result/$sessionId?api_token=';
        final headers = {'Accept': 'text/json'};
        final response = await http.get(url + token, headers: headers);
        var extractedData = json.decode(response.body);
        rightAnswersCount = extractedData['session']['rights'].toString();
        wrongAnswersCount =
            (int.tryParse(extractedData['session']['completed']) -
                    int.tryParse(extractedData['session']['rights']))
                .toString();
        rewardAmount = extractedData['session']['reward'].toString();
        resultPoints = extractedData['points'].toString();

        notifyListeners();
        return;
      }
      continueOrFinish = extractedData['result'];
      rightAnswersCount = extractedData['session']['rights'].toString();
      wrongAnswersCount = (int.tryParse(extractedData['session']['completed']) -
              int.tryParse(extractedData['session']['rights']))
          .toString();
      rewardAmount = extractedData['session']['reward'].toString();
      currentQuestionNumber =
          (int.tryParse(extractedData['session']['completed']) + 1).toString();
      totalQuestionCount = extractedData['session']['limit'].toString();
      imageUrl = extractedData['task']['image'] != null
          ? 'https://rozoom.com.ua/uploads/' +
              extractedData['task']['image'].toString()
          : 'https://png.pngtree.com/png-vector/20190119/ourmid/pngtree-pink-pink-brain-cartoon-cartoon-brain-png-image_473733.jpg';

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

      print('cardTitle --------- $cardTitle');
      print('cardUrl --------- $cardUrl');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> answerTaskWithForm(answerId, answerText) async {
    final token =
        'cq5BTzXGn4u0jzk3dXYIzayhJ5fR3HzIYcOzVr5NsxzGsvjHaWdbv00vI3x9rDi0R3STIMvNZhfR7O8a';
    final url =
        'https://rozoom.com.ua/task/answer/$answerId/text?text=$answerText&api_token=';
    try {
      final headers = {'Accept': 'text/json'};
      final response = await http.get(url + token, headers: headers);

      var extractedData = json.decode(response.body);
      print(extractedData);
      if (extractedData == null) {
        return;
      }

      final sessionId = extractedData['session']['id'];
      continueOrFinish = extractedData['result'];
      if (extractedData['result'] == false) {
        final url = 'https://rozoom.com.ua/task/result/$sessionId?api_token=';
        final headers = {'Accept': 'text/json'};
        final response = await http.get(url + token, headers: headers);
        var extractedData = json.decode(response.body);
        rightAnswersCount = extractedData['session']['rights'].toString();
        wrongAnswersCount =
            (int.tryParse(extractedData['session']['completed']) -
                    int.tryParse(extractedData['session']['rights']))
                .toString();
        rewardAmount = extractedData['session']['reward'].toString();
        resultPoints = extractedData['points'].toString();

        notifyListeners();
        return;
      }
      continueOrFinish = extractedData['result'];
      rightAnswersCount = extractedData['session']['rights'].toString();
      wrongAnswersCount = (int.tryParse(extractedData['session']['completed']) -
              int.tryParse(extractedData['session']['rights']))
          .toString();
      rewardAmount = extractedData['session']['reward'].toString();
      currentQuestionNumber =
          (int.tryParse(extractedData['session']['completed']) + 1).toString();
      totalQuestionCount = extractedData['session']['limit'].toString();
      imageUrl = extractedData['task']['image'] != null
          ? 'https://rozoom.com.ua/uploads/' +
              extractedData['task']['image'].toString()
          : 'https://png.pngtree.com/png-vector/20190119/ourmid/pngtree-pink-pink-brain-cartoon-cartoon-brain-png-image_473733.jpg';

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

      print('cardTitle --------- $cardTitle');
      print('cardUrl --------- $cardUrl');

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

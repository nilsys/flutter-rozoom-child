import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rozoom_app/core/models/http_exception.dart';
import 'package:rozoom_app/shared/constants.dart';

class TrainingThemeModel {
  final String id;
  final String categoryId;
  final String name;
  final String imageUrl;

  TrainingThemeModel({
    this.id,
    this.categoryId,
    this.name,
    this.imageUrl,
  });
}

class TrainingThemes with ChangeNotifier {
  String authToken;
  TrainingThemes(
    this.authToken,
    this._trainingThemesItems,
  );

  List<TrainingThemeModel> _trainingThemesItems = [];

  List<TrainingThemeModel> get trainingThemesItems {
    return [..._trainingThemesItems];
  }

  Future<void> fetchAndSetTrainingThemes() async {
    // print('training auth token ---------------------------- $authToken');
    final url = '$rozoomBaseUrl/trainings';
    // print('training url ---------------------------- $url');
    final headers = {
      'Accept': 'text/json',
      'Authorization': 'Bearer $authToken'
    };
    try {
      final response = await http.get(url, headers: headers);
      // print(response.statusCode);
      final extractedData = json.decode(response.body);
      // print(extractedData);
      if (extractedData['error'] != null) {
        throw HttpException('Щось пішло не так. Спробуйте ще');
      }
      List<TrainingThemeModel> loadedTrainingThemes = [];
      final trainingData = extractedData['trainings'];
      for (int i = 0; i < trainingData.length; i++) {
        loadedTrainingThemes.add(TrainingThemeModel(
            id: trainingData[i]['id'].toString(),
            name: trainingData[i]['name'],
            imageUrl:
                'https://rozoom.com.ua/images/training/${trainingData[i]['id'].toString()}.png'));
      }
      _trainingThemesItems = loadedTrainingThemes;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

class TrainingModel extends ChangeNotifier {
  final String sessionId;
  final bool continueOrFinish;
  final String rightAnswersCount;
  final String wrongAnswersCount;
  final String rewardAmount;
  final String currentQuestionNumber;
  final String totalQuestionCount;
  final String question;
  final List answerVariants;
  final String rightAnswer;
  final String answerId;
  final String points;
  TrainingModel(
      {this.sessionId,
      this.continueOrFinish,
      this.rightAnswersCount,
      this.wrongAnswersCount,
      this.rewardAmount,
      this.currentQuestionNumber,
      this.totalQuestionCount,
      this.question,
      this.answerVariants,
      this.rightAnswer,
      this.answerId,
      this.points});
}

class Training extends ChangeNotifier {
  String authToken;
  Training(this.authToken, this._trainingItems);

  Map<String, TrainingModel> _trainingItems = {};
  Map<String, TrainingModel> get trainingItems {
    return {..._trainingItems};
  }

  Future<void> startTraining(trainingId) async {
    // print('training auth token ---------------------------- $authToken');
    final url = '$rozoomBaseUrl/training/start?training_id=$trainingId';
    // print('training url ---------------------------- $url');
    final headers = {
      'Accept': 'text/json',
      'Authorization': 'Bearer $authToken'
    };
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw HttpException('Щось пішло не так. Спробуйте ще');
      }
      // print(extractedData);
      parseExtractedData(extractedData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> answerTraining(answerId, answerIndex) async {
    final url = '$rozoomBaseUrl/training/answer/$answerId?answer=$answerIndex';
    final headers = {
      'Accept': 'text/json',
      'Authorization': 'Bearer $authToken'
    };
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw HttpException('Щось пішло не так. Спробуйте ще');
      }
      // print(extractedData);
      parseExtractedData(extractedData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> answerTrainingNoListen(answerId, answerIndex) async {
    // print('no listen token ---------------------------- $authToken');
    final url = '$rozoomBaseUrl/training/answer/$answerId?answer=$answerIndex';
    // print('no listen url ---------------------------- $url');
    final headers = {
      'Accept': 'text/json',
      'Authorization': 'Bearer $authToken'
    };
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw HttpException('Щось пішло не так. Спробуйте ще');
      }
      // print(extractedData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> resultTraining(sessionId) async {
    // print('resultTraining auth token ---------------------------- $authToken');
    final url = '$rozoomBaseUrl/training/result/$sessionId';
    // print('resultTraining url ---------------------------- $url');
    final headers = {
      'Accept': 'text/json',
      'Authorization': 'Bearer $authToken'
    };
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      if (extractedData['error'] != null) {
        throw HttpException('Щось пішло не так. Спробуйте ще');
      }
      // print(extractedData);
      parseResult(extractedData);
    } catch (error) {
      throw error;
    }
  }

  void parseExtractedData(Map data) {
    // print(data);
    final String sessionId = data['session']['id'].toString();
    bool continueOrFinish = data['result'];
    final String rightAnswersCount = data['session']['rights'].toString();
    final String wrongAnswersCount =
        (int.tryParse(data['session']['completed'].toString()) -
                int.tryParse(data['session']['rights'].toString()))
            .toString();
    final String rewardAmount = data['session']['reward'].toString();
    final String currentQuestionNumber =
        (int.tryParse(data['session']['completed'].toString()) + 1).toString();
    final String totalQuestionCount = data['session']['limit'].toString();
    if (currentQuestionNumber == totalQuestionCount) {
      continueOrFinish = false;
    }
    final String question = data['question']['question'];
    final List answerVariants = data['question']['variants'];
    var answerIndex = data['question']['answer_idx'];
    final String rightAnswer = answerVariants[answerIndex];
    final String answerId = data['answer_id'].toString();
    Map<String, TrainingModel> loadedTraining = {
      'sessionId': TrainingModel(sessionId: sessionId),
      'continueOrFinish': TrainingModel(continueOrFinish: continueOrFinish),
      'rightAnswersCount': TrainingModel(rightAnswersCount: rightAnswersCount),
      'wrongAnswersCount': TrainingModel(wrongAnswersCount: wrongAnswersCount),
      'rewardAmount': TrainingModel(rewardAmount: rewardAmount),
      'currentQuestionNumber':
          TrainingModel(currentQuestionNumber: currentQuestionNumber),
      'totalQuestionCount':
          TrainingModel(totalQuestionCount: totalQuestionCount),
      'question': TrainingModel(question: question),
      'answerVariants': TrainingModel(answerVariants: answerVariants),
      'rightAnswer': TrainingModel(rightAnswer: rightAnswer),
      'answerId': TrainingModel(answerId: answerId),
    };
    _trainingItems = loadedTraining;
    notifyListeners();
  }

  void parseResult(Map data) {
    final String rightAnswersCount = data['session']['rights'].toString();
    final String wrongAnswersCount =
        (int.tryParse(data['session']['completed'].toString()) -
                int.tryParse(data['session']['rights'].toString()))
            .toString();
    final String rewardAmount = data['session']['reward'].toString();
    final String points = data['trainings_points'].toString();
    Map<String, TrainingModel> loadedTraining = {
      'rightAnswersCount': TrainingModel(rightAnswersCount: rightAnswersCount),
      'wrongAnswersCount': TrainingModel(wrongAnswersCount: wrongAnswersCount),
      'rewardAmount': TrainingModel(rewardAmount: rewardAmount),
      'points': TrainingModel(points: points),
      'sessionId': TrainingModel(sessionId: ''),
      'continueOrFinish': TrainingModel(continueOrFinish: false),
      'currentQuestionNumber': TrainingModel(currentQuestionNumber: '12'),
      'totalQuestionCount': TrainingModel(totalQuestionCount: '12'),
      'question': TrainingModel(question: ''),
      'answerVariants': TrainingModel(answerVariants: ['', '', '', '']),
      'rightAnswer': TrainingModel(rightAnswer: ''),
      'answerId': TrainingModel(answerId: ''),
    };
    _trainingItems = loadedTraining;
    notifyListeners();
  }
}

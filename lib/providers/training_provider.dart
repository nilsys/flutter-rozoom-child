import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rozoom_app/constants.dart';
import 'package:rozoom_app/models/http_exception.dart';

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
    final url = '$rozoomUrlSegment/trainings';
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
    print('training auth token ---------------------------- $authToken');
    final url = '$rozoomUrlSegment/training/start?training_id=$trainingId';
    print('training url ---------------------------- $url');
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
      print(extractedData);
      parseExtractedData(extractedData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> answerTraining(answerId, answerIndex) async {
    print('training auth token ---------------------------- $authToken');
    final url =
        '$rozoomUrlSegment/training/answer/$answerId?answer=$answerIndex';
    print('training url ---------------------------- $url');
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
      print(extractedData);
      // if (extractedData['result'] == false) {
      //   print(
      //       'result false----------------------------------------------------------------------');
      //   final resultUrl =
      //       '$rozoomUrlSegment/training/result/${extractedData['session']['id']}';
      //   print('result url ---------------------------- $resultUrl');
      //   final headers = {
      //     'Accept': 'text/json',
      //     'Authorization': 'Bearer $authToken'
      //   };
      //   try {
      //     final response = await http.get(url, headers: headers);
      //     final extractedResultData = json.decode(response.body);
      //     print(extractedResultData);
      //   } catch (error) {
      //     throw error;
      //   }
      //   parseResult(extractedData);
      // }
      parseExtractedData(extractedData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> answerTrainingNoListen(answerId, answerIndex) async {
    print('no listen token ---------------------------- $authToken');
    final url =
        '$rozoomUrlSegment/training/answer/$answerId?answer=$answerIndex';
    print('no listen url ---------------------------- $url');
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
      print(extractedData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> resultTraining(sessionId) async {
    print('resultTraining auth token ---------------------------- $authToken');
    final url = '$rozoomUrlSegment/training/result/$sessionId';
    print('resultTraining url ---------------------------- $url');
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
      print(extractedData);
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
    print(answerIndex.runtimeType);
    final String rightAnswer = answerVariants[answerIndex];
    print(rightAnswer);
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

// class TaskModel with ChangeNotifier {
//   String authToken;
//   bool continueOrFinish;
//   String rightAnswersCount;
//   String wrongAnswersCount;
//   String rewardAmount;
//   String currentQuestionNumber;
//   String totalQuestionCount;
//   String imageUrl;
//   String question;
//   String answerIdForApi;
//   List answerVariants;
//   String rightAnswer;
//   String rightAnswerStringValue;
//   String answerType;
//   String resultPoints;
//   String explainText;
//   String cardTitle;
//   String cardUrl;
//   String audioQuestion;
//   String audioAnswer_0;
//   String audioAnswer_1;
//   String audioAnswer_2;
//   String audioAnswer_3;
//   List audioAnswer;
//   String fixCount;
//   String fixedCount;

//   TaskModel(this.authToken,
//       {this.continueOrFinish,
//       this.rightAnswersCount,
//       this.wrongAnswersCount,
//       this.rewardAmount,
//       this.currentQuestionNumber,
//       this.totalQuestionCount,
//       this.imageUrl,
//       this.question,
//       this.answerIdForApi,
//       this.answerVariants,
//       this.rightAnswer,
//       this.rightAnswerStringValue,
//       this.answerType,
//       this.resultPoints,
//       this.explainText,
//       this.cardTitle,
//       this.cardUrl,
//       this.audioQuestion,
//       this.audioAnswer_0,
//       this.audioAnswer_1,
//       this.audioAnswer_2,
//       this.audioAnswer_3,
//       this.audioAnswer,
//       this.fixCount,
//       this.fixedCount});

//   get getContinueOrFinish => continueOrFinish;
//   get getRightAnswersCount => rightAnswersCount;
//   get getWrongAnswersCount => wrongAnswersCount;
//   get getRewardAmount => rewardAmount;
//   get getCurrentQuestionNumber => currentQuestionNumber;
//   get getTotalQuestionCount => totalQuestionCount;
//   get getImageUrl => imageUrl;
//   get getQuestion => question;
//   get getAnswerIdForApi => answerIdForApi;
//   get getAnswerVariants => answerVariants;
//   get getrightAnswer => rightAnswer;
//   get getRightAnswerStringValue => rightAnswerStringValue;
//   get getAnswerType => answerType;
//   get getResultPoints => resultPoints;
//   get getAudioQuestion => audioQuestion;

//   // Future<void> nullAudio() async {
//   //   audioAnswer = ['no audio', 'no audio', 'no audio', 'no audio'];
//   //   return audioAnswer;
//   // }

//   Future<void> getFixTaskInfo() async {
//     final url = 'https://rozoom.com.ua/tasks/fix?api_token=';
//     print(url);

//     try {
//       final headers = {'Accept': 'text/json'};
//       final response = await http.get(url + authToken, headers: headers);
//       final extractedData = json.decode(response.body);
//       // print('fix data -------- $extractedData');
//       fixCount = extractedData['fix_count'].toString();
//       // print('fix count - $fixCount');
//       fixedCount = extractedData['fixed_count'].toString();
//       // print('fix count - $fixedCount');
//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> fixTasks() async {
//     // print('start task auth token ---------------------------- $authToken');
//     final url = 'https://rozoom.com.ua/tasks/fix/start?api_token=';
//     print(url);

//     try {
//       final headers = {'Accept': 'text/json'};
//       final response = await http.get(url + authToken, headers: headers);
//       final extractedData = json.decode(response.body);
//       print('fix task -------------- $extractedData');
//       if (extractedData == null) {
//         return;
//       }
//       if (extractedData['flash'] != null) {
//         throw HttpException(extractedData['flash']['message']);
//       }

//       continueOrFinish = extractedData['result'];
//       rightAnswersCount = extractedData['session']['rights'].toString();
//       wrongAnswersCount = (int.tryParse(extractedData['session']['completed']) -
//               int.tryParse(extractedData['session']['rights']))
//           .toString();
//       rewardAmount = extractedData['session']['reward'].toString();
//       currentQuestionNumber =
//           (int.tryParse(extractedData['session']['completed']) + 1).toString();
//       totalQuestionCount = extractedData['session']['limit'].toString();
//       imageUrl = extractedData['task']['image'] != null
//           ? 'https://rozoom.com.ua/uploads/' +
//               extractedData['task']['image'].toString()
//           : '';
//       question = extractedData['task']['question'].toString();
//       answerIdForApi = extractedData['answer']['id'].toString();
//       answerVariants = extractedData['answer']['variants'];
//       rightAnswer =
//           extractedData['answer']['right_idx'].toString();
//       rightAnswerStringValue = extractedData['task']['answer'].toString();
//       answerType = extractedData['task']['type_id'].toString();
//       extractedData['task']['explain_text'] == null
//           ? explainText = ''
//           : explainText = extractedData['task']['explain_text'].toString();
//       if (extractedData['audios'] is List) {
//         audioQuestion = 'no audio';
//         audioAnswer_0 = 'no audio';
//         audioAnswer_1 = 'no audio';
//         audioAnswer_2 = 'no audio';
//         audioAnswer_3 = 'no audio';
//         audioAnswer = [
//           audioAnswer_0,
//           audioAnswer_1,
//           audioAnswer_2,
//           audioAnswer_3
//         ];
//       } else {
//         extractedData['audios']['question'] == null
//             ? audioQuestion = 'no audio'
//             : audioQuestion = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['question'].toString();
//         extractedData['audios']['answer_0'] == null
//             ? audioAnswer_0 = 'no audio'
//             : audioAnswer_0 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_0'].toString();
//         extractedData['audios']['answer_1'] == null
//             ? audioAnswer_1 = 'no audio'
//             : audioAnswer_1 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_1'].toString();
//         extractedData['audios']['answer_2'] == null
//             ? audioAnswer_2 = 'no audio'
//             : audioAnswer_2 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_2'].toString();
//         extractedData['audios']['answer_3'] == null
//             ? audioAnswer_3 = 'no audio'
//             : audioAnswer_3 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_3'].toString();
//         audioAnswer = [
//           audioAnswer_0,
//           audioAnswer_1,
//           audioAnswer_2,
//           audioAnswer_3
//         ];
//       }

//       if (extractedData['card_title'] != false) {
//         cardTitle = extractedData['card_title'];
//         cardUrl =
//             'https://rozoom.com.ua/uploads/' + extractedData['card']['image'];
//       } else {
//         cardTitle = 'no card';
//         cardUrl = 'no cardUrl';
//       }

//       // print('cardTitle --------- $cardTitle');
//       // print('cardUrl --------- $cardUrl');

//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> startTask(themeId) async {
//     // print('start task auth token ---------------------------- $authToken');
//     final url = 'https://rozoom.com.ua/task/start/$themeId?api_token=';
//     // print(url);
//     try {
//       final headers = {'Accept': 'text/json'};
//       final response = await http.get(url + authToken, headers: headers);
//       final extractedData = json.decode(response.body);
//       print(extractedData);
//       if (extractedData == null) {
//         return;
//       }
//       if (extractedData['flash'] != null) {
//         throw HttpException(extractedData['flash']['message']);
//       }

//       continueOrFinish = extractedData['result'];
//       rightAnswersCount = extractedData['session']['rights'].toString();
//       wrongAnswersCount = (int.tryParse(extractedData['session']['completed']) -
//               int.tryParse(extractedData['session']['rights']))
//           .toString();
//       rewardAmount = extractedData['session']['reward'].toString();
//       currentQuestionNumber =
//           (int.tryParse(extractedData['session']['completed']) + 1).toString();
//       totalQuestionCount = extractedData['session']['limit'].toString();
//       imageUrl = extractedData['task']['image'] != null
//           ? 'https://rozoom.com.ua/uploads/' +
//               extractedData['task']['image'].toString()
//           : '';
//       question = extractedData['task']['question'].toString();
//       answerIdForApi = extractedData['answer']['id'].toString();
//       answerVariants = extractedData['answer']['variants'];
//       rightAnswer =
//           extractedData['answer']['right_idx'].toString();
//       rightAnswerStringValue = extractedData['task']['answer'].toString();
//       answerType = extractedData['task']['type_id'].toString();
//       extractedData['task']['explain_text'] == null
//           ? explainText = ''
//           : explainText = extractedData['task']['explain_text'].toString();
//       if (extractedData['audios'] is List) {
//         audioQuestion = 'no audio';
//         audioAnswer_0 = 'no audio';
//         audioAnswer_1 = 'no audio';
//         audioAnswer_2 = 'no audio';
//         audioAnswer_3 = 'no audio';
//         audioAnswer = [
//           audioAnswer_0,
//           audioAnswer_1,
//           audioAnswer_2,
//           audioAnswer_3
//         ];
//       } else {
//         extractedData['audios']['question'] == null
//             ? audioQuestion = 'no audio'
//             : audioQuestion = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['question'].toString();
//         extractedData['audios']['answer_0'] == null
//             ? audioAnswer_0 = 'no audio'
//             : audioAnswer_0 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_0'].toString();
//         extractedData['audios']['answer_1'] == null
//             ? audioAnswer_1 = 'no audio'
//             : audioAnswer_1 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_1'].toString();
//         extractedData['audios']['answer_2'] == null
//             ? audioAnswer_2 = 'no audio'
//             : audioAnswer_2 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_2'].toString();
//         extractedData['audios']['answer_3'] == null
//             ? audioAnswer_3 = 'no audio'
//             : audioAnswer_3 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_3'].toString();
//         audioAnswer = [
//           audioAnswer_0,
//           audioAnswer_1,
//           audioAnswer_2,
//           audioAnswer_3
//         ];
//       }

//       if (extractedData['card_title'] != false) {
//         cardTitle = extractedData['card_title'];
//         cardUrl =
//             'https://rozoom.com.ua/uploads/' + extractedData['card']['image'];
//       } else {
//         cardTitle = 'no card';
//         cardUrl = 'no cardUrl';
//       }

//       // print('cardTitle --------- $cardTitle');
//       // print('cardUrl --------- $cardUrl');

//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> answerTask(answerId, answerListElementNumber) async {
//     // print('answer task auth token ---------------------------- $authToken');
//     final url =
//         'https://rozoom.com.ua/task/answer/$answerId/$answerListElementNumber?api_token=';
//     // print(url);

//     try {
//       final headers = {'Accept': 'text/json'};
//       final response = await http.get(url + authToken, headers: headers);
//       var extractedData = json.decode(response.body);
//       print(extractedData);
//       if (extractedData == null) {
//         return;
//       }

//       final sessionId = extractedData['session']['id'];
//       continueOrFinish = extractedData['result'];
//       if (extractedData['result'] == false) {
//         // print(
//         //     'result false auth token ---------------------------- $authToken');
//         final url = 'https://rozoom.com.ua/task/result/$sessionId?api_token=';
//         print('url ---------- $url');
//         final headers = {'Accept': 'text/json'};
//         final response = await http.get(url + authToken, headers: headers);
//         var extractedData = json.decode(response.body);
//         print('result data $extractedData');
//         rightAnswersCount = extractedData['session']['rights'].toString();
//         wrongAnswersCount =
//             (int.tryParse(extractedData['session']['completed']) -
//                     int.tryParse(extractedData['session']['rights']))
//                 .toString();
//         rewardAmount = extractedData['session']['reward'].toString();
//         resultPoints = extractedData['points'].toString();

//         notifyListeners();
//         return;
//       }
//       continueOrFinish = extractedData['result'];
//       rightAnswersCount = extractedData['session']['rights'].toString();
//       wrongAnswersCount = (int.tryParse(extractedData['session']['completed']) -
//               int.tryParse(extractedData['session']['rights']))
//           .toString();
//       rewardAmount = extractedData['session']['reward'].toString();
//       currentQuestionNumber =
//           (int.tryParse(extractedData['session']['completed']) + 1).toString();
//       totalQuestionCount = extractedData['session']['limit'].toString();
//       imageUrl = extractedData['task']['image'] != null
//           ? 'https://rozoom.com.ua/uploads/' +
//               extractedData['task']['image'].toString()
//           : '';

//       question = extractedData['task']['question'].toString();
//       answerIdForApi = extractedData['answer']['id'].toString();
//       answerVariants = extractedData['answer']['variants'];
//       rightAnswer =
//           extractedData['answer']['right_idx'].toString();
//       rightAnswerStringValue = extractedData['task']['answer'].toString();
//       answerType = extractedData['task']['type_id'].toString();
//       extractedData['task']['explain_text'] == null
//           ? explainText = ''
//           : explainText = extractedData['task']['explain_text'].toString();
//       if (extractedData['audios'] is List) {
//         audioQuestion = 'no audio';
//         audioAnswer_0 = 'no audio';
//         audioAnswer_1 = 'no audio';
//         audioAnswer_2 = 'no audio';
//         audioAnswer_3 = 'no audio';
//         audioAnswer = [
//           audioAnswer_0,
//           audioAnswer_1,
//           audioAnswer_2,
//           audioAnswer_3
//         ];
//       } else {
//         extractedData['audios']['question'] == null
//             ? audioQuestion = 'no audio'
//             : audioQuestion = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['question'].toString();
//         extractedData['audios']['answer_0'] == null
//             ? audioAnswer_0 = 'no audio'
//             : audioAnswer_0 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_0'].toString();
//         extractedData['audios']['answer_1'] == null
//             ? audioAnswer_1 = 'no audio'
//             : audioAnswer_1 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_1'].toString();
//         extractedData['audios']['answer_2'] == null
//             ? audioAnswer_2 = 'no audio'
//             : audioAnswer_2 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_2'].toString();
//         extractedData['audios']['answer_3'] == null
//             ? audioAnswer_3 = 'no audio'
//             : audioAnswer_3 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_3'].toString();
//         audioAnswer = [
//           audioAnswer_0,
//           audioAnswer_1,
//           audioAnswer_2,
//           audioAnswer_3
//         ];
//       }

//       if (extractedData['card_title'] != false) {
//         cardTitle = extractedData['card_title'];
//         cardUrl =
//             'https://rozoom.com.ua/uploads/' + extractedData['card']['image'];
//       } else {
//         cardTitle = 'no card';
//         cardUrl = 'no cardUrl';
//       }

//       // print('cardTitle --------- $cardTitle');
//       // print('cardUrl --------- $cardUrl');

//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> answerTaskWithForm(answerId, answerText) async {
//     // print(
//     //     'answer form task auth token ---------------------------- $authToken');
//     final url =
//         'https://rozoom.com.ua/task/answer/$answerId/text?text=$answerText&api_token=';
//     try {
//       final headers = {'Accept': 'text/json'};
//       final response = await http.get(url + authToken, headers: headers);

//       var extractedData = json.decode(response.body);
//       // print(extractedData);
//       if (extractedData == null) {
//         return;
//       }

//       final sessionId = extractedData['session']['id'];
//       continueOrFinish = extractedData['result'];
//       if (extractedData['result'] == false) {
//         // print(
//         //     'result false form auth token ---------------------------- $authToken');
//         final url = 'https://rozoom.com.ua/task/result/$sessionId?api_token=';
//         final headers = {'Accept': 'text/json'};
//         final response = await http.get(url + authToken, headers: headers);
//         var extractedData = json.decode(response.body);
//         rightAnswersCount = extractedData['session']['rights'].toString();
//         wrongAnswersCount =
//             (int.tryParse(extractedData['session']['completed']) -
//                     int.tryParse(extractedData['session']['rights']))
//                 .toString();
//         rewardAmount = extractedData['session']['reward'].toString();
//         resultPoints = extractedData['points'].toString();

//         notifyListeners();
//         return;
//       }
//       continueOrFinish = extractedData['result'];
//       rightAnswersCount = extractedData['session']['rights'].toString();
//       wrongAnswersCount = (int.tryParse(extractedData['session']['completed']) -
//               int.tryParse(extractedData['session']['rights']))
//           .toString();
//       rewardAmount = extractedData['session']['reward'].toString();
//       currentQuestionNumber =
//           (int.tryParse(extractedData['session']['completed']) + 1).toString();
//       totalQuestionCount = extractedData['session']['limit'].toString();
//       imageUrl = extractedData['task']['image'] != null
//           ? 'https://rozoom.com.ua/uploads/' +
//               extractedData['task']['image'].toString()
//           : '';

//       question = extractedData['task']['question'].toString();
//       answerIdForApi = extractedData['answer']['id'].toString();
//       answerVariants = extractedData['answer']['variants'];
//       rightAnswer =
//           extractedData['answer']['right_idx'].toString();
//       rightAnswerStringValue = extractedData['task']['answer'].toString();
//       answerType = extractedData['task']['type_id'].toString();
//       extractedData['task']['explain_text'] == null
//           ? explainText = ''
//           : explainText = extractedData['task']['explain_text'].toString();
//       if (extractedData['audios'] is List) {
//         audioQuestion = 'no audio';
//         audioAnswer_0 = 'no audio';
//         audioAnswer_1 = 'no audio';
//         audioAnswer_2 = 'no audio';
//         audioAnswer_3 = 'no audio';
//         audioAnswer = [
//           audioAnswer_0,
//           audioAnswer_1,
//           audioAnswer_2,
//           audioAnswer_3
//         ];
//       } else {
//         extractedData['audios']['question'] == null
//             ? audioQuestion = 'no audio'
//             : audioQuestion = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['question'].toString();
//         extractedData['audios']['answer_0'] == null
//             ? audioAnswer_0 = 'no audio'
//             : audioAnswer_0 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_0'].toString();
//         extractedData['audios']['answer_1'] == null
//             ? audioAnswer_1 = 'no audio'
//             : audioAnswer_1 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_1'].toString();
//         extractedData['audios']['answer_2'] == null
//             ? audioAnswer_2 = 'no audio'
//             : audioAnswer_2 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_2'].toString();
//         extractedData['audios']['answer_3'] == null
//             ? audioAnswer_3 = 'no audio'
//             : audioAnswer_3 = 'https://rozoom.com.ua/uploads/' +
//                 extractedData['audios']['answer_3'].toString();
//         audioAnswer = [
//           audioAnswer_0,
//           audioAnswer_1,
//           audioAnswer_2,
//           audioAnswer_3
//         ];
//       }

//       if (extractedData['card_title'] != false) {
//         cardTitle = extractedData['card_title'];
//         cardUrl =
//             'https://rozoom.com.ua/uploads/' + extractedData['card']['image'];
//       } else {
//         cardTitle = 'no card';
//         cardUrl = 'no cardUrl';
//       }

//       // print('cardTitle --------- $cardTitle');
//       // print('cardUrl --------- $cardUrl');

//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//   }
// }

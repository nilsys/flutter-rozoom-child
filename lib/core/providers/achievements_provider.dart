import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rozoom_app/core/models/exceptions.dart';
import 'package:rozoom_app/shared/constants.dart';

class AchievmentCategoryModel {
  final String id;
  final String name;
  AchievmentCategoryModel({this.id, this.name});
}

class AchievmentModel {
  final String id;
  final String categoryId;
  final String description;
  final String price;
  final String imageUrl;
  final String status;

  AchievmentModel(
      {this.id,
      this.categoryId,
      this.description,
      this.price,
      this.imageUrl,
      this.status});
}

class CardModel {
  final String id;
  final String count;
  final String title;
  final String description;
  final String imageUrl;

  CardModel({
    this.id,
    this.count,
    this.title,
    this.description,
    this.imageUrl,
  });
}

class Achievments extends ChangeNotifier {
  final String authToken;
  Achievments(this.authToken);

  String _apiToString;
  String get apiToString => _apiToString;

  bool _isLoadingScreen = true;
  bool get isLoadingScreen => _isLoadingScreen;
  bool _isLoadingWidget = false;
  bool get isLoadingWidget => _isLoadingWidget;

  List<AchievmentCategoryModel> _achievCategoriesItems = [];
  List<AchievmentCategoryModel> get achievCategoriesItems =>
      _achievCategoriesItems;

  List<AchievmentModel> _achievmentItems = [];
  List<AchievmentModel> get achievmentItems => _achievmentItems;

  List<AchievmentModel> achievWithCat(index) {
    return _achievmentItems
        .where((item) => item.categoryId == _achievCategoriesItems[index].id)
        .toList();
  }

  List<CardModel> _cardItems = [];
  List<CardModel> get cardItems => _cardItems;

  String _dialogMessage;
  String get dialogMessage => _dialogMessage;

  // static const baseUrl = 'https://new.rozoom.co.ua';

  Map<String, String> get headers =>
      {'Accept': 'text/json', 'Authorization': 'Bearer $authToken'};

  Future<void> apiGetAchievments() async {
    const urlSegment = '/achievements';
    final url = rozoomBaseUrl + urlSegment;

    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      parseAchievmentCategories(extractedData['categories']);
      parseAchievments(extractedData);
      _isLoadingScreen = false;
      notifyListeners();
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      throw HttpException('Час сессії закінчився!');
    }
  }

  Future<void> apiGetReward(id) async {
    final urlSegment = '/achievements/reward/$id';
    final url = rozoomBaseUrl + urlSegment;
    print('url --------------- $url');

    try {
      _isLoadingWidget = true;
      notifyListeners();
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      print(extractedData);
      //{result: false, flash: {message: Ви отримали винагороду, type: success}}
      _dialogMessage = extractedData['flash']['message'];
      await apiGetAchievments();
      _isLoadingWidget = false;
      notifyListeners();
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      throw HttpException('Час сессії закінчився!');
    }
  }

  void parseAchievmentCategories(List data) {
    try {
      List<AchievmentCategoryModel> loadedCategories = [];
      for (var i = 0; i < data.length; i++) {
        loadedCategories.add(AchievmentCategoryModel(
          id: data[i]['id'] != null ? data[i]['id'].toString() : '',
          name: data[i]['name'] != null ? data[i]['name'] : '',
        ));
      }
      _achievCategoriesItems = loadedCategories;
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Категорії нагород тимчасово недоступні');
    }
  }

  void parseAchievments(Map data) {
    try {
      List<AchievmentModel> loadedAchievments = [];
      Map<String, dynamic> achievmentsData = data['achievements'];
      Map<String, dynamic> achievementStatusData =
          data['achievements_progress'];
      achievmentsData.forEach((key, value) {
        for (var i = 0; i < value.length; i++) {
          loadedAchievments.add(
            AchievmentModel(
                id: value[i]['id'].toString(),
                categoryId: value[i]['category_id'].toString(),
                description: value[i]['description'],
                price: value[i]['price'].toString(),
                imageUrl:
                    'assets/images/achievements/${value[i]['category_id'].toString()}.png',
                status: achievementStatusData[value[i]['id'].toString()]),
          );
        }
      });
      Map<String, dynamic> bigAchievmentsData = data['big_achievements'];

      bigAchievmentsData.forEach((key, value) {
        loadedAchievments.add(
          AchievmentModel(
              id: value['id'].toString(),
              categoryId: value['category_id'].toString(),
              description: value['description'],
              price: value['price'].toString(),
              imageUrl: 'assets/images/achievements/9.png',
              status: achievementStatusData[value['id'].toString()]),
        );
      });

      _achievmentItems = loadedAchievments;
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Нагороди тимчасово недоступні');
    }
  }

  Future<void> apiGetCards() async {
    const urlSegment = '/cards';
    final url = rozoomBaseUrl + urlSegment;

    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      parseCards(extractedData);
      _isLoadingScreen = false;
      notifyListeners();
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      throw HttpException('Час сессії закінчився!');
    }
  }

  void parseCards(Map data) {
    try {
      List<CardModel> loadedCards = [];
      List<dynamic> cardsData = data['cards'];
      print(cardsData.length);
      for (var i = 0; i < cardsData.length; i++) {
        if (cardsData[i]['card'] != null) {
          String dirtyDescription =
              cardsData[i]['card']['translate']['description'] != null
                  ? cardsData[i]['card']['translate']['description']
                  : '';
          print(dirtyDescription);
          final String description = removeAllHtmlTags(dirtyDescription);
          loadedCards.add(CardModel(
            id: cardsData[i]['card_id'] != null
                ? cardsData[i]['card_id'].toString()
                : '',
            count: cardsData[i]['count'] != null
                ? cardsData[i]['count'].toString()
                : '',
            title: cardsData[i]['card']['translate']['title'] != null
                ? cardsData[i]['card']['translate']['title']
                : '',
            description: description,
            imageUrl: cardsData[i]['card']['image'] != null
                ? 'https://rozoom.com.ua/uploads/' +
                    cardsData[i]['card']['image']
                : '',
          ));
        }
      }

      _cardItems = loadedCards;
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Картки тимчасово недоступні');
    }
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }
}

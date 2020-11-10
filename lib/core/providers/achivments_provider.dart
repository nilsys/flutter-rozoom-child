import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rozoom_app/core/models/http_exception.dart';

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

class Achievments extends ChangeNotifier {
  final String authToken;
  Achievments(this.authToken);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

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

  static const baseUrl = 'https://new.rozoom.co.ua';

  Map<String, String> get headers =>
      {'Accept': 'text/json', 'Authorization': 'Bearer $authToken'};

  Future<void> apiGetAchievments() async {
    const urlSegment = '/achievements';
    final url = baseUrl + urlSegment;

    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      parseAchievmentCategories(extractedData['categories']);
      parseAchievments(extractedData);
      _isLoading = false;
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
      print(loadedAchievments.last.id);
      _achievmentItems = loadedAchievments;
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Нагороди тимчасово недоступні');
    }
  }
}

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:fresh4you/data/local/cache_response.dart';
import 'package:fresh4you/data/model/api_response.dart';
import 'package:fresh4you/features/deal/domain/services/featured_deal_service_interface.dart';
import 'package:fresh4you/features/product/domain/models/product_model.dart';

import 'package:fresh4you/helper/api_checker.dart';
import 'package:fresh4you/main.dart';
import 'package:fresh4you/utill/app_constants.dart';

class FeaturedDealController extends ChangeNotifier {
  final FeaturedDealServiceInterface featuredDealServiceInterface;
  FeaturedDealController({required this.featuredDealServiceInterface});

  int? _featuredDealSelectedIndex;
  List<Product>? _featuredDealProductList;
  List<Product>? get featuredDealProductList => _featuredDealProductList;
  int? get featuredDealSelectedIndex => _featuredDealSelectedIndex;

  Future<void> getFeaturedDealList(bool reload) async {
    var localData =
        await database.getCacheResponseById(AppConstants.featuredDealUri);

    if (localData != null) {
      _featuredDealProductList = [];
      var featuredDealProductList = jsonDecode(localData.response);
      featuredDealProductList.forEach((featuredDealProduct) =>
          _featuredDealProductList?.add(Product.fromJson(featuredDealProduct)));
      notifyListeners();
    }

    _featuredDealProductList = [];
    ApiResponse apiResponse =
        await featuredDealServiceInterface.getFeaturedDeal();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200 &&
        apiResponse.response!.data.toString() != '{}') {
      _featuredDealProductList = [];
      apiResponse.response!.data.forEach(
          (fDeal) => _featuredDealProductList?.add(Product.fromJson(fDeal)));
      _featuredDealSelectedIndex = 0;

      if (localData != null) {
        await database.updateCacheResponse(
            AppConstants.featuredDealUri,
            CacheResponseCompanion(
              endPoint: const Value(AppConstants.featuredDealUri),
              header: Value(jsonEncode(apiResponse.response!.headers.map)),
              response: Value(jsonEncode(apiResponse.response!.data)),
            ));
      } else {
        await database.insertCacheResponse(
          CacheResponseCompanion(
            endPoint: const Value(AppConstants.featuredDealUri),
            header: Value(jsonEncode(apiResponse.response!.headers.map)),
            response: Value(jsonEncode(apiResponse.response!.data)),
          ),
        );
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void changeSelectedIndex(int selectedIndex) {
    _featuredDealSelectedIndex = selectedIndex;
    notifyListeners();
  }
}

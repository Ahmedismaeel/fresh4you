import 'package:flutter/material.dart';
import 'package:fresh4you/data/model/api_response.dart';
import 'package:fresh4you/features/onboarding/domain/models/onboarding_model.dart';
import 'package:fresh4you/features/onboarding/domain/services/onboarding_service_interface.dart';
import 'package:fresh4you/helper/api_checker.dart';

class OnBoardingController with ChangeNotifier {
  final OnBoardingServiceInterface onBoardingServiceInterface;

  OnBoardingController({required this.onBoardingServiceInterface});

  final List<OnboardingModel> _onBoardingList = [];
  List<OnboardingModel> get onBoardingList => _onBoardingList;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  changeSelectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void getOnBoardingList() async {
    ApiResponse apiResponse = await onBoardingServiceInterface.getList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _onBoardingList.clear();
      _onBoardingList.addAll(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }
}

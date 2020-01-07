import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/surveyAssignment.dart';
import '../configs/configuration.dart';
import '../utils/navigation_service.dart';
import '../utils/route_paths.dart' as routes;
import '../utils/locator.dart';

enum AppState { Idle, Busy }

class TaskModel with ChangeNotifier {
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  List<SurveyAssignment> _surveyAssignments = [];
  List<SurveyAssignment> get surveyAssignments => _surveyAssignments;

  Future<List<SurveyAssignment>> getAssignments() async {
    final NavigationService _navigationService = locator<NavigationService>();
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(AppState.Busy);
      var responce =
          await http.get(Configuration.apiurl + 'SurveyAssignment', headers: {
        "Content-Type": "application/json",
        "Authorization": preferences.getString("accesstoken")
      });
      if (responce.statusCode == 200) {
        Map responseJson=json.decode(responce.body);
        Iterable i = responseJson['data'];
        _surveyAssignments =
            i.map((model) => SurveyAssignment.fromJson(model)).toList();
      } else if (responce.statusCode == 401) {
        _navigationService.navigateRepalceTo(routes.LoginRoute);
      } else {
        _surveyAssignments = [];
        setState(AppState.Idle);
        notifyListeners();
      }
    } catch (e) {
      setState(AppState.Idle);
      notifyListeners();
      print(e);
    }
    setState(AppState.Idle);
    return _surveyAssignments;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../pages/auth/auth_page.dart';
import '../../../pages/auth/login_page.dart';
import '../../../pages/auth/register_page.dart';
import '../../../pages/error/error_page.dart';
import '../../../pages/game/game_statistics_page.dart';
import '../../../pages/game/indoor/create_game/indoor_create_game_page.dart';
import '../../../pages/game/indoor/create_game/qr_create_page.dart';
import '../../../pages/game/indoor/create_game/qr_list_page.dart';
import '../../../pages/game/indoor/game/indoor_game_detail_page.dart';
import '../../../pages/game/indoor/game/indoor_game_page.dart';
import '../../../pages/game/organizer_panel_page.dart';
import '../../../pages/game/outdoor/out_map_page.dart';
import '../../../pages/game/outdoor/outdoor_game_detail_page.dart';
import '../../../pages/game/outdoor/outdoor_play_game_page.dart';
import '../../../pages/game/outdoor/outdoor_player_istatistik.dart';
import '../../../pages/home/home_page.dart';
import '../../../pages/home/subpages/event_list_subpage.dart';
import '../../../pages/home/subpages/orienteering_explanation_subpage.dart';
import '../../../pages/user/user_edit_page.dart';
import '../../constants/navigation/navigation_constant.dart';

class NavigationRouteManager {
  NavigationRouteManager._init();

  static NavigationRouteManager? _instance;
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  static NavigationRouteManager? get instance {
    _instance ??= NavigationRouteManager._init();
    return _instance;
  }

  Future<List<String>> fetchGameTitles(String userId) async {
  // Bu metot outdoor_games koleksiyonunda belirtilen kullanıcıya ait tüm belgeleri alır.
  final QuerySnapshot querySnapshot = 
      await FirebaseFirestore.instance.collection('outdoor_games').get();

  // Bu metot her bir belgenin ID'sini alır ve bir liste halinde döndürür.
 final List<String> gameTitles = querySnapshot.docs.map((doc) => doc['gametitle'].toString()).toList();

  return gameTitles;
}

  MaterialPageRoute _navigationToFuture(Widget Function(List<String> gameTitles) pageBuilder, RouteSettings args) {
  return MaterialPageRoute(
    builder: (context) => FutureBuilder<List<String>>(
      future: fetchGameTitles(currentUserId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return ErrorPage();
        } else {
          return pageBuilder(snapshot.data!);
        }
      },
    ),
    settings: args,
  );
}

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstant.auth:
        return _navigationToDefault(const AuthPage(), args);
      case NavigationConstant.error:
        return _navigationToDefault(const ErrorPage(), args);
      case NavigationConstant.login:
        return _navigationToDefault(LoginPage(), args);
      case NavigationConstant.register:
        return _navigationToDefault(RegisterPage(), args);
      case NavigationConstant.home:
        return _navigationToDefault(const HomePage(), args);
      case NavigationConstant.userEdit:
        return _navigationToDefault(const UserEditPage(), args);
      case NavigationConstant.eventList:
        return _navigationToDefault(const EventListSubpage(), args);
      case NavigationConstant.indoorCreateGame:
        return _navigationToDefault(const IndoorCraeteGame(), args);
      case NavigationConstant.outdoorMapPage:
        return _navigationToDefault(const OutMapPage(), args);
      case NavigationConstant.qrList:
        return _navigationToDefault(const QrListPage(), args);
      case NavigationConstant.qrCreate:
        return _navigationToDefault(const QrCratePage(), args);
      case NavigationConstant.indoorGameDetail:
        return _navigationToDefault(const IndoorGameDetailPage(), args);
      case NavigationConstant.outdoorGameDetail:
        return _navigationToDefault(const OutdoorGameDetailPage(), args);
      case NavigationConstant.outdoorPlayGame:
        return _navigationToDefault(const OutdoorPlayGame(), args);
      case NavigationConstant.playerStatsPage:
        return _navigationToFuture((gameTitles) {
          return PlayerStatsPage(userId: currentUserId.toString(), gameIds: gameTitles);
        }, args);
      case NavigationConstant.organizerPanel:
        return _navigationToDefault(const OrganizerPanelPage(), args);
      case NavigationConstant.indoorGame:
        return _navigationToDefault(const IndoorGamePage(), args);
      case NavigationConstant.orienteeringExplanation:
        return _navigationToDefault(const OrienteeringExplanationSubPage(), args);
      case NavigationConstant.gameStatistics:
        return _navigationToDefault(const GameStatisticsPage(), args);
      default:
        return _navigationToDefault(const ErrorPage(), args);
    }
  }

  MaterialPageRoute _navigationToDefault(Widget page, RouteSettings args) => MaterialPageRoute(builder: (context) => page, settings: args);
}

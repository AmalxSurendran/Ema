import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HiveUtils{
  static String exerciseInstVideoViewBoxKey = "exerciseInstVideoView";
  static String userPrefsBoxKey = "userPrefs";

  static String viewInstVideo = "viewInstVideo";

  static bool getInstViewedStatus(String gexid) {
    return Hive.box(exerciseInstVideoViewBoxKey).get(gexid,defaultValue: false);
  }
  static Future<void> setInstViewedStatus(String gexid,bool status) {
    return Hive.box(exerciseInstVideoViewBoxKey).put(gexid,status);
  }

  static dynamic getUserPreference(String key){
    return Hive.box(userPrefsBoxKey).get(key,defaultValue: null);
  }

  static Future<void> setUserPreference(String key,bool status){
    return Hive.box(userPrefsBoxKey).put(key,status);
  }

  static init() async {
    await Hive.initFlutter();
    await Hive.openBox(exerciseInstVideoViewBoxKey);
    await Hive.openBox(userPrefsBoxKey);
  }
}
import 'package:shared_preferences/shared_preferences.dart';

class ConfigureService {
  static const nameKey = 'nameOfMonAmour';
  static const numberKey = 'numberOfMonAmour';
  static const waitingTimeKey = 'waitingTime';

  static Future<ConfigureModel> getConfig() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final nameOfMonAmour = prefs.getString(nameKey);
    final numberOfMonAmour = prefs.getString(numberKey);
    final waitingTime = prefs.getInt(waitingTimeKey);

    return ConfigureModel(
        nameOfMonAmour: nameOfMonAmour ?? '',
        numberOfMonAmour: numberOfMonAmour ?? '',
        waitingTime: waitingTime ?? 3);
  }

  static Future<ConfigureModel> saveWaitingTime(int waitingTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(waitingTimeKey, waitingTime);

    return await getConfig();
  }

  static Future<ConfigureModel> saveMonAmour(
      {String numberOfMonAmour = '', String nameOfMonAmour = ''}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(nameKey, nameOfMonAmour);
    await prefs.setString(numberKey, numberOfMonAmour);

    return await getConfig();
  }

  static Future<bool> isReady() async {
    final conf = await getConfig();
    return conf.nameOfMonAmour.isNotEmpty;
  }
}

class ConfigureModel {
  ConfigureModel(
      {required this.numberOfMonAmour,
      required this.nameOfMonAmour,
      required this.waitingTime});

  final int waitingTime;
  final String numberOfMonAmour;
  final String nameOfMonAmour;
}

import 'package:current_weather_temp/data/get_location.dart';
import 'package:current_weather_temp/data/model/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

final weatherProvider = FutureProvider(
  (ref) => WeatherApi().getWeatherData().then((value) => value),
);

class WeatherApi {
  final String? apiKey = dotenv.env["ENCODING_KEY"];
  final String? url = dotenv.env['API_URL'];
  var dateTime = DateTime.now();

  Future getWeatherData() async {
    var gridPoint = await Located().getXYCode();
    //var baseTime = DateFormat('HH00').format(dateTime);
    var baseTime = getBaseTime();
    var baseDate = DateFormat('yyyyMMdd').format(dateTime);
    int numOfRows = 10;
    int pageNo = 1;

    String baseUrl =
        '$url?serviceKey=$apiKey&numOfRows$numOfRows&pageNo=$pageNo&dataType=JSON&base_date=$baseDate&base_time=$baseTime&nx=${gridPoint['x']}&ny=${gridPoint['y']}';

    final response = await http.get(Uri.parse(baseUrl));

    try {
      if (response.statusCode == 200) {
        final weather = weatherFromJson(response.body);

        return weather;
      } else {
        Fluttertoast.showToast(msg: 'Error');
        return 'Error : statusCode != 200';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error : cant try');
      return 'Error: cant try';
    }
  }

  String getBaseTime() {
    var hour = int.parse(DateFormat('HH').format(dateTime));
    var min = int.parse(DateFormat('mm').format(dateTime));

    if (min <= 20) {
      hour = hour - 1;
      return '${hour}00';
    } else {
      return '${hour}00';
    }
  }
}

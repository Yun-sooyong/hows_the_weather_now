// ignore_for_file: library_prefixes, constant_identifier_names, avoid_print

import 'dart:math' as Math;

import 'package:current_weather_temp/data/model/plcae_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

final localeProvider = FutureProvider((ref) => Located().getPlace());

class Located {
  dynamic _getLocale() async {
    Map locale = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      double v1 = double.parse(value.longitude.toStringAsFixed(9));
      double v2 = double.parse(value.latitude.toStringAsFixed(9));
      Map<String, dynamic> positionMap = {
        'lat': v2,
        'lng': v1,
      };
      return positionMap;
    });

    return locale;
  }

  dynamic getXYCode() async {
    var locale = await _getLocale();

    if (locale != null) {
      try {
        return ConvGridGps.gpsToGRID(locale['lat'], locale['lng']);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  dynamic getPlace() async {
    var locale = await _getLocale();
    final String? url = dotenv.env['KAKAO_URL'];

    String baseUrl =
        '$url?input_coord=WGS84&output_coord=WGS84&y=${locale['lat']}&x=${locale['lng']}';
    final response = await http.get(Uri.parse(baseUrl),
        headers: {"Authorization": "KakaoAK ${dotenv.env['KAKAO_REST']}"});

    try {
      if (response.statusCode == 200) {
        final place = placeFromJson(response.body);

        var depth1 = place.documents[0].region1DepthName;
        var depth3 = place.documents[0].region3DepthName;
        // var adressName = place.documents[0].addressName;

        return '$depth1, $depth3';
      } else {
        Fluttertoast.showToast(msg: '${response.statusCode} Error');
        return 'error';
      }
    } catch (e) {
      print(e.toString());
      //e.toString();
    }
  }

  dynamic getGrid() async {
    var convGridValue = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      try {
        return ConvGridGps.gpsToGRID(value.latitude, value.longitude);
      } catch (e) {
        print('좌표 불러오기 오류 : ${e.toString()}');
      }
    });

    return convGridValue;
  }
}

class ConvGridGps {
  static const double RE = 6371.00877; // 지구 반경(km)
  static const double GRID = 5.0; // 격자 간격(km)
  static const double SLAT1 = 30.0; // 투영 위도1(degree)
  static const double SLAT2 = 60.0; // 투영 위도2(degree)
  static const double OLON = 126.0; // 기준점 경도(degree)
  static const double OLAT = 38.0; // 기준점 위도(degree)
  static const double XO = 43; // 기준점 X좌표(GRID)
  static const double YO = 136; // 기1준점 Y좌표(GRID)

  static const double DEGRAD = Math.pi / 180.0;
  static const double RADDEG = 180.0 / Math.pi;

  static double get re => RE / GRID;
  static double get slat1 => SLAT1 * DEGRAD;
  static double get slat2 => SLAT2 * DEGRAD;
  static double get olon => OLON * DEGRAD;
  static double get olat => OLAT * DEGRAD;

  static double get snTmp =>
      Math.tan(Math.pi * 0.25 + slat2 * 0.5) /
      Math.tan(Math.pi * 0.25 + slat1 * 0.5);
  static double get sn =>
      Math.log(Math.cos(slat1) / Math.cos(slat2)) / Math.log(snTmp);

  static double get sfTmp => Math.tan(Math.pi * 0.25 + slat1 * 0.5);
  static double get sf => Math.pow(sfTmp, sn) * Math.cos(slat1) / sn;

  static double get roTmp => Math.tan(Math.pi * 0.25 + olat * 0.5);

  static double get ro => re * sf / Math.pow(roTmp, sn);

  static gridToGPS(int v1, int v2) {
    var rs = {};
    double theta;

    rs['x'] = v1;
    rs['y'] = v2;
    int xn = (v1 - XO).toInt();
    int yn = (ro - v2 + YO).toInt();
    var ra = Math.sqrt(xn * xn + yn * yn);
    if (sn < 0.0) ra = -ra;
    var alat = Math.pow((re * sf / ra), (1.0 / sn));
    alat = 2.0 * Math.atan(alat) - Math.pi * 0.5;

    if (xn.abs() <= 0.0) {
      theta = 0.0;
    } else {
      if (yn.abs() <= 0.0) {
        theta = Math.pi * 0.5;
        if (xn < 0.0) theta = -theta;
      } else {
        theta = Math.atan2(xn, yn);
      }
    }
    var alon = theta / sn + olon;
    rs['lat'] = alat * RADDEG;
    rs['lng'] = alon * RADDEG;

    return rs;
  }

  static gpsToGRID(double v1, double v2) {
    var rs = {};
    double theta;

    rs['lat'] = v1;
    rs['lng'] = v2;
    var ra = Math.tan(Math.pi * 0.25 + (v1) * DEGRAD * 0.5);
    ra = re * sf / Math.pow(ra, sn);
    theta = v2 * DEGRAD - olon;
    if (theta > Math.pi) theta -= 2.0 * Math.pi;
    if (theta < -Math.pi) theta += 2.0 * Math.pi;
    theta *= sn;
    rs['x'] = (ra * Math.sin(theta) + XO + 0.5).floor();
    rs['y'] = (ro - ra * Math.cos(theta) + YO + 0.5).floor();

    return rs;
  }
}

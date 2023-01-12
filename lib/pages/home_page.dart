import 'package:current_weather_temp/data/get_date.dart';
import 'package:current_weather_temp/data/get_location.dart';
import 'package:current_weather_temp/data/get_weather.dart';
import 'package:current_weather_temp/data/model/weather_model.dart';
import 'package:current_weather_temp/pages/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue weatherDate = ref.watch(weatherProvider);
    var currentDate = ref.watch(dateProvider);
    var place = ref.watch(localeProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        drawer: drawer(context),
        appBar: AppBar(
          title: const Text('지금 날씨는?'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            // data reload
            IconButton(
              onPressed: () => ref.refresh(weatherProvider.future),
              icon: const Icon(Icons.replay),
            ),
          ],
        ),

        /// weather.response.body.items.item[index].category
        body: weatherDate.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Text('$error'),
          data: (weatherDate) {
            Weather weather = weatherDate;

            var weatherType =
                weather.response.body.items.item[0].obsrValue; // 강수형태
            var precipitation = double.parse(
                weather.response.body.items.item[2].obsrValue); // 강수량
            //var humidity = weather.response.body.items.item[1].obsrValue; // 습도
            var temperatures =
                weather.response.body.items.item[3].obsrValue; // 기온
            var hour = int.parse(currentDate.getHour());

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  viewWeatherIcon(weatherType, precipitation, hour),
                  Text(
                    '$temperatures ℃',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(height: 50),
                  Text(currentDate.getCurrentDate()),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(place.value.toString()),
                    ],
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// 기상청 초단기실황의 날씨 분류가 정확하지 않아 어느정도 임의로 분류함
  dynamic viewWeatherIcon(String weatherType, double precipitation, int hour) {
    String dayOrNight = hour >= 18 ? 'night' : 'day';

    if (weatherType == '0') {
      return Image.asset(
        'lib/assets/icons/${dayOrNight}Clear.png',
        scale: 1.7,
      );
    } else if (weatherType == '1') {
      if (precipitation <= 3) {
        return Image.asset(
          'lib/assets/icons/rain.png',
          scale: 1.7,
        );
      } else if (precipitation > 15) {
        return Image.asset(
          'lib/assets/icons/rain3.png',
          scale: 1.7,
        );
      } else {
        return Image.asset(
          'lib/assets/icons/rain2.png',
          scale: 1.7,
        );
      }
    } else if (weatherType == '2') {
      return Image.asset(
        'lib/assets/icons/${dayOrNight}Snow.png',
        scale: 1.7,
      );
    } else if (weatherType == '3') {
      return Image.asset(
        'lib/assets/icons/${dayOrNight}Snow.png',
        scale: 1.7,
      );
    } else if (weatherType == '5') {
      return Image.asset(
        'lib/assets/icons/rain.png',
        scale: 1.7,
      );
    } else {
      return Image.asset(
        'lib/assets/icons/${dayOrNight}Cloudy.png',
        scale: 1.7,
      );
    }
  }
}

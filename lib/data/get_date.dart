import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateProvider = Provider((ref) => Dated());

class Dated {
  String getCurrentDate() =>
      DateFormat('yyyy년 MM월 dd일 E요일', 'ko').format(DateTime.now());

  String getHour() => DateFormat('HH').format(DateTime.now());
}

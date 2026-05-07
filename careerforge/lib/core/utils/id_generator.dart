import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class IdGenerator {
  static const _uuid = Uuid();

  static String generateUuid() {
    return _uuid.v4();
  }

  static String generateApplicationId(DateTime date) {
    final dateString = DateFormat('yyyyMMdd').format(date);
    final randomHex = List.generate(4, (_) => Random().nextInt(16).toRadixString(16)).join().toUpperCase();
    return 'APP-$dateString-$randomHex';
  }
}

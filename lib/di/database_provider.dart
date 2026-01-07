import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:line_a_day/core/database/isar_service.dart';

final isarProvider = Provider<Isar>((ref) {
  return IsarService.instance;
});
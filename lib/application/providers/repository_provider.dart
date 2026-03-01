

import 'package:ai_business_card_scanner/domain/repositories/contact_repository.dart';
import 'package:ai_business_card_scanner/infrastructure/repositories_impl/contact_repository_impl.dart';
import 'package:ai_business_card_scanner/infrastructure/services/ocr_service.dart';
import 'package:ai_business_card_scanner/infrastructure/services/sheets_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final ocrServiceProvider = Provider<OcrService>((ref) {
  return OcrService();
});

final sheetsServiceProvider = Provider<SheetsService>((ref) {
  final dio = ref.read(dioProvider);
  return SheetsService(dio);
});

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepositoryImpl(
    ocrService: ref.read(ocrServiceProvider),
    sheetsService: ref.read(sheetsServiceProvider),
  );
});
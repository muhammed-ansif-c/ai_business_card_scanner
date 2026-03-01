
import 'package:ai_business_card_scanner/domain/entities/contact.dart';
import 'package:dio/dio.dart';

class SheetsService {
  final Dio _dio;

  SheetsService(this._dio);

  Future<void> sendToGoogleSheets(Contact contact) async {
    const webhookUrl = "https://script.google.com/macros/s/AKfycbzLWxsiazSb3iA6g1bO0qgpsNuJtv3_z4OL-niA-9lggCfppRKU8ummJkr25XtegrMD/exec";

    try {
      await _dio.post(
        webhookUrl,
        data: {
          "name": contact.name,
          "company": contact.company,
          "phone": contact.phone,
          "email": contact.email,
          "website": contact.website,
          "date": contact.createdAt.toIso8601String(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
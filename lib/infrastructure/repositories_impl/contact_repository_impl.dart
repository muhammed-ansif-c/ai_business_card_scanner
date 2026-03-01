

import 'package:ai_business_card_scanner/core/utils/contact_parser.dart';
import 'package:ai_business_card_scanner/domain/entities/contact.dart';
import 'package:ai_business_card_scanner/domain/repositories/contact_repository.dart';
import 'package:ai_business_card_scanner/infrastructure/services/ocr_service.dart';
import 'package:ai_business_card_scanner/infrastructure/services/sheets_service.dart';
import 'package:hive/hive.dart';

class ContactRepositoryImpl implements ContactRepository {
  final OcrService ocrService;
  final SheetsService sheetsService;

  ContactRepositoryImpl({
    required this.ocrService,
    required this.sheetsService,
  });

 @override
Future<Contact> scanBusinessCard(String imagePath) async {
  final rawText = await ocrService.extractText(imagePath);

 final name = ContactParser.extractName(rawText);
final company = ContactParser.extractCompany(rawText);
final phone = ContactParser.extractPhone(rawText);
final email = ContactParser.extractEmail(rawText);
final website = ContactParser.extractWebsite(rawText);
final address = ContactParser.extractAddress(rawText);


  return Contact(
    name: name,
    company: company,
    phone: phone,
    email: email,
    website: website,
    address: address,
    createdAt: DateTime.now(),
  );
}


@override
Future<void> saveToSheets(Contact contact) async {
  final box = Hive.box('contacts');

  // Always save locally first
  await box.add({
    "name": contact.name,
    "company": contact.company,
    "phone": contact.phone,
    "email": contact.email,
    "website": contact.website,
    "address": contact.address,
    "date": contact.createdAt.toIso8601String(),
  });

  // Try sending to Google but do not fail app
  try {
    await sheetsService.sendToGoogleSheets(contact);
  } catch (_) {
    // Ignore Google error for stability
  }
}

 @override
Future<List<Contact>> getSavedContacts() async {
  final box = Hive.box('contacts');

  final contacts = box.values.map((e) {
    final map = Map<String, dynamic>.from(e);
    return Contact(
      name: map['name'] ?? '',
      company: map['company'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      address: map['address'],
      createdAt: DateTime.parse(map['date']),
    );
  }).toList();

  return contacts;
}

}
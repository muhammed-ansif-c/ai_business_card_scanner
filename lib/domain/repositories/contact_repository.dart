

import 'package:ai_business_card_scanner/domain/entities/contact.dart';

abstract class ContactRepository {
  Future<Contact> scanBusinessCard(String imagePath);
  Future<void> saveToSheets(Contact contact);
  Future<List<Contact>> getSavedContacts();
}
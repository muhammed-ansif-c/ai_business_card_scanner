

import 'package:ai_business_card_scanner/application/providers/repository_provider.dart';
import 'package:ai_business_card_scanner/domain/entities/contact.dart';
import 'package:ai_business_card_scanner/domain/repositories/contact_repository.dart';
import 'package:flutter_riverpod/legacy.dart';

class ScanState {
  final bool isLoading;
  final Contact? contact;
  final String? error;

  const ScanState({
    this.isLoading = false,
    this.contact,
    this.error,
  });

  ScanState copyWith({
    bool? isLoading,
    Contact? contact,
    String? error,
  }) {
    return ScanState(
      isLoading: isLoading ?? this.isLoading,
      contact: contact ?? this.contact,
      error: error,
    );
  }
}

class ScanNotifier extends StateNotifier<ScanState> {
  final ContactRepository repository;

  ScanNotifier(this.repository) : super(const ScanState());

  Future<void> scan(String imagePath) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final contact = await repository.scanBusinessCard(imagePath);
      state = state.copyWith(isLoading: false, contact: contact);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

Future<void> scanBoth(String frontPath, String backPath) async {
  state = state.copyWith(isLoading: true, error: null);

  try {
    final front = await repository.scanBusinessCard(frontPath);
    final back = await repository.scanBusinessCard(backPath);

    final mergedContact = Contact(
      name: front.name != "Not Available" ? front.name : back.name,
      company: front.company != "Not Available" ? front.company : back.company,
      phone: front.phone != "Not Available" ? front.phone : back.phone,
      email: front.email != "Not Available" ? front.email : back.email,
      website: front.website != "Not Available" ? front.website : back.website,
      address: back.address,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      isLoading: false,
      contact: mergedContact,
    );
  } catch (e) {
    state = state.copyWith(
      isLoading: false,
      error: "Scanning failed",
    );
  }
}


 Future<void> save(Contact contact) async {
  state = state.copyWith(isLoading: true, error: null);

  try {
    await repository.saveToSheets(contact);
    state = state.copyWith(isLoading: false);
  } catch (_) {
    state = state.copyWith(
      isLoading: false,
      error: "Failed to save. Please try again.",
    );
  }
}


//Reset while navigating back from dashboard screen 
void reset() {
  state = const ScanState();
}


}

final scanProvider =
    StateNotifierProvider<ScanNotifier, ScanState>((ref) {
  final repo = ref.read(contactRepositoryProvider);
  return ScanNotifier(repo);
});
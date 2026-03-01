

import 'package:ai_business_card_scanner/application/providers/repository_provider.dart';
import 'package:ai_business_card_scanner/domain/entities/contact.dart';
import 'package:ai_business_card_scanner/domain/repositories/contact_repository.dart';
import 'package:flutter_riverpod/legacy.dart';

class DashboardState {
  final bool isLoading;
  final List<Contact> contacts;
  final String? error;

  const DashboardState({
    this.isLoading = false,
    this.contacts = const [],
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    List<Contact>? contacts,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      contacts: contacts ?? this.contacts,
      error: error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final ContactRepository repository;

  DashboardNotifier(this.repository) : super(const DashboardState());

  Future<void> loadContacts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final contacts = await repository.getSavedContacts();
      state = state.copyWith(
        isLoading: false,
        contacts: contacts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repo = ref.read(contactRepositoryProvider);
  return DashboardNotifier(repo);
});
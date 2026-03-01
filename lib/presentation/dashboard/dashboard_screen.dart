

import 'package:ai_business_card_scanner/application/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).loadContacts();
    });
  }


Future<void> _call(String phone) async {
  final cleaned = phone.replaceAll(RegExp(r'\D'), '');
  final uri = Uri.parse("tel:$cleaned");

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}


// Future<void> _whatsapp(String phone) async {
//   final cleaned = phone.replaceAll(RegExp(r'\D'), '');
//   final uri = Uri.parse("https://wa.me/$cleaned");

//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   }
// }


Future<void> _whatsapp(String phone) async {
  String cleaned = phone.replaceAll(RegExp(r'\D'), '');

  // If 10 digits, assume India
  if (cleaned.length == 10) {
    cleaned = '91$cleaned';
  }

  // If starts with 0
  if (cleaned.startsWith('0')) {
    cleaned = '91${cleaned.substring(1)}';
  }

  final uri = Uri.parse("whatsapp://send?phone=$cleaned");

  try {
    await launchUrl(uri);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("WhatsApp not installed")),
    );
  }
}


@override
Widget build(BuildContext context) {
  final state = ref.watch(dashboardProvider);

  final filtered = state.contacts.where((contact) {
    return contact.name
        .toLowerCase()
        .contains(searchQuery.toLowerCase());
  }).toList();

  return Scaffold(
    backgroundColor: const Color(0xFFF4F8FF),
    appBar: AppBar(
      backgroundColor: Colors.blue,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Saved Contacts",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 🔍 Search Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by name",
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // 🔄 Loading
          if (state.isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),

          // ❌ Empty State
          if (!state.isLoading && filtered.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "No contacts saved yet",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

          // 📋 Contact List
          if (!state.isLoading && filtered.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final contact = filtered[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.blue.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            // 👤 Avatar
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child: Text(
                                contact.name.isNotEmpty
                                    ? contact.name[0].toUpperCase()
                                    : "?",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            // 📄 Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    contact.company,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 📞 Actions
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.call,
                                        color: Colors.blue),
                                    onPressed: () =>
                                        _call(contact.phone),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.message,
                                        color: Colors.green),
                                    onPressed: () =>
                                        _whatsapp(contact.phone),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    ),
  );
}
}
import 'dart:io';

import 'package:ai_business_card_scanner/application/providers/scan_provider.dart';
import 'package:ai_business_card_scanner/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  File? _frontImage;
  File? _backImage;

  Future<void> _pickImage(bool isFront) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(picked.path);
        } else {
          _backImage = File(picked.path);
        }
      });

      // Auto scan when both images selected
      if (_frontImage != null && _backImage != null) {
        await ref
            .read(scanProvider.notifier)
            .scanBoth(_frontImage!.path, _backImage!.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Business Card Scanner"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(true),
              child: const Text("Upload Front Image"),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () => _pickImage(false),
              child: const Text("Upload Back Image"),
            ),

            const SizedBox(height: 16),

            if (_frontImage != null)
              Column(
                children: [
                  const Text("Front Image"),
                  Image.file(_frontImage!, height: 120),
                  const SizedBox(height: 8),
                ],
              ),

            if (_backImage != null)
              Column(
                children: [
                  const Text("Back Image"),
                  Image.file(_backImage!, height: 120),
                  const SizedBox(height: 8),
                ],
              ),

            const SizedBox(height: 16),

            if (state.isLoading) const CircularProgressIndicator(),

            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  state.error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            if (state.contact != null)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${state.contact!.name}"),
                      Text("Company: ${state.contact!.company}"),
                      Text("Phone: ${state.contact!.phone}"),
                      Text("Email: ${state.contact!.email}"),
                      Text("Website: ${state.contact!.website}"),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        // onPressed: () async {
                        //   await ref
                        //       .read(scanProvider.notifier)
                        //       .save(state.contact!);

                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text("Saved Successfully")),
                        //   );

                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => const DashboardScreen(),
                        //     ),
                        //   );
                        // },
                        onPressed: () async {
                          final contact = state.contact;
                          if (contact == null) return;

                          await ref.read(scanProvider.notifier).save(contact);

                          // Reset provider state
                          ref.read(scanProvider.notifier).reset();

                          // Clear selected images
                          setState(() {
                            _frontImage = null;
                            _backImage = null;
                          });

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Contact saved successfully"),
                            ),
                          );

                          // Navigate to Dashboard
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DashboardScreen(),
                            ),
                          );
                        },

                        child: const Text("Save to Google Sheets"),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

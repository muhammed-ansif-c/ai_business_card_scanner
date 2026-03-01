# AI Business Card Scanner App

A Flutter application that scans business cards using OCR, extracts contact details, saves them to Google Sheets, and displays saved contacts in a dashboard.

---

## 📌 Features

- Upload front & back images of business card
- Extract text using Google ML Kit (OCR)
- Parse Name, Company, Phone, Email, Website
- Save extracted data to Google Sheets via Webhook
- Local caching using Hive
- Dashboard with:
  - Search functionality
  - Call integration
  - WhatsApp integration
- Proper error handling & loading states

---

## 🏗 Architecture

This project follows Clean Architecture with clear separation of concerns:

lib/
- domain/
  - entities/
  - repositories/
- infrastructure/
  - services/
  - repositories_impl/
- application/
  - providers/
- presentation/
  - scan/
  - dashboard/

### Layers Explanation

**Domain Layer**
- Contains business entities (Contact)
- Contains repository contracts
- No dependency on Flutter

**Infrastructure Layer**
- OCR Service (Google ML Kit)
- Google Sheets Service (Dio Webhook)
- Repository implementation
- Hive local storage

**Application Layer**
- Riverpod state management
- Scan provider
- Dashboard provider

**Presentation Layer**
- UI screens
- Scan screen
- Dashboard screen

---

## 🤖 AI / OCR Implementation

Google ML Kit Text Recognition is used to extract raw text from the business card image.

Steps:
1. Image picked using image_picker
2. Passed to ML Kit TextRecognizer
3. Extracted raw text
4. Parsed using custom ContactParser utility
5. Mapped to Contact entity

Regex is used to extract:
- Phone number
- Website
- Email

---

## 📊 Google Sheets Integration

Google Apps Script Webhook is used.

Process:
1. Created Google Sheet
2. Created Apps Script extension
3. Published as Web App
4. Used generated Webhook URL
5. Sent data using Dio POST request

Data sent:
- name
- company
- phone
- email
- website
- date

---

## 💾 Local Storage

Hive is used to cache saved contacts locally.

- Data stored when Save is clicked
- Dashboard loads from Hive
- Enables offline access

---

## 🚀 Setup Instructions

1. Clone the repository
2. Run:
   flutter pub get
3. Add your Google Apps Script Webhook URL inside:
   infrastructure/services/sheets_service.dart
4. Run:
   flutter run

---

## 📦 State Management

Riverpod StateNotifier is used for:

- Scan state
- Dashboard state
- Repository injection

Provides:
- Loading states
- Error handling
- Clean separation from UI

---

## 📱 External Integrations

- Phone call: tel://
- WhatsApp: https://wa.me/
- url_launcher package used

---

## 🎯 Evaluation Coverage

✔ OCR Implementation  
✔ Google Sheets Integration  
✔ Clean Architecture  
✔ Riverpod State Management  
✔ Dashboard with search  
✔ Call & WhatsApp integration  
✔ Error handling  
✔ Local caching (Hive)  

---

## 👨‍💻 Developer Notes

This project was developed with production-level separation of concerns and scalable architecture structure.

class ContactParser {
  static String extractEmail(String text) {
    final emailRegex =
        RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
    final match = emailRegex.firstMatch(text);
    return match?.group(0) ?? "Not Available";
  }

  static String extractPhone(String text) {
    final phoneRegex =
        RegExp(r'(\+?\d[\d\s\-]{8,}\d)');
    final match = phoneRegex.firstMatch(text);
    return match?.group(0) ?? "Not Available";
  }

  static String extractWebsite(String text) {
    final websiteRegex =
        RegExp(r'(www\.[\w\-]+\.\w+|https?:\/\/[\w\-\.]+)');
    final match = websiteRegex.firstMatch(text);
    return match?.group(0) ?? "Not Available";
  }

  static String extractName(String text) {
    final lines = text.split('\n');
    if (lines.isNotEmpty) {
      return lines.first.trim();
    }
    return "Not Available";
  }

  static String extractCompany(String text) {
    final lines = text.split('\n');
    if (lines.length > 1) {
      return lines[1].trim();
    }
    return "Not Available";
  }

  static String extractAddress(String text) {
  final lines = text.split('\n');

  for (var line in lines) {
    final lower = line.toLowerCase();

    if (lower.contains("street") ||
        lower.contains("road") ||
        lower.contains("india") ||
        lower.contains("kerala") ||
        lower.contains("address") ||
        RegExp(r'\d{6}').hasMatch(line)) {
      return line.trim();
    }
  }

  return "Not Available";
}

}
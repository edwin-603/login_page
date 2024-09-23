import 'package:flutter/material.dart';
import 'package:ocr_scan_text/ocr_scan_text.dart';

class ScanAllModule extends ScanModule {
  ScanAllModule()
      : super(
    label: '',
    color: Colors.redAccent.withOpacity(0.3),
    validateCountCorrelation: 1,
  );

  @override
  Future<List<ScanResult>> matchedResult(
      List<TextBlock> textBlocks,
      String fullText,
      ) async {
    List<ScanResult> results = [];
    RegExp aadhaarRegex = RegExp(r'\d{4} \d{4} \d{4}');
    RegExp dobRegex = RegExp(r'\d{2}[/\-]\d{2}[/\-]\d{4}');
    RegExp genderRegex = RegExp(r'Male|Female|Transgender', caseSensitive: false);
    RegExp addressRegex = RegExp(r'Address:\s*(.*?)(\d{6})$', multiLine: true);

    String extractedName = '';
    String extractedAadhaarNumber = '';
    String extractedDob = '';
    String extractedGender = '';
    String extractedAddress = '';
    String previousLine = '';

    // List of common Aadhaar card keywords to ignore in name extraction
    List<String> keywordsToIgnore = [
      'Government of India',
    ];

    for (var block in textBlocks) {
      for (var line in block.lines) {
        String lineText = line.text.trim();

        if (aadhaarRegex.hasMatch(lineText)) {
          extractedAadhaarNumber = aadhaarRegex.firstMatch(lineText)?.group(0) ?? '';
        }

        if (dobRegex.hasMatch(lineText)) {
          extractedDob = dobRegex.firstMatch(lineText)?.group(0) ?? '';

          if (extractedName.isEmpty) {
            bool isNameValid = !keywordsToIgnore.any((keyword) => previousLine.contains(keyword));
            if (isNameValid) {
              extractedName = previousLine;
            }
          }
        }

        if (genderRegex.hasMatch(lineText)) {
          extractedGender = genderRegex.firstMatch(lineText)?.group(0) ?? '';
        }
        if (addressRegex.hasMatch(lineText)) {
          extractedAddress = addressRegex.firstMatch(lineText)?.group(1)?.trim() ?? '';
        }

        previousLine = lineText;

        results.add(
          ScanResult(
            cleanedText: lineText,
            scannedElementList: line.elements,
          ),
        );
      }
    }

    print('Extracted Name: $extractedName');
    print('Extracted Aadhaar Number: $extractedAadhaarNumber');
    print('Extracted DOB: $extractedDob');
    print('Extracted Gender: $extractedGender');
    print('Extracted Address: $extractedAddress');

    results.add(
      ScanResult(
        cleanedText: 'Name: $extractedName, Aadhaar: $extractedAadhaarNumber, DOB: $extractedDob, Gender: $extractedGender',
        scannedElementList: [],
      ),
    );

    return results;
  }
}

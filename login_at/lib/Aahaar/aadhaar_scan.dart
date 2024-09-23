import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:login_at/Aahaar/aadhaar_address.dart';
import 'package:login_at/Aahaar/scan_all.dart';
import 'package:ocr_scan_text/ocr_scan_text.dart';
import 'aadhaar_details.dart';

class AadhaarScanDetailsPage extends StatefulWidget {
  const AadhaarScanDetailsPage({Key? key}) : super(key: key);

  @override
  _AadhaarScanDetailsPageState createState() => _AadhaarScanDetailsPageState();
}

class _AadhaarScanDetailsPageState extends State<AadhaarScanDetailsPage> {
  // TTS instance
  final FlutterTts _flutterTts = FlutterTts();

  String extractedName = '';
  String extractedAadhaarNumber = '';
  String extractedDob = '';
  String extractedGender = '';

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("en-US");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan"),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            margin: const EdgeInsets.all(16),
            child: _buildLiveScan(),
          ),
          // Display extracted details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Name', extractedName),
                  const SizedBox(height: 10),
                  _buildDetailRow('Aadhaar Number', extractedAadhaarNumber),
                  const SizedBox(height: 10),
                  _buildDetailRow('DOB', extractedDob),
                  const SizedBox(height: 10),
                  _buildDetailRow('Gender', extractedGender),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (extractedName.isNotEmpty && extractedAadhaarNumber.isNotEmpty) {
                _speakDetails();
                Get.to(() => AadhaarAddressScanPage(
                  name: extractedName,
                  dob: extractedDob,
                  aadhaarNumber: extractedAadhaarNumber,
                  gender: extractedGender,

                ));
              } else {
                Get.snackbar('Error', 'Please scan the Aadhaar details before proceeding.', snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text('Scan Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveScan() {
    return LiveScanWidget(
      ocrTextResult: (ocrTextResult) {
        setState(() {
          ocrTextResult.mapResult.forEach((module, result) {
            print('Result for module $module: $result');

            if (result is List<ScanResult>) {
              for (var data in result) {
                if (data.cleanedText.contains('Name:')) {
                  extractedName = data.cleanedText.split('Name: ')[1].split(', ')[0];
                }
                if (data.cleanedText.contains('Aadhaar:')) {
                  extractedAadhaarNumber = data.cleanedText.split('Aadhaar: ')[1].split(', ')[0];
                }
                if (data.cleanedText.contains('DOB:')) {
                  extractedDob = data.cleanedText.split('DOB: ')[1].split(', ')[0];
                }
                if (data.cleanedText.contains('Gender:')) {
                  extractedGender = data.cleanedText.split('Gender: ')[1];
                }
              }
            } else {
              print('Unexpected result type: ${result.runtimeType}');
            }
          });
        });
      },
      scanModules: [ScanAllModule()..start()],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  void _speakDetails() async {
    String details = 'Name: $extractedName, Aadhaar Number: $extractedAadhaarNumber, DOB: $extractedDob, Gender: $extractedGender';
    await _flutterTts.speak(details);
  }
}

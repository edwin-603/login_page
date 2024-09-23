import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:login_at/Aahaar/scan_all.dart';
import 'package:ocr_scan_text/ocr_scan/model/scan_result.dart';
import 'package:ocr_scan_text/ocr_scan/widget/live_scan_widget.dart';
import 'aadhaar_details.dart';

class AadhaarAddressScanPage extends StatefulWidget {
  final String name;
  final String aadhaarNumber;
  final String dob;
  final String gender;

  const AadhaarAddressScanPage({
    Key? key,
    required this.name,
    required this.aadhaarNumber,
    required this.dob,
    required this.gender,
  }) : super(key: key);

  @override
  _AadhaarAddressScanPageState createState() => _AadhaarAddressScanPageState();
}

class _AadhaarAddressScanPageState extends State<AadhaarAddressScanPage> {
  final FlutterTts _flutterTts = FlutterTts();
  String extractedAddress = '';

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("en-US");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Address"),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            margin: const EdgeInsets.all(16),
            child: _buildLiveScan(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Address', extractedAddress),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {

                Get.to(() => AadhaarDetailsPage(
                  name: widget.name,
                  dob: widget.dob,
                  aadhaarNumber: widget.aadhaarNumber,
                  gender: widget.gender,
                ));

            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveScan() {
    return LiveScanWidget(
      ocrTextResult: (ocrTextResult) {
        setState(() {
          extractedAddress = '';

          ocrTextResult.mapResult.forEach((module, result) {
            if (result is List<ScanResult>) {
              for (var data in result) {
                if (data.cleanedText.contains('Address:')) {
                  extractedAddress = data.cleanedText.split('Address: ')[1].trim();
                  break;
                }
              }
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
          child: Text(value.isNotEmpty ? value : ''),
        ),
      ],
    );
  }
}

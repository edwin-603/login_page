import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AadhaarDetailsPage extends StatefulWidget {
  final String name;
  final String dob;
  final String aadhaarNumber;
  final String gender;

  const AadhaarDetailsPage({
    Key? key,
    required this.name,
    required this.dob,
    required this.aadhaarNumber,
    required this.gender,
  }) : super(key: key);

  @override
  _AadhaarDetailsPageState createState() => _AadhaarDetailsPageState();
}

class _AadhaarDetailsPageState extends State<AadhaarDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Aadhaar Details'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildDetailRow('Name', widget.name),
                const SizedBox(height: 10),
                _buildDetailRow('Date of Birth', widget.dob),
                const SizedBox(height: 10),
                _buildDetailRow('Aadhaar Number', widget.aadhaarNumber),
                const SizedBox(height: 10),
                _buildDetailRow('Gender', widget.gender),
                const SizedBox(height: 20),

                // Mobile Number
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    hintText: 'Mobile Number'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number'.tr;
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Mobile number must be 10 digits'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.snackbar(
                        'Success'.tr,
                        'Aadhaar details submitted successfully'.tr,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      // Speak Aadhaar details
                      String details = 'Name: ${widget.name}, Date of Birth: ${widget.dob}, Aadhaar Number: ${widget.aadhaarNumber}, Gender: ${widget.gender}';
                      _speak(details);
                    }
                  },
                  child: Text('Submit'.tr),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

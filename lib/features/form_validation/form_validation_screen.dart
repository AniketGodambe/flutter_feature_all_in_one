import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feature_all_in_one/view_source_code.dart';

class FormValidationScreen extends StatefulWidget {
  const FormValidationScreen({super.key});

  @override
  State<FormValidationScreen> createState() => _FormValidationScreenState();
}

class _FormValidationScreenState extends State<FormValidationScreen> {
  TextEditingController fullNameCTR = TextEditingController();
  TextEditingController addressCTR = TextEditingController();
  TextEditingController emailCTR = TextEditingController();
  TextEditingController mobileCTR = TextEditingController();
  TextEditingController pincodeCTR = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Validations"),
        actions: [
          ElevatedButton(
            onPressed: () {
              String filePath =
                  'lib/features/form_validation/form_validation_screen.dart';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SourceCodeView(filePath: filePath),
                ),
              );
            },
            child: Text('Source Code'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customTextField(
                textController: fullNameCTR,
                hintText: "Full Name",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Full name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _customTextField(
                hintText: "Address",
                textController: addressCTR,
                keyBoardType: TextInputType.streetAddress,
              ),
              const SizedBox(height: 20),

              _customTextField(
                hintText: "Email",
                textController: emailCTR,
                keyBoardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email is required";
                  }
                  // Simple email regex validation
                  String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _customTextField(
                hintText: "Mobile",
                textController: mobileCTR,
                keyBoardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Mobile number is required";
                  }
                  // Check if mobile is 10 digits
                  String pattern = r'^\d{10}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return "Enter a valid 10-digit mobile number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _customTextField(
                hintText: "Pincode",
                textController: pincodeCTR,
                keyBoardType: TextInputType.phone,
                maxLength: 6,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Pincode is required";
                  }
                  // Check if pincode is 6 digits
                  String pattern = r'^\d{6}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return "Enter a valid 6-digit pincode";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.white,
                onTap: () {
                  var payload = {
                    "full_name": fullNameCTR.text.trim(),
                    "address": addressCTR.text.trim(),
                    "email": emailCTR.text.trim(),
                    "mobile": mobileCTR.text.trim(),
                    "pincode": pincodeCTR.text.trim(),
                  };
                  if (formKey.currentState!.validate()) {
                    print("Form Validated. Procced for action");

                    print(jsonEncode(payload));
                  } else {
                    print(jsonEncode(payload));
                    print("InValid. Fail");
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _customTextField({
    required TextEditingController textController,
    hintText,
    TextInputType keyBoardType = TextInputType.text,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return TextFormField(
      controller: textController,
      keyboardType: keyBoardType,
      validator: validator,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: InkWell(
          onTap: () {
            textController.clear();
            setState(() {});
          },
          child: Icon(Icons.close, color: Colors.grey),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

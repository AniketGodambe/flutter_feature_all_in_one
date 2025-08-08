import 'package:flutter/material.dart';
import 'package:flutter_feature_all_in_one/features/fetch_device_contacts/fetch_device_contacts_screen.dart';
import 'package:flutter_feature_all_in_one/features/select_image/selecte_image_screen.dart';
import 'package:flutter_feature_all_in_one/features/list_pagination/list_pagination_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Features")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: List.generate(featureList.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        featureList[index]['navigation'] as Widget,
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: EdgeInsets.only(bottom: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color(0xFFD3EEF4), Color(0xFFF1EEC8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 8),
                      color: Colors.black.withAlpha(100),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  featureList[index]['featureName'].toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  static List<Map<String, Object>> featureList = [
    {"featureName": "Select Image", "navigation": SelecteImageScreen()},
    {
      "featureName": "Fetch Device Contacts",
      "navigation": FetchDeviceContactsScreen(),
    },
    {"featureName": "List Pagination", "navigation": ListPaginationAPI()},
  ];
}

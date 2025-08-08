import 'package:flutter/material.dart';
import 'package:flutter_feature_all_in_one/features/biometric/add_biometric_screen.dart';
import 'package:flutter_feature_all_in_one/features/fetch_device_contacts/fetch_device_contacts_screen.dart';
import 'package:flutter_feature_all_in_one/features/open_street_maps/open_street_map_screen.dart';
import 'package:flutter_feature_all_in_one/features/select_image/selecte_image_screen.dart';
import 'package:flutter_feature_all_in_one/features/list_pagination/list_pagination_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Features")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 16, // Horizontal space between grid items
            mainAxisSpacing: 16, // Vertical space between grid items
            childAspectRatio:
                3 / 1, // Width to height ratio of each item (adjust as needed)
          ),
          itemCount: featureList.length,
          itemBuilder: (context, index) {
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
                alignment: Alignment.center,
                child: Text(
                  featureList[index]['featureName'].toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
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
    {"featureName": "Bio-Metric", "navigation": AddBiometricScreen()},
    {"featureName": "Open Street Map", "navigation": OpenStreetMapScreen()},
  ];
}

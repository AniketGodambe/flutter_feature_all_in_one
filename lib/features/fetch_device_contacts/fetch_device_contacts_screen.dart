import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_all_in_one/view_source_code.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class FetchDeviceContactsScreen extends StatefulWidget {
  const FetchDeviceContactsScreen({super.key});

  @override
  State<FetchDeviceContactsScreen> createState() =>
      _FetchDeviceContactsScreenState();
}

class _FetchDeviceContactsScreenState extends State<FetchDeviceContactsScreen> {
  List<Contact>? contacts;
  bool isLoading = true;
  bool permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndFetch();
  }

  Future<void> _checkPermissionAndFetch() async {
    setState(() {
      isLoading = true;
      permissionDenied = false;
    });

    var status = await Permission.contacts.status;

    if (status.isGranted) {
      _fetchContacts();
    } else if (status.isDenied) {
      PermissionStatus newStatus = await Permission.contacts.request();

      if (newStatus.isGranted) {
        _fetchContacts();
      } else if (newStatus.isPermanentlyDenied) {
        setState(() {
          permissionDenied = true;
          isLoading = false;
        });
        openAppSettings();
      } else {
        setState(() {
          permissionDenied = true;
          isLoading = false;
        });
      }
    } else if (status.isPermanentlyDenied) {
      setState(() {
        permissionDenied = true;
        isLoading = false;
      });
    } else {
      setState(() {
        permissionDenied = true;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchContacts() async {
    try {
      final result = await FastContacts.getAllContacts();
      setState(() {
        contacts = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        contacts = [];
        isLoading = false;
      });
    }
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Colors.grey[400]),
          title: Container(height: 20, color: Colors.grey[400]),
          subtitle: Container(height: 14, color: Colors.grey[400]),
        ),
      ),
      separatorBuilder: (_, __) => Divider(),
      itemCount: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Contacts')),
        body: _buildShimmerList(),
      );
    }

    if (permissionDenied) {
      return Scaffold(
        appBar: AppBar(title: Text('Contacts')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Permission denied!'),
              ElevatedButton(
                onPressed: () {
                  openAppSettings();
                },
                child: Text('Open App Settings'),
              ),
              ElevatedButton(
                onPressed: _checkPermissionAndFetch,
                child: Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          ElevatedButton(
            onPressed: () {
              String filePath =
                  'lib/features/fetch_device_contacts/fetch_device_contacts_screen.dart';
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
      body: contacts == null || contacts!.isEmpty
          ? Center(child: Text('No contacts found.'))
          : ListView.separated(
              itemBuilder: (_, index) {
                final contact = contacts![index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      contact.displayName.isNotEmpty
                          ? contact.displayName[0]
                          : '?',
                    ),
                  ),
                  title: Text(contact.displayName),
                  subtitle: Text(
                    contact.phones.map((e) => e.number).join(", ").isEmpty
                        ? "-"
                        : contact.phones.map((e) => e.number).join(", "),
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(),
              itemCount: contacts!.length,
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feature_all_in_one/view_source_code.dart';
import 'package:local_auth/local_auth.dart';

class AddBiometricScreen extends StatefulWidget {
  const AddBiometricScreen({super.key});

  @override
  State<AddBiometricScreen> createState() => _AddBiometricScreenState();
}

class _AddBiometricScreenState extends State<AddBiometricScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool isAuthenticated = false;
  String _authorized = 'Not Authorized';

  @override
  void initState() {
    super.initState();
    _checkBiometricsAvailability();
  }

  Future<void> _checkBiometricsAvailability() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;

      _authenticate();
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      authenticated = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      isAuthenticated = authenticated;
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image Example"),
        actions: [
          ElevatedButton(
            onPressed: () {
              String filePath =
                  'lib/features/biometric/add_biometric_screen.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Can Check Biometrics: $_canCheckBiometrics'),
            SizedBox(height: 20),
            Text('Authentication Status: $_authorized'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _canCheckBiometrics ? _authenticate : null,
              child: Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}

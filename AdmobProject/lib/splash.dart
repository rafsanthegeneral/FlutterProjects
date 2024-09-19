import 'package:esyearn/dashboard/dashboard.dart';
import 'package:esyearn/dashboard/home.dart';
import 'package:esyearn/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkNetwork();
  }

  Future<void> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    await Future.delayed(
        Duration(seconds: 2)); // Simulate a delay for the splash screen

    if (connectivityResult == ConnectivityResult.none) {
      // No network connection
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NoNetworkPage()),
      );
    } else {
      // Connected to a network
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png', // Ensure this path is correct
              width: 150,
              height: 150,
            ),
            Text(
              'Easy Earn',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class NoNetworkPage extends StatefulWidget {
  @override
  _NoNetworkPageState createState() => _NoNetworkPageState();
}

class _NoNetworkPageState extends State<NoNetworkPage> {
  bool _isChecking = false;

  Future<void> _checkNetwork() async {
    setState(() {
      _isChecking = true;
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    await Future.delayed(Duration(seconds: 1)); // Simulate a short delay

    setState(() {
      _isChecking = false;
    });

    if (connectivityResult != ConnectivityResult.none) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Still no network connection.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Network'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.wifi_off,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'No network connection',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            _isChecking
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _checkNetwork,
                    child: Text('Retry'),
                  ),
          ],
        ),
      ),
    );
  }
}

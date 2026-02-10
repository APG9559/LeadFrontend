import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    // small delay for splash effect
    await Future.delayed(const Duration(seconds: 2));

    String? token = await storage.read(key: "token");

    if (!mounted) return;

    if (token != null) {
      Navigator.pushReplacementNamed(context, "/leads");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://res.cloudinary.com/shipit-cdn/images/c_scale,w_448,h_299,dpr_2/f_auto,q_auto/v1733410609/wordpress/new-york/new-york.jpg?_i=AA',
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/geolocation_service.dart';
import 'search_page.dart';
import 'weather_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  Future<void> getLocationData() async {
    final geolocationService = context.read<GeolocationService>();
    final position = await geolocationService.getCurrentPosition();

    if (mounted) {
      if (position != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherPage(
              locationName: 'Position actuelle',
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement de votre position...'),
          ],
        ),
      ),
    );
  }
}

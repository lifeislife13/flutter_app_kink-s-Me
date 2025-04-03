import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Récupère la position GPS réelle de l'utilisateur.
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Localisation désactivée.");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        debugPrint("Permission localisation refusée en permanence.");
        return null;
      }
    }
    if (permission == LocationPermission.denied) {
      debugPrint("Permission localisation refusée.");
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
      );
    } catch (e) {
      debugPrint("Erreur getCurrentLocation: $e");
      return null;
    }
  }

  /// Convertit une position GPS en nom de ville.
  static Future<String?> getCityFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality;
      }
    } catch (e) {
      debugPrint("Erreur getCityFromCoordinates: $e");
    }
    return null;
  }

  /// Renvoie une position fictive correspondant au centre de la ville
  /// de l'utilisateur, en utilisant son nom de ville.
  static Future<Position?> getCityCenter(Position realPosition) async {
    String? city = await getCityFromCoordinates(realPosition);
    if (city != null) {
      try {
        List<Location> locations = await locationFromAddress(city);
        if (locations.isNotEmpty) {
          return Position(
            latitude: locations.first.latitude,
            longitude: locations.first.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
        }
      } catch (e) {
        debugPrint("Erreur getCityCenter: $e");
      }
    }
    return null;
  }
}

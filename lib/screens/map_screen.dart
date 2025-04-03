// map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_and_messaging_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  bool _anonymized = true;
  late Future<LatLng> _cityCenterFuture;
  List<Map<String, dynamic>> _userProfiles = [];

  @override
  void initState() {
    super.initState();
    _cityCenterFuture = _getUserCityCenter();
    _loadUserProfiles().then((profiles) {
      setState(() {
        _userProfiles = profiles;
      });
    });
  }

  Future<LatLng> _getUserCityCenter() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      return LatLng(48.8566, 2.3522); // Paris fallback
    }
  }

  Future<List<Map<String, dynamic>>> _loadUserProfiles() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'pseudo': data['pseudo'] ?? 'Anonyme',
        'profileText': data['profileText'] ?? '',
        'photoURL': data['photoURL'] ?? '',
        'uid': doc.id,
        'location': data['location'],
      };
    }).toList();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _shareLocationWithBuddy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Localisation partagée avec Buddy.")),
    );
  }

  void _showUserBottomSheet(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    user['photoURL'].isNotEmpty
                        ? NetworkImage(user['photoURL'])
                        : const AssetImage('assets/avatar.png')
                            as ImageProvider,
              ),
              const SizedBox(height: 12),
              Text(
                user['pseudo'],
                style: const TextStyle(color: Colors.amber, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                user['profileText'],
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.chat),
                label: const Text("Discuter"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChatAndMessagingScreen(
                            isChat: true,
                            userPseudo: user['pseudo'],
                            userPhoto: user['photoURL'],
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("La Boussole des Désirs"),
        backgroundColor: Colors.black,
        actions: [
          Row(
            children: [
              const Text("Anonyme", style: TextStyle(color: Colors.white)),
              Switch(
                value: _anonymized,
                onChanged: (val) {
                  setState(() {
                    _anonymized = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<LatLng>(
        future: _cityCenterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur lors du chargement de la carte.\n${snapshot.error}",
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final LatLng center = snapshot.data!;
            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: center, zoom: 12),
              markers: {
                Marker(
                  markerId: const MarkerId("userCenter"),
                  position: center,
                  infoWindow: const InfoWindow(title: "Ma position"),
                ),
                ..._userProfiles
                    .map((user) {
                      final loc = user['location'];
                      if (loc == null ||
                          user['uid'] ==
                              FirebaseAuth.instance.currentUser?.uid) {
                        return null;
                      }
                      return Marker(
                        markerId: MarkerId(user['uid']),
                        position: LatLng(loc['latitude'], loc['longitude']),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueViolet,
                        ),
                        onTap: () {
                          _showUserBottomSheet(user);
                        },
                      );
                    })
                    .whereType<Marker>()
                    .toSet(),
              },
              myLocationEnabled: true,
              mapType: MapType.normal,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _shareLocationWithBuddy,
        child: const Icon(Icons.location_on),
      ),
    );
  }
}

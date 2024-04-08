import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocalización en Mapa',
      home: LocalizacionScreen(),
    );
  }
}

class LocalizacionScreen extends StatefulWidget {
  @override
  _LocalizacionScreenState createState() => _LocalizacionScreenState();
}


class _LocalizacionScreenState extends State<LocalizacionScreen> {
  late GoogleMapController mapController;
  late LatLng _currentLocation;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied) {
      // El usuario denegó el permiso, puedes mostrar un mensaje o solicitar nuevamente
    } else if (status.isPermanentlyDenied) {
      // El usuario denegó el permiso de forma permanente, debes redirigirlo a la configuración de la aplicación
      openAppSettings();
    }
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Geolocalización'),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _currentLocation, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: _currentLocation == null
                  ? Set<Marker>()
                  : {
                      Marker(
                        markerId: const MarkerId('current_location'),
                        position: _currentLocation,
                        infoWindow: const InfoWindow(title: 'Tu Ubicación'),
                      ),
                    },
            ),
    );
  }
}

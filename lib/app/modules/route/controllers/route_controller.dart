import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class RouteController extends GetxController {
  // Observables
  // final isLoading = true.obs;
  // final errorMessage = ''.obs;
  // final markers = <Marker>{}.obs;
  // final polylines = <Polyline>{}.obs;

  // // Variables
  // GoogleMapController? mapController;
  // Position? currentPosition;

  // // Coordonnées de l'ISM (à adapter selon votre localisation)
  // final LatLng ismLocation = const LatLng(14.6937, -17.4441); // Dakar, Sénégal

  // // Plus besoin de clé API Google Maps !

  // @override
  // void onInit() {
  //   super.onInit();
  //   initializeMap();
  // }

  // Future<void> initializeMap() async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';

  //     // Obtenir la position actuelle
  //     Position? position = await getCurrentLocation();
  //     if (position != null) {
  //       currentPosition = position;

  //       // Ajouter les marqueurs
  //       addMarkers();

  //       // Obtenir et afficher l'itinéraire
  //       await getRoute();
  //     }
  //   } catch (e) {
  //     errorMessage.value = "Erreur lors de l'obtention de votre position: $e";
  //     isLoading.value = false;
  //   }
  // }

  // Future<Position?> getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw Exception('Les services de localisation sont désactivés');
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw Exception('Permission de localisation refusée');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     throw Exception('Permission de localisation refusée définitivement');
  //   }

  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high
  //   );
  // }

  // void addMarkers() {
  //   if (currentPosition != null) {
  //     markers.add(
  //       Marker(
  //         markerId: const MarkerId('current_location'),
  //         position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
  //         infoWindow: const InfoWindow(title: 'Votre position'),
  //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //       ),
  //     );
  //   }

  //   markers.add(
  //     Marker(
  //       markerId: const MarkerId('ism_location'),
  //       position: ismLocation,
  //       infoWindow: const InfoWindow(title: 'ISM - Institut Supérieur de Management'),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //     ),
  //   );
  // }

  // Future<void> getRoute() async {
  //   if (currentPosition == null) return;

  //   try {
  //     // Utilisation de l'API OSRM (Open Source Routing Machine) - 100% gratuite
  //     String url = 'https://router.project-osrm.org/route/v1/driving/'
  //         '${currentPosition!.longitude},${currentPosition!.latitude};'
  //         '${ismLocation.longitude},${ismLocation.latitude}'
  //         '?overview=full&geometries=geojson&steps=true';

  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> data = json.decode(response.body);

  //       if (data['routes'] != null && data['routes'].isNotEmpty) {
  //         // Extraire les coordonnées de la route
  //         List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
  //         List<LatLng> routePoints = coordinates
  //             .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
  //             .toList();

  //         polylines.add(
  //           Polyline(
  //             polylineId: const PolylineId('route'),
  //             points: routePoints,
  //             color: const Color(0xFFF58613), // Orange ISM
  //             width: 5,
  //           ),
  //         );

  //         isLoading.value = false;

  //         // Calculer la distance et le temps
  //         double duration = data['routes'][0]['duration'].toDouble(); // en secondes
  //         double distance = data['routes'][0]['distance'].toDouble(); // en mètres

  //         String distanceText = distance > 1000
  //             ? '${(distance / 1000).toStringAsFixed(1)} km'
  //             : '${distance.toStringAsFixed(0)} m';

  //         showRouteInfo(distanceText, Duration(seconds: duration.toInt()));
  //       }
  //     }
  //   } catch (e) {
  //     errorMessage.value = "Erreur lors du calcul de l'itinéraire: $e";
  //     isLoading.value = false;
  //   }
  // }

  // List<LatLng> decodePolyline(String encoded) {
  //   List<LatLng> points = [];
  //   int index = 0;
  //   int len = encoded.length;
  //   int lat = 0;
  //   int lng = 0;

  //   while (index < len) {
  //     int b;
  //     int shift = 0;
  //     int result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lat += dlat;

  //     shift = 0;
  //     result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lng += dlng;

  //     points.add(LatLng(lat / 1E5, lng / 1E5));
  //   }
  //   return points;
  // }

  // void showRouteInfo(String distance, Duration duration) {
  //   String durationText = "${duration.inHours}h ${duration.inMinutes % 60}min";

  //   Get.dialog(
  //     AlertDialog(
  //       backgroundColor: const Color(0xFFFFFFFF),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       title: Row(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(8),
  //             decoration: BoxDecoration(
  //               color: const Color(0xFFF58613).withOpacity(0.1),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: const Icon(
  //               Icons.directions,
  //               color: Color(0xFFF58613),
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           const Text(
  //             'Itinéraire vers l\'ISM',
  //             style: TextStyle(
  //               color: Color(0xFF351F16),
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               const Icon(Icons.straighten, color: Color(0xFF351F16), size: 20),
  //               const SizedBox(width: 8),
  //               Text(
  //                 'Distance: $distance',
  //                 style: const TextStyle(fontSize: 16),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Row(
  //             children: [
  //               const Icon(Icons.access_time, color: Color(0xFF351F16), size: 20),
  //               const SizedBox(width: 8),
  //               Text(
  //                 'Durée estimée: $durationText',
  //                 style: const TextStyle(fontSize: 16),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           style: TextButton.styleFrom(
  //             backgroundColor: const Color(0xFFF58613),
  //             foregroundColor: Colors.white,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void centerMapOnRoute() {
  //   if (currentPosition != null && mapController != null) {
  //     mapController!.animateCamera(
  //       CameraUpdate.newLatLngBounds(
  //         LatLngBounds(
  //           southwest: LatLng(
  //             currentPosition!.latitude < ismLocation.latitude
  //                 ? currentPosition!.latitude
  //                 : ismLocation.latitude,
  //             currentPosition!.longitude < ismLocation.longitude
  //                 ? currentPosition!.longitude
  //                 : ismLocation.longitude,
  //           ),
  //           northeast: LatLng(
  //             currentPosition!.latitude > ismLocation.latitude
  //                 ? currentPosition!.latitude
  //                 : ismLocation.latitude,
  //             currentPosition!.longitude > ismLocation.longitude
  //                 ? currentPosition!.longitude
  //                 : ismLocation.longitude,
  //           ),
  //         ),
  //         100.0,
  //       ),
  //     );
  //   }
  // }

  // void onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  // void retryInitialization() {
  //   initializeMap();
  // }

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final markers = <Marker>[].obs;
  final polylines = <Polyline>[].obs;
  final MapController mapController = MapController();

  LatLng? currentPosition;
  final LatLng ismLocation = LatLng(14.6937, -17.4441); // Dakar ISM

  @override
  void onInit() {
    super.onInit();
    initializeMap();
  }

  Future<void> initializeMap() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      Position? position = await getCurrentLocation();
      if (position != null) {
        currentPosition = LatLng(position.latitude, position.longitude);

        addMarkers();
        await getRoute();
      }
    } catch (e) {
      errorMessage.value = "Erreur : $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Service de localisation désactivé");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Permission refusée");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permission refusée définitivement");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void addMarkers() {
    markers.clear();
    if (currentPosition != null) {
      markers.add(
        Marker(
          point: currentPosition!,
          builder:
              (ctx) =>
                  const Icon(Icons.my_location, color: Colors.blue, size: 40),
        ),
      );
    }

    markers.add(
      Marker(
        point: ismLocation,
        builder:
            (ctx) => const Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    );
  }

  Future<void> getRoute() async {
    if (currentPosition == null) return;

    try {
      String url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${currentPosition!.longitude},${currentPosition!.latitude};'
          '${ismLocation.longitude},${ismLocation.latitude}'
          '?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          List<dynamic> coords = data['routes'][0]['geometry']['coordinates'];

          List<LatLng> points =
              coords
                  .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
                  .toList();

          polylines.clear();
          polylines.add(
            Polyline(
              points: points,
              strokeWidth: 4,
              color: const Color(0xFFF58613),
            ),
          );
        }
      }
    } catch (e) {
      errorMessage.value = "Erreur dans le calcul de l'itinéraire: $e";
    }
  }

  void retry() {
    initializeMap();
  }

  void centerMapOnRoute() {
    if (polylines.isNotEmpty && polylines.first.points.isNotEmpty) {
      final points = polylines.first.points;

      double minLat = points.first.latitude;
      double maxLat = points.first.latitude;
      double minLng = points.first.longitude;
      double maxLng = points.first.longitude;

      for (var point in points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      final bounds = LatLngBounds(
        LatLng(minLat, minLng),
        LatLng(maxLat, maxLng),
      );

      mapController.fitBounds(
        bounds,
        options: const FitBoundsOptions(padding: EdgeInsets.all(30)),
      );
    }
  }
}

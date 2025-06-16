import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/route_controller.dart';

class RouteView extends GetView<RouteController> {
  const RouteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isLoading.value
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFF58613),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Calcul de l\'itinéraire...',
                      style: TextStyle(fontSize: 16, color: Color(0xFF351F16)),
                    ),
                  ],
                ),
              )
              : controller.errorMessage.value.isNotEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              controller.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF351F16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: controller.retry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF58613),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      center:
                          controller.currentPosition != null
                              ? LatLng(
                                controller.currentPosition!.latitude,
                                controller.currentPosition!.longitude,
                              )
                              : controller.ismLocation,
                      zoom: 14,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.yourcompany.yourapp',
                      ),
                      MarkerLayer(markers: controller.markers),
                      PolylineLayer(polylines: controller.polylines),
                    ],
                  ),

                  // Bouton centrer
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: controller.centerMapOnRoute,
                      backgroundColor: const Color(0xFFF58613),
                      foregroundColor: Colors.white,
                      tooltip: 'Centrer sur l\'itinéraire',
                      child: const Icon(Icons.my_location),
                    ),
                  ),

                  // Carte d'information en haut
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF58613).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.school,
                              color: Color(0xFFF58613),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Itinéraire vers l\'ISM',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF351F16),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Suivez la ligne bleue pour arriver à destination',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

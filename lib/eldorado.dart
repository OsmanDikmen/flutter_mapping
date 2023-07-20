import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<LatLng>> routes = [
     [
      LatLng(41.0082, 28.9784),
      LatLng(41.0112, 28.9827),
      LatLng(41.0141, 28.9865),
      LatLng(41.0178, 28.9907),
    ],
    [
      LatLng(41.0178, 28.9907),
      LatLng(41.0214, 28.9948),
      LatLng(41.0252, 28.9987),
      LatLng(41.0291, 29.0025),
    ],
    [
      LatLng(41.0291, 29.0025),
      LatLng(41.0331, 29.0062),
      LatLng(41.0371, 29.0099),
      LatLng(41.0411, 29.0135),
    ],
    [
      LatLng(41.0411, 29.0135),
      LatLng(41.0431, 29.0069),
      LatLng(41.0471, 29.0102),
      LatLng(41.0491, 29.0147),
    ],
  ];

  List<LatLng> routePoints = [];
  int currentRouteIndex = 0;
  MapController _mapController = MapController(); // Add the map controller here

  @override
  void initState() {
    super.initState();
    loadRouteData();
  }

  Future<void> loadRouteData() async {
    setState(() {
      routePoints = routes[currentRouteIndex];
    });

    // Set up a timer to switch routes every 3 seconds
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        currentRouteIndex = (currentRouteIndex + 1) % routes.length;
        routePoints = routes[currentRouteIndex];
      });

      if (routePoints.isNotEmpty) {
        // When the route changes, set the map's center to the first coordinate in the new route
        _mapController.move(routePoints.first, 15.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterMap(
          mapController: _mapController, // Use the map controller here
          options: MapOptions(
            center: LatLng(41.025, 28.9926),
            zoom: 15,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            PolylineLayerOptions(
              polylines: [
                Polyline(
                  points: routePoints,
                  color: Colors.green,
                  strokeWidth: 3.0,
                ),
              ],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: routePoints.isNotEmpty ? routePoints.first : LatLng(0, 0),
                  builder: (ctx) => Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                ),
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: routePoints.isNotEmpty ? routePoints.last : LatLng(0, 0),
                  builder: (ctx) => Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




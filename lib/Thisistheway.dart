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
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    loadRouteData();
  }

  Future<void> loadRouteData() async {
    // Simüle edilmiş iki nokta arası yol verileri
    // Gerçek yol verilerini bu kısımda yükleyebilirsiniz
    routePoints = [
      LatLng(41.0082, 28.9784), // Başlangıç noktası
      LatLng(41.0431, 29.0069), // Bitiş noktası
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(41.025, 28.9926), // Haritanın merkezi
            zoom: 12,
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
                  color: Colors.red,
                  strokeWidth: 3.0,
                ),
              ],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: routePoints[0],
                  builder: (ctx) => Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 40.0,
                    ),
                  ),
                ),
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: routePoints[1],
                  builder: (ctx) => Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 40.0,
                    ),
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


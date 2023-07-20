import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  LatLng startPoint = LatLng(41.0082, 28.9784);
  LatLng endPoint = LatLng(41.0431, 29.0069);

  @override
  void initState() {
    super.initState();
    fetchRouteData();
  }

  Future<void> fetchRouteData() async {
    final query = '''
      [out:json];
      way["highway"](around: 1000, ${startPoint.latitude}, ${startPoint.longitude});
      out geom;
    ''';

    final url = Uri.parse('https://overpass-api.de/api/interpreter');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'data=${Uri.encodeComponent(query)}',
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final elements = decodedResponse['elements'];

      final List<LatLng> points = [];
      for (var element in elements) {
        if (element['type'] == 'way') {
          final List<dynamic> geometry = element['geometry'];
          for (var node in geometry) {
            final double lat = node['lat'];
            final double lon = node['lon'];
            final LatLng point = LatLng(lat, lon);
            points.add(point);
          }
        }
      }

      setState(() {
        routePoints = points;
      });
    } else {
      print('Error fetching route data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPoints = routePoints
        .where((point) =>
            point.latitude >= startPoint.latitude &&
            point.latitude <= endPoint.latitude &&
            point.longitude >= startPoint.longitude &&
            point.longitude <= endPoint.longitude)
        .toList();

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: startPoint, // Başlangıç noktasını merkeze al
          zoom: 12,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (selectedPoints.isNotEmpty)
            PolylineLayerOptions(
              polylines: [
                Polyline(
                  points: selectedPoints,
                  color: Colors.blue,
                  strokeWidth: 3.0,
                ),
              ],
            ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: startPoint,
                builder: (ctx) => Icon(
                  Icons.circle,
                  color: Colors.green,
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: endPoint,
                builder: (ctx) => Icon(
                  Icons.circle,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



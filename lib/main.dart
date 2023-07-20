import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(41.0082, 28.9784),
                  zoom: 8,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png", //"https://snowmap.fast-sfc.com/base_snow_map/{z}/{x}/{y}.png"
                    subdomains: ['a', 'b', 'c'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

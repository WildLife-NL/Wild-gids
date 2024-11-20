import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildgids/config/theme/asset_icons.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});
  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final startingPoint = const LatLng(51.25851739912562, 5.622422796819703);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
            initialCenter: startingPoint,
            initialZoom: 11,
            minZoom: 9,
            maxZoom: 18,
            cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(const LatLng(52.25851, 6.6224),
                    const LatLng(50.25851, 4.6224)))),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.wildlifenl.wildgids',
          ),
          MarkerLayer(markers: [
            Marker(
                point: startingPoint,
                width: 30,
                height: 30,
                child: SvgPicture.asset(AssetIcons.locationDot),
                rotate: true),
          ])
        ],
      ),
    );
  }
}

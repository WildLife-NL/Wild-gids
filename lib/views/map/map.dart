import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildgids/config/theme/asset_icons.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    const startingPoint = LatLng(51.25851739912562, 5.622422796819703);

    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
          initialCenter: startingPoint, // Center the map over Weerterbos
          initialZoom: 11,

          // Set map zoom and location boundaries
          minZoom: 9,
          maxZoom: 18,
          cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(const LatLng(52.25851, 6.6224),
                  const LatLng(50.25851, 4.6224)))),
      children: [
        TileLayer(
          // Display map tiles from any source
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildgids/config/theme/asset_icons.dart';
import 'package:wildgids/config/theme/custom_colors.dart';
import 'package:wildgids/services/interaction_type.dart';
import 'package:wildgids/views/reporting/reporting.dart';
import 'package:wildlife_api_connection/models/interaction_type.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});
  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  List<InteractionType> _interactionTypes = [];

  final startingPoint = const LatLng(51.25851739912562, 5.622422796819703);

  void _getInteractionTypes() async {
    var interactionTypesData =
        await InteractionTypeService().getAllInteractionTypes();
    setState(() {
      _interactionTypes = interactionTypesData;
    });
  }

  @override
  void initState() {
    super.initState();
    _getInteractionTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: CustomColors.light700,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Maak rapportage",
                        style: TextStyle(
                          fontSize: 20,
                          color: CustomColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInterationTypes(_interactionTypes),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: CustomColors.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
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

  Widget _buildInterationTypes(List<InteractionType> interactionTypes) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(15.0),
        itemCount: interactionTypes.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportingView(
                      interactionType: interactionTypes[index],
                      initialPage: 0,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SvgPicture.asset(
                            interactionTypes[index].name.toLowerCase() ==
                                    'waarneming'
                                ? AssetIcons.waarneming
                                : interactionTypes[index].name.toLowerCase() ==
                                        'schademelding'
                                    ? AssetIcons.schademelding
                                    : AssetIcons.wildaanrijding,
                            fit: BoxFit.cover,
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                              color: Colors.grey.shade300,
                              height: MediaQuery.of(context).size.width * 0.45,
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: const Center(
                                child: Text(
                                  'Loading...',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    interactionTypes[index].name,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

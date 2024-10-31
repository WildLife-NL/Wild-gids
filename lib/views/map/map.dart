import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildgids/config/theme/asset_icons.dart';
import 'package:wildgids/config/theme/custom_colors.dart';
import 'package:wildgids/services/species.dart';
import 'package:wildlife_api_connection/models/species.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});
  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  List<Species> _species = [];
  Species? _selectedSpecies;
  String _selectedInterationType = 'interactie';
  int _selectedMeter = 0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  final startingPoint = const LatLng(51.25851739912562, 5.622422796819703);

  void _getSpecies() async {
    var speciesData = await SpeciesService().getAllSpecies();
    setState(() {
      _species = speciesData;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSpecies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> meters = [0, 25, 50, 100, 200, 500];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Welk dier wil je rapporteren?'),
                  content: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: CustomColors.light700,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<Species>(
                              hint: Text(
                                "Kies een dier",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: CustomColors.dark200.withOpacity(0.7),
                                ),
                              ),
                              value: _selectedSpecies,
                              isExpanded: true,
                              underline: Container(),
                              items: [
                                ..._species.map((Species species) {
                                  return DropdownMenuItem<Species>(
                                    value: species,
                                    child: Text(
                                      species.commonName,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: CustomColors.dark200
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (Species? species) {
                                setState(() {
                                  _selectedSpecies = species;
                                });
                              },
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                              dropdownColor: CustomColors.light700,
                              iconEnabledColor:
                                  CustomColors.dark200.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Had je een interactie of waarneming?",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: CustomColors.dark200,
                            ),
                          ),
                          ListTile(
                            title: const Text('Interatie'),
                            leading: Radio<String>(
                              value: "interatie",
                              groupValue: _selectedInterationType,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedInterationType =
                                      value!.toLowerCase();
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Waarneming'),
                            leading: Radio<String>(
                              value: "waarneming",
                              groupValue: _selectedInterationType,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedInterationType =
                                      value!.toLowerCase();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Kun je een schatting geven van de afstand tussen jou en het dier?",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: CustomColors.dark200,
                            ),
                          ),
                          SizedBox(
                            height: 125,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 35,
                              perspective: 0.005,
                              onSelectedItemChanged: (index) {
                                if (index.isEven) {
                                  setState(() {
                                    _selectedMeter = meters[index ~/ 2];
                                  });
                                }
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: meters.length * 2 - 1,
                                builder: (context, index) {
                                  if (index.isOdd) {
                                    return const Divider();
                                  } else {
                                    final valueIndex = index ~/ 2;
                                    return Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${meters[valueIndex]} m',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: _selectedMeter ==
                                                  meters[valueIndex]
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: _selectedMeter ==
                                                  meters[valueIndex]
                                              ? CustomColors.primary
                                              : Colors.black,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(CustomColors.error),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(CustomColors.success),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0)),
                      ),
                      onPressed: () async {
                        // TODO: Report shit
                        print('oui');
                      },
                      child: const Text(
                        'Reporteren',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              });
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
      ),
    );
  }
}

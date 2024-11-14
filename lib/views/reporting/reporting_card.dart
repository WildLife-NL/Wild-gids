import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildgids/config/theme/asset_icons.dart';
import 'package:wildgids/config/theme/custom_colors.dart';
import 'package:wildgids/services/species.dart';
import 'package:wildlife_api_connection/models/interaction_type.dart';
import 'package:wildlife_api_connection/models/species.dart';

class ReportingCardView extends StatefulWidget {
  final String question;
  final int step;
  final String buttonText;
  final Function onPressed;
  final Function(
    String? description,
    Species? species,
    LatLng? location,
    String? animalSpecies,
  ) onDataChanged;
  final String? animalSpecies;
  final Species? species;
  final InteractionType? interactionType;
  final LatLng? location;
  final String? description;

  const ReportingCardView({
    super.key,
    required this.question,
    required this.step,
    required this.buttonText,
    required this.onPressed,
    required this.onDataChanged,
    this.animalSpecies,
    this.species,
    this.interactionType,
    this.location,
    this.description,
  });

  @override
  ReportingCardViewState createState() => ReportingCardViewState();
}

class ReportingCardViewState extends State<ReportingCardView> {
  List<Species> _species = [];

  String? _description;
  LatLng? _currentLocation;
  String? _animalSpecies;
  Species? _selectedSpecies;

  final TextEditingController _controller = TextEditingController();

  List<String> animalSpecies = [
    "Evenhoevigen",
    "Roofdieren",
    "Knaagdieren",
  ];

  @override
  void initState() {
    super.initState();
    _getSpecies();
    if (widget.step == 3) _requestLocationAccess();
  }

  void _getSpecies() async {
    var speciesData = await SpeciesService().getAllSpecies();
    if (mounted) {
      setState(() {
        _species = speciesData;
      });
    }
  }

  Future<void> _requestLocationAccess() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      await _updateLocation();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _updateDescription(String? description) async {
    if (mounted) {
      setState(() {
        _description = description;
      });
    }
    widget.onDataChanged(
      _description,
      _selectedSpecies,
      LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      _animalSpecies,
    );
  }

  Future<void> _updateLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    }

    widget.onDataChanged(
      null,
      _selectedSpecies,
      LatLng(position.latitude, position.longitude),
      _animalSpecies,
    );
  }

  void _selectSpecies(Species species) {
    if (mounted) {
      setState(() {
        _selectedSpecies = species;
      });
    }
    widget.onDataChanged(
      null,
      _selectedSpecies,
      null,
      _animalSpecies,
    );
  }

  void _selectAnimalSpecies(String animalSpecies) {
    if (mounted) {
      setState(() {
        _animalSpecies = animalSpecies;
      });
    }
    widget.onDataChanged(
      null,
      null,
      null,
      _animalSpecies,
    );
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    if (mounted) {
      setState(() {
        if (widget.location != null) {
          _currentLocation = LatLng(widget.location!.latitude.toDouble(),
              widget.location!.longitude.toDouble());
        } else {
          _currentLocation = LatLng(position.latitude, position.longitude);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _animalSpecies = widget.animalSpecies;
    _selectedSpecies = widget.species;
    _description = widget.description ?? _controller.text;
    _getLocation();

    return Column(
      children: [
        Text(
          widget.question,
          style: const TextStyle(
            color: CustomColors.primary,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.step == 1 || widget.step == 2) ...[
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.step == 1 ? 3 : 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: widget.step == 1 ? 0.80 : 0.8,
              ),
              itemCount:
                  widget.step == 1 ? animalSpecies.length : _species.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (widget.step == 1) {
                      _selectAnimalSpecies(animalSpecies[index]);
                    } else if (widget.step == 2) {
                      _selectSpecies(_species[index]);
                    }
                    widget.onPressed();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.step == 1) ...[
                        SizedBox(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: SvgPicture.asset(
                              animalSpecies[index].toLowerCase() ==
                                      'knaagdieren'
                                  ? AssetIcons.knaagdieren
                                  : animalSpecies[index].toLowerCase() ==
                                          'roofdieren'
                                      ? AssetIcons.roofdieren
                                      : AssetIcons.evenhoevigen,
                            ),
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/${_species[index].commonName.toLowerCase().replaceAll(' ', '-')}.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        widget.step == 1
                            ? animalSpecies[index]
                            : _species[index].commonName,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ] else if (widget.step == 4) ...[
          const SizedBox(height: 10),
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Typ hier je opmerkingen ...",
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              _updateDescription(_controller.text);
              widget.onPressed();
            },
            child: Text(widget.buttonText),
          ),
        ] else ...[
          const SizedBox(height: 10),
          if (widget.step == 5) ...[
            Text("Interatie type: ${widget.interactionType!.name}"),
            if (widget.species != null)
              Text("Dier: ${widget.species!.commonName}"),
            if (widget.description != null && widget.description!.isNotEmpty)
              Text("Opmerkingen: ${widget.description}"),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: SizedBox(
              child: FlutterMap(
                mapController: MapController(),
                options: MapOptions(
                  initialCenter: _currentLocation ??
                      const LatLng(51.25851739912562, 5.622422796819703),
                  initialZoom: 11,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.wildlifenl.wildgids',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                      point: _currentLocation ??
                          const LatLng(51.25851739912562, 5.622422796819703),
                      width: 30,
                      height: 30,
                      child: SvgPicture.asset(AssetIcons.locationDot),
                      rotate: true,
                    ),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              _updateLocation();
              widget.onPressed();
            },
            child: Text(widget.buttonText),
          ),
        ],
      ],
    );
  }
}

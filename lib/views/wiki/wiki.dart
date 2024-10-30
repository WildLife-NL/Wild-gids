import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wildgids/services/species.dart';
import 'package:wildgids/views/wiki/detailed.dart';
import 'package:wildlife_api_connection/models/species.dart';

class WikiView extends StatefulWidget {
  const WikiView({super.key});

  @override
  WikiViewState createState() => WikiViewState();
}

class WikiViewState extends State<WikiView> {
  final TextEditingController _searchController = TextEditingController();
  List<Species> _species = [];
  final List<Species> _filteredSpecies = [];

  void _performSearch(String query) {
    _filteredSpecies.clear();
    for (var spec in _species) {
      if (spec.name.toLowerCase().contains(query.toLowerCase()) ||
          spec.commonName.toLowerCase().contains(query.toLowerCase())) {
        _filteredSpecies.add(spec);
      }
    }
    setState(() {});
  }

  List<String> categories = [
    "Carnivoor",
    "Herbivoor",
    "Omnivoor",
    "Knaagdieren",
  ];

  @override
  void initState() {
    super.initState();
    _getSpecies();
  }

  void _getSpecies() async {
    var speciesData = await SpeciesService().getAllSpecies();
    setState(() {
      _species = speciesData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Zoeken ...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onChanged: _performSearch,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    _performSearch(_searchController.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    debugPrint('Tapped on ${categories[index]}');
                    // TODO: Add functionality for category selection
                  },
                  child: Container(
                    width: 155,
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            categories[index],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: _searchController.text.isNotEmpty
                      ? _filteredSpecies.asMap().entries.map((entry) {
                          int index = entry.key;
                          Species species = entry.value;
                          return _buildTile(species, index);
                        }).toList()
                      : _species.asMap().entries.map((entry) {
                          int index = entry.key;
                          Species species = entry.value;
                          return _buildTile(species, index);
                        }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(Species species, int index) {
    return StaggeredGridTile.count(
      crossAxisCellCount: index % 5 == 4 ? 2 : 1,
      mainAxisCellCount: (index % 5 == 0 || index % 5 == 3) ? 1 : 2,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedWikiView(
                species: species,
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade300,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/${species.commonName.toLowerCase().replaceAll(' ', '-')}.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(
                        species.commonName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

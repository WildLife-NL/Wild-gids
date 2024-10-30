import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:wildgids/widgets/bullet_list.dart';
import 'package:wildgids/views/wiki/widgets/player_widget.dart';
import 'package:wildlife_api_connection/models/species.dart';

class DetailedWikiView extends StatefulWidget {
  const DetailedWikiView({
    super.key,
    required this.species,
  });

  final Species species;

  @override
  DetailedWikiViewState createState() => DetailedWikiViewState();
}

class DetailedWikiViewState extends State<DetailedWikiView> {
  late final AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> _initPlayer() async {
    await player.setSource(AssetSource('mp3/example.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.species.commonName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder(
          future: _initPlayer(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/images/${widget.species.commonName.toLowerCase().replaceAll(' ', '-')}.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Text(
                                  'Image not found',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hoe om te gaan tijdens een interactie?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              BulletList([
                                'Blijf kalm en vermijd oogcontact.',
                                'Trek je langzaam terug.',
                                'Maak jezelf groot en luid. (alleen wanneer echt nodig!)',
                                'Zoek snel een veilige plek.',
                              ]),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.45,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/${widget.species.commonName.toLowerCase().replaceAll(' ', '-')}.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Text(
                                      'Image not found',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PlayerWidget(
                      player: player,
                      sourceName: "example.mp3",
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Wist je dat, wolven elkaars gehuil tot 10 kilometer ver kunnen horen? Dit doen ze om met elkaar te communiceren!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.45,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/${widget.species.commonName.toLowerCase().replaceAll(' ', '-')}.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Text(
                                      'Image not found',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.45,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/${widget.species.commonName.toLowerCase().replaceAll(' ', '-')}.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Text(
                                      'Image not found',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        // TODO: Start Quiz
                      },
                      child: const Text('Start Quiz'),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

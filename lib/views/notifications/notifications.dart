import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  NotificationsViewState createState() => NotificationsViewState();
}

class NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Meldingen pagina")),
    );
  }
}

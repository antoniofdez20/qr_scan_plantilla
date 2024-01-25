import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

//launchURL nos va a permitir lanzar la url o map que hayamos escaneado
void launchURL(BuildContext context, ScanModel scan) async {
  final url = scan.valor;

  if (scan.tipus == 'http') {
    if (!await launch(url)) throw 'Could not launch $url';
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}

import 'package:flutter/material.dart';
import 'package:qr_scan/widgets/scan_tiles.dart';

//cargara la lista de direcciones que hayamos escaneado
class DireccionsScreen extends StatelessWidget {
  const DireccionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScanTiles(tipus: 'http');
  }
}

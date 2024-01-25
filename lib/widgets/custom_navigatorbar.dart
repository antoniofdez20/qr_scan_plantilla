import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/providers/ui_provider.dart';

// este navigation appbar nos va a permitir cambiar entre las pantallas de lista de mapas y la de direcciones
class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;
    final scanListProvider = Provider.of<ScanListProvider>(context);

    return BottomNavigationBar(
        onTap: (int i) => uiProvider.selectedMenuOpt = i,
        elevation: 0,
        currentIndex: currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: 'Mapa (${scanListProvider.countGeo})',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.compass_calibration),
            label: 'Direccions (${scanListProvider.countHttp})',
          )
        ]);
  }
}

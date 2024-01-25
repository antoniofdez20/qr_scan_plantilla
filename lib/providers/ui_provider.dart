import 'package:flutter/material.dart';

//Con este provider vamos a controlar la informacion actualizada de nuestro widget BottomNavigationBar
//sabiendo que opcion del menu esta seleccionada en cada momento.
class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt = 0;

  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  set selectedMenuOpt(int index) {
    _selectedMenuOpt = index;
    notifyListeners();
  }
}

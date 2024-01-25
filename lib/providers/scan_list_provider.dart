import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

/// Nos va a servir de intermediario entre nuestra base de datos y nuestros widgets
/// manteniendo los con la información actualizada tras las operaciones en la base de datos.
class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipusSeleccionat = 'http';
  int _countGeo = 0;
  int _countHttp = 0;

  int get countGeo => _countGeo;
  int get countHttp => _countHttp;

  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    if (nouScan.tipus == tipusSeleccionat) {
      this.scans.add(nouScan);
      notifyListeners();
    }

    updateCounts();

    return nouScan;
  }

  carregarScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...scans];
    notifyListeners();
  }

  carregarScansPerTipus(String tipus) async {
    final scans = await DBProvider.db.getScanByTipus(tipus);
    this.scans = [...scans];
    this.tipusSeleccionat = tipus;
    updateCounts();
    notifyListeners();
  }

  esborraTots() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    updateCounts();
    notifyListeners();
  }

  esborraPerId(int id) async {
    await DBProvider.db.deleteScansbyId(id);
    scans.removeWhere((element) => element.id == id);
    updateCounts();
    notifyListeners();
  }

  Future<void> updateCounts() async {
    _countGeo = await DBProvider.db.countByTipus('geo');
    _countHttp = await DBProvider.db.countByTipus('http');
    notifyListeners();
  }
}

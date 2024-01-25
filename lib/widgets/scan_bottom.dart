import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

// ScanButton nos va a permitir escanear el código QR
// en mi caso dejo diferentes opciones para añadir o direccion o mapa ya que no puedo usar el scanner
class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(
        Icons.filter_center_focus,
      ),
      onPressed: () async {
        String barcodeScanRes = 'https://paucasesnovescifp.cat/';
        //String barcodeScanRes = 'geo:39.7260888,2.9109173';
        //String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        //'#3D8BEF', 'Cancel·lar', false, ScanMode.QR);

        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        ScanModel nouScan = ScanModel(valor: barcodeScanRes);
        scanListProvider.nouScan(barcodeScanRes);
        launchURL(context, nouScan);
      },
    );
  }
}

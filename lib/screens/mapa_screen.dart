import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//cargara el mapa con la ubicacion del marcador que hayamos escaneado
//además nos va a permitir volver a centrar el mapa en la ubicación del marcador
//cambiar entre los dos tipos de mapas y obviamente volver a la pantalla anterior
class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  //controlador que utilizaré para centrar el mapa según el marcador introducido
  late GoogleMapController _googleMapController;
  //variable que me servirá para cambiar entre los dos tipos de MapType
  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    final CameraPosition _puntInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17,
      tilt: 50,
    );

    Set<Marker> markers = <Marker>{};
    markers.add(Marker(
      markerId: const MarkerId('id1'),
      position: scan.getLatLng(),
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _googleMapController.animateCamera(
                CameraUpdate.newLatLng(scan.getLatLng()),
              );
            },
            icon: const Icon(Icons.gps_fixed),
            tooltip: 'Centrar en la posición del marcador',
          ),
        ],
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: _currentMapType,
        markers: markers,
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _googleMapController =
              controller; // Guardar la referencia al controlador
        },
      ),
      floatingActionButton: FloatingActionButton(
        //cambiar entre los dos tipos de mapas
        onPressed: () {
          setState(() {
            _currentMapType = (_currentMapType == MapType.normal)
                ? MapType.hybrid
                : MapType.normal;
          });
        },
        child: const Icon(Icons.map),
        tooltip: 'Cambiar Tipo de Mapa',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

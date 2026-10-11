import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapaServicoView extends StatefulWidget {
  final String titulo;
  final String endereco;
  final LatLng destino;

  const MapaServicoView({
    super.key,
    required this.titulo,
    required this.endereco,
    required this.destino,
  });

  @override
  State<MapaServicoView> createState() => _MapaServicoViewState();
}

class _MapaServicoViewState extends State<MapaServicoView> {
  final _mapController = MapController();
  StreamSubscription<Position>? _posicaoSub;
  LatLng? _minhaPosicao;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _iniciarLocalizacao();
  }

  @override
  void dispose() {
    _posicaoSub?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _iniciarLocalizacao() async {
    final gpsAtivo = await Geolocator.isLocationServiceEnabled();
    if (!gpsAtivo) {
      if (mounted) setState(() => _erro = 'Ative o GPS do aparelho.');
      return;
    }

    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() => _erro = 'Permissão de localização negada.');
      }
      return;
    }

    _posicaoSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // atualiza a cada 10 metros
      ),
    ).listen((pos) {
      if (!mounted) return;
      setState(() {
        _minhaPosicao = LatLng(pos.latitude, pos.longitude);
        _erro = null;
      });
    });
  }

  void _centralizarEmMim() {
    final pos = _minhaPosicao;
    if (pos == null) return;
    _mapController.move(pos, 16);
  }

  String? get _distanciaTexto {
    final pos = _minhaPosicao;
    if (pos == null) return null;
    final metros = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      widget.destino.latitude,
      widget.destino.longitude,
    );
    return metros >= 1000
        ? '${(metros / 1000).toStringAsFixed(1).replaceAll('.', ',')} km'
        : '${metros.round()} m';
  }

  Future<void> _abrirRota() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${widget.destino.latitude},${widget.destino.longitude}'
      '&travelmode=driving',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o mapa.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.destino,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.exemplo.app', // troque pelo seu
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.destino,
                    width: 40,
                    height: 40,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  if (_minhaPosicao != null)
                    Marker(
                      point: _minhaPosicao!,
                      width: 22,
                      height: 22,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [
                            BoxShadow(blurRadius: 6, color: Colors.black26),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors'),
              ),
            ],
          ),

          if (_erro != null)
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Card(
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_erro!),
                ),
              ),
            ),

          Positioned(
            right: 16,
            bottom: 200,
            child: FloatingActionButton(
              heroTag: 'minha_localizacao',
              onPressed: _centralizarEmMim,
              child: const Icon(Icons.my_location),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(child: Text(widget.endereco)),
                      ],
                    ),
                    if (_distanciaTexto != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.directions_car_outlined,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text('$_distanciaTexto de você'),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _abrirRota,
                        icon: const Icon(Icons.navigation, color: Colors.white),
                        label: const Text(
                          'Traçar rota',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
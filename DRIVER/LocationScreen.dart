import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LatLng _startPoint = const LatLng(35.37, 1.33); // TIARET
  final LatLng _endPoint = const LatLng(35.7, -0.64); // ORAN

  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  Marker? _trackingMarker;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _setRandomPolyline();
    _setMarkers();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _setRandomPolyline() {
    final List<LatLng> routeCoordinates = _generateRandomPath(_startPoint, _endPoint, 5);

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route1'),
          points: routeCoordinates,
          color: Colors.red,
          width: 5,
        ),
      );
    });
  }

  void _setMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: _startPoint,
          infoWindow: const InfoWindow(title: 'Start Point'),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: _endPoint,
          infoWindow: const InfoWindow(title: 'End Point'),
        ),
      );
    });
  }

  List<LatLng> _generateRandomPath(LatLng start, LatLng end, int numPoints) {
    final Random random = Random();
    List<LatLng> path = [start];

    for (int i = 0; i < numPoints; i++) {
      double lat = start.latitude + (end.latitude - start.latitude) * (i + 1) / (numPoints + 1) +
          (random.nextDouble() - 0.5) * 0.1;
      double lng = start.longitude + (end.longitude - start.longitude) * (i + 1) / (numPoints + 1) +
          (random.nextDouble() - 0.5) * 0.1;
      path.add(LatLng(lat, lng));
    }

    path.add(end);
    return path;
  }

  void _startTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      LatLng latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        if (_trackingMarker == null) {
          _trackingMarker = Marker(
            markerId: const MarkerId('tracking'),
            position: latLng,
            infoWindow: const InfoWindow(title: 'Current Location'),
          );
          _markers.add(_trackingMarker!);
        } else {
          _trackingMarker = _trackingMarker!.copyWith(
            positionParam: latLng,
          );
          _markers.removeWhere((marker) => marker.markerId == const MarkerId('tracking'));
          _markers.add(_trackingMarker!);
        }
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _startPoint,
              zoom: 8,
            ),
            polylines: _polylines,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _startTracking,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

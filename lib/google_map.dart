import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  bool _mapReady = false;
  final double _zoomValue = 18;
  late GoogleMapController _googleMapController;
  LatLng myLatLong = const LatLng(22.39094717909865, 91.85616162280324);

  List<LatLng> locationList = [];

  String address = 'Lucknow';
  late CameraPosition _cameraPosition = CameraPosition(
    target: myLatLong,
    tilt: 50,
    zoom: _zoomValue,
    bearing: 150,
  );

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service is disabled');
    }
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanently denied, we'
          'can not request permissions');
    }
    final location = await Geolocator.getCurrentPosition();
    debugPrint("current location: ${location.latitude},${location.longitude}");
    myLatLong = LatLng(location.latitude, location.longitude);
    _cameraPosition = CameraPosition(
      target: myLatLong,
      tilt: 50,
      zoom: _zoomValue,
      bearing: 150,
    );
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    _mapReady = true;
    locationList.add(LatLng(location.latitude, location.longitude));
    setState(() {});
    return await Geolocator.getCurrentPosition();
  }

  void _listenCurrentLocation() async {
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      timeLimit: Duration(seconds: 10),
    )).listen((location) async {
      address = await getPlacemarks(location.latitude, location.longitude);
      debugPrint("locationStream: ${location.latitude},${location.longitude}");
      _cameraPosition = CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        tilt: 50,
        zoom: _zoomValue,
        bearing: 150,
      );
      _googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));

      locationList.add(LatLng(location.latitude, location.longitude));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Location: ${location.latitude},${location.longitude}"),
      ));
      setState(() {});
    });
  }

  Future<String> getPlacemarks(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      var address = '';

      if (placemarks.isNotEmpty) {
        // Concatenate non-null components of the address
        var streets = placemarks.reversed
            .map((placemark) => placemark.street)
            .where((street) => street != null);

        // Filter out unwanted parts
        streets = streets.where((street) =>
            street!.toLowerCase() !=
            placemarks.reversed.last.locality!
                .toLowerCase()); // Remove city names
        streets = streets
            .where((street) => !street!.contains('+')); // Remove street codes

        address += streets.join(', ');

        address += ', ${placemarks.reversed.last.subLocality ?? ''}';
        address += ', ${placemarks.reversed.last.locality ?? ''}';
        address += ', ${placemarks.reversed.last.subAdministrativeArea ?? ''}';
        address += ', ${placemarks.reversed.last.administrativeArea ?? ''}';
        address += ', ${placemarks.reversed.last.postalCode ?? ''}';
        address += ', ${placemarks.reversed.last.country ?? ''}';
      }

      print("Your Address for ($lat, $long) is: $address");

      return address;
    } catch (e) {
      print("Error getting placemarks: $e");
      return "No Address";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController googleMapController) {
          _googleMapController = googleMapController;
          _determinePosition();
          _listenCurrentLocation();
        },
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: _cameraPosition,
        markers: {
          _mapReady
              ? Marker(
                  infoWindow: InfoWindow(title: address),
                  markerId: const MarkerId('1'),
                  position: myLatLong,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRose),
                )
              : const Marker(markerId: MarkerId("dsfd"))
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId("sdfsdff"),
            points: locationList,
            color: Colors.red,
          ),
        },
        onTap: (value) {
          debugPrint("tapLocation: $value");
        },
      ),
    );
  }
}

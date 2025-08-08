import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMapScreen extends StatefulWidget {
  const OpenStreetMapScreen({super.key});

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  final MapController mapController = MapController();
  // Location Tracking variables
  LatLng? currentPosition;
  LatLng? selectedPosition;
  String currentAddress = 'Fetching location...';
  String selectedAddress = 'Tap on map to select location';

  // Search Functionality
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<Location> searchResults = [];

  Timer? _debounceTimer;

  // Status Flags
  bool isLoading = true;
  bool mapReady = false;
  bool isEditMode = false;
  String locationError = '';

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    mapController.dispose();
    super.dispose();
  }

  // Initialize map with proper location
  Future<void> _initializeMap() async {
    try {
      if (!isEditMode) {
        await _determineCurrentPosition();
      }
      mapReady = true;
    } catch (e) {
      locationError = 'Map initialization failed: ${e.toString()}';
      isLoading = false;
    }

    setState(() {});
  }

  // Handle current position determination
  Future<void> _determineCurrentPosition() async {
    isLoading = true;
    locationError = '';

    try {
      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      currentPosition = latLng;
      await _updateAddressFromPosition(latLng, isCurrentLocation: true);

      // Move map to position if we have a controller
      if (mapReady) {
        mapController.move(latLng, 15);
      }
    } catch (e) {
      locationError = 'Error getting location: ${e.toString()}';
      // Fallback to default position if current location fails
      currentPosition = const LatLng(0, 0);
    } finally {
      isLoading = false;
    }

    setState(() {});
  }

  // Handle map taps
  void onMapTap(LatLng point) {
    setState(() {
      selectedPosition = point;
      selectedAddress = 'Fetching address...';
    });
    _updateAddressFromPosition(point);
  }

  // Update address from coordinates
  Future<void> _updateAddressFromPosition(
    LatLng latLng, {
    bool isCurrentLocation = false,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = _formatAddress(place);

        if (isCurrentLocation) {
          currentAddress = address;
          if (!isEditMode) {
            searchController.text = address;
          }
        } else {
          selectedAddress = address;
          searchController.text = address;
        }
      }
    } catch (e) {
      final errorMsg = 'Could not get address: ${e.toString()}';
      if (isCurrentLocation) {
        currentAddress = errorMsg;
      } else {
        selectedAddress = errorMsg;
      }
    }

    setState(() {});
  }

  // Format address from placemark
  String _formatAddress(Placemark place) {
    return [
      place.street,
      place.subLocality,
      place.locality,
      place.postalCode,
      place.country,
    ].where((part) => part != null && part.isNotEmpty).join(', ');
  }

  // Handle search functionality
  void onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      if (searchController.text.isNotEmpty) {
        searchLocation();
      } else {
        searchResults.clear();
      }
    });
  }

  // Search for locations
  Future<void> searchLocation() async {
    if (searchController.text.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(
        searchController.text,
      );
      searchResults = locations;
      setState(() {});
    } catch (e) {
      searchResults.clear();
      locationError = 'Search error: ${e.toString()}';
    }
  }

  // Handle search result selection
  Future<void> selectSearchResult(Location location) async {
    final latLng = LatLng(location.latitude, location.longitude);

    try {
      await _updateAddressFromPosition(latLng);
      selectedPosition = latLng;
      searchFocusNode.unfocus();

      if (mapReady) {
        mapController.move(latLng, 15);
      }

      searchResults.clear();
    } catch (e) {
      locationError = 'Error selecting location: ${e.toString()}';
    }

    setState(() {});
  }

  // Initialize edit mode with existing location
  void initializeEditLocation(LatLng position, String address) {
    isEditMode = true;
    currentPosition = position;
    currentAddress = address;
    selectedPosition = position;
    selectedAddress = address;
    searchController.text = address;

    if (mapReady) {
      mapController.move(position, 15);
    } else {
      mapController.move(position, 15);
    }
  }

  // Get current location data
  Map<String, dynamic> getLocationData() {
    final position = selectedPosition ?? currentPosition;

    return {
      'latitude': position?.latitude,
      'longitude': position?.longitude,
      'address': position != null
          ? (selectedPosition != null ? selectedAddress : currentAddress)
          : null,
    };
  }

  // Validate if we have a proper location
  bool get hasValidLocation {
    return (selectedPosition ?? currentPosition) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OpenStreet Map Example")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                      hintText: "Search Place",
                      suffixIcon: InkWell(
                        onTap: () {
                          searchController.clear();
                          searchResults.clear();
                          setState(() {});
                        },
                        child: Icon(Icons.close, color: Colors.grey),
                      ),

                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),

                    controller: searchController,
                    onChanged: (v) {
                      onSearchChanged();
                    },
                    onFieldSubmitted: (v) {
                      searchLocation();
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                  ),
                ),
                searchResults.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final location = searchResults[index];
                          return FutureBuilder<List<Placemark>>(
                            future: placemarkFromCoordinates(
                              location.latitude,
                              location.longitude,
                            ),
                            builder: (context, snapshot) {
                              final address =
                                  snapshot.hasData && snapshot.data!.isNotEmpty
                                  ? "${snapshot.data!.first.street}, ${snapshot.data!.first.locality}"
                                  : "Unknown location";

                              return ListTile(
                                leading: const Icon(Icons.location_on),
                                title: Text(
                                  address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  selectSearchResult(location);
                                },
                              );
                            },
                          );
                        },
                      ),
              ],
            ),
            locationError.isNotEmpty
                ? Card(
                    color: Colors.red[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(child: Text(locationError)),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => locationError = '',
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),

            SizedBox(
              height: 400,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      onTap: (tapPosition, point) => onMapTap(point),
                      initialCenter: currentPosition ?? const LatLng(0.0, 0.0),
                      initialZoom: currentPosition != null ? 15 : 4,
                      minZoom: 0,
                      maxZoom: 19,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'net.tlserver6y.flutter_map_location_marker.example',
                      ),
                      CurrentLocationLayer(
                        style: LocationMarkerStyle(
                          marker: DefaultLocationMarker(
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                          markerSize: const Size(40, 40),
                          accuracyCircleColor: Colors.blue.withOpacity(0.3),
                          headingSectorColor: Colors.blue.withOpacity(0.8),
                          headingSectorRadius: 60,
                        ),
                      ),
                      MarkerLayer(
                        markers: [
                          if (selectedPosition != null)
                            Marker(
                              key: ValueKey(selectedPosition),
                              point: selectedPosition!,
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(180),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                        ),
                      ),
                      child: RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Map Data by ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: "OpenStreetMap\n",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      "Current Location",
                      currentPosition != null
                          ? "${currentPosition!.latitude.toStringAsFixed(6)}, "
                                "${currentPosition!.longitude.toStringAsFixed(6)}"
                          : "Unknown",
                      currentAddress,
                      icon: Icons.my_location,
                      iconColor: Colors.blue,
                    ),

                    const Divider(),
                    _buildInfoRow(
                      "Selected Location",
                      selectedPosition != null
                          ? "${selectedPosition!.latitude.toStringAsFixed(6)}, "
                                "${selectedPosition!.longitude.toStringAsFixed(6)}"
                          : "Not selected",
                      selectedAddress,
                      icon: Icons.location_pin,
                      iconColor: Colors.red,
                    ),

                    isLoading
                        ? const LinearProgressIndicator()
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String title,
    String coordinates,
    String address, {
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(coordinates),
              Text(address, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

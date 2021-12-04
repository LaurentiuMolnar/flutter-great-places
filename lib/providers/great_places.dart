import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places/helpers/db_helper.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
        location.latitude, location.longitude);

    final newPlace = Place(
      id: DateTime.now().toIso8601String(),
      title: title,
      location: location.copyWith(address: address),
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();

    await DatabaseHelper.insert(table: 'places', data: {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final data = await DatabaseHelper.getData('places');
    _items = [
      ...data.map(
        (place) => Place(
          id: place['id'],
          title: place['title'],
          location: PlaceLocation(
            latitude: place['loc_lat'],
            longitude: place['loc_lng'],
            address: place['address'],
          ),
          image: File(
            place['image'],
          ),
        ),
      )
    ];
    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

const googleApiKey = '';

class LocationHelper {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKey';
  }

  static Future<String> getPlaceAddress(double lat, double lang) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lang&key=$googleApiKey';

    final res = await http.get(Uri.parse(url));

    return json.decode(res.body)['results'][0]['formatted_address'];
  }
}

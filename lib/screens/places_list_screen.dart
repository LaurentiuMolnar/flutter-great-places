import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/place_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Consumer<GreatPlaces>(
                builder: (ctx, gpProvider, child) => gpProvider.items.isEmpty
                    ? child!
                    : ListView.builder(
                        itemCount: gpProvider.items.length,
                        itemBuilder: (ctx, idx) {
                          final place = gpProvider.items[idx];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(place.image),
                            ),
                            title: Text(place.title),
                            subtitle: Text(place.location.address ?? ''),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                PlaceDetailsScreen.routeName,
                                arguments: place.id,
                              );
                            },
                          );
                        },
                      ),
                child:
                    const Center(child: Text('Got no places yet. Add some!')),
              ),
      ),
    );
  }
}

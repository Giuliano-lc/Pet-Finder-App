import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:petfinder/design_configs.dart';
import 'package:petfinder/models/spotted_animal_model.dart';

import '../models/pet_model.dart';

class HomeViewBloc {
  final ValueNotifier<List<PetModel>> petsNotifier = ValueNotifier([]);
  List<SpottedAnimalModel> spottedAnimalsList = [];

  final mapController = MapController(
      initMapWithUserPosition: const UserTrackingOption(
          enableTracking: true,
          unFollowUser: true
      )
  );

  Future<List<PetModel>> getPetsInfo() async{
    await Future.delayed(const Duration(seconds: 1));
    return generatePetList(count: 5);
  }

  List<PetModel> generatePetList({required int count}) {
    final random = Random();

    const names = ['Max', 'Bella', 'Charlie', 'Luna', 'Buddy', 'Daisy'];
    const breeds = ['Poodle', 'Labrador', 'Bulldog', 'Golden Retriever', 'Shih Tzu'];

    List<PetModel> pets = [];
    for (int i = 0; i < count; i++) {
      double latitude = -33.7 + random.nextDouble() * (5.3 - (-33.7));
      double longitude = -74.0 + random.nextDouble() * (-34.8 - (-74.0));

      pets.add(PetModel(
        id: i + 1,
        name: names[random.nextInt(names.length)],
        breed: breeds[random.nextInt(breeds.length)],
        latitude: double.parse(latitude.toStringAsFixed(6)),
        longitude: double.parse(longitude.toStringAsFixed(6)),
      ));
    }
    return pets;
  }

  void onMapIsReady(bool ready) async {
    if (ready){
      petsNotifier.value = await getPetsInfo();
      showPetsInMap();
    }
  }

  void onPetTap(PetModel pet) async {
    await mapController.moveTo(
        GeoPoint(latitude: pet.latitude, longitude: pet.longitude)
    );
    await mapController.setZoom(
      zoomLevel: 10
    );
  }

  void showPetsInMap() async {
    for (PetModel pet in petsNotifier.value) {
      await mapController.addMarker(
        markerIcon: MarkerIcon(
          icon: Icon(Icons.pets, color: DesignConfigs.brownColor),
        ),
        GeoPoint(latitude: pet.latitude, longitude: pet.longitude)
      );
    }
  }

  void onGeoPointClicked(BuildContext context, GeoPoint? point) {
    if (point == null) return;

    PetModel? selectedPet;
    for (PetModel pet in petsNotifier.value) {
      if (point == GeoPoint(latitude: pet.latitude, longitude: pet.longitude)) {
        selectedPet = pet;
      }
    }
    if (selectedPet != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Pet Selecionado"),
            content: Text("Você clicou no ${selectedPet!.name}, um ${selectedPet.breed}."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fechar"),
              ),
            ],
          );
        },
      );
      return;
    }


    SpottedAnimalModel? spottedAnimal;

    for (SpottedAnimalModel animal in spottedAnimalsList) {
      if (point == animal.localization) {
        spottedAnimal = animal;
      }
    }

    if (spottedAnimal != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Animal Avistado"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (spottedAnimal!.picture != null)
                    Image.file(
                      alignment: Alignment.center,
                      File(spottedAnimal.picture!),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 10),
                  Text("Espécie: ${spottedAnimal.species ?? 'Não informada'}"),
                  const SizedBox(height: 10),
                  Text("Cor: ${spottedAnimal.color ?? 'Não informada'}"),
                  const SizedBox(height: 10),
                  Text("Porte: ${spottedAnimal.size ?? 'Não informado'}"),
                  const SizedBox(height: 10),
                  Text("Descrição Adicional: ${spottedAnimal.additionalDescription ?? 'Não informada'}"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fechar"),
              ),
            ],
          );
        },
      );
      return;
    }


  }

  void addSpottedAnimal(SpottedAnimalModel pet) async {
    spottedAnimalsList.add(pet);
    await mapController.addMarker(
        markerIcon: MarkerIcon(
          icon: Icon(Icons.pets, color: DesignConfigs.orangeColor),
        ),
        GeoPoint(latitude: pet.localization!.latitude, longitude: pet.localization!.longitude)
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/home_view_bloc.dart';
import '../design_configs.dart';
import '../models/add_pet_model.dart';
import '../models/pet_model.dart';
import '../widget/login_app_bar.dart';
import '../widget/standard_circular_progress_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final bloc = HomeViewBloc();

  @override
  void initState() {
    super.initState();
    bloc.mapController.listenerMapSingleTapping.addListener(singleTappingHandler);
  }

  void singleTappingHandler() {
    GeoPoint? tappedPoint = bloc.mapController.listenerMapSingleTapping.value;
    if (tappedPoint != null) {
      showPetFormDialog(context, tappedPoint);
    }
  }

  void showPetFormDialog(BuildContext context, GeoPoint localization) {
    final formKey = GlobalKey<FormState>();
    final ImagePicker picker = ImagePicker();
    double height = 8.0;
    SpottedAnimalModel pet = SpottedAnimalModel.empty();
    pet.localization = localization;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Animal'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Espécie'),
                    items: ['Cachorro', 'Gato', 'Outro']
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (value) => pet.species = value,
                    validator: (value) => value == null ? 'Selecione uma espécie' : null,
                  ),
                  SizedBox(height: height,),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cor'),
                    onChanged: (value) => pet.color = value,
                    validator: (value) => value == null || value.isEmpty ? 'Informe a cor' : null,
                  ),
                  SizedBox(height: height,),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Porte'),
                    items: ['Pequeno', 'Médio', 'Grande']
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (value) => pet.size = value,
                    validator: (value) => value == null ? 'Selecione o porte' : null,
                  ),
                  SizedBox(height: height,),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Descrição adicional'),
                    onChanged: (value) => pet.additionalDescription = value,
                  ),
                  SizedBox(height: height,),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton.icon(
                      onPressed: () async {
                        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                        if (photo != null) pet.picture = photo.path;
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Foto carregada com sucesso!'),
                          ));
                        }
                      },
                      icon: const Icon(Icons.upload),
                      label: const Text('Carregar Foto (opcional)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  bloc.addSpottedAnimal(pet);
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: mapWidget()
            ),
            Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<List<PetModel>>(
                      valueListenable: bloc.petsNotifier,
                      builder: (context, pets, _) {
                        if (pets.isEmpty) {
                          return const Center(child: StandardCircularProgressIndicator());
                        }
                        return Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: pets.length,
                            itemBuilder: (context, index) {
                              final pet = pets[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 4,
                                  color: DesignConfigs.whiteColor,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    title: Text(
                                      pet.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: DesignConfigs.brownColor,
                                      ),
                                    ),
                                    subtitle: Text(
                                      pet.breed,
                                      style: TextStyle(
                                        color: DesignConfigs.grayColor,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.pets,
                                      color: DesignConfigs.brownColor,
                                    ),
                                    onTap: () => bloc.onPetTap(pet),
                                  ),
                                ),
                              );
                            },
                          ),
                        );

                      },
                    ),
                  ],
                )
            )
          ],
        ),
      )
    );
  }

  Widget mapWidget() {
    return Column(
      children: [
        Expanded(
          child: OSMFlutter(
            onGeoPointClicked: (point) => bloc.onGeoPointClicked(context, point),
            controller: bloc.mapController,
            mapIsLoading: const StandardCircularProgressIndicator(),
            onMapIsReady: bloc.onMapIsReady,
            osmOption: OSMOption(
              isPicker: true,
              enableRotationByGesture: true,
              showContributorBadgeForOSM: true,
              showDefaultInfoWindow: true,
              showZoomController: false,
              zoomOption: const ZoomOption(
                initZoom: 16,
                minZoomLevel: 2,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: MarkerIcon(
                  icon: Icon(
                    Icons.person_pin,
                    color: DesignConfigs.brownColor,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

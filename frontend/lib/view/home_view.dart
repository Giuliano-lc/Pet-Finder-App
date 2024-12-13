import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../bloc/home_view_bloc.dart';
import '../design_configs.dart';
import '../models/pet_model.dart';
import '../widget/standard_circular_progress_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final bloc = HomeViewBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  mapWidget(),
                  const SizedBox(width: 16,),
                  Expanded(
                    flex: 1,
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
                                          color: DesignConfigs.orangeColor,
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
              )
            )
          ],
        ),
      )
    );
  }

  Widget mapWidget() {
    return Expanded(
        flex: 1,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  OSMFlutter(
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
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () { bloc.mapController.zoomIn(); },
                  icon: Icon(
                    Icons.zoom_in,
                    size: 40,
                    color: DesignConfigs.brownColor,
                  ),
                ),
                IconButton(
                  onPressed: () { bloc.mapController.zoomOut(); },
                  icon: Icon(
                    Icons.zoom_out,
                    size: 40,
                    color: DesignConfigs.brownColor,
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}

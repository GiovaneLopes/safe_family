import 'package:asuka/asuka.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:safe_lopes_family/modules/home_map/home_map_cubit.dart';
import 'package:safe_lopes_family/src/resources/images.dart';
import 'package:safe_lopes_family/src/resources/map_themes.dart';

class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {
  // ignore: prefer_collection_literals
  final HomeMapCubit homeMapCubit = Modular.get();

  @override
  void initState() {
    super.initState();
    homeMapCubit.initialize();
    DefaultAssetBundle.of(context)
        .loadString(MapThemes.nightMapTheme)
        .then((value) => homeMapCubit.mapTheme = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: BlocConsumer(
          bloc: homeMapCubit,
          listener: (context, state) {
            if (state.runtimeType == HomeMapErrorState) {
              final errorState = state as HomeMapErrorState;
              Asuka.showSnackBar(SnackBar(content: Text(errorState.message)));
            }
          },
          builder: (context, state) {
            if (state.runtimeType == HomeMapErrorState) {
              return Center(
                  child: Column(
                children: [
                  const Text('Algo deu errado, tente novamente'),
                  const SizedBox(
                    height: 12,
                  ),
                  IconButton(
                    onPressed: () => homeMapCubit.initialize(),
                    icon: const Icon(
                      Icons.update_outlined,
                    ),
                  ),
                ],
              ));
            }
            if (state.runtimeType == HomeMapInitialState) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }
            var successState = state as HomeMapSuccessState;
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: homeMapCubit.onMapCreated,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(-23.499110, -46.527729),
                      zoom: 15,
                    ),
                    zoomControlsEnabled: false,
                    markers: successState.markers,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(2, 2),
                                  color: Colors.grey.withOpacity(.1),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: (homeMapCubit.dropdownUsers.isNotEmpty)
                                      ? DropdownButton2(
                                          value: homeMapCubit.selectedUser,
                                          underline: const SizedBox(),
                                          isExpanded: true,
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                            ),
                                          ),
                                          items: homeMapCubit.dropdownUsers
                                              .map<
                                                  DropdownMenuItem<UserEntity>>(
                                                (UserEntity user) =>
                                                    DropdownMenuItem<
                                                        UserEntity>(
                                                  value: user,
                                                  child: Row(
                                                    children: [
                                                      (user ==
                                                              homeMapCubit
                                                                  .selectedUser)
                                                          ? Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  Images.logo,
                                                                  width: 26,
                                                                ),
                                                              ],
                                                            )
                                                          : Container(
                                                              width: 26,
                                                            ),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          user.name,
                                                          maxLines: 1,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              homeMapCubit.selectedUser = value;
                                            });
                                          },
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              Images.logo,
                                              width: 40,
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Olá, ${homeMapCubit.userEntity.name}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () => homeMapCubit.signOut(),
                          child: const Icon(
                            Icons.logout,
                            size: 32,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 86,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(2, 2),
                              color: Colors.grey.withOpacity(.1),
                              spreadRadius: 2,
                              blurRadius: 2),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () => Modular.to.pushNamed('/circles'),
                            child: const Icon(
                              Icons.person_pin_circle_outlined,
                              size: 32,
                              color: Colors.blue,
                            ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 26,
                    right: 16,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 38.0),
                      child: !homeMapCubit.devicePositionStream!.isPaused
                          ? FloatingActionButton(
                              heroTag: 'help',
                              backgroundColor: Colors.blue,
                              onPressed: () => setState(() {
                                homeMapCubit.switchStreamGps();
                              }),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 32,
                              ),
                            )
                          : FloatingActionButton(
                              heroTag: 'help',
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              onPressed: () => setState(() {
                                homeMapCubit.switchStreamGps();
                              }),
                              child: const Icon(
                                Icons.pause,
                                size: 32,
                              ),
                            ),
                    ),
                  ),
                  if (homeMapCubit.dropdownUsers.isNotEmpty)
                    ExpandableBottomSheet(
                      background: Container(),
                      persistentHeader: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, -2),
                              color: Colors.grey.withOpacity(.1),
                              spreadRadius: 2,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            height: 4,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      expandableContent: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pessoas',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Column(
                              children: successState.users
                                  .map(
                                    (e) => Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0, horizontal: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.blue,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          200.0),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: CachedNetworkImage(
                                                      imageUrl: e.photoUrl!,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  progress) =>
                                                              const Padding(
                                                        padding:
                                                            EdgeInsets.all(12),
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              exception,
                                                              stack) =>
                                                          const Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          e.name,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            if (e.battery !=
                                                                null)
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    FeatherIcons
                                                                        .batteryCharging,
                                                                    size: 15,
                                                                    color: (e
                                                                                .battery! <=
                                                                            15)
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Text(
                                                                    '${e.battery.toString()} %',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: (e.battery! <=
                                                                              15)
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: const [
                                                        Text(
                                                          'Últ. local.: ',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Av Assis Ribeiro, nº 3000',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: const [
                                                        Text(
                                                          'Desde: ',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          ' 12:00',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                thickness: 5,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          thickness: .7,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

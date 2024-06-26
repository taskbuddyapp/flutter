import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:taskbuddy/widgets/input/with_state/text_inputs/input_title.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/screens/location_input/location_input.dart';
import 'package:taskbuddy/widgets/ui/platforms/bottom_sheet.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Location data model
class LocationData {
  LatLng location;
  String locationName;

  LocationData({
    required this.location,
    required this.locationName
  });
}

// Location information widget
// This widget displays the information of a selected location
class LocationInformation extends StatelessWidget {
  final Function(LatLng?, String? name) onLocationChanged;
  final LatLng? location;
  final String? locationName;
  final bool showEditButton;

  const LocationInformation({
    required this.onLocationChanged,
    this.locationName,
    this.location,
    this.showEditButton = true,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 225),
      child: ClipRRect(
        // Blur background
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4)
            ),
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Location name
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locationName ?? l10n.unnamedLocation,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        l10n.pinnedLocation, // "Pinned location" text
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Edit icon
                if (showEditButton)
                  // Show the edit button, which opens a new screen to edit the location
                  Touchable(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      CrossPlatformBottomSheet.showModal(
                        context,
                        [
                          BottomSheetButton(
                            title: l10n.change,
                            icon: Icons.edit,
                            onTap: (c) {
                              Navigator.of(context).pushNamed(
                                '/location-chooser',
                                arguments: LocationInputArguments(
                                  initPosition: location,
                                  locationName: locationName,
                                  onLocationSelected: (loc, name) {
                                    onLocationChanged(loc, name);
                                  }
                                )
                              );
                            },
                          ),
                          BottomSheetButton(
                            title: l10n.remove,
                            icon: Icons.delete,
                            onTap: (c) {
                              onLocationChanged(null, null);
                            }
                          ),
                        ],
                        title: l10n.pinnedLocation
                      );
                    }
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocationDisplay extends StatefulWidget {
  final LatLng? location;
  final String? locationName;
  final double? radius;
  final Function(LatLng?, String? name)? onLocationChanged;
  final MapController? mapController;
  final bool optional;
  final String tooltipText;
  final bool showEditButton;
  final double zoom;

  const LocationDisplay({
    this.onLocationChanged,
    this.location,
    this.mapController,
    this.locationName,
    this.radius,
    this.optional = true,
    this.tooltipText = '',
    this.showEditButton = true,
    this.zoom = 10,
    Key? key
  }) : super(key: key);

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showEditButton)
          InputTitle(
            title: l10n.location,
            optional: widget.optional,
            tooltipText: widget.tooltipText.isEmpty ? null : widget.tooltipText,
          ),
        if (widget.location != null && widget.showEditButton)
          const SizedBox(height: 8,),
        if (widget.location != null && widget.showEditButton) 
          Text(l10n.approximateLocation, style: Theme.of(context).textTheme.labelMedium,),
        const SizedBox(height: Sizing.inputSpacing,),
        if (widget.location != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 300, // Set the height of the map to 300
              child: Stack( // Vertical stack of map and location display
                children: [
                  // Show the map
                  FlutterMap(
                    mapController: widget.mapController,
                    options: MapOptions(
                      initialCenter: widget.location!,
                      initialZoom: widget.zoom
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'app.taskbuddy.flutter',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: widget.location!,
                            child: const Icon(Icons.location_on, color: Colors.red),
                          ),
                        ],
                      ),
                      if (widget.radius != null)
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: widget.location!,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                              radius: widget.radius! * 1000,
                              borderColor: Theme.of(context).colorScheme.outline,
                              borderStrokeWidth: 2,
                              useRadiusInMeter: true
                            )
                          ],
                        ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 75),
                        child: OSMAttribution()
                      ),
                    ],
                  ),
                  // Show the location text
                  LocationInformation(
                    onLocationChanged: (loc, name) {
                      widget.onLocationChanged?.call(loc, name);
                    },
                    showEditButton: widget.showEditButton,
                    location: widget.location,
                    locationName: widget.locationName,
                  ),
                ],
              ),
            )
          ),
        if (widget.location == null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.noLocationProvided, style: Theme.of(context).textTheme.labelMedium,),
              const SizedBox(height: 8,),
              Button(
                child: Text(
                  l10n.change,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/location-chooser',
                    arguments: LocationInputArguments(
                      initPosition: widget.location,
                      locationName: widget.locationName,
                      onLocationSelected: (loc, name) {
                        widget.onLocationChanged?.call(loc, name);
                      }
                    )
                  );
                }
              ),
            ],
          ),
      ],
    );
  }
}
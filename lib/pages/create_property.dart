import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/components/custom_dropdown.dart';
import 'package:bnbscout24/components/date_input.dart';
import 'package:bnbscout24/components/form_input.dart';
import 'package:bnbscout24/components/custom_text_input.dart';
import 'package:bnbscout24/components/image_picker_widget.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/data/property.dart';
import 'package:bnbscout24/utils/maps_api/maps_api.dart';
import 'package:bnbscout24/utils/maps_api/search_result.dart';
import 'package:bnbscout24/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nominatim_flutter/model/request/search_request.dart';
import 'package:nominatim_flutter/nominatim_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePropertyPage extends StatefulWidget {
  const CreatePropertyPage({super.key});

  @override
  State<CreatePropertyPage> createState() => _CreatePropertyPageState();
}

class _CreatePropertyPageState extends State<CreatePropertyPage> {
  String priceInterval = "Daily";
  List<XFile> images = List.empty(growable: true);
  bool creating = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController areaController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController mbitPerSecond = TextEditingController();

  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void createProperty() async {
    setState(() {
      creating = true;
    });

    try {
      int price = int.parse(priceController.text) * 100;
      double squareMeters = double.parse(areaController.text);
      double mbitsPerSec = double.parse(mbitPerSecond.text);
      int rooms = int.parse(roomController.text);

      // Geocoding Addresss
      MapsAPI api = MapsAPI();
      List<SearchResult>? adds = await api.resolve(addressController.text);

      if (adds == null || adds.isEmpty) {
        SnackbarService.showError(
            "Could not find this address, check your input");
        return;
      }

      List<String> pictureIds = List.empty(growable: true);
      // Uploading images
      for (XFile? file in images) {
        if (file == null) {
          print("Null image, wth is going on?");
          continue;
        }
        String? id =
            await Property.uploadImage(await file.readAsBytes(), file.name);
        if (id != null) {
          pictureIds.add(id);
        } else {
          print("Wth is going on here?");
        }
      }

      SearchResult address = adds[0];

      Property property = Property(
          name: titleController.text,
          userId: "Unknown",
          description: descriptionController.text,
          address: address.displayName,
          pictureIds: pictureIds,
          priceInterval: priceInterval,
          priceIntervalCents: price,
          squareMetres: squareMeters,
          roomAmount: rooms,
          geoLat: address.latitude,
          geoLon: address.longitude,
          mbitPerSecond: mbitsPerSec);
      Property? result = await Property.createProperty(property);

      Navigator.pop(context);
    } on FormatException {
      SnackbarService.showError("Could not create the property, because of invalid input! Check all the fields.");
    } 
    catch (e) {
      print(e);
      SnackbarService.showError("Could not create the property, because of an unknown reason!");
    } finally {
      setState(() {
        creating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(
                Sizes.paddingRegular,
                Sizes.paddingRegular,
                Sizes.paddingRegular,
                Sizes.paddingRegular),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(spacing: Sizes.paddingSmall, children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: Sizes.paddingBig),
                      child: Text(
                        "Add Property",
                        style: TextStyle(
                            fontSize: Sizes.textSizeBig,
                            fontWeight: FontWeight.bold),
                      )),
                ]),
                Expanded(
                  child: SingleChildScrollView(
                      child: IntrinsicHeight(
                    child: Column(
                      children: [
                        ImagePickerWidget(
                          size: 200,
                            onImagesPicked: (pickedImages) => setState(() {
                                  images = pickedImages;
                                })),
                                SizedBox(height: 30,),
                        FormInput(
                          label: "Title",
                          children: [
                            CustomTextInput(
                              hint: "Title",
                              controller: titleController,
                            ),
                          ],
                        ),
                        FormInput(
                          label: "Address",
                          children: [
                            CustomTextInput(
                              hint: "Address",
                              controller: addressController,
                            ),
                          ],
                        ),
                        FormInput(
                          label: "Booking interval",
                          children: [
                            CustomDropdown(
                              value: priceInterval,
                              onChanged: (val) async {
                                setState(() {
                                  priceInterval = val;
                                });
                              },
                              items: [
                                "Daily",
                                "Weekly",
                                "Monthly"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                            ),
                            CustomTextInput(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: priceController,
                              hint: "Price per interval",
                              suffixIcon: Icon(Icons.euro),
                            )
                          ],
                        ),
                        FormInput(
                          label: "Details",
                          children: [
                            CustomTextInput(
                              suffixIcon: Icon(Icons.square_foot),
                              keyboardType: TextInputType.numberWithOptions(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: areaController,
                              hint: "Square meters",
                            ),
                            CustomTextInput(
                              suffixIcon: Icon(Icons.room),
                              keyboardType: TextInputType.numberWithOptions(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: roomController,
                              hint: "Rooms",
                            ),
                            CustomTextInput(
                              suffixIcon: Icon(Icons.wifi),
                              keyboardType: TextInputType.numberWithOptions(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: mbitPerSecond,
                              hint: "Mbit/s",
                            ),
                          ],
                        ),
                        FormInput(
                          label: "Access details",
                          children: [
                            CustomTextInput(
                              hint: "Describe how to access the property",
                              maxLines: 3,
                              controller: descriptionController,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ),
                creating
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: Sizes.paddingRegular,
                      children: [
                        Text("Creating property..."),
                        CircularProgressIndicator()
                      ],
                    )
                    : SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                            text: "Create Property", onPressed: createProperty)),
              ],
            )));
  }
}

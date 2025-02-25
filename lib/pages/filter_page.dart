import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/components/custom_dropdown.dart';
import 'package:bnbscout24/components/date_input.dart';
import 'package:bnbscout24/components/form_input.dart';
import 'package:bnbscout24/components/custom_text_input.dart';
import 'package:bnbscout24/components/page_base.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends StatefulWidget {
  static String KEY_PRICE_INTERVAL = "FilterPriceInterval";
  static String KEY_PRICE_MIN = "FilterPriceMin";
  static String KEY_PRICE_MAX = "FilterPriceMax";

  static String KEY_AREA_MIN = "FilterAreaMin";
  static String KEY_AREA_MAX = "FilterAreaMax";

  static String KEY_FROM_DATE = "FilterFromDate";
  static String KEY_TO_DATE = "FilterToDate";

  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  static String priceInterval = "Daily";
  final TextEditingController priceMinController = TextEditingController();
  final TextEditingController priceMaxController = TextEditingController();

  final TextEditingController areaMinController = TextEditingController();
  final TextEditingController areaMaxController = TextEditingController();

  static DateTime? fromDate = DateTime.now();
  static DateTime? toDate = null;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    priceMinController.text =
        prefs.getDouble(FilterPage.KEY_PRICE_MIN)?.toString() ?? "";
    priceMaxController.text =
        prefs.getDouble(FilterPage.KEY_PRICE_MAX)?.toString() ?? "";

    areaMinController.text =
        prefs.getDouble(FilterPage.KEY_AREA_MIN)?.toString() ?? "";
    areaMaxController.text =
        prefs.getDouble(FilterPage.KEY_AREA_MAX)?.toString() ?? "";

    setState(() {
      priceInterval =
          prefs.getString(FilterPage.KEY_PRICE_INTERVAL)?.toString() ?? "Daily";
      fromDate =
          DateTime.tryParse(prefs.getString(FilterPage.KEY_FROM_DATE) ?? "");
      toDate = DateTime.tryParse(prefs.getString(FilterPage.KEY_TO_DATE) ?? "");
    });
  }




  void applyFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(FilterPage.KEY_PRICE_INTERVAL, priceInterval);

    double? priceMin = double.tryParse(priceMinController.text);
    if (priceMin != null) {
      prefs.setDouble(FilterPage.KEY_PRICE_MIN, priceMin);
    }
    else {
      prefs.remove(FilterPage.KEY_PRICE_MIN);
    }

    double? priceMax = double.tryParse(priceMaxController.text);
    if (priceMax != null) {
      prefs.setDouble(FilterPage.KEY_PRICE_MAX, priceMax);
    }
    else {
      prefs.remove(FilterPage.KEY_PRICE_MAX);
    }

    double? areaMin = double.tryParse(areaMinController.text);
    if (areaMin != null) {
      prefs.setDouble(FilterPage.KEY_AREA_MIN, areaMin);
    }
    else {
      prefs.remove(FilterPage.KEY_AREA_MIN);
    }

    double? areaMax = double.tryParse(areaMaxController.text);
    if (areaMax != null) {
      prefs.setDouble(FilterPage.KEY_AREA_MAX, areaMax);
    }
    else {
      prefs.remove(FilterPage.KEY_AREA_MAX);
    }

    if (fromDate != null) {
      prefs.setString(FilterPage.KEY_FROM_DATE, fromDate!.toIso8601String());
    }
    else {
      prefs.remove(FilterPage.KEY_FROM_DATE);
    }

    if (toDate != null) {
      prefs.setString(FilterPage.KEY_TO_DATE, toDate!.toIso8601String());
    }
    else {
      prefs.remove(FilterPage.KEY_TO_DATE);
    }

  }

  @override
  Widget build(BuildContext context) {

    return PageBase(
          title: "Filter",
            child: IntrinsicHeight(
            child: Column(spacing: Sizes.paddingSmall, 
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                
                FormInput(
                  label: "Price",
                  children: [
                    CustomDropdown(
                      value: priceInterval,
                      onChanged: (val) async {
                        setState(() {
                          priceInterval = val;
                        });
                      },
                      items: ["Daily", "Weekly", "Monthly"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                    ),
                    CustomTextInput(
                      suffixIcon: Icon(Icons.euro),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      hint: "Min.",
                      controller: priceMinController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    CustomTextInput(
                      suffixIcon: Icon(Icons.euro),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: priceMaxController,
                      hint: "Max.",
                    )
                  ],
                ),
                FormInput(
                  label: "Area",
                  children: [
                    CustomTextInput(
                      suffixIcon: Icon(Icons.square_foot),
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: areaMinController,
                      hint: "Min.",
                    ),
                    CustomTextInput(
                      suffixIcon: Icon(Icons.square_foot),
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: areaMaxController,
                      hint: "Max.",
                    )
                  ],
                ),
                FormInput(
                  label: "Availability",
                  children: [
                    DateInput(
                      initialDate: fromDate,
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 30 * 24)),
                      onDateSelected: (date) async {
                        setState(() {
                          fromDate = date;
                        });
                      },
                    ),
                    DateInput(
                      initialDate: toDate,
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 30 * 24)),
                      onDateSelected: (date) async {
                        setState(() {
                          toDate = date;
                        }); 
                      },
                    )
                  ],
                ),
                Spacer(),
                SizedBox(
                    width: double.infinity,
                    child: ColorButton(
                        text: "Apply",
                        onPressed: () {
                          applyFilter();
                          Navigator.pop(context);
                        })),
              ],
            )));
  }
}

import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/components/date_input.dart';
import 'package:bnbscout24/components/form_input.dart';
import 'package:bnbscout24/components/custom_text_input.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FilterPage extends StatefulWidget {
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

    priceMinController.text = prefs.getDouble(FilterPage.KEY_PRICE_MIN)?.toString() ?? "";
    priceMaxController.text = prefs.getDouble(FilterPage.KEY_PRICE_MAX)?.toString() ?? "";

    areaMinController.text = prefs.getDouble(FilterPage.KEY_AREA_MIN)?.toString() ?? "";
    areaMaxController.text = prefs.getDouble(FilterPage.KEY_AREA_MAX)?.toString() ?? "";

    setState(() {
      
      fromDate = DateTime.tryParse(prefs.getString(FilterPage.KEY_FROM_DATE) ?? "");
      toDate = DateTime.tryParse(prefs.getString(FilterPage.KEY_TO_DATE) ?? "");
    });
  }

  void addDoubleInputListener(TextEditingController controller, String key) {
    controller.addListener(() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(key, double.parse(controller.text));
    });

    
  }

  void addDateInput(TextEditingController controller, String key) {
    controller.addListener(() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(key, double.parse(controller.text));
    });

    
  }

  @override
  Widget build(BuildContext context) {
    addDoubleInputListener(priceMinController, FilterPage.KEY_PRICE_MIN);
    addDoubleInputListener(priceMaxController, FilterPage.KEY_PRICE_MAX);

    addDoubleInputListener(areaMinController, FilterPage.KEY_AREA_MIN);
    addDoubleInputListener(areaMaxController, FilterPage.KEY_AREA_MAX);


  

    return Container(
      padding: EdgeInsets.fromLTRB(Sizes.paddingSmall, Sizes.paddingSmall, Sizes.paddingSmall, Sizes.navBarFullSize),
      child: Column(
        children: [
          FormInput(
            label: "Price", 
            children: [
                CustomTextInput(
                  suffixIcon: Icon(Icons.euro),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  hint: "Min.",
                  controller: priceMinController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                CustomTextInput(
                  suffixIcon: Icon(Icons.euro),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                  lastDate: DateTime.now().add(const Duration(days: 30 * 24)),
                  onDateSelected: (date) async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString(FilterPage.KEY_FROM_DATE, date.toIso8601String());
                  },
                ),
                DateInput(
                  initialDate: toDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30 * 24)),
                  onDateSelected: (date) async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString(FilterPage.KEY_TO_DATE, date.toIso8601String());
                  },
                )
              ],
          ),
          Spacer(),
          SizedBox(
              width: double.infinity,
              child: PrimaryButton(text: "Apply", onPressed: () => {
                Navigator.pop(context)
              })
            ),
          
          
          
        ],
    ))
    ; 
  }
}

class FilterPageResult {
  final double? priceMin;
  final double? priceMax;

  final double? areaMin;
  final double? areaMax;

  final DateTime? from;
  final DateTime? to;

  const FilterPageResult({ this.priceMin, this.priceMax, this.areaMin, this.areaMax, this.from, this.to });

}
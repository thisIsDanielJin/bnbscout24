import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/components/date_input.dart';
import 'package:bnbscout24/components/form_input.dart';
import 'package:bnbscout24/components/text_input.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Sizes.paddingSmall, Sizes.paddingSmall, Sizes.paddingSmall, Sizes.navBarFullSize),
      child: Column(
        children: [
          FormInput(
            label: "Price", 
            children: [
                TextInput(
                  suffixIcon: Icon(Icons.euro),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  hint: "Min.",
                ),
                TextInput(
                  suffixIcon: Icon(Icons.euro),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  hint: "Max.",
                )
              ],
          ),
           FormInput(
            label: "Area", 
            children: [
                TextInput(
                  suffixIcon: Icon(Icons.square_foot),
                  keyboardType: TextInputType.numberWithOptions(),
                  hint: "Min.",
                ),
                TextInput(
                  suffixIcon: Icon(Icons.square_foot),
                  keyboardType: TextInputType.numberWithOptions(),
                  hint: "Max.",
                )
              ],
          ),
          FormInput(
            label: "Availability", 
            children: [
                DateInput(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30 * 24)),
                ),
                DateInput(
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30 * 24)),
                )
              ],
          ),
          Spacer(),
          SizedBox(
              width: double.infinity,
              child: PrimaryButton(text: "Apply", onPressed: () => print("HEO"))
            ),
          
          
          
        ],
    ))
    ; 
  }
}
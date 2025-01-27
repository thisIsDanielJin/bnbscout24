import 'package:bnbscout24/components/form_input.dart';
import 'package:bnbscout24/components/text_input.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          FormInput(
            label: "Price", 
            children: [
                TextInput(
                  hint: "Min.",
                ),
                TextInput(
                  hint: "Max.",
                )
              ],
          ),
           FormInput(
            label: "Area", 
            children: [
                TextInput(
                  hint: "Min.",
                ),
                TextInput(
                  hint: "Max.",
                )
              ],
          ),
          FormInput(
            label: "Availability", 
            children: [
                TextInput(
                  hint: "From",
                ),
                TextInput(
                  hint: "To",
                )
              ],
          ),
        ],
    ))
    ; 
  }
}
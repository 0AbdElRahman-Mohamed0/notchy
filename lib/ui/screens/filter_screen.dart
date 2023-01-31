import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notchy/ui/widget/custom_button.dart';
import 'package:notchy/ui/widget/input_form_field.dart';
import 'package:notchy/ui/widget/simple_dropdown.dart';
import 'package:quiver/strings.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _limit;
  String? _sort;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filters',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Items',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  InputFormField(
                    above: true,
                    labelText: 'How many products to show',
                    hintText: 'Number of show products',
                    onSaved: (limit) => _limit = limit,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  SimpleDropDown<String>(
                    list: const ['asc', 'desc'],
                    text: 'Sort by',
                    hintText: 'Select sort way',
                    onSaved: (sort) => _sort = sort,
                    onChanged: (sort) {},
                  ),
                ],
              ),
              CustomButton(
                onTap: () {
                  _formKey.currentState?.save();
                  if (isBlank(_limit) && isBlank(_sort)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Select one filter at least.',
                          textAlign: TextAlign.center,
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, {
                    'limit': _limit,
                    'sort': _sort,
                  });
                },
                title: 'Apply Filters',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

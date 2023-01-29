import 'dart:io';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flrx_validator/flrx_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notchy/models/address_model.dart';
import 'package:notchy/models/name_model.dart';
import 'package:notchy/ui/widget/custom_button.dart';
import 'package:notchy/ui/widget/input_form_field.dart';
import 'package:quiver/strings.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String? _username;
  NameModel? _name;
  String? _email;
  String? _pass;
  AddressModel? _address;
  bool _obscure = true;
  bool _confirmationObscure = true;
  String? _phone;
  late CountryCode _countryCode;

  _submit() async {
    if (!_formKey.currentState!.validate()) {
      if (!_autoValidate) setState(() => _autoValidate = true);
      return;
    }

    _formKey.currentState?.save();
  }

  @override
  void initState() {
    super.initState();
    _countryCode =
        const CountryCode(code: 'EG', dialCode: '+20', name: 'Egypt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 34),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Create Account',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Please fill the input below here.',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 18,
              ),
              InputFormField(
                above: true,
                labelText: 'Username',
                onSaved: (name) => _username = name,
                validator: Validator(
                  rules: [
                    RequiredRule(validationMessage: 'Please enter a username.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputFormField(
                above: true,
                labelText: 'First Name',
                onSaved: (name) => _name?.firstName = name,
                validator: Validator(
                  rules: [
                    RequiredRule(
                        validationMessage: 'Please enter your first name.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputFormField(
                above: true,
                labelText: 'Last Name',
                onSaved: (name) => _name?.lastName = name,
                validator: Validator(
                  rules: [
                    RequiredRule(
                        validationMessage: 'Please enter your last name.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Phone',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width) * 100 / 375,
                    child: InputFormField(
                      readOnly: true,
                      validator: (_) => isBlank(_phone) ? '' : null,
                      hasConstraints: false,
                      prefixIcon: InkWell(
                        onTap: () async {
                          const countryPicker = FlCountryCodePicker();
                          _countryCode = (await countryPicker.showPicker(
                              context: context, initialSelectedLocale: 'EG'))!;
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              _countryCode.dialCode,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            _countryCode.flagImage,
                            const SizedBox(
                              width: 4,
                            ),
                            SvgPicture.asset(
                              'assets/svg/arrow_down.svg',
                              height: 16,
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: InputFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      onChanged: (phone) {
                        _phone = phone;
                        setState(() {});
                      },
                      onSaved: (phone) => _phone = phone,
                      validator: Validator(
                        rules: [
                          RequiredRule(
                              validationMessage:
                                  'Please enter a phone number.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InputFormField(
                above: true,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _email = email,
                validator: Validator(
                  rules: <Rule>[
                    RequiredRule(validationMessage: 'Please enter an email.'),
                    EmailRule(validationMessage: 'Please enter a valid email.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputFormField(
                above: true,
                labelText: 'City',
                onSaved: (city) => _address?.city = city,
                validator: Validator(
                  rules: [
                    RequiredRule(validationMessage: 'Please enter a city.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputFormField(
                above: true,
                labelText: 'Street',
                onSaved: (street) => _address?.street = street,
                validator: Validator(
                  rules: [
                    RequiredRule(
                        validationMessage: 'Please enter a street name.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputFormField(
                      above: true,
                      labelText: 'Building Number',
                      onSaved: (buildingNumber) {
                        _address?.buildingNumber =
                            int.tryParse(buildingNumber ?? '0');
                      },
                      validator: Validator(
                        rules: [
                          RequiredRule(validationMessage: 'Required.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InputFormField(
                      above: true,
                      labelText: 'zipcode',
                      onSaved: (zipcode) => _address?.zipcode = zipcode,
                      validator: Validator(
                        rules: [
                          RequiredRule(validationMessage: 'Required.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              InputFormField(
                above: true,
                labelText: 'Password',
                obscure: _obscure,
                suffixIcon: InkWell(
                  onTap: () {
                    _obscure = !_obscure;
                    setState(() {});
                  },
                  child: SvgPicture.asset(_obscure
                      ? 'assets/svg/eye-close.svg'
                      : 'assets/svg/eye-open.svg'),
                ),
                onSaved: (pass) => _pass = pass,
                onChanged: (pass) {
                  _pass = pass;
                  setState(() {});
                },
                validator: Validator(
                  rules: [
                    RequiredRule(validationMessage: 'Please enter a password.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputFormField(
                above: true,
                labelText: 'Confirm Password',
                obscure: _confirmationObscure,
                suffixIcon: InkWell(
                  onTap: () {
                    _confirmationObscure = !_confirmationObscure;
                    setState(() {});
                  },
                  child: SvgPicture.asset(_confirmationObscure
                      ? 'assets/svg/eye-close.svg'
                      : 'assets/svg/eye-open.svg'),
                ),
                validator: (pass) => RegExp('^$_pass\$').hasMatch(pass ?? '')
                    ? null
                    : 'Password is not match.',
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onTap: _submit,
                title: 'SIGN UP',
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: 'Sign in',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

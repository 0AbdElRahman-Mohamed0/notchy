import 'package:dio/dio.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flrx_validator/flrx_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notchy/models/address_model.dart';
import 'package:notchy/models/name_model.dart';
import 'package:notchy/models/user_model.dart';
import 'package:notchy/providers/auth_provider.dart';
import 'package:notchy/ui/widget/custom_button.dart';
import 'package:notchy/ui/widget/error_pop_up.dart';
import 'package:notchy/ui/widget/input_form_field.dart';
import 'package:notchy/ui/widget/loading.dart';
import 'package:notchy/utils/extension_methods/dio_error_extention.dart';
import 'package:quiver/strings.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String? _username;
  NameModel? _name;
  String? _email;
  AddressModel? _address;
  String? _phone;
  late CountryCode _countryCode;

  _submit() async {
    if (!_formKey.currentState!.validate()) {
      if (!_autoValidate) setState(() => _autoValidate = true);
      return;
    }
    _formKey.currentState?.save();
    try {
      LoadingScreen.show(context);
      final user = UserModel(
        email: _email,
        name: _name,
        phone: _phone,
        address: _address,
        username: _username,
      );
      await context.read<AuthProvider>().updateProfile(user);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your profile updated successfully.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    } on DioError catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => ErrorPopUp(message: e.readableError),
      );
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => const ErrorPopUp(
            message: 'Something went wrong. Please try again.'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
    _countryCode =
        const CountryCode(code: 'EG', dialCode: '+20', name: 'Egypt');
  }

  _initData() {
    final user = context.read<AuthProvider>().user;
    _email = user?.email;
    _name = user?.name;
    _phone = user?.phone;
    _address = user?.address;
    _username = user?.username;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputFormField(
                above: true,
                labelText: 'Username',
                initialValue: user?.username,
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
                initialValue: user?.name?.firstName,
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
                initialValue: user?.name?.lastName,
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
                      initialValue: user?.phone,
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
                initialValue: user?.email,
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
                initialValue: user?.address?.city,
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
                initialValue: user?.address?.street,
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
                      initialValue: user?.address?.buildingNumber.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
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
                      initialValue: user?.address?.zipcode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
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
              CustomButton(
                onTap: _submit,
                title: 'Edit Data',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

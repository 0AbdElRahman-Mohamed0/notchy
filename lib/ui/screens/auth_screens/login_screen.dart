import 'package:flrx_validator/flrx_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notchy/ui/screens/auth_screens/registration_screen.dart';
import 'package:notchy/ui/screens/nav_screen.dart';
import 'package:notchy/ui/widget/custom_button.dart';
import 'package:notchy/ui/widget/input_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String? _email;
  bool _obscure = true;
  String? _pass;

  _submit() async {
    if (!_formKey.currentState!.validate()) {
      if (!_autoValidate) setState(() => _autoValidate = true);
      return;
    }
    _formKey.currentState?.save();
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (_) => const NavScreen(),
        ),
        (route) => false);
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
              Center(
                child: Image.asset(
                  'assets/images/login_vector.jpg',
                  height: MediaQuery.of(context).size.height * 250 / 812,
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              Text(
                'Login',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Please sign in to continue.',
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
                validator: Validator(
                  rules: [
                    RequiredRule(validationMessage: 'Please enter a password.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onTap: _submit,
                title: 'LOGIN',
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => const RegistrationScreen(),
                    ),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: 'Sign up',
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

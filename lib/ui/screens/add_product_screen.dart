import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flrx_validator/flrx_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notchy/models/product_model.dart';
import 'package:notchy/providers/categories_provider.dart';
import 'package:notchy/providers/products_provider.dart';
import 'package:notchy/ui/widget/custom_button.dart';
import 'package:notchy/ui/widget/error_pop_up.dart';
import 'package:notchy/ui/widget/input_form_field.dart';
import 'package:notchy/ui/widget/loading.dart';
import 'package:notchy/ui/widget/simple_dropdown.dart';
import 'package:notchy/ui/widget/take_photo_pop_up.dart';
import 'package:notchy/utils/extension_methods/dio_error_extention.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String? _name;
  String? _category;
  String? _price;
  String? _description;
  File? _image;

  Future<void> _pickImage() async {
    Navigator.pop(context);
    final pFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pFile != null) _image = File(pFile.path);
    if (mounted) setState(() {});
  }

  Future<void> _takeImage() async {
    Navigator.pop(context);
    final pFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (pFile != null) _image = File(pFile.path);
    if (mounted) setState(() {});
  }

  _putImage() async {
    await showDialog(
      context: context,
      builder: (context) => TakePhotoPopUp(
        pickImageOnPressed: _pickImage,
        takeImageOnPressed: _takeImage,
      ),
    );
  }

  _deleteImage() {
    _image = null;
    setState(() {});
  }

  _submit() async {
    if (!_formKey.currentState!.validate()) {
      if (!_autoValidate) setState(() => _autoValidate = true);
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add an image.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    _formKey.currentState?.save();
    try {
      LoadingScreen.show(context);
      final product = ProductModel(
        price: num.tryParse(_price ?? '0'),
        title: _name,
        category: _category,
        description: _description,
        fileImage: _image,
      );
      await context.read<ProductsProvider>().addProduct(product);
      if (!mounted) return;
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your product added successfully.',
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
  Widget build(BuildContext context) {
    final categories = context.watch<CategoriesProvider>().categories;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
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
              _image == null
                  ? InkWell(
                      onTap: _putImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: Theme.of(context).primaryColor,
                              size: 50,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Add Product Image',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: _deleteImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).errorColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 18,
              ),
              InputFormField(
                above: true,
                labelText: 'Product Name',
                onSaved: (name) => _name = name,
                validator: Validator(
                  rules: [
                    RequiredRule(
                        validationMessage: 'Please enter a product name.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SimpleDropDown<String>(
                list: categories,
                text: 'Categories',
                onSaved: (category) => _category = category,
                onChanged: (category) {},
                validator: Validator(
                  rules: [
                    RequiredRule(validationMessage: 'Please select category.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputFormField(
                above: true,
                labelText: 'Price',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                onSaved: (price) => _price = price,
                validator: Validator(
                  rules: [
                    RequiredRule(validationMessage: 'Please enter price.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InputFormField(
                above: true,
                labelText: 'Description',
                maxLines: 6,
                onSaved: (description) => _description = description,
                validator: Validator(
                  rules: [
                    RequiredRule(
                        validationMessage: 'Please enter product details.'),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                onTap: _submit,
                title: 'Submit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

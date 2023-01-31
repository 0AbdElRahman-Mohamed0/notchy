import 'package:flutter/material.dart';

class SimpleDropDown<T> extends StatefulWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? labelText;
  final String? text;
  final bool small;
  final List<T>? list;
  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T>? onSaved;

  const SimpleDropDown({
    Key? key,
    this.value,
    required this.onChanged,
    this.hintText,
    this.small = false,
    this.labelText,
    this.text,
    required this.list,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  State<SimpleDropDown> createState() => _SimpleDropDownState<T>();
}

class _SimpleDropDownState<T> extends State<SimpleDropDown<T>> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.text != null)
          Text(
            widget.text!,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        SizedBox(
          height: 48,
          child: DropdownButtonFormField<T>(
            value: widget.value,
            onChanged: widget.onChanged,
            focusNode: _focus,
            validator: widget.validator,
            onSaved: widget.onSaved,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
            icon: widget.list!.isNotEmpty
                ? const Icon(Icons.keyboard_arrow_down)
                : const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
            selectedItemBuilder: (context) => widget.list!
                .map(
                  (e) => widget.small
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: Text(
                            '$e',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : Text(
                          '$e',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                        ),
                )
                .toList(),
            items: widget.list
                ?.map((T e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      '$e',
                      overflow: TextOverflow.ellipsis,
                    )))
                .toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              hintText: widget.hintText,
              labelText: widget.labelText,
              contentPadding: const EdgeInsets.only(right: 16, left: 10),
            ),
          ),
        ),
      ],
    );
  }
}

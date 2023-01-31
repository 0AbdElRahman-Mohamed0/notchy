import 'package:flutter/material.dart';

class TakePhotoPopUp extends StatelessWidget {
  final void Function()? takeImageOnPressed;
  final void Function()? pickImageOnPressed;

  const TakePhotoPopUp(
      {Key? key, this.pickImageOnPressed, this.takeImageOnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          Text(
            'Upload photo',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: takeImageOnPressed,
                child: Container(
                  height: 46,
                  width: 112,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Camera',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              InkWell(
                onTap: pickImageOnPressed,
                child: Container(
                  height: 46,
                  width: 112,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Gallery',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

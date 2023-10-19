import 'package:flutter/material.dart';
import 'package:gohan_map/colors/app_colors.dart';

class AppSearchBar extends StatelessWidget {
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function()? onPressClear;
  final bool showBack;
  final bool autofocus;
  final TextEditingController? controller;
  const AppSearchBar({
    Key? key,
    this.onSubmitted,
    this.onChanged,
    this.onPressClear,
    this.showBack = true,
    this.autofocus = false,
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        //角丸
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.greyLightColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.greyColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (showBack == true)
              InkWell(
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.blackTextColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextField(
                  controller: controller,
                  autofocus: autofocus,
                  cursorColor: AppColors.blackTextColor,
                  decoration: const InputDecoration(
                    hintText: 'お店の 検索 / 登録',
                    border: InputBorder.none,
                  ),
                  onSubmitted: onSubmitted,
                  onChanged: onChanged,
                ),
              ),
            ),
            InkWell(
              onTap: onPressClear,
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.blackTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

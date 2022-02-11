import 'package:flutter/material.dart';

///
/// Simple TextButton with [isSelected] property that can be used to show selected state.
///
class ToggleableButton extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final Function()? onPressed;
  const ToggleableButton({
    Key? key,
    required this.child,
    this.isSelected = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: TextButton.styleFrom(
        primary: isSelected ? null : Colors.white,
        backgroundColor: isSelected ? Colors.white : null,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(
            color: Colors.white,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

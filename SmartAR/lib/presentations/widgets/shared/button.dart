import "package:SmartAR/data/consts.dart";
import "package:flutter/material.dart";

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.isOutline = false,
    this.loaderRadius = 25,
    this.color,
    this.bgColor,
    this.icon,
    this.borderRadius = 15,
    this.onPressed,
  });
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final bool isOutline;
  final int loaderRadius;
  final double borderRadius;
  final Color? bgColor;
  final Color? color;
  final Widget? icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color effectiveBgColor = bgColor ?? theme.primaryColor;
    final Color effectiveTextColor =
        color ??
        (theme.brightness == Brightness.dark ? Colors.white : textPrimary);

    Widget buildButtonChild() {
      if (icon != null) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: icon!,
              ),
            ),
            Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, color: effectiveTextColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      } else {
        return Text(
          text,
          style: TextStyle(fontSize: 16, color: effectiveTextColor),
        );
      }
    }

    if (isOutline) {
      return SizedBox(
        width: MediaQuery.of(context).size.width - 28,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: effectiveTextColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buildButtonChild(),
        ),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width - 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: buildButtonChild(),
      ),
    );
  }
}

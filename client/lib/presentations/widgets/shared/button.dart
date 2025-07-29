import "package:flutter/material.dart";
import "package:smartar/data/consts.dart";

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
      return Stack(
        alignment: Alignment.center,
        children: [
          icon != null
              ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: icon!,
                ),
              )
              : SizedBox.shrink(),
          Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: effectiveTextColor),
              textAlign: TextAlign.center,
            ),
          ),
          isLoading
              ? Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    color: color,
                    strokeWidth: 2,
                  ),
                ),
              )
              : SizedBox.shrink(),
        ],
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width - 28,
      child:
          isOutline
              ? OutlinedButton(
                onPressed: !isDisabled ? onPressed : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: effectiveTextColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                child: buildButtonChild(),
              )
              : ElevatedButton(
                onPressed: !isDisabled ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: effectiveBgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                child: buildButtonChild(),
              ),
    );
  }
}

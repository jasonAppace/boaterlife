import 'package:flutter/material.dart';
import 'color_utils.dart';
import 'font_utils.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onButtonPressed;
  final String? textValue;
  final double? Width;
  final double? Height;
  final Color? TextColor;
  final double? TextSzie;
  final bool? isLoading; // New loading parameter (optional)

  CustomButton({
    this.onButtonPressed,
    this.textValue,
    Key? key,
    this.Width,
    this.Height,
    this.TextColor,
    this.TextSzie,
    this.isLoading, // Add to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool loading = isLoading ?? false; // Default to false if not provided

    return Container(
      height: Height,
      width: Width,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: MediaQuery.of(context).size.width / 1,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: loading
              ? Theme.of(context).primaryColor.withOpacity(0.6) // Dimmed when loading
              : Theme.of(context).primaryColor,
        ),
        child: MaterialButton(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: loading ? null : onButtonPressed, // Disable when loading
          child: loading
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    TextColor ?? ColorUtils.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                textValue ?? 'Loading...',
                style: TextStyle(
                  fontFamily: FontUtils.urbanistSemiBold,
                  fontSize: TextSzie ?? 16,
                  color: (TextColor ?? ColorUtils.white).withOpacity(0.7),
                ),
              ),
            ],
          )
              : Text(
            textValue!,
            style: TextStyle(
              fontFamily: FontUtils.urbanistSemiBold,
              fontSize: TextSzie ?? 16,
              color: TextColor ?? ColorUtils.white,
            ),
          ),
        ),
      ),
    );
  }
}
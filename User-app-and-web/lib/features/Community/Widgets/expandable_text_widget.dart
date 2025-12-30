import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'font_utils.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String? textValue;
  final String? fontFamily;
  final double? fontSize;
  final Color? textColor;
  final TextAlign? textAlign;
  final int? maxLines;

  const ExpandableTextWidget({
    this.textValue,
    this.fontFamily,
    this.fontSize,
    this.textColor,
    this.textAlign,
    this.maxLines,
    Key? key,
  }) : super(key: key);

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: widget.fontFamily ?? FontUtils.urbanistSemiBold,
      fontSize: widget.fontSize ?? 18,
      color: widget.textColor ?? ColorUtils.black,
    );

    if (widget.textValue == null || widget.textValue!.isEmpty) {
      return const SizedBox();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Create a TextPainter to measure the text
        final textSpan = TextSpan(
          text: widget.textValue,
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textAlign: widget.textAlign ?? TextAlign.start,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        if (!isOverflowing || isExpanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.textValue!,
                textAlign: widget.textAlign,
                style: textStyle,
              ),
              if (isOverflowing)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    "See Less",
                    style: TextStyle(
                      fontSize: widget.fontSize ?? 18,
                      color: Theme.of(context).primaryColor,
                      fontFamily: widget.fontFamily ?? FontUtils.urbanistSemiBold,
                    ),
                  ),
                ),
            ],
          );
        }

        // Truncate text and append "See More" at the end of the last line
        final linkText = " See More";

        // Determine where to truncate the text
        String truncatedText = widget.textValue!;
        textPainter.text = TextSpan(
          text: truncatedText + linkText,
          style: textStyle,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        while (textPainter.didExceedMaxLines) {
          truncatedText = truncatedText.substring(0, truncatedText.length - 1);
          textPainter.text = TextSpan(
            text: truncatedText + linkText,
            style: textStyle,
          );
          textPainter.layout(maxWidth: constraints.maxWidth);
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = true;
            });
          },
          child: RichText(
            text: TextSpan(
              text: truncatedText,
              style: textStyle,
              children: [
                TextSpan(
                  text: linkText,
                  style: TextStyle(
                    fontSize: widget.fontSize ?? 18,
                    color: Theme.of(context).primaryColor,
                    fontFamily: widget.fontFamily ?? FontUtils.urbanistSemiBold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

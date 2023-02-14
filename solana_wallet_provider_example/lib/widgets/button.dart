/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../themes/color_palette.dart';


/// Button
/// ------------------------------------------------------------------------------------------------

class Button extends StatelessWidget {
  
  /// Creates a [TextButton].
  const Button({
    super.key,
    required this.style,
    this.enabled = true,
    required this.onPressed,
    required  this.child,
  });

  /// Styling.
  final ButtonStyle style;

  /// Active state.
  final bool enabled;

  /// Callback handler.
  final void Function()? onPressed;

  /// Content.
  final Widget child;

  /// Button style.
  static ButtonStyle styleFrom({ 
    final Color? backgroundColor, 
    final EdgeInsets? padding,
  }) => TextButton.styleFrom(
    shape: const StadiumBorder(),
    minimumSize: const Size.square(48.0),
    foregroundColor: ColorPalette.text,
    backgroundColor: backgroundColor,    
    disabledBackgroundColor: ColorPalette.surface,
    textStyle: const TextStyle(
      fontSize: 24.0, 
      fontWeight: FontWeight.w300,
    ),
    padding: padding ?? const EdgeInsets.symmetric(
      horizontal: 24.0,
    ),
  );

  @override
  Widget build(BuildContext context) => TextButton(
    style: style,
    onPressed: enabled ? onPressed : null, 
    child: child,
  );
}
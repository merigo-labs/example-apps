/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../themes/color_palette.dart';
import 'button.dart';


/// Secondary Button
/// ------------------------------------------------------------------------------------------------

class SecondaryButton extends StatelessWidget {
  
  /// Creates a secondary [TextButton].
  const SecondaryButton({
    super.key,
    this.enabled = true,
    required this.onPressed,
    required  this.child,
  });

  /// Active state.
  final bool enabled;

  /// Callback handler.
  final void Function()? onPressed;

  /// Content.
  final Widget child;

  /// Button style.
  static ButtonStyle style() => Button.styleFrom(backgroundColor: ColorPalette.surface);

  @override
  Widget build(BuildContext context) => Button(
    style: SecondaryButton.style(),
    enabled: enabled,
    onPressed: onPressed, 
    child: child,
  );
}
/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider_example/widgets/button.dart';
import '../themes/color_palette.dart';


/// Primary Button
/// ------------------------------------------------------------------------------------------------

class PrimaryButton extends StatelessWidget {
  
  /// Creates a primary [TextButton].
  const PrimaryButton({
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
  static ButtonStyle style() => Button.styleFrom(backgroundColor: Colors.transparent);
  
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24.0),
      gradient: const LinearGradient(
        colors: ColorPalette.solana,
      ),
    ),
    child: Button(
      style: PrimaryButton.style(),
      enabled: enabled,
      onPressed: onPressed, 
      child: child,
    ),
  );
}
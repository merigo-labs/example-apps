/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:solana_wallet_provider_example/screens/methods_screen.dart';
import 'package:solana_wallet_provider_example/screens/send_screen.dart';
import 'themes/color_palette.dart';
import 'widgets/primary_button.dart';
import 'widgets/secondary_button.dart';


/// Main
/// ------------------------------------------------------------------------------------------------

void main(final List<String> arguments) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}


/// App
/// ------------------------------------------------------------------------------------------------

class App extends StatelessWidget {

  const App({super.key});

  Widget _builder(final BuildContext context, final AsyncSnapshot snapshot) {
    return snapshot.connectionState != ConnectionState.done
      ? const CircularProgressIndicator()
      : const SendScreen();
  }

  void _setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: ColorPalette.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(final BuildContext context) {
    _setSystemUIOverlayStyle();
    return SolanaWalletProvider.create(                   // Wrap app with [SolanaWalletProvider].
      identity: AppIdentity(
        uri: Uri.parse('https://merigolabs.com'),         // Your app's domain name.
        icon: Uri.parse('favicon.png'),                   // Relative path from [uri] to your icon.
        name: 'Merigo Labs',                              // Your app's name.
      ), 
      cluster: Cluster.devnet,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorPalette.scheme(),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontSize: 16.0,
            ),
          ),
          extensions: [
            SolanaWalletThemeExtension(                   // Custom [SolanaWalletProvider] theme.
              cardTheme: SolanaWalletCardTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              primaryButtonStyle: PrimaryButton.style(),
              secondaryButtonStyle: SecondaryButton.style(),
            ),
          ],
        ),
        home: FutureBuilder(
          future: SolanaWalletProvider.initialize(),      // Initialize the provider.
          builder: _builder,
        ),
      ),
    );
  }
}
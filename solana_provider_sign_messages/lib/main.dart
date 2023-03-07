/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';


/// Main
/// ------------------------------------------------------------------------------------------------

void main() {
  runApp(const SignMessagesExampleApp());
}


/// Sign Messages Example App
/// ------------------------------------------------------------------------------------------------

class SignMessagesExampleApp extends StatelessWidget {
  const SignMessagesExampleApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Messages Example',
      home: Scaffold(
        body: SolanaWalletProvider.create(
          identity: AppIdentity(
            // uri: Uri.parse('https://solana.com'), // TODO: Add your application's website url.
            // icon: Uri.parse('favicon.icon'),
            // name: '<YOUR_APP_NAME>',              // TODO: Add your application name.
          ),
          cluster: Cluster.devnet,                // TODO: Set the wallet application (e.g. Phantom) to the same network.
          child: const SignMessagesExamplePage(),
        ),
      ),
    );
  }
}


/// Sign Messages Example Page
/// ------------------------------------------------------------------------------------------------

class SignMessagesExamplePage extends StatefulWidget {
  const SignMessagesExamplePage({super.key});
  @override
  State<SignMessagesExamplePage> createState() => _SignMessagesExamplePageState();
}


/// Sign Messages Example Page State
/// ------------------------------------------------------------------------------------------------

class _SignMessagesExamplePageState extends State<SignMessagesExamplePage> {
  
  /// Debug message.
  String? _message;

  /// SolanaWalletProvider.initialize().
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = SolanaWalletProvider.initialize();
  }

  /// Connect application.
  Future<AuthorizeResult> authorize(final SolanaWalletProvider provider) {
    return provider.adapter.authorize().whenComplete(() => setState((){}));
  }

  /// Disconnect application.
  Future<DeauthorizeResult> deauthorize(final SolanaWalletProvider provider) {
    return provider.adapter.deauthorize().whenComplete(() => setState((){}));
  }
  
  /// Sign a message example.
  void signMessage(final SolanaWalletProvider provider) async {
    try {
      setState(() => _message = 'Authorizing DApp...');

      // Get the authorization result or request authorization with a wallet endpoint.
      final AuthorizeResult result = provider.authorizeResult ?? await provider.adapter.reauthorizeOrAuthorize();

      // Get the authorized wallet addresses.
      final PublicKey wallet = result.accounts.first.toPublicKey();

      setState(() => _message = 'Creating message...');

      // Create a message to be signed by the wallet endpoint.
      // TODO: Replace with your message.
      const String message = 'Hello Solana!';

      setState(() => _message = 'Signing message(s)...');

      // Sign message with a wallet address.
      final SignMessagesResult messageResult = await provider.adapter.signMessages(
        messages: [base64UrlEncode(message.codeUnits)],
        addresses: [wallet.toBase64()],
        skipReauthorize: false,
      );

      setState(() => _message = 'Signed message(s)\n${messageResult.signedPayloads}');
      print('SIGNED MESSAGE(S)\n${messageResult.signedPayloads}');
      _message = 'SUCCESS!';
    } catch (error) {
      _message = 'SIGN MESSAGE ERROR\n$error';
    } finally {
      setState((){});
    }
  }

  Widget _textButton({
    required final VoidCallback? onPressed,
    required final String text,
  }) => TextButton(
    onPressed: onPressed, 
    style: TextButton.styleFrom(disabledForegroundColor: Colors.black12),
    child: Text(text, textAlign: TextAlign.center),
  );

  @override
  Widget build(BuildContext context) {
    final String? message = _message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {

            if (snapshot.hasError) {
              return Text('${snapshot.error ?? 'Failed to initialize SolanaWalletProvider.'}');
            }

            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }

            final provider = SolanaWalletProvider.of(context);
            final isAuthorized = provider.adapter.isAuthorized;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _textButton(
                  onPressed: isAuthorized ? null : () => authorize(provider), 
                  text: 'Connect',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _textButton(
                  onPressed: isAuthorized ? () => deauthorize(provider) : null, 
                  text: 'Disconnect',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _textButton(
                  onPressed: isAuthorized ? () => signMessage(provider) : null,
                  text: 'Sign Message',
                ),
                const SizedBox(
                  height: 32.0,
                ),
                if (message != null)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
              ],
            );
          }
        ),
      ),
    );
  }
}

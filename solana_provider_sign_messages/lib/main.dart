/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:solana_web3/programs/memo.dart';
import 'package:solana_web3/solana_web3.dart';


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
            uri: Uri.parse('https://solana.com'), // TODO: Add your application's website url.
            icon: Uri.parse('favicon.icon'),
            name: '<YOUR_APP_NAME>',              // TODO: Add your application name.
          ),
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

  /// Ensure that the provider is loaded once.
  bool _providerLoaded = false;

  /// The provider widget found in the widget tree.
  late final SolanaWalletProviderState provider;

  /// Initialise [provider].
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_providerLoaded) {
      _providerLoaded = true;
      provider = SolanaWalletProvider.of(context);
    }
  }
  
  /// Sign a message example.
  void signMessage() async {
    try {
      setState(() => _message = 'Authorizing DApp...');

      // Get the authorization result or request authorization with a wallet endpoint.
      final AuthorizeResult result = provider.authorizeResult ?? await provider.reauthorizeOrAuthorize();

      // Map the authorized wallet addresses to public keys.
      final List<PublicKey> accounts = result.accounts.map(
        (final Account account) => PublicKey.fromBase64(account.address)
      ).toList(growable: false);

      setState(() => _message = 'Creating message...');

      // Create a message to be signed by a wallet endpoint.
      // TODO: Replace with your message.
      final PublicKey myWallet = accounts.first;
      final latestBlockhash = await provider.connection.getLatestBlockhash();
      final Message message = Transaction(
        recentBlockhash: latestBlockhash.blockhash,
        lastValidBlockHeight: latestBlockhash.lastValidBlockHeight,
        feePayer: myWallet,
        instructions: [
          MemoProgram.create('Memo message.')
        ],
      ).compileMessage();

      setState(() => _message = 'Signing message(s)...');

      // Sign message with a wallet address.
      final SignMessagesResult messageResult = await provider.signMessages(
        messages: [message], 
        addresses: [myWallet],
      );

      setState(() => _message = 'Signed message(s)\n${messageResult.signedPayloads}');
      print('SIGNED MESSAGE(S)\n${messageResult.signedPayloads}');

    } catch (error) {
      setState(() => _message = 'SIGN MESSAGE ERROR\n$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? message = _message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => signMessage(), 
              child: const Text(
                'Sign Message',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            if (message != null)
              Text(
                message,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../themes/color_palette.dart';
import '../widgets/secondary_button.dart';


/// Methods Screen
/// ------------------------------------------------------------------------------------------------

class MethodsScreen extends StatefulWidget {
  
  const MethodsScreen({
    super.key,
  });

  @override
  State<MethodsScreen> createState() => _MethodsScreenState();
}


/// Methods Screen State
/// ------------------------------------------------------------------------------------------------

class _MethodsScreenState extends State<MethodsScreen> {

  Future<AuthorizeResult> _authorize(final SolanaWalletProvider provider) {
    return provider.connect(context);
  }
  
  Future<DeauthorizeResult> _deauthorize(final SolanaWalletProvider provider) {
    return provider.disconnect(context);
  }

  Future<SignTransactionsResult> _signTransactions(final SolanaWalletProvider provider) {
    final Transaction tx = Transaction(
      instructions: [
        MemoProgram.create('Sign Transactions Test'),
      ],
    );
    return provider.signTransactions(
      context,
      Future.value([tx]),
    );
  }

  Future<SignAndSendTransactionsResult> _signAndSendTransactions(
    final SolanaWalletProvider provider,
  ) {
    final Transaction tx = Transaction(
      instructions: [
        MemoProgram.create('Sign Transactions Test'),
      ],
    );
    return provider.signAndSendTransactions(
      context,
      Future.value([tx]),
    );
  }

  Future<SignMessagesResult> _signMessages(final SolanaWalletProvider provider) async {
    final wallet = provider.connectedAccount!.toPublicKey();
    final MessagesAndAddresses msgs = MessagesAndAddresses(
      messages: ['Hi message'], 
      addresses: [wallet],
    );
    return provider.signMessages(
      context,
      Future.value(msgs),
    );
  }

  Future<SignMessagesResult> _signInMessage(final SolanaWalletProvider provider) async {
    final SignInMessage msgs = SignInMessage(
      domain: 'localhost:59000',
      uri: Uri.parse('ws://localhost:59000'),
    );
    print('DOMAIN ${msgs.domain}');
    return provider.signInMessage(
      context,
      Future.value(msgs),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SolanaWalletProvider provider = SolanaWalletProvider.of(context);
    return Scaffold(
      backgroundColor: ColorPalette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SolanaWalletButton(),
              const Divider(),
              const Text('Non Priveleged Methods'),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  SecondaryButton(
                    enabled: !provider.adapter.isAuthorized,
                    onPressed: () => _authorize(provider), 
                    child: const Text('Connect'),
                  ),
                  SecondaryButton(
                    enabled: provider.adapter.isAuthorized,
                    onPressed: () => _deauthorize(provider), 
                    child: const Text('Disconnect'),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              const Text('Priveleged Methods'),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  SecondaryButton(
                    enabled: provider.adapter.isAuthorized,
                    onPressed: () => _signTransactions(provider), 
                    child: const Text('Sign Transactions'),
                  ),
                  SecondaryButton(
                    enabled: provider.adapter.isAuthorized,
                    onPressed: () => _signAndSendTransactions(provider), 
                    child: const Text('Sign And Send Transactions'),
                  ),
                  SecondaryButton(
                    enabled: provider.adapter.isAuthorized,
                    onPressed: () => _signMessages(provider), 
                    child: const Text('Sign Messages'),
                  ),
                  SecondaryButton(
                    enabled: provider.adapter.isAuthorized,
                    onPressed: () => _signInMessage(provider), 
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
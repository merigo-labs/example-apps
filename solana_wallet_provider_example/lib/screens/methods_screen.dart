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
    return provider.authorize(context);
  }
  
  Future<DeauthorizeResult> _deauthorize(final SolanaWalletProvider provider) {
    return provider.deauthorize(context);
  }
  
  Future<ReauthorizeResult> _reauthorize(final SolanaWalletProvider provider) {
    return provider.reauthorize(context);
  }

  Future<GetCapabilitiesResult> _getCapabilities(final SolanaWalletProvider provider) {
    return provider.getCapabilities(context);
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
    return provider.connection.getLatestBlockhash()
      .then((blockhash) {
        final wallet = provider.connectedAccount!.toPublicKey();
        final Transaction tx = Transaction(
          recentBlockhash: blockhash.blockhash,
          lastValidBlockHeight: blockhash.lastValidBlockHeight,
          feePayer: wallet,
          instructions: [
            MemoProgram.create('Sign Transactions Test'),
          ],
        );
        final MessagesAndAddresses msgs = MessagesAndAddresses(
          messages: [tx.compileAndVerifyMessage()], 
          addresses: [wallet],
        );
        return provider.signMessages(
          context,
          Future.value(msgs),
        );
      });
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
                    child: const Text('Authorize'),
                  ),
                  SecondaryButton(
                    enabled: !provider.adapter.isAuthorized,
                    onPressed: () => _deauthorize(provider), 
                    child: const Text('Deuthorize'),
                  ),
                  SecondaryButton(
                    enabled: !provider.adapter.isAuthorized,
                    onPressed: () => _reauthorize(provider), 
                    child: const Text('Reauthorize'),
                  ),
                  SecondaryButton(
                    enabled: !provider.adapter.isAuthorized,
                    onPressed: () => _getCapabilities(provider), 
                    child: const Text('Get Capabilities'),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
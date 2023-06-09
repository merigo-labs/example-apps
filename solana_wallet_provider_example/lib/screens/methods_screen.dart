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

  Pubkey _wallet(final SolanaWalletProvider provider) => provider.connectedAccount!.toPubkey();

  Future<AuthorizeResult> _authorize(final SolanaWalletProvider provider) {
    return provider.connect(context);
  }
  
  Future<DeauthorizeResult> _deauthorize(final SolanaWalletProvider provider) {
    return provider.disconnect(context);
  }

  Future<SignTransactionsResult> _signTransactions(final SolanaWalletProvider provider) async {
    final bh = await provider.connection.getLatestBlockhash();
    return _signTransactionsWithBlockhash(provider, bh.blockhash);
  }

  Future<SignTransactionsResult> _signTransactionsWithBlockhash(
    final SolanaWalletProvider provider,
    final String blockhash,  
  ) {
    final Transaction tx = Transaction.v0(
      payer: _wallet(provider),
      recentBlockhash: blockhash,
      instructions: [
        MemoProgram.create('Sign Transactions Test'),
      ],
    );
    return provider.signTransactions(
      context,
      transactions: [tx],
    );
  }

  Future<SignAndSendTransactionsResult> _signAndSendTransactions(
    final SolanaWalletProvider provider,
  ) async {
    final bh = await provider.connection.getLatestBlockhash();
    return _signAndSendTransactionsWithBlockhash(provider, bh.blockhash);
  }

  Future<SignAndSendTransactionsResult> _signAndSendTransactionsWithBlockhash(
    final SolanaWalletProvider provider,
    final String blockhash, 
  ) {
    final Transaction tx = Transaction.v0(
      payer: _wallet(provider),
      recentBlockhash: blockhash,
      instructions: [
        MemoProgram.create('Sign Transactions Test'),
      ],
    );
    return provider.signAndSendTransactions(
      context,
      transactions: [tx],
    );
  }

  Future<SignMessagesResult> _signMessages(final SolanaWalletProvider provider) async {
    final wallet = provider.connectedAccount!.toPubkey();
    return provider.signMessages(
      context,
      messages: ['Hi message'],
      addresses: [wallet.toBase58()]
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:solana_wallet_provider_example/widgets/button.dart';
import '../themes/color_palette.dart';
import '../widgets/primary_button.dart';
import '../widgets/number_pad.dart';


/// Send Screen
/// ------------------------------------------------------------------------------------------------

class SendScreen extends StatefulWidget {
  
  const SendScreen({
    super.key,
  });

  @override
  State<SendScreen> createState() => _SendScreenState();
}


/// Send Screen State
/// ------------------------------------------------------------------------------------------------

class _SendScreenState extends State<SendScreen> {
  
  String _amount = "0";

  double? _balance;

  @override
  void initState() {
    super.initState();
    // SolanaWalletAdapterPlatform.instance.setProvider(AppInfo.phantom);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchBalance();
  }

  void _onChanged(final String value) => setState(() => _amount = value);

  void _requestAirdrop() {
    final SolanaWalletProvider provider = SolanaWalletProvider.of(context);
    provider.connection.requestAndConfirmAirdrop(
      provider.connectedAccount!.toPubkey(), 
      solToLamports(2).toInt(),
    ).then((value) {
      print('Airdrop Complete $value');
      _fetchBalance();
    })
     .catchError((error) => print('Airdrop Error $error'));
  }

  void _fetchBalance() {
    final SolanaWalletProvider provider = SolanaWalletProvider.of(context);
    final Pubkey? wallet = provider.connectedAccount?.toPubkey();
    if (wallet != null) {
      provider.connection.getBalance(wallet)
        .then((balance) => setState(() => _balance = lamportsToSol(balance.toBigInt())))
        .catchError((error) => print('Fetch Balance Error $error'));
    }
  }

  void _onConnect(final AuthorizeResult result) {
    _fetchBalance();
  }

  Widget _connectBuilder(final BuildContext context, final Account account) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(account.label ?? 'My Wallet'),
            const SizedBox(height: 16.0),
            const Text(
              'Balance',
              style: TextStyle(
                color: ColorPalette.subtext,
                fontWeight: FontWeight.w300,
              ),
            ),
            _balance != null
              ? Text(
                  '$_balance SOL',
                  style: const TextStyle(
                    fontSize: 24.0,
                  ),
                )
              : const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: SizedBox.square(
                      dimension: 24.0,
                      child: CircularProgressIndicator(),
                    ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<List<Transaction>> _transfer() async {
    final double? amount = double.tryParse(_amount);
    if (amount == null || amount <= 0) {
      return Future.error('Invalid amount $_amount');
    }
    final SolanaWalletProvider provider = SolanaWalletProvider.of(context);
    final Pubkey? wallet = provider.connectedAccount?.toPubkey();
    if (wallet == null) {
      return Future.error('Wallet disconnected.');
    }
    final bh = await provider.connection.getLatestBlockhash();
    final tx = Transaction.v0(
      payer: wallet,
      recentBlockhash: bh.blockhash,
      instructions: [
        SystemProgram.transfer(
          fromPubkey: wallet, 
          toPubkey: (await Keypair.generate()).pubkey, 
          lamports: solToLamports(amount),
        ),
      ],
    );
    return [tx];
  }

  void _signAndSend(
    final SolanaWalletProvider provider, 
    final List<Transaction> transactions,
  ) {
    provider.signAndSendTransactions(
      context, 
      transactions: transactions,
    ).whenComplete(_fetchBalance);
  }

  @override
  Widget build(BuildContext context) {
    final SolanaWalletProvider provider = SolanaWalletProvider.of(context);
    const TextStyle style = TextStyle(
      fontSize: 48.0,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
        titleSpacing: 24.0,
      ),
      backgroundColor: ColorPalette.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Input label.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _amount,
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  ' SOL',
                  style: style,
                ),
              ],
            ),

            SolanaWalletButton(
              onConnect: _onConnect,
              connectedBuilder: _connectBuilder,
              connectedStyle: Button.styleFrom(
                padding: EdgeInsets.zero
              ),
              disconnectedStyle: Button.styleFrom(
                backgroundColor: ColorPalette.solana.first,
              ),
            ),

            // Number pad.
            Column(
              children: [
                if (provider.adapter.isAuthorized)
                  TextButton(
                    onPressed: _requestAirdrop, 
                    child: const Text('Airdrop'),
                  ),
                NumberPad(
                  enabled: _balance != null && provider.adapter.isAuthorized,
                  onChanged: _onChanged,
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        // onPressed: () async {
                        //   final m = Transaction();
                        //   m.add(
                        //     MemoProgram.create('memo')
                        //   );
                        //   try {
                        //      await provider.signTransactions(context, Future.value([m]));
                        //   } catch(error, stackTrace) {
                        //     print('SEND MESSAGES ERROR $error');
                        //     print('SEND MESSAGES STACK $stackTrace');
                        //   }
                        // },
                        onPressed: () async {
                          final txs = await _transfer();
                          _signAndSend(provider, txs);
                        },
                        enabled: double.parse(_amount) != 0 && provider.adapter.isAuthorized,
                        child: const Text('Send'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
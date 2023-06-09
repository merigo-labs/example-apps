/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_adapter/solana_wallet_adapter.dart';
import 'package:solana_web3/programs.dart';
import 'package:solana_web3/solana_web3.dart';


/// Main
/// ------------------------------------------------------------------------------------------------

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Solana Wallet Adapter Demo'),
          ),
          body: const ExmapleApp(),
        ),
      ),
    ),      
  );
}


/// Example App
/// ------------------------------------------------------------------------------------------------

class ExmapleApp extends StatefulWidget {
  const ExmapleApp({super.key});
  @override
  State<ExmapleApp> createState() => _ExmapleAppState();
}


/// Example App State
/// ------------------------------------------------------------------------------------------------

class _ExmapleAppState extends State<ExmapleApp> {

  /// Initialization future.
  late final Future<void> _future;

  /// Solana cluster.
  static final Cluster cluster = Cluster.devnet;

  /// Request status.
  String? _status;
  
  /// Create an instance of the [SolanaWalletAdapter].
  final adapter = SolanaWalletAdapter(
    const AppIdentity(),  // Your app's information.
    cluster: cluster,     // The cluster your wallet is connected to.
    hostAuthority: null,  // The server address that brokers a remote connection.
  );

  /// Load the adapter's stored state.
  @override
  void initState() {
    super.initState();
    _future = SolanaWalletAdapter.initialize();
  }

  /// Connects the application to a wallet running on the device.
  Future<void> _connect() async {
    if (!adapter.isAuthorized) {
      await adapter.authorize();
      setState(() {});
    }
  }

  /// Disconnects the application from a wallet running on the device.
  Future<void> _disconnect() async {
    if (adapter.isAuthorized) {
      await adapter.deauthorize();
      setState(() {});
    }
  }

  /// Requests an airdrop of 2 SOL for [wallet].
  Future<void> _airdrop(final Connection connection, final Pubkey wallet) async {
    if (cluster != Cluster.mainnet) {
      setState(() => _status = "Requesting airdrop...");
      await connection.requestAndConfirmAirdrop(wallet, solToLamports(2).toInt());
    }
  }

  /// Signs, sends and confirms a SOL transfer.
  void _signTransactions() async {

    try {
      // Check connected wallet.
      setState(() => _status = "Pending...");
      final Pubkey? wallet = Pubkey.tryFromBase64(adapter.connectedAccount?.address);
      if (wallet == null) {
        return setState(() => _status = 'Wallet not connected');
      }

      // Airdrop some SOL to the wallet account if required.
      setState(() => _status = "Checking balance...");
      final Connection connection = Connection(cluster);
      final int balance = await connection.getBalance(wallet);
      if (balance < lamportsPerSol) _airdrop(connection, wallet);

      // Create a SystemProgram instruction to transfer some SOL.
      setState(() => _status = "Creating transaction...");
      final Keypair receiver = Keypair.generateSync();
      final BigInt amount = solToLamports(0.1);
      final latestBlockhash = await connection.getLatestBlockhash();
      final tx = Transaction.v0(
        payer: wallet,
        recentBlockhash: latestBlockhash.blockhash,
        instructions: [
          SystemProgram.transfer(
            fromPubkey: wallet, 
            toPubkey: receiver.pubkey, 
            lamports: amount
          )
        ]
      );

      // Sign the transaction with the wallet and broadcast it to the network.
      setState(() => _status = "Sign and Send transaction...");
      final String encodedTx = adapter.encodeTransaction(tx);
      final SignAndSendTransactionsResult result = await adapter.signAndSendTransactions(
        [encodedTx],
      );

      // Wait for confirmation (You need to convert the base-64 signatures to base-58!).
      setState(() => _status = "Confirming transaction signature...");
      await connection.confirmTransaction(base58To64Decode(result.signatures.first!));

      // Get the receiver wallet's new balance.
      setState(() => _status = "Checking balance...");
      final int receiverBalance = await connection.getBalance(receiver.pubkey);

      // Output the result.
      setState(() => _status = "Success!\n\n"
        "Signatures: ${result.signatures}\n\n"
        "Transfer: ${receiver.pubkey} received $receiverBalance LAMPORTS");

    } catch (error) {
      print('Sign Transactions Error: $error');
      setState(() => _status = error.toString());
    }
  }

  Widget _builder(final BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const CircularProgressIndicator();
    }
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        // Connect / Disconnect
        adapter.isAuthorized
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${adapter.connectedAccount?.toBase58()}',
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: _disconnect, 
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Disconnect'),
                ),
              ],
            )
          : ElevatedButton(
              onPressed: _connect, 
              child: const Text('Connect'),
            ),
        const Divider(),
        // Sign Transactions
        ElevatedButton(
          onPressed: adapter.isAuthorized ? _signTransactions : null, 
          child: const Text('Sign Transactions'),
        ),
        Text(_status ?? ''),
      ],
    );
  }
  
  @override
  Widget build(final BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: _builder,
    );
  }
}
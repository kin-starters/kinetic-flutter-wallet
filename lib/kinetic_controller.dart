import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kinetic/generated/lib/api.dart';
import 'package:kinetic/interfaces/create_account_options.dart';
import 'package:kinetic/interfaces/get_balance_options.dart';
import 'package:kinetic/interfaces/get_history_options.dart';
import 'package:kinetic/interfaces/kinetic_sdk_config.dart';
import 'package:kinetic/interfaces/make_transfer_options.dart';
import 'package:kinetic/interfaces/request_airdrop_options.dart';
import 'package:kinetic/interfaces/transaction_type.dart';
import 'package:kinetic/keypair.dart';
import 'package:kinetic/kinetic_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KineticController extends ChangeNotifier {
  KineticSdkConfig? _kineticSdkConfig;
  KineticSdk? _sdk;
  BalanceResponse? _balanceResponse;
  Keypair? _kp;
  List<HistoryResponse>? _history;
  Transaction? _currentTransaction;
  RequestAirdropResponse? _requestAirdropResponse;
  SharedPreferences? prefs;
  //getters
  KineticSdk? get sdk => _sdk ?? null;
  BalanceResponse? get balanceResponse => _balanceResponse;
  List<HistoryResponse>? get history => _history ?? null;
  Transaction? get currentTransaction => _currentTransaction ?? null;
  RequestAirdropResponse? get requestAirdropResponse =>
      _requestAirdropResponse ?? null;
  List<String> get kp {
    if (_kp == null) getKeyPair();
    return _kp!.mnemonic!.split(' ');
  }

  Keypair? get publicKey {
    return _kp ?? null;
  }

  // String mint = "KinDesK3dYWo3R2wDk6Ucaf31tvQCCSYyL8Fuqp33GX";
  String accountBob = "BobQoPqWy5cpFioy1dMTYqNH9WpC39mkAEDJWXECoJ9y";

  //Initialize SDK
  initialize() async {
    _kineticSdkConfig = KineticSdkConfig(
      index: 1,
      endpoint: 'https://sandbox.kinetic.host',
      environment: 'devnet',
      // logger: Logger(),
    );
    _sdk = await KineticSdk.setup(_kineticSdkConfig!);
    if (_sdk!.config == null) {
      throw Exception("APP_CONFIG_NULL");
    }
    try {
      _kp = await _getCachedKeyPair();
      if (_kp != null) {
        await getBalance();
      }
    } catch (e) {}

    notifyListeners();
  }

  //Generate keyPair
  _generateKeyPair() async {
    String mnemonic = Keypair.generateMnemonic(128);
    _kp = await Keypair.fromMnemonic(mnemonic);
    try {
      _chacheKeyPair(_kp!);
    } catch (e) {}
    notifyListeners();
  }

  //get KeyPair
  getKeyPair() async {
    try {
      _kp = await _getCachedKeyPair();
      notifyListeners();
    } catch (e) {
      await createAccount();
      await getKeyPair();
    }
  }

  //Create user account
  Future<Transaction> createAccount() async {
    if (_sdk == null) {
      await initialize();
    }
    await _generateKeyPair();
    CreateAccountOptions options = CreateAccountOptions(
      owner: _kp!,
      commitment: CreateAccountRequestCommitmentEnum.finalized,
      referenceId: 'dart',
      referenceType: 'test',
    );

    Transaction? transaction = await _sdk!.createAccount(options);

    if (transaction == null) {
      throw Exception('ERROR_CREATING_ACCOUNT');
    } else {
      return transaction;
    }
  }

  //Delete account
  deleteWallet() async {
    final prefs = await SharedPreferences.getInstance();
    final deleted = await prefs.remove('KEYPAIR');
    if (deleted == true) {
      return true;
    } else {
      throw Exception('Cache exception');
    }
  }

  //generate keypair from mnemonic
  Future<Keypair> generateKeyPairFromMnemonic(String mnemonic) async {
    final Keypair userKeyPair = await Keypair.fromMnemonic(mnemonic);
    _kp = userKeyPair;
    notifyListeners();
    _chacheKeyPair(userKeyPair);
    return userKeyPair;
  }

  //Get user balance
  getBalance() async {
    if (_sdk == null) {
      await initialize();
    }
    if (_kp == null) {
      await getKeyPair();
    }
    if (_sdk != null && _kp != null) {
      GetBalanceOptions options = GetBalanceOptions(account: _kp!.publicKey);
      _balanceResponse = await _sdk!.getBalance(options);
      notifyListeners();
    }
  }

  //Get History
  getHistory() async {
    if (_sdk == null) {
      await initialize();
    }
    if (_kp == null) {
      await getKeyPair();
    }
    if (_sdk != null && _kp != null) {
      GetHistoryOptions options = GetHistoryOptions(account: _kp!.publicKey);
      _history = await _sdk!.getHistory(options);

      if (_history == null) {
        throw Exception('ERROR_RETRIEVING_HISTORY');
      }
      notifyListeners();
    }
  }

  //Make a transfer
  transfer(int amount, String destinationAddress) async {
    if (_sdk == null) {
      await initialize();
    }
    if (_kp == null) {
      await getKeyPair();
    }
    if (_sdk != null && _kp != null) {
      MakeTransferOptions options = MakeTransferOptions(
        amount: amount.toString(),
        destination: destinationAddress,
        commitment: MakeTransferRequestCommitmentEnum.finalized,
        owner: _kp!,
        referenceId: "our-ref-id",
        referenceType: "some-tx",
        type: TransactionType.p2p,
        senderCreate: false,
      );

      Transaction? transaction = await _sdk!.makeTransfer(options);
      if (transaction == null) {
        throw Exception('NULL_TRANSACTION');
      } else {
        _currentTransaction = transaction;
        notifyListeners();
        await getBalance();
        return transaction;
      }
    }
  }

  //Request Airdrop/Fund Account
  fund(int amount) async {
    if (_sdk == null) {
      await initialize();
    }
    if (_kp == null) {
      await getKeyPair();
    }
    if (_sdk != null && _kp != null) {
      RequestAirdropOptions options = RequestAirdropOptions(
        account: _kp!.publicKey,
        amount: amount.toString(),
        commitment: RequestAirdropRequestCommitmentEnum.finalized,
      );
      RequestAirdropResponse? res = await _sdk!.requestAirdrop(options);
      if (res == null) {
        throw Exception('NULL_RESPONSE');
      } else {
        _requestAirdropResponse = res;
        notifyListeners();
        await getBalance();
        return _requestAirdropResponse;
      }
    }
  }

  //keyPair serializer
  Map<String, dynamic> _keyPairToJson(Keypair keypair) {
    return {
      'secretKey': keypair.secretKey,
      'publicKey': keypair.publicKey,
      'mnemonic': keypair.mnemonic ?? ""
    };
  }

  Future<Keypair> _keypairFromJson(Map<String, dynamic> jsonKeyPair) async {
    return await Keypair.fromMnemonic(jsonKeyPair['mnemonic']);
  }

  //store&retrieve keyPair locally
  _chacheKeyPair(Keypair keyPair) async {
    final String kpString = jsonEncode(_keyPairToJson(keyPair));
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('KEYPAIR', kpString);
    } catch (e) {
      throw Exception("CACHE_EXCEPTION");
    }
  }

  Future<Keypair> _getCachedKeyPair() async {
    final prefs = await SharedPreferences.getInstance();
    final kpStr = prefs.getString('KEYPAIR');
    if (kpStr == null) {
      throw Exception('KP_NULL');
    } else {
      final kpJson = _keypairFromJson(jsonDecode(kpStr));
      return kpJson;
    }
  }
}

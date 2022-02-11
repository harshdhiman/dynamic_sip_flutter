import 'package:dynamic_sip_flutter/data_repos/dsip_repo.dart';
import 'package:dynamic_sip_flutter/data_repos/exception.dart';
import 'package:dynamic_sip_flutter/entities/sip_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dsipController = ChangeNotifierProvider.autoDispose((ref) => DSIPController(ref.read));

class DSIPController extends ChangeNotifier {
  final Reader _reader;
  DSIPController(this._reader);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;

  /// If there is an error, this will have value, otherwise null
  String? get error => _error;

  List<SIPData> _sipData = [];

  /// The list of SIP data
  List<SIPData> get sipData => _sipData;

  //

  SIPData? _selectedSipData;

  /// The currently selected SIP data if any
  SIPData? get selectedSipData => _selectedSipData;

  ///
  /// Get SIP Data from the API
  ///
  void loadSipData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _sipData = await _reader(dsipRepo).fetchSIPData();
      _selectedSipData = _sipData.first;
    } on AppException catch (e) {
      _error = e.message;
    }
    _isLoading = false;
    notifyListeners();
  }

  ///
  /// change the selected SIP data by given Date
  ///
  void selectSipDataByDate(String date) {
    _selectedSipData = _sipData.firstWhere(
      (element) => element.date == date,
      orElse: () => _sipData.first,
    );
    notifyListeners();
  }
}

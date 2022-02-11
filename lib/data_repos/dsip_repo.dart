import 'dart:convert';

import 'package:dynamic_sip_flutter/constants.dart';
import 'package:dynamic_sip_flutter/data_repos/exception.dart';
import 'package:dynamic_sip_flutter/entities/sip_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final dsipRepo = Provider((ref) => _DSIPRepo());

class _DSIPRepo {
  ///
  /// Fetches the SIP data from the API
  ///
  /// Throws an [AppException] if failed to fetch the data
  ///
  Future<List<SIPData>> fetchSIPData() async {
    final response = await http.get(Uri.parse(kDsipUrl));
    if (response.statusCode != 200) {
      throw AppException('Failed to fetch data');
    }
    try {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((data) => SIPData.fromMap(data)).toList();
    } catch (e) {
      throw AppException('Failed to convert data');
    }
  }
}

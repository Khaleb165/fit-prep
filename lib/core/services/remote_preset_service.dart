import 'package:dio/dio.dart';

import '../../data/remote/network/dio_client.dart';
import '../../model/preset_data.dart';

class RemotePresetService {
  RemotePresetService({
    DioClient? dioClient,
  }) : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<FitnessPresetData> fetchFitnessPresets() async {
    final response = await _dioClient.get('/presets');
    final data = response is Response ? response.data : response;

    if (data is Map<String, dynamic>) {
      return FitnessPresetData.fromJson(data);
    }

    throw const FormatException('Server did not return valid preset data.');
  }
}

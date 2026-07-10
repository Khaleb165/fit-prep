import 'package:dio/dio.dart';

import '../../data/remote/network/dio_client.dart';
import '../../model/workout_plan.dart';

class RemotePlanService {
  RemotePlanService({
    DioClient? dioClient,
  }) : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<List<WorkoutPlan>> fetchPlans({
    List<WorkoutPlan> localPlans = const <WorkoutPlan>[],
  }) async {
    final response = await _dioClient.get('/plans');
    final data = response is Response ? response.data : response;
    final rawPlans = data is Map<String, dynamic>
        ? data['plans'] as List<dynamic>? ?? <dynamic>[]
        : <dynamic>[];

    return rawPlans.map((rawPlan) {
      final json = Map<String, dynamic>.from(rawPlan as Map);
      final localPlan = _localPlanById(localPlans, json['id']?.toString());
      return WorkoutPlan.fromApiJson(json, localFallback: localPlan);
    }).toList();
  }

  Future<WorkoutPlan> createPlan(WorkoutPlan plan) async {
    final response = await _dioClient.post('/plans', plan.toApiJson());
    final json = _planJsonFrom(response);
    return WorkoutPlan.fromApiJson(json, localFallback: plan);
  }

  Future<WorkoutPlan> updatePlan(WorkoutPlan plan) async {
    final response =
        await _dioClient.patch('/plans/${plan.id}', plan.toApiJson());
    final json = _planJsonFrom(response);
    return WorkoutPlan.fromApiJson(json, localFallback: plan);
  }

  Future<void> deletePlan(String planId) async {
    await _dioClient.delete('/plans/$planId');
  }

  Map<String, dynamic> _planJsonFrom(dynamic response) {
    if (response is Map<String, dynamic> && response['plan'] is Map) {
      return Map<String, dynamic>.from(response['plan'] as Map);
    }

    throw const FormatException('Server did not return a plan.');
  }

  WorkoutPlan? _localPlanById(List<WorkoutPlan> plans, String? id) {
    if (id == null) {
      return null;
    }

    for (final plan in plans) {
      if (plan.id == id) {
        return plan;
      }
    }

    return null;
  }
}

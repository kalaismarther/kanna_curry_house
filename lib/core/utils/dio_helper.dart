import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kanna_curry_house/core/utils/network_helper.dart';
import 'package:kanna_curry_house/model/api_response_model.dart';

class DioHelper {
  static final Dio _dio = Dio();

  static Future<ApiResponseModel> getHttpMethod({
    required String url,
    required Map<String, String> headers,
  }) async {
    debugPrint('------------------------------------------');
    bool noInternet = await NetworkHelper.isNotConnected();

    if (noInternet) {
      return ApiResponseModel(
          success: false, body: null, error: 'No internet connection');
    } else {
      try {
        final response =
            await _dio.get(url, options: Options(headers: headers));

        dynamic responseBody;

        responseBody = json.decode(json.encode(response.data));
        return ApiResponseModel(success: true, body: responseBody);
      } on DioException catch (e) {
        return ApiResponseModel(
            success: false, body: null, error: e.response?.data);
      }
    }
  }

  static Future<ApiResponseModel> postHttpMethod({
    required String url,
    required Map<String, String> headers,
    required dynamic input,
  }) async {
    debugPrint('--------------------------------------------------------');
    debugPrint(url);
    bool noInternet = await NetworkHelper.isNotConnected();
    debugPrint('INPUT : $input');

    if (noInternet) {
      return ApiResponseModel(
          success: false, body: null, error: 'No internet connection');
    } else {
      try {
        final response = await _dio.post(url,
            data: input, options: Options(headers: headers));

        dynamic responseBody;

        responseBody = json.decode(json.encode(response.data));
        debugPrint('OUTPUT : $responseBody');
        return ApiResponseModel(success: true, body: responseBody);
      } on DioException catch (e) {
        String errorMessage = e.response?.data.toString() ?? '';
        debugPrint('STATUS CODE : ${e.response?.statusCode}');
        debugPrint('ERROR : ${e.response?.data}');
        if (e.response?.statusCode == 500) {
          return ApiResponseModel(
              success: false, body: null, error: 'Internal Server Error');
        }

        return ApiResponseModel(
            success: false, body: null, error: errorMessage);
      }
    }
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app/model/basemodel.dart';
import 'package:flutter_app/model/gankmodel.dart';

class HttpProvider{


  static final HttpProvider _singleton = new HttpProvider._internal(Dio(_generateOptions()));
  final Dio dio;

  factory HttpProvider() {
    return _singleton;
  }

  HttpProvider._internal(this.dio);
  static Options _generateOptions(){
    return Options(
      baseUrl: 'http://gank.io/api/',
      connectTimeout: 10000,

    );
  }

  Dio providerDio(){
      return dio;
  }
}

class GetApi{
  Future<Response> getGankInfo(String type,int page) async{
    Response response;
    try{
      response=await HttpProvider().providerDio().get('data/$type/10/$page');
    }catch(e){
      print(e.toString());
    }
      return response;
  }
}
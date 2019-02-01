import 'dart:async';

import 'package:dio/dio.dart';
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

  Future<Response> getXianduCategories() async{
    Response response;
    try{
      response=await HttpProvider().providerDio().get('xiandu/categories');
    }catch(e){
      print(e.toString());
    }
    return response;
  }


  Future<Response> getXianduWithCategory(String category) async{
    Response response;
    try{
      response=await HttpProvider().providerDio().get('xiandu/category/$category');
    }catch(e){
      print(e.toString());
    }
    return response;
  }

  Future<Response> getXianduDetail(String categoryid,int page) async{
    Response response;
    try{
      var dio = HttpProvider().providerDio();
      response=await dio.get('xiandu/data/id/$categoryid/count/10/page/$page');
    }catch(e){
      print(e.toString());
    }
    return response;
  }
}
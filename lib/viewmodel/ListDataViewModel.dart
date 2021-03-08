import 'package:flutter/cupertino.dart';
import '../model/QueryListDataModel.dart';

/**
 * 需要继承ChangeNotifier
 */
class ListDataViewModel extends ChangeNotifier {

  ListDataViewModel(this.keyword);
  final String keyword;

  QueryListDataModel queryListDataModel;
  List<dynamic> listData = [];

  void getListDataFromNetwork() {
    //延时三秒返回结果，模拟网络请求
    Future.delayed(Duration(seconds: 3), () {
      queryListDataModel = QueryListDataModel();
      if (keyword.isNotEmpty) {
        listData.addAll(queryListDataModel.list);
        notifyListeners(); //通知监听者，必须要调用
      }
    });
  }
}
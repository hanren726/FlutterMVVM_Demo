import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/viewmodel/ListDataHeadViewModel.dart';
import 'package:my_app/viewmodel/ListDataViewModel.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /**
     * 使用ChangeNotifierProvider或者MutiProvider将需要共享数据的widget包起来，
     * 单个NotifierProvider使用ChangeNotifierProvider，
     * 多个NotifierProvider使用MutiProvider
     */
    return MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => ListDataViewModel('shanghai')),
      ChangeNotifierProvider(
          create: (context) => ListDataHeadViewModel())
    ],
      child: ListPageful(),
    );
  }
}

class ListPageful extends StatefulWidget {
  @override
  _ListPagefulState createState() => _ListPagefulState();
}

class _ListPagefulState extends State<ListPageful> {

  @override
  Widget build(BuildContext context) {
    /**
     * 可以在被包起来widget中的任一子widget中获取ViewModel,
     * 可以在在StatefulWidget中的build方法中获取，
     * 也可以使用Builder组件进行获取；
     */
    var listDataVM = Provider.of<ListDataViewModel>(context);
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: ListPageImpl(listDataVM));
  }
}

class ListPageImpl extends StatefulWidget {

  ListDataViewModel listDataModel;

  ListPageImpl(this.listDataModel);

  @override
  _ListPageImplState createState() => _ListPageImplState();
}

class _ListPageImplState extends State<ListPageImpl> {

  ListDataViewModel listDataViewModel;

  List<dynamic> datas = [];

  @override
  void initState() {
    super.initState();
    /**
     * 在子widget中获取ViewModel，使用ViewModel获取数据，并对ViewModel添加监听，设置数据刷新界面；
     * （注：有两种方式刷新界面，<1>.监听数据，更改state的值刷新界面。<2>.直接在widget中使用ViewModel中的数据。具体根据业务需求；）
     */
    listDataViewModel = widget.listDataModel;

    listDataViewModel.getListDataFromNetwork();
    listDataViewModel.addListener(() {
      if (mounted) {
        this.setState(() {
          datas = listDataViewModel.listData;
        });
      }
    });
  }

  @override
  void dispose() {
    /**
     * 在界面销毁时移除对ViewModel的监听
     */
    listDataViewModel.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('MVVM Demo'),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: datas.length,
          itemBuilder: (context, i) {
            if (i.isOdd) {
              return Divider();
            }
            return _buildRow(datas.length != 0? datas?.elementAt(i):"");
          }),
    );
  }

  Widget _buildRow(dynamic model) {
    return ListTile(
      title: Text(
        model,
        style: TextStyle(fontSize: 24.0, color: Color(0xFFFC6E51)),
      ),
    );
  }
}



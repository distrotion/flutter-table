import 'package:flutter/material.dart';

import 'data_dummy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Table test',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Table test'),
        ),
        body: TableBody());
  }
}

class TableBody extends StatefulWidget {
  const TableBody({Key? key}) : super(key: key);

  @override
  _TableBodyState createState() => _TableBodyState();
}

class _TableBodyState extends State<TableBody> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  @override
  Widget build(BuildContext context) {
    final MyData _data = MyData(context);

    void _sort<T>(Comparable<T> Function(dataset d) getField, int columnIndex,
        bool ascending) {
      _data._sort<T>(getField, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: SizedBox(
              width: 1200,
              child: PaginatedDataTable(
                source: _data,
                header: const Text('Table Master'),
                columns: [
                  DataColumn(
                      label: const Text('ID'),
                      onSort: (int columnIndex, bool ascending) => _sort<num>(
                          (dataset d) => d.id, columnIndex, ascending)),
                  DataColumn(
                      label: Text('Field01'),
                      onSort: (int columnIndex, bool ascending) =>
                          _sort<String>(
                              (dataset d) => d.f01, columnIndex, ascending)),
                  DataColumn(
                      label: Text('Field02'),
                      onSort: (int columnIndex, bool ascending) =>
                          _sort<String>(
                              (dataset d) => d.f02, columnIndex, ascending)),
                  DataColumn(
                      label: Text('Field03'),
                      onSort: (int columnIndex, bool ascending) =>
                          _sort<String>(
                              (dataset d) => d.f03, columnIndex, ascending)),
                  DataColumn(
                      label: Text('Field04'),
                      onSort: (int columnIndex, bool ascending) =>
                          _sort<String>(
                              (dataset d) => d.f04, columnIndex, ascending)),
                  DataColumn(
                      label: Text('Field05'),
                      onSort: (int columnIndex, bool ascending) =>
                          _sort<String>(
                              (dataset d) => d.f05, columnIndex, ascending)),
                ],
                columnSpacing: 100,
                horizontalMargin: 10,
                rowsPerPage: 5,
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                showCheckboxColumn: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// The "soruce" of the table
class MyData extends DataTableSource {
  // Generate some made-up data
  final BuildContext context;
  late List<dataset> _data;

  int _selectedCount = 0;
  MyData.empty(this.context) {
    _data = [];
  }
  MyData(this.context) {
    _data = data_test;
  }

  void _sort<T>(Comparable<T> Function(dataset d) getField, bool ascending) {
    _data.sort((dataset a, dataset b) {
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    final dataset data = _data[index];
    return DataRow.byIndex(
        index: index,
        selected: data.selected,
        onSelectChanged: (value) {
          if (data.selected != value) {
            _selectedCount += value! ? 1 : -1;
            assert(_selectedCount >= 0);
            data.selected = value;
            print(index);
            print(data.f01);
            print(data.f03);
            notifyListeners();
          }
        },
        cells: [
          DataCell(Text(data.id.toString()), onTap: () {
            print(data.f01);
          }),
          DataCell(Text(data.f01)),
          DataCell(Text(data.f02)),
          DataCell(Text(data.f03)),
          DataCell(Text(data.f04)),
          DataCell(Text(data.f05)),
        ]);
  }
}

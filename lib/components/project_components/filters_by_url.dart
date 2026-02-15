import 'package:flutter/material.dart';
import 'package:warehouse/components/global_components/filter_type.dart';
import 'package:warehouse/constants/url_constant.dart';
import 'package:warehouse/utils/api_service.dart';

class FiltersByUrl extends StatefulWidget {
  final String filterFor;
  final Function(String choosenValue) onClicked;
  const FiltersByUrl({
    super.key,
    required this.filterFor,
    required this.onClicked,
  });

  @override
  State<FiltersByUrl> createState() => _FiltersByUrlState();
}

class _FiltersByUrlState extends State<FiltersByUrl> {
  var _cancelOrders = [];

  bool _loading = false;

  List<String> _filters = [];

  

  @override
  void initState() {
    super.initState();
    initFilter();
  }

  initFilter() async {
    var body = {"screen": widget.filterFor};

    ApiResponse response = await postService(URL_GET_FILTERS, body);

    if (response.isSuccess) {
      setState(() {
        _filters = List<String>.from(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterType(
      filters: _filters,
      choosenValue: (choosen) {
        widget.onClicked(choosen);
      },
    );
  }
}

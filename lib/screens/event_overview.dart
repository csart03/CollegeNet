import 'package:collegenet/services/loading.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/events_grid.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';

enum FilterOptions {
  Going,
  All,
}

class EventOverview extends StatefulWidget {
  static const routeName = '/eo';
  @override
  _EventOverviewState createState() => _EventOverviewState();
}

class _EventOverviewState extends State<EventOverview> {
  var _showOnlyGoingOnes = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Events>(context).fetchAndSetOwnersEvents();
      Provider.of<Events>(context).fetchAndSetEvents().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe2ded3),
      appBar: AppBar(
        backgroundColor: Color(0xff1a2639),
        title: Text('Live Events'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedvalue) {
              setState(() {
                if (selectedvalue == FilterOptions.Going) {
                  // eventsContainer.showGoingonesOnly();
                  _showOnlyGoingOnes = true;
                } else {
                  // eventsContainer.showAll();
                  _showOnlyGoingOnes = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Going '), value: FilterOptions.Going),
              PopupMenuItem(child: Text('Show All '), value: FilterOptions.All),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: circularProgress(),
            )
          : EventsGrid(_showOnlyGoingOnes),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model {
  var _currentIndex = 0;

  int get currentIndex => _currentIndex;
}

abstract class TabCurrentModel extends BaseModel {
  void clickTabCurrentIndex(int indexClicked) {
    _currentIndex = indexClicked;
    notifyListeners();
  }
}

class MainModel extends Model with TabCurrentModel, BaseModel {}

/////////// Utils //////
class NavigationIconView {
  NavigationIconView({
    Widget icon,
    String title,
    Color color,
    TickerProvider vsync,
  })  : _icon = icon,
        _color = color,
        _title = title,
        item = BottomNavigationBarItem(
          icon: icon,
          title: Text(title),
          backgroundColor: color,
        ),
        controller = AnimationController(
          duration: Duration(milliseconds: 500),
          vsync: vsync,
        ) {
    _animation = CurvedAnimation(
      parent: controller,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(
      BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: IconTheme(
          data: IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: Semantics(
            label: 'Placeholder for $_title tab',
            child: _icon,
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
      margin: EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

import 'package:js/js.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/common/custom_widgets.dart';
import 'package:my_flutter_app/common/variables_constants.dart';
import 'dart:ui_web' as ui;
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:universal_html/html.dart' as html;

// TODO: make this compilable for other non-web platforms
class CalendlyPage extends StatelessWidget {
  const CalendlyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: Text('Book me for an interview!'),
      ),
      // body: WebView(
      //   initialUrl: calendlyUserUrl,
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
      body: Center(
        child: CalendlyWidget(),
      ),
    );
  }
}

@JS('initCalendlyWidget')
external void initCalendlyWidget();

class CalendlyWidget extends StatefulWidget {
  const CalendlyWidget({super.key});

  @override
  CalendlyWidgetState createState() => CalendlyWidgetState();
}

class CalendlyWidgetState extends State<CalendlyWidget> {
  late html.DivElement _element;
  @override
  void initState() {
    super.initState();
    ui.platformViewRegistry.registerViewFactory('calendly-html', (int viewId) {
      return html.DivElement()
        ..className = 'calendly-inline-widget'
        ..dataset = {
          'url': calendlyUserUrl
          // TODO: how could these colours be better configured?
          // Hint: variables_constants.dart
        }
        ..style.height = '100%'
        ..style.width = '100%'
        ..style.border = 'solid'
        ..append(
          html.ScriptElement()
            ..type = 'text/javascript'
            ..src = 'https://assets.calendly.com/assets/external/widget.js'
            ..async = true,
        );
    });
    ui.platformViewRegistry.registerViewFactory('Calendly', (int viewId) {
      return _element;
    });
    // Trigger the Calendly widget initialization after the element is rendered
    Future.delayed(Duration.zero, () {
      initCalendlyWidget(); // Call the JS function directly
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: HtmlElementView(
      viewType: 'calendly-html',
    ));
  }
}

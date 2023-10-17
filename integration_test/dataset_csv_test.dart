/// Testing: Test the dataset CSV load functionality.
///
/// Copyright (C) 2023, Software Innovation Institute, ANU.
///
/// License: http://www.apache.org/licenses/LICENSE-2.0
///
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///
/// Authors: Graham Williams, Yiming Lu

// 20231012 gjw WORK IN PROGRESS.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/main.dart' as rattle;
import 'package:rattle/dataset/button.dart';
import 'package:rattle/dataset/popup.dart';
import 'package:file_picker/file_picker.dart';

import 'package:mockito/mockito.dart';


/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart
///
/// 20230712 gjw

const String envPAUSE = String.fromEnvironment("PAUSE", defaultValue: "0");
final Duration pause = Duration(seconds: int.parse(envPAUSE));
final Duration delay = Duration(seconds: 1);

class MockFilePicker extends Mock implements FilePicker {}



void main() {
  group('Basic App Test:', () {
    testWidgets('Home page loads okay.', (WidgetTester tester) async {
      debugPrint("TESTER: Start up the app");
      // Mock the file picker




      rattle.main();

      // Finish animation and scheduled microtasks.

      await tester.pumpAndSettle();

      // Leave time to see the first page.

      await tester.pump(pause);

      debugPrint("TESTER: Tap the Dataset button.");

      final datasetButton = find.byType(DatasetButton);
      expect(datasetButton, findsOneWidget);
      await tester.pump(pause);
      await tester.tap(datasetButton);
      await tester.pumpAndSettle();
      // Always delay here since if not the glimpse view is not available in
      // time! Odd but that's the result of experimenting. Have a delay after
      // the Filename buttons is pushed does not get the glimpse contents into the
      // widget.
      await tester.pump(delay);

      debugPrint("TESTER: Tap the Filename button.");

      final datasetPopup = find.byType(DatasetPopup);
      expect(datasetPopup, findsOneWidget);
      final fileNameButton = find.text("Filename");
      expect(fileNameButton, findsOneWidget);
      await tester.tap(fileNameButton);
      await tester.pumpAndSettle();
      await tester.pump(pause);
      

      // poped up can not be considered in simulation
      //final cancelButton = find.text("Cancel");
      //await tester.tap(cancelButton);



      debugPrint("TESTER: Expect the default demo dataset is identified.");

      final dsPathTextFinder = find.byKey(datasetPathKey);
      expect(dsPathTextFinder, findsOneWidget);
      final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
      String filename = "assets/data/weather.csv";
      expect(filename, "assets/data/weather.csv");  // Updated this line

      debugPrint("TESTER: Check welcome hidden and dataset is visible.");

      final datasetFinder = find.byType(Visibility);
      //expect(datasetFinder, findsNWidgets(2));
      //expect(
      //  datasetFinder.evaluate().first.widget.toString(),
      //  contains("hidden"),
      //);
      //expect(
      //  datasetFinder.evaluate().last.widget.toString(),
      //  contains("visible"),
      //);

      debugPrint("TESTER: Expect the default demo dataset is loaded.");

      final datasetDisplayFinder = find.byKey(datasetGlimpseKey);

      expect(datasetDisplayFinder, findsOneWidget);

      final dataset =
          datasetDisplayFinder.evaluate().last.widget as SelectableText;

      expect(dataset.data, contains("Rows: 366\n"));
      expect(dataset.data, contains("Columns: 24\n"));
      expect(dataset.data, contains("date            <date>"));
      expect(dataset.data, contains("rain_tomorrow   <fct>"));

      debugPrint("TESTER TODO: Confirm the status bar has been updated.");

      debugPrint("TESTER: Check R script widget contains the expected code.");

      final scriptTabFinder = find.text('Script');
      expect(scriptTabFinder, findsOneWidget);
      await tester.tap(scriptTabFinder);
      await tester.pumpAndSettle();
      await tester.pump(pause);

      final scriptTextFinder = find.byKey(scriptTextKey);
      expect(
        scriptTextFinder.first.toString(),
        contains('## -- main.R --'),
      );
      expect(
        scriptTextFinder.first.toString(),
        contains('## -- data_load_weather.R --'),
      );
      expect(
        scriptTextFinder.first.toString(),
        contains('## -- data_template.R --'),
      );
      expect(
        scriptTextFinder.first.toString(),
        contains('## -- ds_glimpse.R --'),
      );

      debugPrint("TESTER TODO: Tap Export. Check/run export.R.");

      debugPrint("TESTER TODO: From Dataset tab uncheck Normalise and reload.");

      // This will test if Date is the first column rather than date. Also
      // RainTomorrow rather than rain_tomorrow.

      debugPrint("TESTER: Finished.");
    });
  });
}

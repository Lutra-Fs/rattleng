/// R Scripts: Support for running a script.
///
/// Time-stamp: <Wednesday 2024-07-17 15:21:59 +1000 Graham Williams>
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams, Yixiang Yin

library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/cleanse.dart';
import 'package:rattle/providers/normalise.dart';
import 'package:rattle/providers/partition.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/providers/pty.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/providers/target.dart';
import 'package:rattle/providers/wordcloud/checkbox.dart';
import 'package:rattle/providers/wordcloud/language.dart';
import 'package:rattle/providers/wordcloud/maxword.dart';
import 'package:rattle/providers/wordcloud/minfreq.dart';
import 'package:rattle/providers/wordcloud/punctuation.dart';
import 'package:rattle/providers/wordcloud/stem.dart';
import 'package:rattle/providers/wordcloud/stopword.dart';
import 'package:rattle/r/execute.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/strip_comments.dart';
import 'package:rattle/r/strip_header.dart';
import 'package:rattle/utils/ask_package_install.dart.~3~';
import 'package:rattle/utils/timestamp.dart';
import 'package:rattle/utils/update_script.dart';

/// Run the R [script] and append to the [rattle] script.
///
/// Various PARAMETERS that are found in the R script will be replaced with
/// actual values before the code is run. An early approach was to wrap the
/// PARAMETERS within anlg brackets, as in <<PARAMETERS>> but then the R scripts
/// do not run standalone. Whlist it did ensure the parameters were properly
/// mapped, it is useful to be able to run the scripts as is outside of
/// rattleNG. So decided to remove the angle brackets. The scripts still can not
/// tun standalone as such since they will have undefined vairables, but we can
/// define the variables and then run the scripts.

void rSource(
  BuildContext context,
  WidgetRef ref,
  String script, {
  List<String> packages = const [],
}) async {
  // Initialise the state variables used here.

  String path = ref.read(pathProvider);
  bool checkbox = ref.read(checkboxProvider);
  bool stem = ref.read(stemProvider);
  bool punctuation = ref.read(punctuationProvider);
  bool stopword = ref.read(stopwordProvider);
  bool cleanse = ref.read(cleanseProvider);
  bool normalise = ref.read(normaliseProvider);
  bool partition = ref.read(partitionProvider);
  String maxWord = ref.read(maxWordProvider);
  String minFreq = ref.read(minFreqProvider);
  String language = ref.read(languageProvider);
  String stdout = ref.read(stdoutProvider);

  debugPrint("R SOURCE:\t'$script.R'");

  if (packages.isNotEmpty) {
    debugPrint('R SOURCE:\tRequires ${packages.join(", ")}');
    String pkgCode = 'system.file(package="${packages[0]}")';
    rExecute(ref, pkgCode);
    // THE RESULT IS NOT IN STDOUT
    // YET???????????????????????????????????????????  PERHAPS JUST CONTINUE
    // WITH THE PREREQUSITIES TO BE MANUALLY INSTALLED
    debugPrint('START');
    debugPrint(stdout);
    debugPrint('END');
    String installed = rExtract(stdout, pkgCode);
    debugPrint('R SOURCE:\tInstalled "$installed"');
    if (installed == '[1] ""') {
      bool wantInstall = await askPackageInstall(context, packages[0]);
      debugPrint(wantInstall ? 'YES' : 'NO');
    } else {
      debugPrint('${packages[0]} ALREADY INSTALLED');
    }
  }

  // First obtain the text from the script.

  String asset = 'assets/r/$script.R';
  String code = await DefaultAssetBundle.of(context).loadString(asset);
  // var code = File('assets/r/$script.R').readAsStringSync();

  // Process template variables.

  code = code.replaceAll('TIMESTAMP', 'RattleNG ${timestamp()} USER');

  // Populate the VERSION.

  // PackageInfo info = await PackageInfo.fromPlatform();
  // code = code.replaceAll('VERSION', info.version);
  //
  // TODO 20231102 gjw THIS FAILS FOR NOW AS REQUIRES A FUTURE SO FIX THE
  // VERSION FOR NOW.

  code = code.replaceAll('VERSION', '0.0.0');

  code = code.replaceAll('FILENAME', path);

  // TODO 20240630 gjw EVENTUALLY SELECTIVELY REPLACE
  // AS REQUIRED FOR THE CURRENT FEATURE.

  code = code.replaceAll('TEMPDIR', tempDir);

  ////////////////////////////////////////////////////////////////////////
  // WORD CLOUD
  ////////////////////////////////////////////////////////////////////////

  code = code.replaceAll('RANDOMORDER', checkbox.toString().toUpperCase());
  code = code.replaceAll('STEM', stem ? 'TRUE' : 'FALSE');
  code = code.replaceAll('PUNCTUATION', punctuation ? 'TRUE' : 'FALSE');
  code = code.replaceAll('STOPWORD', stopword ? 'TRUE' : 'FALSE');
  code = code.replaceAll('LANGUAGE', language);

  (minFreq.isNotEmpty && num.tryParse(minFreq) != null)
      ? code = code.replaceAll('MINFREQ', num.parse(minFreq).toInt().toString())
      : code = code.replaceAll('MINFREQ', '1');

  (maxWord.isNotEmpty && num.tryParse(maxWord) != null)
      ? code = code.replaceAll('MAXWORD', num.parse(maxWord).toInt().toString())
      : code = code.replaceAll('MAXWORD', 'Inf');

  // Do we split the dataset? The option is presented on the DATASET GUI, and if
  // set we split the dataset.

  // TODO if (script.contains('^dataset_')) {

  // Do we split the dataset? The option is presented on the DATASET GUI, and if
  // set we split the dataset.

  code = code.replaceAll('SPLIT_DATASET', partition ? 'TRUE' : 'FALSE');

  // Do we want to normalise the dataset? The option is presented on the DATASET
  // GUI, and if set we normalise the dataset's variable names.

  code = code.replaceAll('NORMALISE_NAMES', normalise ? 'TRUE' : 'FALSE');

  // Do we want to cleanse the dataset? The option is presented on the DATASET
  // GUI, and if it is set we will cleanse the dataset columns.

  code = code.replaceAll('CLEANSE_DATASET', cleanse ? 'TRUE' : 'FALSE');

  // TODO 20231016 gjw HARD CODE FOR NOW BUT EVENTUALLY PASSED IN THROUGH THE
  // FUNCTION CALL AS A MAP AS DESCRIBED ABOVE..

  // TODO 20231016 gjw THESE SHOULD BE SET IN THE DATASET TAB AND ACCESS THROUGH
  // PROVIDERS.
  //
  // target
  // risk
  // id
  // split

  // TODO 20231102 gjw THE FOLLOWING HARD CODED AND ONLY WORKS FOR THE DEMO
  // DATASET!!!!

  code = code.replaceAll('VAR_TARGET', ref.read(targetProvider));

  //    normalise ? "rain_tomorrow" : "RainTomorrow",
//  );
  code = code.replaceAll('VAR_RISK', normalise ? 'risk_mm' : 'RISK_MM');
  code = code.replaceAll('VARS_ID', '"date", "location"');

  code = code.replaceAll('DATA_SPLIT_TR_TU_TE', '0.7, 0.15, 0.15');

  // TODO if (script == 'model_build_rpart')) {

  // TODO 20231016 gjw THESE SHOULD BE SET IN THE MODEL TAB AND ARE THEN
  // REPLACED WITHING model_build_rpart.R

  code = code.replaceAll(' PRIORS', '');
  code = code.replaceAll(' LOSS', '');
  code = code.replaceAll(' MAXDEPTH', '');
  code = code.replaceAll(' MINSPLIT', '');
  code = code.replaceAll(' MINBUCKET', '');
  code = code.replaceAll(' CP', '');

  // TODO if (script == 'model_build_random_forest')) {

  code = code.replaceAll('RF_NUM_TREES', '500');
  code = code.replaceAll('RF_MTRY', '4');
  code = code.replaceAll('RF_NA_ACTION', 'randomForest::na.roughfix');

  // Add the code to the script provider so it will be displayed in the script
  // tab and available to be exported there.

  updateScript(
    ref,
    "\n${'#' * 72}\n## -- $script.R --\n${'#' * 72}"
    '\n${rStripHeader(code)}',
  );

  // Run the code without comments.

  code = rStripComments(code);

  ref.read(ptyProvider).write(const Utf8Encoder().convert(code));
}

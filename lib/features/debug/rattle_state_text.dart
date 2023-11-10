/// A text widget showing the current rattle state.
///
/// Time-stamp: <Wednesday 2023-11-01 08:41:55 +1100 Graham Williams>
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
/// Authors: Graham Williams

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/provider/model.dart';
import 'package:rattle/provider/normalise.dart';
import 'package:rattle/provider/partition.dart';
import 'package:rattle/provider/path.dart';
import 'package:rattle/provider/script.dart';
import 'package:rattle/provider/status.dart';
import 'package:rattle/provider/stderr.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/provider/target.dart';
import 'package:rattle/provider/vars.dart';
import 'package:rattle/utils/count_lines.dart';
import 'package:rattle/utils/truncate.dart';

class RattleStateText extends ConsumerWidget {
  const RattleStateText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialise the state variables used here.

    String path = ref.watch(pathProvider);
    String status = ref.watch(statusProvider);
    String script = ref.watch(scriptProvider);
    String stderr = ref.watch(stderrProvider);
    String stdout = ref.watch(stdoutProvider);
    String model = ref.watch(modelProvider);
    String target = ref.watch(targetProvider);
    List<String> vars = ref.watch(varsProvider);
    bool partition = ref.watch(partitionProvider);
    bool normalise = ref.watch(normaliseProvider);

    return SingleChildScrollView(
      child: Builder(
        builder: (BuildContext context) {
          return SelectableText(
            "STATUS:      $status\n"
            "SCRIPT:      ${countLines(script)} lines\n"
            "STDOUT:      ${countLines(stdout)} lines\n"
            "STDERR:      ${countLines(stderr)} lines\n"
            "PATH:        $path\n"
            "NORMALISE:   $normalise\n"
            "PARTITION:   $partition\n"
            "VARS:        ${truncate(vars.toString())}\n"
            "TARGET:      $target\n"
            "RISK:        \$risk \n"
            "IDENTIFIERS: \$identifiers \n"
            "IGNORE:      \$ignore\n"
            "MODEL:       $model\n",
            style: monoSmallTextStyle,
          );
        },
      ),
    );
  }
}

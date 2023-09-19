/// Model tab for home page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Wednesday 2023-09-20 09:34:30 +1000 Graham Williams>
//
// Licensed under the GNU General Public License, Version 3 (the "License");
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

import 'package:provider/provider.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_forest.dart';
import 'package:rattle/r/extract_tree.dart';
import 'package:rattle/model/radio_buttons.dart';
import 'package:rattle/models/rattle_model.dart';

// TODO 20230916 gjw DOES THIS NEED TO BE STATEFUL?

class ModelTab extends StatefulWidget {
  const ModelTab({Key? key}) : super(key: key);

  @override
  ModelTabState createState() => ModelTabState();
}

class ModelTabState extends State<ModelTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RattleModel>(
      // A [Consumer] of the [RattleModel] so we can access updated values of
      // the stdout variable.
      builder: (context, rattle, child) {
        return Scaffold(
          body: Column(
            children: [
              ModelRadioButtons(),
              Visibility(
                visible: rattle.model == "Tree",
                child: Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 0),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        rExtractTree(rattle.stdout),
                        style: monoTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: rattle.model == "Forest",
                child: Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 0),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        rExtractForest(rattle.stdout),
                        style: monoTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
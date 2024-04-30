/// Model tab for home page.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Friday 2023-11-03 05:45:47 +1100 Graham Williams>
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

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/features/model/save_wordcloud_png.dart';

import 'package:rattle/provider/model.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/constants/app.dart';
import 'package:rattle/features/model/radio_buttons.dart';
import 'package:rattle/r/extract_forest.dart';
import 'package:rattle/r/extract_tree.dart';

// TODO 20230916 gjw DOES THIS NEED TO BE STATEFUL?

var systemTempDir = Directory.systemTemp;

String word_cloud_image_path =  "${systemTempDir.path}/wordcloud.png";
File word_cloud_file = File(word_cloud_image_path);

class ModelTab extends ConsumerStatefulWidget {
  const ModelTab({Key? key}) : super(key: key);

  @override
  ConsumerState<ModelTab> createState() => _ModelTabState();
}

class _ModelTabState extends ConsumerState<ModelTab> {
  @override
  Widget build(BuildContext context) {
    String model = ref.watch(modelProvider);
    String stdout = ref.watch(stdoutProvider);
    return Scaffold(
      body: Column(
        children: [
          const ModelRadioButtons(),
          Visibility(
            visible: model == "Cluster",
            child: const Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          Visibility(
            visible: model == "Associate",
            child: const Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          Visibility(
            visible: model == "Tree",
            child: Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                child: SingleChildScrollView(
                  child: SelectableText(
                    rExtractTree(stdout),
                    style: monoTextStyle,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: model == "Forest",
            child: Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                child: SingleChildScrollView(
                  child: SelectableText(
                    rExtractForest(stdout),
                    style: monoTextStyle,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: model == "Boost",
            child: const Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          Visibility(
            visible: model == "Word Cloud",
            child: Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10),
                child: SingleChildScrollView(
                  child: wordcloudWindow(),
                ),
              ),
            ),
          ),
          Visibility(
            visible: model == "SVM",
            child: const Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          Visibility(
            visible: model == "Linear",
            child: const Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
          Visibility(
            visible: model == "Neural",
            child: const Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text("NOT YET IMPLEMENTED"),
              ],
            ),
          ),
        ],
      ),
    );
  }

}


class wordcloudWindow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
  // reload the wordcloud png
  imageCache.clear();
  imageCache.clearLiveImages();
  // bool rebuild = ref.watch(wordcloudBuildProvider);
  debugPrint("path: ${word_cloud_image_path}");
  debugPrint("build wordcloud window.");
  bool pngBuild = word_cloud_file.existsSync();
  if (!pngBuild) {
    return Column(children: [
      SizedBox(height: 50),
      Text("No model has been built"),
    ],);
  }

  if (pngBuild) { 
    return Column(children: [
                            Image.file(File(word_cloud_image_path)),
                            SaveWordCloudButton(
                              wordCloudImagePath: word_cloud_image_path,
                            ),      
    ],);
  }
  
  return Text("bug");
  }
}
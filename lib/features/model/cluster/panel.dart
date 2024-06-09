/// Widget to display the Cluster introduction or built tree.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-06-09 16:42:59 +1000 Graham Williams>
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

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/colors.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/r/extract_cluster.dart';
import 'package:rattle/widgets/markdown_file.dart';

/// The tree panel displays the tree instructions or the tree biuld output.

class ClusterPanel extends ConsumerStatefulWidget {
  const ClusterPanel({super.key});

  @override
  ConsumerState<ClusterPanel> createState() => _ClusterPanelState();
}

class _ClusterPanelState extends ConsumerState<ClusterPanel> {
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);
    String content = rExtractCluster(stdout);

    return content == ''
        ? Expanded(
            child: Center(
              child: sunkenMarkdownFileBuilder(clusterIntroFile),
            ),
          )
        : Expanded(
            child: Container(
              decoration: sunkenBoxDecoration,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10),
              child: SingleChildScrollView(
                child: SelectableText(
                  content,
                  style: monoTextStyle,
                ),
              ),
            ),
          );
  }
}

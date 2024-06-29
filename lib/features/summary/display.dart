/// Widget to display the SUMMARY introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-06-29 15:19:53 +1000 Graham Williams>
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

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the R output.

class SummaryDisplay extends ConsumerStatefulWidget {
  const SummaryDisplay({super.key});

  @override
  ConsumerState<SummaryDisplay> createState() => _SummaryDisplayState();
}

class _SummaryDisplayState extends ConsumerState<SummaryDisplay> {
  //

  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(summaryIntroFile, context)];

    String content = '';
    List<String> lines = [];

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'summary(ds)');

    // Add a blank line between each sub-table.

    lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('  ') && !lines[i].trimLeft().startsWith('NA')) {
        lines[i] = '\n${lines[i]}';
      }
    }

    content = lines.join('\n');

    // Replace multiple empty lines with a single empty line.

    content = content.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Summary of the Dataset\n\n'
              'Generated using `base::summary(ds)`.\n\n'
              'This is the most basic R command for summarising the dataset.\n\n'
              'For **numeric data** the minimum, and maximum values are listed. '
              'Between these we can see listed the first and thrid quartiles as '
              'well as the median (the second quartile) and the mean.\n\n'
              'For **categoric data** a frequency table is provided, showing the '
              'frequency of the categoric values from the most frequent to '
              'the least frequent. '
              'Only the top few categoric values will be listed.\n\n'
              'A count of **missing values** is shown for variables with '
              'missing values.',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'contents(ds)');

    // Replace multiple empty lines with a single empty line.

    content = content.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Contents of the Dataset\n\n'
              'Generated using `Hmisc::contents(ds)`.\n\n'
              'This content-oriented summary of the data lists the number of '
              '**levels** (the different values for the categoric variable) '
              'for each categoric variable, as well as identifying '
              'whether it is ordered. The type of storage is reported '
              'together with a count of the number of **missing values** (NAs).'
              '\n\n'
              'The actual levels for categoric variables are listed in the '
              'table shown further down in the display',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'describe(ds)');

    // Remove the initial `ds` and separate each variable with a blank line.

    lines = content.split('\n');

    // Filter out the lines that are exactly 'ds'.

    lines = lines.where((line) => line.trim() != 'ds').toList();

    // Add extra line after each variable block.

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('--')) {
        lines[i] = '\n${lines[i]}\n';
      }
    }

    // Insert a bank line before the listing of the percentiles.

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('     .')) {
        lines[i] = '\n${lines[i]}';
      }
    }

    // Join the lines back into a single string.

    content = lines.join('\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Describe the Dataset\n\n'
              'Generated using `Hmisc::describe(ds)`',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    content = 'Kurtosis:\n';
    content += rExtract(stdout, 'kurtosis(ds[numc], na.rm=TRUE)');
    content += '\nSkewness:\n';
    content += rExtract(stdout, 'skewness(ds[numc], na.rm=TRUE)');

    // Add some spacing to the output.

    // Split the string into lines.

    lines = content.split('\n');

    // Iterate over the lines and modify them.

    for (int i = 0; i < lines.length; i++) {
      if (!RegExp(r'^\s*[\d-]').hasMatch(lines[i])) {
        lines[i] = '\n${lines[i]}';
      }
    }

    // Join the lines back into a single string.

    content = lines.join('\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Kurtosis and Skewness\n\n'
              'Generated using `fBasics::kurtosis` and `fBasics::skewness`\n\n',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'lapply(ds[numc], basicStats)');

    // Replace $ at the beginning of any lines.

    //content = content.replaceAll(RegExp(r'^$'), '');
    content = content.replaceAll('\$', '');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Detailed Variable Statistics\n\n'
              'Generated using `fBasics::basicStats`\n\n',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    content = rExtract(stdout, 'md.pattern(ds)');

    // Add a blank line between each sub-table.

    lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith(' ') && !RegExp(r'^\s+\d').hasMatch(lines[i])) {
        lines[i] = '\n${lines[i]}';
      }
    }

    content = lines.join('\n');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '# Patterns of Missing Data - Textual\n\n'
              'Generated using `mice::md.pattern(ds)`',
          content: content,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    return Pages(
      // key: treePagesKey, // to go to the result page after clicking build button
      children: pages,
    );
  }
}

/// Utility to strip header comments from an R script file.
///
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Friday 2023-09-15 09:17:56 +1000 Graham Williams>
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

/// The intention is to strip the initial copyright message from the script,
/// though keeping the first line, assumened to be the script title, and then
/// keeping all other lines from the script file supplied as the [String]
/// [code].

String rStripHeader(String code) {
  // Keep first line then strip everything down to the first line not starting
  // with a hash.

  List<String> lines = code.split('\n');

  // Find the index of the first line that doesn't start with '#'

  int index = 0;
  while (index < lines.length && lines[index].trim().startsWith('#')) {
    index++;
  }

  // Join the lines.

  String result = "\n${lines.first} \n#${lines.sublist(index).join('\n')}";

  return result;
}

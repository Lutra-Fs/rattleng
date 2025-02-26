# RattleNG Changelog

Recorded here are the high level changes for the RattleNG app.

Guide: Each version update is recorded here with a short user-oriented
description of the update. Updates in the 6.3.n series are heading
toward a 6.3 release.

## 6.3 FUTURE Wrangle tab implementation

+ Rearrange RESCALE interface [6.2.40 20240808 gjw]
+ Review and clean [6.2.39 20240808 zy]
+ Update configs for RESCALE and TREE [6.2.38 20240808 gjw]
+ Add icon for all platforms. [6.2.37 20240807 gjw]
+ Refactor number chooser widget [20240807 yyz]
+ fBasics to timeDate for kurtosis and skewness [6.2.36 20240806 gjw]
+ Add INTERVAL to RESCALE [6.2.35 20240806 yyx]
+ Update xterm and fix selected transparency. [6.2.34 20240805 gjw]
+ Fine tune buttons. [6.2.33 20240804 gjw]
+ Build snapcraft package for distribution [6.2.32 20240804 gjw]
+ Bug fixes: update dateset template after transforms [6.2.31 20240803 gjw]
+ Add RANK function to RESCALE feature of TRANSFORM tab [6.2.30 20240802 yyx]
+ Ensure transformed vars added to types provider [6.2.29 20240802 yyx]
+ Review and cleanup. [6.2.28 20240802 gjw]
+ Working MacOS and Windows. Fixed R path for MacOS [6.2.27 20240802 gjw]
+ Bug fix: handle Windows path for temp dir [6.2.26 20240802 gjw]
+ Bug fix: do not reset toggles on dataset load [6.2.25 20240801 gjw]
+ Add CrossTable to SUMMARY [6.2.24 20240801 gjw]
+ R script cleanup. Docs update. Ubuntu 20.04 build [6.2.23 20240801 gjw]
+ Prompt for script name on saving [6.2.22 20240801 zy]
+ Fine tuning [6.2.21 20240801 gjw]
+ RESCALE update [6.2.20 20240731 yyx]
+ Add a table view icon [6.2.19 20240731 gjw]
+ Implement IMPUTE.  [6.2.18 20240730 gjw]
+ Use pacman:: rather than library() [6.2.18 20240730 gjw]
+ Cleanup ready for release [6.2.17 20240729 gjw]
+ Add more survivor links. [6.2.16 20240729 gjw]
+ Re-do Tests. Update markdown. Add survivor links. [6.2.15 20240729 gjw]
+ Implement TESTS [6.2.14 20240726 yyx]
+ Remove WEIGHTS (not used). Remove Global Save [6.2.14 20240726 gjw]
+ Attempt to give MacOS permission to run R [6.2.13 20240725 gjw]
+ Updating formats, links, etc, particularly for MISSING [6.2.12 20240725 gjw]
+ Testing github actions [6.2.11 20240725 gjw]
+ Initial experiment with WRANGLE gui WIP [6.2.10 20240725 gjw]
+ Automate build and installation updates [6.2.9 20240724 gjw]
+ Add group by selector for VISUALISE [6.2.8 20240723 yyx]
+ Add variable selection to VISUALISE [6.2.7 20240723 yyx]
+ Add glimpse to TRANSFORM
+ Add transform R scripts. Activate URL links. VISUALISE risk var [6.2.6 20240722 gjw]
+ Add a shell for the Wrangle tab functionality [6.2.5 20240719 gjw]
+ Move Page navigation to the bottom [6.2.4 20240718 yyx]
+ Refactor dataset feature [6.2.3 20240715 gjw]
+ Initial R code and integration of exploration plots [6.2.2 20240715 gjw]
+ Add EXPORT to ImagePage() [6.2.1 20240712 gjw]

## 6.2 Dataset Roles, Display Pages.

+ Move to SVG images [20240711 yyx]
+ Implement ImagePage() [20240711 yyx]
+ Add dataset role selector [20240711 yyx]
+ Update TREE and FOREST display [6.1.24 20240630 gjw]
+ Add word frequency to WORDCLOUD [6.1.23 gjw]
+ Add MISSING and CORRELATION features [6.1.22 gjw]
+ Update tree/cluster/forest to use TextPage() [6.1.21 gjw] 
+ Complete SUMMARY text features [6.1.20 gjw]
+ New Pages() widget for multiple page display [6.1.19 yyx]
+ Rename `panels` to `features` as a standard [6.1.18 gjw]
+ Implement sliding panels for wordcloud display [6.1.17 yyx]
+ R script asset read fix to get deployed app working [6.1.16 gjw]
+ Refactor the markdown file display for each tab [6.1.15 gjw]
+ Re-org features to tab/panels to support future flexibility [6.1.14 gjw]
+ Implement pattern for all model tabs [6.1.13 gjw]
+ Use a NavigationRail for the left hand navigation [6.1.12 yyx]
+ Add ActivityButton as default button for Build/Display [6.1.11]
+ Review status bar, markdown intros, add Under Construction [6.1.10]
+ Wordclound in-pattern with tab/config/panel [6.1.9]
+ Initial EXPLORE framework [6.1.8]
+ Migrate FOREST to tab/config/panel pattern [6.1.7]
+ Migrate TREE to tab/config/panel pattern [6.1.6]
+ Console font update. Common sunken effect for panels [6.1.5]
+ Implement project reset [6.1.4]
+ Restructure dataset tab into tab/config/panel [6.1.3]
+ Add wordcloud introductory message [6.1.2]
+ WordCloud cleanup. Improve image display. [6.1.1]

## 6.1 Word Clouds, Basic Trees, and Basic Forests

+ Comprehensive cleanup with dart code metrics [6.1.0]
+ Wordcloud -> WordCloud - it is generally two words [6.0.7]
+ Add CLEANSE option for DATASET to suite RandomForest na.roughfix() [6.0.6]
+ Wait until wordcloud file has content [6.0.5]
+ Pre merge code cleanup [6.0.4]
+ Implement wordcloud [6.0.3]

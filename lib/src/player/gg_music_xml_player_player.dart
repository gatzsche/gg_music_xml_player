// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_time_controller/gg_time_controller.dart';
import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import '../timeline/gg_document_timeline.dart';
import '../timeline/typedefs.dart';

typedef OnDocItem = void Function(GgDocumentItem items);

class GgMusicXmlPlayer {
  GgMusicXmlPlayer({
    required this.document,
    required this.onItem,
    double? frameRate,
    Stopwatch? stopwatch,
    GgPeriodicTimer? timer,
  }) {
    _init(
      frameRate: frameRate,
      stopwatch: stopwatch,
      timer: timer,
    );
  }

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init({
    required double? frameRate,
    required Stopwatch? stopwatch,
    required GgPeriodicTimer? timer,
  }) {
    _initDocument();
    _initTimeController(
      frameRate: frameRate,
      stopwatch: stopwatch,
      timer: timer,
    );
  }

  // ...........................................................................
  late GgTimeController timeController;

  // ...........................................................................
  void _initTimeController({
    required double? frameRate,
    required Stopwatch? stopwatch,
    required GgPeriodicTimer? timer,
  }) {
    timeController = GgTimeController(
      onTimeStamp: _timerFired,
      frameRate: frameRate ?? GgTimeController.defaultFrameRate,
      stopwatch: stopwatch,
      timer: timer,
    );
  }

  // ...........................................................................
  final MusicXmlDocument document;
  late GgDocumentTimeline timeline;
  final OnDocItem onItem;

  // ######################
  // Private
  // ######################

  void _initDocument() {
    timeline = GgDocumentTimeline(document: document);
    onItem(timeline.currentItem);
  }

  // ...........................................................................
  void _timerFired(Seconds time) {
    final nothingHasChanged = time >= timeline.currentItem.validFrom &&
        time < timeline.currentItem.validTo;
    if (nothingHasChanged) {
      return;
    }

    final newItem = timeline.item(time);
    onItem(newItem);
  }
}

// #############################################################################
GgMusicXmlPlayer exampleGgMusicXmlPlayer({
  OnDocItem? onItem,
  Stopwatch? stopwatch,
}) =>
    GgMusicXmlPlayer(
        document: wholePieceXmlDoc,
        onItem: onItem ?? (_) {},
        stopwatch: stopwatch ?? Stopwatch());

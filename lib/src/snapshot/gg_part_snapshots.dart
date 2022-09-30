// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_chord_snapshots.dart';
import 'gg_multi_snapshots.dart';
import 'gg_note_snapshots.dart';
import 'gg_snapshot.dart';
import 'typedefs.dart';

// #############################################################################
/// Wrap GgPartSnapshot around GgMultiSnapshot
class GgPartSnapshot implements GgMultiSnapshot {
  const GgPartSnapshot({
    required this.snapshots,
    required this.validFrom,
    required this.validTo,
    required this.part,
    required this.noteSnapshot,
    required this.chordSnapshot,
  });

  // ...........................................................................
  @override
  final Seconds validFrom;

  @override
  final Seconds validTo;

  @override
  final List<GgSnapshot> snapshots;

  // ...........................................................................
  final GgChordSnapshot chordSnapshot;
  final GgNoteSnapshot noteSnapshot;
  final Part part;
}

// #############################################################################
/// Manages all snapshots for a given part
class GgPartSnapshots extends GgMultiSnapshots {
  GgPartSnapshots({
    required this.part,
  }) : super(snapshotHandlers: [
          GgChordSnapshots(part: part),
          GgNoteSnapshots(part: part),
        ]) {
    _init();
  }

  // ...........................................................................
  final Part part;

  // ...........................................................................
  @override
  GgPartSnapshot get currentSnapshot => _currentSnapshot;

  // ...........................................................................
  /// Returns the snapshot for a given position
  @override
  GgPartSnapshot snapshot(Seconds timePosition) {
    if (timePosition < _currentSnapshot.validFrom ||
        timePosition >= _currentSnapshot.validTo) {
      _updateCurrentSnapshot(timePosition);
    }

    return _currentSnapshot;
  }

  // ######################
  // Private
  // ######################

  late GgPartSnapshot _currentSnapshot;

  // ...........................................................................
  void _init() {
    _updateCurrentSnapshot(0.0);
  }

  // ...........................................................................
  void _updateCurrentSnapshot(Seconds timePosition) {
    final multi = super.snapshot(timePosition);

    _currentSnapshot = GgPartSnapshot(
      snapshots: multi.snapshots,
      validFrom: multi.validFrom,
      validTo: multi.validTo,
      chordSnapshot: multi.snapshots[0] as GgChordSnapshot,
      noteSnapshot: multi.snapshots[1] as GgNoteSnapshot,
      part: part,
    );
  }
}

// #############################################################################
final exampleGgPartSnapshots = GgPartSnapshots(
  part: wholePieceXmlDoc.parts.first,
);
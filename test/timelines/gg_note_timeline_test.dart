// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/sample_xml/tied_note/gg_example_music_xml_tied_note.dart';
import 'package:gg_music_xml_player/src/timelines/gg_note_timeline.dart';
import 'package:test/test.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  late GgNoteTimeline timeline = exampleNoteTimeline();

  group('GgItemGenerator', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        fakeAsync((fake) {
          // Get all items
          final items = timeline.items;

          // Check key signature
          var item = items.first;
          expect(item.validFrom, 0.0);
          expect(item.data, [timeline.part.measures[0].notes[0]]);

          // Bar 2
          expect(items[1].data, [timeline.part.measures[1].notes[0]]);
          expect(items[2].data, [timeline.part.measures[1].notes[1]]);
          expect(items[3].data, [timeline.part.measures[1].notes[2]]);
          expect(items[4].data, [timeline.part.measures[1].notes[3]]);

          // Last bar
          expect(
            items[items.length - 2].data.last,
            timeline.part.measures.last.notes.last,
          );
        });
      });

      test('should load ties correctly', () {
        final itemGenerator =
            GgNoteTimeline(part: ggExampleMusicXmlTiedNote.parts.first);
        expect(itemGenerator.items.length, 4);

        // The tied duration of the notes should span three measures
        final firstNote = itemGenerator.items.first.data.first;
        expect(firstNote.noteDuration.seconds, 2);
        expect(firstNote.noteDuration.timePosition, 0);
        expect(firstNote.noteDurationTied.timePosition, 0);
        expect(firstNote.noteDurationTied.seconds, 6);

        // The tied duration of the notes should span three measures
        final secondNote = itemGenerator.items[1].data.first;
        expect(secondNote.noteDuration.seconds, 2);
        expect(secondNote.noteDuration.timePosition, 2);
        expect(secondNote.noteDurationTied.timePosition, 0);
        expect(secondNote.noteDurationTied.seconds, 6);

        // The tied duration of the notes should span three measures
        final thirdNote = itemGenerator.items[2].data.first;
        expect(thirdNote.noteDuration.seconds, 2);
        expect(thirdNote.noteDuration.timePosition, 4);
        expect(thirdNote.noteDurationTied.timePosition, 0);
        expect(thirdNote.noteDurationTied.seconds, 6);
      });
    });

    // #########################################################################
    group('item(time)', () {
      test('should return the right item for the given time', () {
        final items = timeline.items;

        // Check exact positions of items
        void checkTimePosition(GgNoteItem item) {
          expect(
            item,
            timeline.item(item.validFrom),
          );
        }

        checkTimePosition(items[0]);
        checkTimePosition(items[5]);
        checkTimePosition(items[1]);
        checkTimePosition(items.last);

        // Check positions inbetween items
        final t0 = items[0].validFrom;
        final t1 = items[1].validFrom;
        final t01 = t0 + (t1 - t0) / 2;
        expect(timeline.item(t01), items[0]);
      });
    });
  });
}

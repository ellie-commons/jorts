/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


/*
This handles everything view

Notably:
-recognize links to open in fav browser
-recognize local links to open in Files
-Allow a zoom unzoom

Hypertextview is a Granite widget derived from TextView

Formatting code courtesy of Colin Kiama
https://github.com/colinkiama/vala-gtk4-text-formatting-demo/tree/main

*/

public class Jorts.TextView : Granite.HyperTextView {
        public TextView () {

                this.buffer = new Gtk.TextBuffer (null);
                this.bottom_margin = 12;
                this.left_margin = 12;
                this.right_margin = 12;
                this.top_margin = 6;

                this.set_hexpand (true);
                this.set_vexpand (true);
                this.set_wrap_mode (Gtk.WrapMode.WORD_CHAR);
        }

        public string get_content () {
                return this.buffer.text;
        }

        public void paste () {
                var clipboard = Gdk.Display.get_default ().get_clipboard ();
                clipboard.read_text_async.begin ((null), (obj, res) => {
                try {

                    var pasted_text = clipboard.read_text_async.end (res);
                    this.buffer.text = pasted_text;

                } catch (Error e) {
                    print ("Cannot access clipboard: " + e.message);
                }
            });
        }
}

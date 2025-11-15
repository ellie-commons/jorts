/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* A textview incorporating detecting links and emails
* Fairly vanilla but having a definition allows to easily extend it
*/
public class Jorts.TextView : Granite.HyperTextView {

    public string text {
        owned get {return buffer.text;}
        set {buffer.text = value;}
    }

    construct {
        buffer = new Gtk.TextBuffer (null);
        bottom_margin = 10;
        left_margin = 10;
        right_margin = 10;
        top_margin = 5;

        set_hexpand (true);
        set_vexpand (true);
        set_wrap_mode (Gtk.WrapMode.WORD_CHAR);

        //Application.gsettings.bind ("scribbly-mode-active", this, "scribbly", SettingsBindFlags.DEFAULT);
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

    public void list () {
        Gtk.TextIter start, end;
        buffer.get_selection_bounds (out start, out end);

        var first_line = (uint8)start.get_line ();
        var last_line = (uint8)end.get_line ();
        debug ("got " + first_line.to_string () + " to " + last_line.to_string ());

        Gtk.TextIter startline;
        var list_item_start = Application.gsettings.get_string ("list-item-start");

        buffer.begin_user_action ();
        for (uint8 i = first_line; i <= last_line; i++) {

            debug ("doing line " + i.to_string ());
            buffer.get_iter_at_line_index (out startline, i, 0);
            buffer.insert (ref startline, list_item_start, -1);
        }
        buffer.end_user_action ();

    }
}

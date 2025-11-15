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

    public void toggle_list () {
        Gtk.TextIter start, end;
        buffer.get_selection_bounds (out start, out end);

        var first_line = (uint8)start.get_line ();
        var last_line = (uint8)end.get_line ();
        debug ("got " + first_line.to_string () + " to " + last_line.to_string ());

        var list_item_start = Application.gsettings.get_string ("list-item-start");
        var selected_is_list = this.is_list (first_line, last_line, list_item_start);

        buffer.begin_user_action ();
        if (selected_is_list)
        {
            this.remove_list (first_line, last_line, list_item_start);

        } else {
            this.set_list (first_line, last_line, list_item_start);
        }
        buffer.end_user_action ();
    }

    /**
     * Add the list prefix only to lines who hasnt it already
     */
    private bool has_prefix (uint8 line_number, string list_item_start) {
        Gtk.TextIter start, end;
        buffer.get_iter_at_line_offset (out start, line_number, 0);

        end = start.copy ();
        end.forward_to_line_end ();

        var text_in_line = buffer.get_slice (start, end, false);

        return text_in_line.has_prefix (list_item_start);
    }

    /**
     * Checks whether Line x to Line y are all bulleted.
     */
    private bool is_list (uint8 first_line, uint8 last_line, string list_item_start) {

        for (uint8 line_number = first_line; line_number <= last_line; line_number++) {
            debug ("doing line " + line_number.to_string ());

            if (!this.has_prefix (line_number, list_item_start)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Add the list prefix only to lines who hasnt it already
     */
    private void set_list (uint8 first_line, uint8 last_line, string list_item_start) {
        Gtk.TextIter line_start;
        for (uint8 line_number = first_line; line_number <= last_line; line_number++) {

            debug ("doing line " + line_number.to_string ());
            if (!this.has_prefix (line_number, list_item_start)) {
                buffer.get_iter_at_line_offset (out line_start, line_number, 0);
                buffer.insert (ref line_start, list_item_start, -1);
            }
        }
    }

    /**
     * Remove list prefix from line x to line y. Presuppose it is there
     */
    private void remove_list (uint8 first_line, uint8 last_line, string list_item_start) {
        Gtk.TextIter line_start, prefix_end;
        var remove_range = list_item_start.length;

        for (uint8 line_number = first_line; line_number <= last_line; line_number++) {

            debug ("doing line " + line_number.to_string ());
            buffer.get_iter_at_line_offset (out line_start, line_number, 0);
            buffer.get_iter_at_line_offset (out prefix_end, line_number, remove_range);
            buffer.delete (ref line_start, ref prefix_end);
        }
    }


}

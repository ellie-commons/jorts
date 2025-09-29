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

    public bool scribbly {
        get { return "scribbly" in this.css_classes;}
        set { scribbly_set (value);}
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

    private void scribbly_set (bool if_scribbly) {
        if (if_scribbly) {
            this.add_css_class ("scribbly");

        } else {
            if ("scribbly" in this.css_classes) {
                this.remove_css_class ("scribbly");
            }
        }
    }
}

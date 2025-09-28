/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

 public class Jorts.NoteView : Gtk.Box {
    public Gtk.HeaderBar headerbar;
    public Gtk.EditableLabel editablelabel;
    public Jorts.TextView textview;
    public Jorts.ActionBar actionbar;

    public Gtk.MenuButton emoji_button;
    public Gtk.EmojiChooser emojichooser_popover;
    public Gtk.MenuButton menu_button;

    public bool monospace {
        get { return textview.monospace;}
        set { mono_set (value);}
    }

    construct {
        orientation = VERTICAL;
        spacing = 0;

        headerbar = new Gtk.HeaderBar () {
            show_title_buttons = false
        };
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        headerbar.add_css_class ("headertitle");

        // Defime the label you can edit. Which is editable.
        editablelabel = new Gtk.EditableLabel ("") {
            xalign = 0.5f,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>L"},
                _("Click to edit the title")
            )
        };
        editablelabel.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);
        headerbar.set_title_widget (editablelabel);

        textview = new Jorts.TextView ();
        var scrolled = new Gtk.ScrolledWindow () {
            child = textview
        };

        actionbar = new Jorts.ActionBar ();
        emoji_button = actionbar.emoji_button;
        emojichooser_popover = actionbar.emojichooser_popover;
        menu_button = actionbar.menu_button;

        append (headerbar);
        append (scrolled);
        append (actionbar);
        //set_focus_child (textview);


        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        // Display the current zoom level when the popover opens
        // Else it does not get set
        emojichooser_popover.show.connect (on_emoji_popover);

        // User chose emoji, add it to buffer
        emojichooser_popover.emoji_picked.connect ((emoji) => {
            textview.buffer.insert_at_cursor (emoji, -1);
        });

        //The application tells us the show/hide bar state has changed!
        //Application.gsettings.bind ("hide-bar", actionbar, "revealed", SettingsBindFlags.INVERT_BOOLEAN);
    }


    // Randomize the button emoji when clicked
    public void on_emoji_popover () {
        debug ("Emote requested!");

        emoji_button.set_icon_name (
            Jorts.Utils.random_emote (
                emoji_button.get_icon_name ()
            )
        );
    }

    private void mono_set (bool if_mono) {
        if (if_mono) {
            editablelabel.add_css_class ("monospace");
        } else {
            if ("monospace" in editablelabel.css_classes) {
                editablelabel.remove_css_class ("monospace");
            }
        }
        textview.monospace = if_mono;
    }
}

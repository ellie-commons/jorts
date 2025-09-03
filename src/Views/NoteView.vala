/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

 public class Jorts.NoteView : Gtk.Box {

        public Jorts.TextView textview;
        public Gtk.ActionBar actionbar;

        public Gtk.Button delete_item;

        public Gtk.MenuButton emoji_button;
        public Gtk.EmojiChooser emojichooser_popover;

        public Gtk.MenuButton menu_button;

    construct {
        orientation = VERTICAL;
        spacing = 0;

        // Define the text thingy
        var scrolled = new Gtk.ScrolledWindow ();
        textview = new Jorts.TextView ();

        scrolled.set_child (textview);

        var new_item = new Gtk.Button () {
            icon_name = "list-add-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>n"},
                _("New sticky note")
            )
        };
        new_item.action_name = Application.ACTION_PREFIX + Application.ACTION_NEW;
        new_item.add_css_class ("themedbutton");

        delete_item = new Gtk.Button () {
            icon_name = "edit-delete-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>w"},
                _("Delete sticky note")
            )
        };
        delete_item.add_css_class ("themedbutton");



        var emojichooser_popover = new Gtk.EmojiChooser ();

        emoji_button = new Gtk.MenuButton () {
            icon_name = Jorts.Utils.random_emote (),
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>period"},
                _("Insert emoji")
            )
        };
        emoji_button.add_css_class ("themedbutton");
        emoji_button.popover = emojichooser_popover;





        menu_button = new Gtk.MenuButton () {
            icon_name = "open-menu-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>M"},
                _("Preferences for this sticky note")
            )
        };
        menu_button.direction = Gtk.ArrowType.UP;
        menu_button.add_css_class ("themedbutton");

        actionbar = new Gtk.ActionBar () {
            hexpand = true
        };
        actionbar.pack_start (new_item);
        actionbar.pack_start (delete_item);
        actionbar.pack_end (menu_button);
        actionbar.pack_end (emoji_button);

        var handle = new Gtk.WindowHandle () {
            child = actionbar
        };

        append (scrolled);
        append (handle);
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
        Application.gsettings.bind ("hide-bar", actionbar, "revealed", SettingsBindFlags.INVERT_BOOLEAN);
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

}

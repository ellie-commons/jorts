/*
* Copyright (c) 2017-2024 Lains
* Copyright (c) 2025 Stella (teamcons on GitHub) and the Ellie_Commons community
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

/* CONTENT

Preferences is boring
Everything is in a Handle so user can move the window from anywhere
It is a box, with inside of it a box and an actionbar

the innerbox has widgets for settings.
the actionbar has a donate me and a set back to defaults just like elementaryOS

*/
namespace jorts {
    public class PreferenceWindow :  Gtk.Window {


        public PreferenceWindow (Gtk.Application app) {
            debug("Showing preference window");

            Object (application: app);
            Intl.setlocale ();

            var gtk_settings = Gtk.Settings.get_default ();

            // Since each sticky note adopts a different accent color
            // we have to revert to default when this one is focused
            this.notify["is-active"].connect(() => {
                if (this.is_active) {
                    //gtk_settings.gtk_theme_name = Application.system_accent;
                    gtk_settings.gtk_theme_name = "io.elementary.stylesheet." + jorts.Constants.DEFAULT_THEME.ascii_down();
                }
            });


            /*************************************************/
            // Headerbar bs

            /// TRANSLATORS: Feel free to improvise. The goal is a playful wording to convey the idea of app-wide settings
            var titlelabel = new Gtk.Label (_("Preferences for your Jorts"));
            titlelabel.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);
            set_title (titlelabel.get_text ());
            
            var headerbar = new Gtk.HeaderBar () {
                title_widget = titlelabel,
                show_title_buttons = true,
            };

            set_titlebar (headerbar);
            set_size_request (jorts.Constants.DEFAULT_PREF_WIDTH, jorts.Constants.DEFAULT_PREF_HEIGHT);
            set_default_size (jorts.Constants.DEFAULT_PREF_WIDTH, jorts.Constants.DEFAULT_PREF_HEIGHT);
            resizable = true;
            add_css_class ("dialog");
            add_css_class (Granite.STYLE_CLASS_MESSAGE_DIALOG);



            /*************************************************/
            // Box with settingsbox and then reset button
            var mainbox = new Gtk.Box (VERTICAL, 0) {
                margin_bottom = 6,
                margin_top = 6,
                margin_start = 12,
                margin_end = 12
            };

            // the box with all the settings
            var settingsbox = new Gtk.Box (VERTICAL, 10) {
                margin_bottom = 0,
                margin_top = 0,
                margin_start = 0,
                margin_end = 0,
                hexpand = true,
                vexpand = true
            };


                /*************************************************/
                /*              scribbly Toggle                  */
                /*************************************************/

                var scribbly_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);

                var scribbly_toggle = new Gtk.Switch () {
                    halign = Gtk.Align.END,
                    hexpand = true,
                    valign = Gtk.Align.CENTER,
                };

                var scribbly_label = new Granite.HeaderLabel (_("Activate scribbly mode")) {
                    mnemonic_widget = scribbly_toggle,
                    secondary_text = _("If enabled, unfocused sticky notes become unreadable to protect their content from peeking eyes")
                };

                scribbly_box.append (scribbly_label);
                scribbly_box.append (scribbly_toggle);
                settingsbox.append(scribbly_box); 

                Application.gsettings.bind (
                    "scribbly-mode-active", 
                    scribbly_toggle, "active",
                    SettingsBindFlags.DEFAULT);



            /*************************************************/
            // Bar at the bottom
            var actionbar = new Gtk.ActionBar ();
            actionbar.set_hexpand (true);
            actionbar.set_vexpand (false);

            // Monies?
            var support_button = new Gtk.LinkButton.with_label (
                jorts.Constants.DONATE_LINK,
                _("Support us!")
            );
            actionbar.pack_start (support_button);


            // Reset
            var reset_button = new Gtk.Button();
            reset_button.set_label( _("Reset to Default"));
            reset_button.tooltip_markup = (_("Reset all settings to defaults"));
            actionbar.pack_end (reset_button);

            reset_button.clicked.connect(() => {
                string[] keys = {"font-name", "scribbly-mode-active"};
                foreach (var key in keys) {
                    Application.gsettings.reset (key);
                }
            });

            mainbox.append (settingsbox);
            mainbox.append(actionbar);

            // Make the whole window grabbable
            var handle = new Gtk.WindowHandle () {
                child = mainbox
            };

            this.child = handle;
            this.show ();
            this.present ();
        }

    }
}




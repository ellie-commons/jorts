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
namespace Jorts {
    public class PreferenceWindow : Gtk.Window {

        public const string ACTION_PREFIX = "app.";
        public const string ACTION_NEW = "action_new";

        public static Gee.MultiMap<string, string> action_accelerators;

        private const GLib.ActionEntry[] ACTION_ENTRIES = {
            { ACTION_NEW, action_new }
        };

        construct {
            debug ("Showing preference window");
            Intl.setlocale ();

            var actions = new SimpleActionGroup ();
            actions.add_action_entries (ACTION_ENTRIES, this);
            insert_action_group ("app", actions);

            var gtk_settings = Gtk.Settings.get_default ();

            // Since each sticky note adopts a different accent color
            // we have to revert to default when this one is focused
            this.notify["is-active"].connect (() => {
                if (this.is_active) {
                    //gtk_settings.gtk_theme_name = Application.system_accent;
                    gtk_settings.gtk_theme_name = "io.elementary.stylesheet.blueberry";
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
                show_title_buttons = true
            };

            set_titlebar (headerbar);
            set_size_request (Jorts.Constants.DEFAULT_PREF_WIDTH, Jorts.Constants.DEFAULT_PREF_HEIGHT);
            set_default_size (Jorts.Constants.DEFAULT_PREF_WIDTH, Jorts.Constants.DEFAULT_PREF_HEIGHT);

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
            var settingsbox = new Gtk.Box (VERTICAL, 24) {
                margin_bottom = 6,
                margin_top = 6,
                margin_start = 6,
                margin_end = 6,
                hexpand = true,
                vexpand = true
            };

                /*************************************************/
                /*              scribbly Toggle                  */
                /*************************************************/

                var scribbly_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

                var scribbly_toggle = new Gtk.Switch () {
                    halign = Gtk.Align.END,
                    hexpand = true,
                    valign = Gtk.Align.CENTER,
                };

                var scribbly_label = new Granite.HeaderLabel (_("Make unfocused notes unreadable")) {
                    mnemonic_widget = scribbly_toggle,
                    secondary_text = _("If enabled, unfocused sticky notes become unreadable to protect their content from peeking eyes (Ctrl+H)")
                };

                scribbly_box.append (scribbly_label);
                scribbly_box.append (scribbly_toggle);
                settingsbox.append (scribbly_box);

                Application.gsettings.bind (
                    "scribbly-mode-active", 
                    scribbly_toggle, "active",
                    SettingsBindFlags.DEFAULT);


                /*************************************************/
                /*               hidebar Toggle                  */
                /*************************************************/

                var hidebar_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

                var hidebar_toggle = new Gtk.Switch () {
                    halign = Gtk.Align.END,
                    hexpand = true,
                    valign = Gtk.Align.CENTER,
                };

                var hidebar_label = new Granite.HeaderLabel (_("Hide buttons")) {
                    mnemonic_widget = hidebar_toggle,
                    secondary_text = _("If enabled, hides the bottom bar in sticky notes. Keyboard shortcuts will still function (Ctrl+T)")
                };

                hidebar_box.append (hidebar_label);
                hidebar_box.append (hidebar_toggle);
                settingsbox.append (hidebar_box); 

                Application.gsettings.bind (
                    "hide-bar",
                    hidebar_toggle, "active",
                    SettingsBindFlags.DEFAULT);

                /*************************************************/
                /*               Autostart Link                  */
                /*************************************************/

            string desktop_environment = Environment.get_variable ("XDG_CURRENT_DESKTOP");
            print (desktop_environment + " detected!");

            // Show only in Pantheon because others do not have an autostart panel
            if (desktop_environment == "Pantheon") {

                var link = Granite.SettingsUri.PERMISSIONS ;
                var linkname = _("Permissions") ;

                var permissions_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
                var permissions_link = new Gtk.LinkButton.with_label (
                                                    link,
                                                    linkname
                                                );

                // _("Applications → Permissions")
                permissions_link.tooltip_text = link;
                permissions_link.halign = Gtk.Align.END;

                var permissions_label = new Granite.HeaderLabel (_("Allow to start at login")) {
                    mnemonic_widget = permissions_link,
                    secondary_text = _("You can set the sticky notes to appear when you log in by adding Jorts to autostart")
                };
                permissions_label.set_hexpand (true);

                permissions_box.append (permissions_label);
                permissions_box.append (permissions_link);
                settingsbox.append (permissions_box);

            // Not Pantheon, not the Windows port. Must be a rando DE
            } else {

                var link = "https://flathub.org/apps/search?q=autostart" ;
                var linkname = _("Autostart apps") ;

                var permissions_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
                var permissions_link = new Gtk.LinkButton.with_label (
                                                    link,
                                                    linkname
                                                );

                // _("Applications → Permissions")
                permissions_link.tooltip_text = link;
                permissions_link.halign = Gtk.Align.END;

                var permissions_label = new Granite.HeaderLabel (_("Allow to start at login")) {
                    mnemonic_widget = permissions_link,
                    secondary_text = _("You can set the sticky notes to appear when you log in by adding Jorts to autostart")
                };
                permissions_label.set_hexpand (true);

                permissions_box.append (permissions_label);
                permissions_box.append (permissions_link);
                settingsbox.append (permissions_box);

            }

            /*************************************************/
            // Bar at the bottom
            var actionbar = new Gtk.ActionBar ();
            actionbar.set_hexpand (true);
            actionbar.set_vexpand (false);

            // Monies?
            var support_button = new Gtk.LinkButton.with_label (
                Jorts.Constants.DONATE_LINK,
                _("Support us!")
            );
            actionbar.pack_start (support_button);

            // Reset
            var reset_button = new Gtk.Button ();
            reset_button.set_label ( _("Reset to Default"));
            reset_button.tooltip_markup = (_("Reset all settings to defaults"));
            actionbar.pack_end (reset_button);

            reset_button.clicked.connect (on_reset);

            //  var close_button = new Gtk.Button();
            //  close_button.set_label( _("Close"));
            //  close_button.clicked.connect(() => {this.close();});
            //  actionbar.pack_end (close_button);

            mainbox.append (settingsbox);
            mainbox.append (actionbar);

            // Make the whole window grabbable
            var handle = new Gtk.WindowHandle () {
                child = mainbox
            };

            this.child = handle;
            this.show ();
            this.present ();
        }

        private void action_new () {
            ((Application)this.application).create_note (null);
        }

        private void on_reset () {
            string[] keys = {"scribbly-mode-active", "hide-bar"};
            foreach (var key in keys) {
                Application.gsettings.reset (key);
            }
        }
    }
}




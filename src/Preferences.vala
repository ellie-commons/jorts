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



*/
namespace jorts {
    public class PreferenceWindow :  Granite.Dialog {



        public PreferenceWindow (GLib.Settings gsettings) {

            set_name (_("Preferences for Jorts"));

            /*************************************************/
            // Box with settingsbox and then reset button
            var mainbox = new Gtk.Box (VERTICAL, 0) {
                margin_bottom = 0,
                margin_top = 0,
            };

            // the box with all the settings
            var settingsbox = new Gtk.Box (VERTICAL, 6) {
                margin_bottom = 12,
                margin_top = 12,
                margin_start = 12,
                margin_end = 12
            };

            var preferences_label = new Granite.HeaderLabel (_("Preferences for all sticky notes"));
            preferences_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);
            settingsbox.append(preferences_label); 



                /*************************************************/
                /*                  Default Font                 */
                /*************************************************/

                var default_font_label = new Granite.HeaderLabel (_("Default Font")) {
                    hexpand = true
                };
                var default_font_button = new Gtk.FontDialogButton (new Gtk.FontDialog ()) {
                    valign = Gtk.Align.CENTER,
                    use_font = true
                };
                var default_font_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
                default_font_box.append (default_font_label);
                default_font_box.append (default_font_button);
                settingsbox.append(default_font_box); 

                gsettings.bind_with_mapping (
                    "font-name", default_font_button,
                    "font-desc", SettingsBindFlags.DEFAULT,
                    font_button_bind_get, font_button_bind_set, null, null);


                /*************************************************/
                /*              Scribble Toggle                  */
                /*************************************************/

                var scribble_toggle = new Gtk.Switch () {
                    halign = Gtk.Align.END,
                    hexpand = true,
                    valign = Gtk.Align.CENTER
                };
                var scribble_label = new Granite.HeaderLabel (_("Activate scribble mode")) {
                    mnemonic_widget = scribble_toggle,
                    secondary_text = _("If enabled, unfocused sticky notes become unreadable to protect their content from peeking eyes")
                };
                var scribble_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);
                scribble_box.append (scribble_label);
                scribble_box.append (scribble_toggle);
                settingsbox.append(scribble_box); 

                scribble_toggle.notify["active"].connect (() => {
                    gsettings.set_boolean ("squiggly-mode-active", scribble_toggle.active);
                });
                gsettings.bind ("squiggly-mode-active", scribble_toggle, "active",SettingsBindFlags.DEFAULT);




            /*************************************************/
            // Bar at the bottom
            var actionbar = new Gtk.ActionBar ();
            actionbar.set_hexpand (true);
            actionbar.set_vexpand (false);

            var reset_button = new Gtk.Button();
            reset_button.set_label( _("Reset to Default"));
            reset_button.tooltip_markup = (_("Reset all settings to defaults"));
            actionbar.pack_start (reset_button);

            reset_button.clicked.connect(() => {
                string[] keys = {"font-name", "squiggly-mode-active"};
                foreach (var key in keys) {
                    interface_settings.reset (key);
                }
            });

        
            var close_button = new Gtk.Button ();
            close_button.set_label(_("Close"));
            close_button.clicked.connect(() => this.close());
            actionbar.pack_end (close_button);


            mainbox.append (settingsbox);
            mainbox.append(actionbar);

            this.child = mainbox;
            this.show ();
            this.present ();
        }

        /**
        * Convert string representation of font to Pango.FontDescription.
        *
        * Note: String format is described at https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html
        * @see SettingsBindGetMappingShared
        */
        protected static bool font_button_bind_get (Value value, Variant variant, void* user_data) {
            string font = variant.get_string ();
            var desc = Pango.FontDescription.from_string (font);
            value.set_boxed (desc);
            return true;
        }

        /**
        * Convert Pango.FontDescription to string representation of font.
        *
        * Note: String format is described at https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html
        * @see SettingsBindSetMappingShared
        */
        protected static Variant font_button_bind_set (Value value, VariantType expected_type, void* user_data) {
            var desc = (Pango.FontDescription) value.get_boxed ();
            string font = desc.to_string ();
            return new Variant.string (font);
        }
    }
}




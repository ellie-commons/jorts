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

            set_name (_("Preferences"));

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

            var preferences_label = new Gtk.Label (_("Preferences")) {
                xalign = 0.0f
            };
            preferences_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

            settingsbox.append(preferences_label); 

            // Scribble mode
            var scribble_toggle = new Granite.SwitchModelButton (_("Activate scribble mode")) {
                description = _("If enabled, unfocused sticky notes become unreadable"),
                active = gsettings.get_boolean ("squiggly-mode-active")
            };
            settingsbox.append (scribble_toggle);




            mainbox.append (settingsbox);
            //mainbox.attach(actionbar);

            this.child = mainbox;
            this.show ();
            this.present ();
        }
    }
}



/*          // Bar at the bottom
        actionbar = new Gtk.ActionBar ();
        actionbar.set_hexpand (true);
        actionbar.set_vexpand (false);

        var reset_button = new Gtk.Button () {
            tooltip_markup = _("Reset all settings to defaults");
        };
        actionbar.pack_end (reset_button);
  */


/*      var reset = add_button (_("Reset to Default"));

    reset.clicked.connect (on_click_reset);
    private void on_click_reset () {
        var reset_confirm_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            _("Are you sure you want to reset personalization?"),
            _("All settings in this pane will be restored to the factory defaults. This action can't be undone."),
            "dialog-warning", Gtk.ButtonsType.CANCEL
        ) {
            modal = true,
            transient_for = (Gtk.Window) get_root ()
        };
        var reset_button = reset_confirm_dialog.add_button (_("Reset"), Gtk.ResponseType.ACCEPT);
        reset_button.add_css_class (Granite.STYLE_CLASS_DESTRUCTIVE_ACTION);
        reset_confirm_dialog.response.connect ((response_id) => {
            if (response_id != Gtk.ResponseType.ACCEPT) {
                reset_confirm_dialog.destroy ();
                return;
            }

            do_reset ();
            reset_confirm_dialog.destroy ();
            restored ();
        });
        reset_confirm_dialog.show ();
    }  */






/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

 public class Jorts.PreferencesView : Gtk.Box {
    public Gtk.Switch scribbly_toggle;
    public Gtk.Switch hidebar_toggle;
    //public Gtk.Button reset_button;
    private Granite.Toast toast;
    public Gtk.Button close_button;

    construct {
        orientation = VERTICAL;
        margin_top = 12;
        margin_bottom = 12;
        margin_start = 12;
        margin_end = 12;

        var overlay = new Gtk.Overlay ();
        append (overlay);

            toast = new Granite.Toast (_("Request to system sent"));
            overlay.add_overlay (toast);

            // the box with all the settings
            var settingsbox = new Gtk.Box (VERTICAL, 24) {
                margin_top = 6,
                margin_start = 6,
                margin_end = 6,
                hexpand = true,
                vexpand = true,
                valign = Gtk.Align.START
            };

                /*************************************************/
                /*              scribbly Toggle                  */
                /*************************************************/

                debug ("Built UI. Lets do connects and binds");

                var scribbly_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

                scribbly_toggle = new Gtk.Switch () {
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


                /*************************************************/
                /*               hidebar Toggle                  */
                /*************************************************/

                var hidebar_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

                hidebar_toggle = new Gtk.Switch () {
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


                /****************************************************/
                /*               Autostart Request                  */
                /****************************************************/

                                    Xdp.Portal portal = new Xdp.Portal ();
                GenericArray<weak string> cmd = new GenericArray<weak string> ();
                cmd.add ("io.github.ellie_commons.jorts");


                var both_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6) {
                    halign = Gtk.Align.FILL
                };

                ///TRANSLATORS: Button to autostart the application
                var set_autostart = new Gtk.Button () {
                    label = _("Set autostart"),
                    valign = Gtk.Align.CENTER
                };
                //set_autostart.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);

                set_autostart.clicked.connect (() => {
                    debug ("Setting autostart");

                    portal.request_background.begin (
                    null,
                    _("Set Jorts to start with the computer"),
                    cmd,
                    Xdp.BackgroundFlags.AUTOSTART,
                    null);

                    toast.send_notification ();
                });

                ///TRANSLATORS: Button to remove the autostart for the application
                var remove_autostart = new Gtk.Button () {
                    label = _("Remove autostart"),
                    valign = Gtk.Align.CENTER
                };
                //remove_autostart.add_css_class (Granite.STYLE_CLASS_DESTRUCTIVE_ACTION);

                remove_autostart.clicked.connect (() => {
                    debug ("Removing autostart");

                    portal.request_background.begin (
                    null,
                    _("Remove Jorts from system autostart"),
                    cmd,
                    Xdp.BackgroundFlags.NONE,
                    null);

                    toast.send_notification ();
                });

                both_buttons.append (set_autostart);
                both_buttons.append (remove_autostart);

                var autostart_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

                var autostart_label = new Granite.HeaderLabel (_("Allow to start at login")) {
                    mnemonic_widget = both_buttons,
                    secondary_text = _("You can request the system to start this application automatically"),
                    hexpand = true
                };

                autostart_box.append (autostart_label);
                autostart_box.append (both_buttons);
                settingsbox.append (autostart_box);

            /*************************************************/
            // Bar at the bottom
            var actionbar = new Gtk.CenterBox () {
                margin_start = 6,
                margin_end = 6,
                valign = Gtk.Align.END
            };
            actionbar.set_hexpand (true);
            actionbar.set_vexpand (false);

            // Monies?
            var support_button = new Gtk.LinkButton.with_label (
                Jorts.Constants.DONATE_LINK,
                _("Support us!")
            );
            actionbar.start_widget = support_button;

            // Reset
            //reset_button = new Gtk.Button ();
            //reset_button.set_label ( _("Reset to Default"));
            //reset_button.tooltip_markup = (_("Reset all settings to defaults"));
            //actionbar.pack_end (reset_button);

            close_button = new Gtk.Button () {
                width_request = 96,
                label = _("Close"),
                tooltip_markup = Granite.markup_accel_tooltip (
                    {"<Alt>F4"},
                    _("Close preferences")
                )
            };
            actionbar.end_widget = close_button;

            append (settingsbox);
            append (actionbar);
    }
}

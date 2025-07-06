/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2017-2024 Lains
 * SPDX-FileCopyrightText: 2025 Stella & Charlie (teamcons.carrd.co)
 * SPDX-FileCopyrightText: 2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


 public class Jorts.PreferencesView : Gtk.Box {
    public Gtk.Switch scribbly_toggle;
    public Gtk.Switch hidebar_toggle;
    public Gtk.Button reset_button;
    private Granite.Toast toast;

    construct {

        orientation = VERTICAL;

        margin_bottom = 6;
        margin_top = 6;
        margin_start = 12;
        margin_end = 12;


        var overlay = new Gtk.Overlay ();
        append (overlay);

            toast = new Granite.Toast (_("Request to system sent"));
            overlay.add_overlay (toast);

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
                    label = _("Set autostart")
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
                    label = _("Remove autostart")
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
                /*               Autostart Link                  */
                /*************************************************/
/*  
            string desktop_environment = Environment.get_variable ("XDG_CURRENT_DESKTOP");
            print ("\nEnvironment: " + desktop_environment + " detected!");

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
  */
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
            reset_button = new Gtk.Button ();
            reset_button.set_label ( _("Reset to Default"));
            reset_button.tooltip_markup = (_("Reset all settings to defaults"));
            actionbar.pack_end (reset_button);


            //  var close_button = new Gtk.Button();
            //  close_button.set_label( _("Close"));
            //  close_button.clicked.connect(() => {this.close();});
            //  actionbar.pack_end (close_button);

            append (settingsbox);
            append (actionbar);
    }

}

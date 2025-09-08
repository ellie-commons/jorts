/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


/* CONTENT

Preferences is boring
Everything is in a Handle so user can move the window from anywhere
It is a box, with inside of it a box and an actionbar

the innerbox has widgets for settings.
the actionbar has a donate me and a set back to defaults just like elementaryOS

*/
public class Jorts.PreferenceWindow : Gtk.ApplicationWindow {

    private static GLib.Once<Jorts.PreferenceWindow> _instance;
    public static unowned Jorts.PreferenceWindow instance () {
            return _instance.once (() => { return new Jorts.PreferenceWindow (); });
        }

    Jorts.PreferencesView prefview;
    public bool is_shown = false;

    public static PreferenceWindow () {
        debug ("Showing preference window");
        Intl.setlocale ();

        hide_on_close = true;

        var gtk_settings = Gtk.Settings.get_default ();

        // Since each sticky note adopts a different accent color
        // we have to revert to default when this one is focused
        this.notify["is-active"].connect (() => {
            if (this.is_active) {
                gtk_settings.gtk_theme_name = "io.elementary.stylesheet.blueberry";
            }
        });

        /********************************************/
        /*              HEADERBAR BS                */
        /********************************************/

        /// TRANSLATORS: Feel free to improvise. The goal is a playful wording to convey the idea of app-wide settings
        var titlelabel = new Gtk.Label (_("Preferences for your Jorts"));
        titlelabel.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);
        set_title (_("Preferences") + _(" - Jorts"));

        var headerbar = new Gtk.HeaderBar () {
            title_widget = titlelabel,
            show_title_buttons = false
        };
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);

        set_titlebar (headerbar);
        set_size_request (Jorts.Constants.DEFAULT_PREF_WIDTH, Jorts.Constants.DEFAULT_PREF_HEIGHT);
        set_default_size (Jorts.Constants.DEFAULT_PREF_WIDTH, Jorts.Constants.DEFAULT_PREF_HEIGHT);
        resizable = false;

        add_css_class (Granite.STYLE_CLASS_MESSAGE_DIALOG);

        prefview = new Jorts.PreferencesView ();

        // Make the whole window grabbable
        var handle = new Gtk.WindowHandle () {
            child = prefview
        };

        this.child = handle;

        set_focus (prefview.close_button);

        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        Application.gsettings.bind (
            "scribbly-mode-active",
            prefview.scribbly_toggle, "active",
            SettingsBindFlags.DEFAULT);


        Application.gsettings.bind (
            "hide-bar",
            prefview.hidebar_toggle, "active",
            SettingsBindFlags.DEFAULT);

        //prefview.reset_button.clicked.connect (on_reset);
        prefview.close_button.clicked.connect (() => {close ();});

        show.connect (() => {
            is_shown = true;
        });

        close_request.connect (() => {
            is_shown = false;
            ((Jorts.Application)application).check_if_quit ();
            return false;
        });

    }

/*      private void on_reset () {
        debug ("Resetting settings…");

        string[] keys = {"scribbly-mode-active", "hide-bar"};
        foreach (var key in keys) {
            Application.gsettings.reset (key);
        }
    }  */
}

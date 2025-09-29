/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/**
* The popover menu to tweak individual notes
* Contains a setting for color, one for monospace font, one for zoom
*/
public class Jorts.PopoverView : Gtk.Popover {
    private Jorts.StickyNoteWindow parent_window;
    private Jorts.ColorBox color_button_box;
    private Jorts.MonospaceBox monospace_box;
    private Jorts.ZoomBox font_size_box;

    private Themes _old_color = Jorts.Constants.DEFAULT_THEME;
    public Themes color {
        get {return _old_color;}
        set {on_color_changed (value);}
    }

    public bool monospace {
        get {return monospace_box.monospace;}
        set {on_monospace_changed (value);}
    }

    private uint8 _old_zoom;
    public uint8 zoom {
        get {return font_size_box.zoom;}
        set {do_set_zoom (value);}
    }

    public signal void theme_changed (Jorts.Themes selected);
    public signal void zoom_changed (Jorts.Zoomkind zoomkind);
    public signal void monospace_changed (bool if_monospace);

    /****************/
    public PopoverView (Jorts.StickyNoteWindow window) {
        position = Gtk.PositionType.TOP;
        halign = Gtk.Align.END;
        parent_window = window;

        var view = new Gtk.Box (VERTICAL, 12) {
            margin_top = 12,
            margin_bottom = 12
        };

        color_button_box = new Jorts.ColorBox ();
        monospace_box = new Jorts.MonospaceBox ();
        font_size_box = new Jorts.ZoomBox ();

        view.append (color_button_box);
        view.append (monospace_box);
        view.append (font_size_box);

        child = view;

        color_button_box.theme_changed.connect (on_color_changed);
        monospace_box.monospace_changed.connect (on_monospace_changed);
        font_size_box.zoom_changed.connect (on_zoom_changed);
    }



    /**
    * Switches stylesheet
    * First use appropriate stylesheet, Then switch the theme classes
    */
    private void on_color_changed (Jorts.Themes new_theme) {
        debug ("Updating theme to %s".printf (new_theme.to_string ()));

        // Avoid deathloop where the handler calls itself
        color_button_box.theme_changed.disconnect (on_color_changed);

        // Accent
        var stylesheet = "io.elementary.stylesheet." + new_theme.to_css_class ();
        parent_window.gtk_settings.gtk_theme_name = stylesheet;

        // Add remove class
        if (_old_color.to_string () in parent_window.css_classes) {
            parent_window.remove_css_class (_old_color.to_string ());
        }
        parent_window.add_css_class (new_theme.to_string ());

        // Propagate values
        _old_color = new_theme;
        color_button_box.color = new_theme;
        NoteData.latest_theme = new_theme;

        // Cleanup
        ((Jorts.Application)parent_window.application).manager.save_all ();
        color_button_box.theme_changed.connect (on_color_changed);
    }

    /**
    * Switches the .monospace class depending on the note setting
    */
    private void on_monospace_changed (bool monospace) {
        debug ("Updating monospace to %s".printf (monospace.to_string ()));

        parent_window.view.monospace = monospace;
        monospace_box.monospace = monospace;
        Jorts.NoteData.latest_mono = monospace;

        ((Jorts.Application)parent_window.application).manager.save_all ();
    }


    /*********************************************/
    /*              ZOOM feature                 */
    /*********************************************/

    /**
    * Called when a signal from the popover says stuff got changed
    */
    private void on_zoom_changed (Jorts.Zoomkind zoomkind) {
        debug ("Zoom changed!");

        switch (zoomkind) {
            case Zoomkind.ZOOM_IN:              zoom_in (); break;          // vala-lint=double-spaces
            case Zoomkind.DEFAULT_ZOOM:         zoom_default (); break;     // vala-lint=double-spaces
            case Zoomkind.ZOOM_OUT:             zoom_out (); break;         // vala-lint=double-spaces
            default:                            zoom_default (); break;     // vala-lint=double-spaces
        }
        ((Jorts.Application)parent_window.application).manager.save_all ();
    }

    /**
    * Wrapper to check an increase doesnt go above limit
    */
    public void zoom_in () {
        if ((_old_zoom + 20) <= Jorts.Constants.ZOOM_MAX) {
            zoom = _old_zoom + 20;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    public void zoom_default () {
        if (_old_zoom != Jorts.Constants.DEFAULT_ZOOM ) {
            zoom = Jorts.Constants.DEFAULT_ZOOM;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    /**
    * Wrapper to check an increase doesnt go below limit
    */
    public void zoom_out () {
        if ((_old_zoom - 20) >= Jorts.Constants.ZOOM_MIN) {
            zoom = _old_zoom - 20;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    /**
    * Switch zoom classes, then reflect in the UI and tell the application
    */
    private void do_set_zoom (uint8 new_zoom) {
        debug ("Setting zoom: " + zoom.to_string ());

        // Switches the classes that control font size
        parent_window.remove_css_class (Jorts.Utils.zoom_to_class ( _old_zoom));
        _old_zoom = new_zoom;
        parent_window.add_css_class (Jorts.Utils.zoom_to_class ( new_zoom));

        // Adapt headerbar size to avoid weird flickering
        parent_window.view.headerbar.height_request = Jorts.Utils.zoom_to_ui_size (_old_zoom);

        // Reflect the number in the popover
        font_size_box.zoom = new_zoom;

        // Keep it for next new notes
        //((Application)this.application).latest_zoom = zoom;
        NoteData.latest_zoom = zoom;
    }

}

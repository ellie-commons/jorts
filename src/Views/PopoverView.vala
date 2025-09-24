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

    public Themes color {
        get {return color_button_box.color;}
        set {color_button_box.color = value;}
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

        /* APPENDS */
        view.append (color_button_box);
        view.append (monospace_box);
        //view.append (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        view.append (font_size_box);

        child = view;

        color_button_box.theme_changed.connect ((selected) => {theme_changed (selected);});
        monospace_box.monospace_changed.connect (on_monospace_changed);
        font_size_box.zoom_changed.connect (on_zoom_changed);
    }




    /**
    * Switches the .monospace class depending on the note setting
    */  
    private void on_monospace_changed (bool monospace) {
        debug ("Updating monospace to %s".printf (monospace.to_string ()));

        if (monospace) {
            parent_window.editableheader.add_css_class ("monospace");

        } else {
            if ("monospace" in parent_window.editableheader.css_classes) {
                parent_window.editableheader.remove_css_class ("monospace");
            }

        }
        parent_window.view.textview.monospace = monospace;
        monospace_box.monospace = monospace;
        Jorts.NoteData.latest_mono = monospace;
        parent_window.changed ();
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
            case Zoomkind.ZOOM_IN:              zoom_in (); break;
            case Zoomkind.DEFAULT_ZOOM:         zoom_default (); break;
            case Zoomkind.ZOOM_OUT:             zoom_out (); break;
            default:                            zoom_default (); break;
        }
        ((Jorts.Application)parent_window.application).manager.save_all.begin ();
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
        parent_window.headerbar.height_request = Jorts.Utils.zoom_to_UIsize (_old_zoom);

        // Reflect the number in the popover
        font_size_box.zoom = new_zoom;

        // Keep it for next new notes
        //((Application)this.application).latest_zoom = zoom;
        NoteData.latest_zoom = zoom;
    }

}

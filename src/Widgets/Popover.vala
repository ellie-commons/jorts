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

    public uint16 zoom { set {font_size_box.zoom = value;}}

    public signal void theme_changed (Jorts.Themes selected);
    public signal void zoom_changed (Jorts.Zoomkind zoomkind);
    public signal void monospace_changed (bool if_monospace);

    static construct
    {
        add_binding_action(Gdk.Key.plus, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_ZOOM_IN, null);
        add_binding_action(Gdk.Key.equal, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_ZOOM_DEFAULT, null);    
        add_binding_action(48, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_ZOOM_DEFAULT, null);    
        add_binding_action(Gdk.Key.minus, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_ZOOM_OUT, null);

        add_binding_action(Gdk.Key.w, Gdk.ModifierType.CONTROL_MASK, Application.ACTION_PREFIX + Application.ACTION_NEW, null);
        add_binding_action(Gdk.Key.w, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_DELETE, null);
        add_binding_action(Gdk.Key.m, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_TOGGLE_MONO, null);    
        add_binding_action(Gdk.Key.g, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_SHOW_MENU, null);
        add_binding_action(Gdk.Key.o, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_SHOW_MENU, null);
        add_binding_action(Gdk.Key.l, Gdk.ModifierType.CONTROL_MASK, StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_FOCUS_TITLE, null);
   }


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
        font_size_box.zoom_changed.connect ((zoomkind) => {this.zoom_changed (zoomkind);});
    }



    /**
    * Switches stylesheet
    * First use appropriate stylesheet, Then switch the theme classes
    */
    private void on_color_changed (Jorts.Themes new_theme) {
        debug ("Updating theme to %s".printf (new_theme.to_string ()));

        // Avoid deathloop where the handler calls itself
        color_button_box.theme_changed.disconnect (on_color_changed);

        // Add remove class
        if (_old_color.to_string () in parent_window.css_classes) {
            parent_window.remove_css_class (_old_color.to_string ());
        }
        parent_window.add_css_class (new_theme.to_string ());

        // Propagate values
        _old_color = new_theme;
        color_button_box.color = new_theme;
        NoteData.latest_theme = new_theme;

        // Cleanup;
        parent_window.changed ();
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

       parent_window.changed ();
    }
}

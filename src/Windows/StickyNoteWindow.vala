/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


/* CONTENT

Each StickyNoteWindow instance is a sticky note
It takes a NoteData, and creates the UI

It is connected to settings and reacts to changes

It sometimes calls Application methods for actions that requires higher oversight level
like creating a new note, or saving

Notably, it interacts with popover - a SettingsPopover instant, where stuff is more hairy
Both interact through signals and methods.

A method packages the informations into one NoteData
Theme and Zoom changing are just a matter of adding and removing classes


*/
public class Jorts.StickyNoteWindow : Gtk.ApplicationWindow {
    public Gtk.Settings gtk_settings;

    private Gtk.HeaderBar headerbar;
    public Gtk.EditableLabel editableheader;
    private Jorts.NoteView view;
    private PopoverView popover;
    public TextView textview;

    private Themes _old_color;
    public Jorts.Themes color {
        get { return popover.color;}
        set { popover.color = value; on_theme_changed (value);}
    }

    public bool monospace {
        get { return popover.monospace;}
        set { on_monospace_changed (value);}
    }

    private int _old_zoom;
    public int zoom {
        get { return popover.zoom;}
        set { do_set_zoom (value);}
    }

    public NoteData data {
        owned get { return packaged ();}
        set { load_data (value);}
    }


    private static uint debounce_timer_id;

    // Connected to by the NoteManager to know it is time to save
    public signal void changed ();

    private const string ACTION_PREFIX = "app.";
    private const string ACTION_DELETE = "action_delete";
    private const string ACTION_SHOW_EMOJI = "action_show_emoji";
    private const string ACTION_SHOW_MENU = "action_show_menu";
    private const string ACTION_FOCUS_TITLE = "action_focus_title";
    private const string ACTION_ZOOM_OUT = "action_zoom_out";
    private const string ACTION_ZOOM_DEFAULT = "action_zoom_default";
    private const string ACTION_ZOOM_IN = "action_zoom_in";

    public static Gee.MultiMap<string, string> action_accelerators;

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_DELETE, action_delete},
        { ACTION_SHOW_EMOJI, action_show_emoji},
        { ACTION_SHOW_MENU, action_show_menu},
        { ACTION_FOCUS_TITLE, action_focus_title},
        { ACTION_ZOOM_OUT, action_zoom_out},
        { ACTION_ZOOM_DEFAULT, action_zoom_default},
        { ACTION_ZOOM_IN, action_zoom_in},
    };

    public StickyNoteWindow (Gtk.Application app, NoteData data) {
        Intl.setlocale ();
        debug ("[STICKY NOTE] New StickyNoteWindow instance!");
        application = app;

        var actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("app", actions);

        gtk_settings = Gtk.Settings.get_default ();

        add_css_class ("rounded");
        title = "" + _(" - Jorts");


        /*****************************************/
        /*              HEADERBAR                */
        /*****************************************/

        this.headerbar = new Gtk.HeaderBar () {
            show_title_buttons = false
        };
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        headerbar.add_css_class ("headertitle");


        // Defime the label you can edit. Which is editable.
        editableheader = new Gtk.EditableLabel ("") {
            xalign = 0.5f,
            halign = Gtk.Align.CENTER,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>L"},
                _("Click to edit the title")
            )
        };
        editableheader.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);
        headerbar.set_title_widget (editableheader);
        this.set_titlebar (headerbar);

        view = new NoteView ();
        view.delete_item.action_name = ACTION_PREFIX + ACTION_DELETE;
        textview = view.textview;

        popover = new Jorts.PopoverView ();
        view.menu_button.popover = popover;

        set_child (view);
        set_focus (view);


        /****************************************/
        /*              LOADING                 */
        /****************************************/
 

        on_scribbly_changed ();
        load_data (data);


        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        debug ("Built UI. Lets do connects and binds");

        // Save when title or text have changed
        editableheader.changed.connect (on_editable_changed);
        view.textview.buffer.changed.connect (debounce_save);

        popover.theme_changed.connect (on_theme_changed);
        popover.monospace_changed.connect (on_monospace_changed);
        popover.zoom_changed.connect (on_zoom_changed);

        // Use the color theme of this sticky note when focused
        this.notify["is-active"].connect (on_focus_changed);

        //The application tells us the squiffly state has changed!
        Application.gsettings.changed["scribbly-mode-active"].connect (on_scribbly_changed);

        // Respect animation settings for showing ui elements
        if (Gtk.Settings.get_default ().gtk_enable_animations && (!Application.gsettings.get_boolean ("hide-bar"))) {
                show.connect_after (delayed_show);

        } else {
            Application.gsettings.bind (
                "hide-bar",
                view.actionbar,
                "revealed",
                SettingsBindFlags.INVERT_BOOLEAN);
        }
    } // END OF MAIN CONSTRUCT


        /********************************************/
        /*                  METHODS                 */
        /********************************************/

    /**
    * Show UI elements shorty after the window is shown
    */
    private void delayed_show () {
        Timeout.add_once (1000, () => {    
            Application.gsettings.bind (
                "hide-bar",
                view.actionbar,
                "revealed",
                SettingsBindFlags.INVERT_BOOLEAN);
        });
        show.disconnect (delayed_show);
    }

    // Add a debounce so we aren't writing the entire buffer every character input
    private void debounce_save () {
        debug ("Changed! Timer: %s".printf (debounce_timer_id.to_string ()));

        if (debounce_timer_id != 0) {
            GLib.Source.remove (debounce_timer_id);
        }

        debounce_timer_id = Timeout.add (Jorts.Constants.DEBOUNCE, () => {
            debounce_timer_id = 0;
            changed ();
            return GLib.Source.REMOVE;
        });
    }

    private void on_editable_changed () {
        title = editableheader.text + _(" - Jorts");
        debounce_save ();
    }

    // Called when a change in settings is detected
    private void on_scribbly_changed () {
        debug ("Scribbly mode changed!");

        if (Application.gsettings.get_boolean ("scribbly-mode-active")) {
            if (this.is_active == false) {
                this.add_css_class ("scribbly");
            }

        } else {
            if (this.is_active == false) {
                this.remove_css_class ("scribbly");
            }
        }
    }

    // 
    /**
    * Changes the stylesheet accents to the notes color
    * Add or remove the Redacted font if the setting is active
    */
    private void on_focus_changed () {
        debug ("Focus changed!");

        if (this.is_active) {
            var stylesheet = "io.elementary.stylesheet." + color.to_string ().ascii_down ();
            gtk_settings.gtk_theme_name = stylesheet;
        }

        if (Application.gsettings.get_boolean ("scribbly-mode-active")) {
            if (this.is_active) {
                this.remove_css_class ("scribbly");
            } else {
                this.add_css_class ("scribbly");
            }
        } else if ("scribbly" in this.css_classes) {
            this.remove_css_class ("scribbly");
        }
    }

    /**
    * Package the note into a NoteData and pass it back
    */
    public NoteData packaged () {
        debug ("Packaging into a noteData…");

        var content = this.view.textview.buffer.text;

        int width ; int height;
        this.get_default_size (out width, out height);

        var data = new NoteData (
                editableheader.text,
            color,
            content,
            view.textview.monospace,
            this.zoom,
                width,
                height);

        return data;
    }

    /**
    * Propagate the content of a NoteData into the various UI elements
    */    
    private void load_data (NoteData data) {
        debug ("Loading noteData…");

        set_default_size (data.width, data.height);
        editableheader.text = data.title;
        title = editableheader.text + _(" - Jorts");
        view.textview.buffer.text = data.content;

        zoom = data.zoom;
        monospace = data.monospace;
        color = data.theme;
    }

    /**
    * Switches stylesheet
    * First use appropriate stylesheet, Then switch the theme classes
    */  
    private void on_theme_changed (Jorts.Themes new_theme) {
        debug ("Updating theme to %s".printf (new_theme.to_string ()));

        print (" - " + new_theme.to_nicename ());

        var stylesheet = "io.elementary.stylesheet." + new_theme.to_css_class ();
        this.gtk_settings.gtk_theme_name = stylesheet;

        if (_old_color.to_string () in css_classes) {
            remove_css_class (_old_color.to_string ());
        }

        _old_color = new_theme;
        add_css_class (new_theme.to_string ());
        NoteData.latest_theme = new_theme;
        changed ();
    }

    /**
    * Switches the .monospace class depending on the note setting
    */  
    private void on_monospace_changed (bool monospace) {
        debug ("Updating monospace to %s".printf (monospace.to_string ()));

        if (monospace) {
            editableheader.add_css_class ("monospace");

        } else {
            if ("monospace" in editableheader.css_classes) {
                editableheader.remove_css_class ("monospace");
            }

        }
        view.textview.monospace = monospace;
        popover.monospace = monospace;
        Jorts.NoteData.latest_mono = monospace;
        changed ();
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
            case Zoomkind.DEFAULT_ZOOM:         zoom = 100; break;
            case Zoomkind.ZOOM_OUT:             zoom_out (); break;
            default:                            zoom = 100; break;
        }
        ((Jorts.Application)this.application).manager.save_all.begin ();
    }

    /**
    * Wrapper to check an increase doesnt go above limit
    */  
    public void zoom_in () {
        if ((_old_zoom + 20) <= Jorts.Constants.ZOOM_MAX) {
            zoom = _old_zoom + 20;
        }
    }

    public void zoom_default () {
        zoom = Jorts.Constants.DEFAULT_ZOOM;
    }

    /**
    * Wrapper to check an increase doesnt go below limit
    */  
    public void zoom_out () {
        if ((_old_zoom - 20) >= Jorts.Constants.ZOOM_MIN) {
            zoom = _old_zoom - 20;
        }
    }

    /**
    * Switch zoom classes, then reflect in the UI and tell the application
    */  
    private void do_set_zoom (int zoom) {
        debug ("Setting zoom: " + zoom.to_string ());

        // Switches the classes that control font size
        this.remove_css_class (Jorts.Utils.zoom_to_class ( _old_zoom));
        _old_zoom = zoom;
        this.add_css_class (Jorts.Utils.zoom_to_class ( _old_zoom));

        this.headerbar.height_request = Jorts.Utils.zoom_to_UIsize (_old_zoom);

        // Reflect the number in the popover
        popover.zoom = zoom;

        // Keep it for next new notes
        //((Application)this.application).latest_zoom = zoom;
        NoteData.latest_zoom = zoom;
    }

    private void action_focus_title () {set_focus (editableheader); editableheader.editing = true;}
    private void action_show_emoji () {view.emoji_button.activate ();}
    private void action_show_menu () {view.menu_button.activate ();}
    private void action_delete () {((Jorts.Application)this.application).manager.delete_note (this);}

    private void action_zoom_out () {zoom_out ();}
    private void action_zoom_default () {zoom_default ();}
    private void action_zoom_in () {zoom_in ();}
}

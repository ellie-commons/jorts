/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


/**
* Represents a Sticky Note, with its own settings and content
* There is a View, which contains the text
* There is a Popover, which manages the per-window settings (Tail wagging the dog situation)
* Can be packaged into a noteData file for convenient storage
* Reports to the NoteManager for saving
*/
public class Jorts.StickyNoteWindow : Gtk.ApplicationWindow {
    public Gtk.Settings gtk_settings;

    public Gtk.EditableLabel editableheader;
    public Jorts.NoteView view;
    private PopoverView popover;
    public TextView textview;

    public NoteData data {
        owned get { return packaged ();}
        set { load_data (value);}
    }

    private static uint debounce_timer_id;

    private const string ACTION_PREFIX = "app.";
    private const string ACTION_DELETE = "action_delete";
    private const string ACTION_SHOW_EMOJI = "action_show_emoji";
    private const string ACTION_SHOW_MENU = "action_show_menu";
    private const string ACTION_FOCUS_TITLE = "action_focus_title";
    private const string ACTION_ZOOM_OUT = "action_zoom_out";
    private const string ACTION_ZOOM_DEFAULT = "action_zoom_default";
    private const string ACTION_ZOOM_IN = "action_zoom_in";

    private const string ACTION_THEME_1 = "action_theme_1";
    private const string ACTION_THEME_2 = "action_theme_2";
    private const string ACTION_THEME_3 = "action_theme_3";
    private const string ACTION_THEME_4 = "action_theme_4";
    private const string ACTION_THEME_5 = "action_theme_5";
    private const string ACTION_THEME_6 = "action_theme_6";
    private const string ACTION_THEME_7 = "action_theme_7";
    private const string ACTION_THEME_8 = "action_theme_8";
    private const string ACTION_THEME_9 = "action_theme_9";
    private const string ACTION_THEME_0 = "action_theme_0";
    
    public static Gee.MultiMap<string, string> action_accelerators;

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_DELETE, action_delete},
        { ACTION_SHOW_EMOJI, action_show_emoji},
        { ACTION_SHOW_MENU, action_show_menu},
        { ACTION_FOCUS_TITLE, action_focus_title},
        { ACTION_ZOOM_OUT, action_zoom_out},
        { ACTION_ZOOM_DEFAULT, action_zoom_default},
        { ACTION_ZOOM_IN, action_zoom_in},
        { ACTION_THEME_1, action_theme_1},
        { ACTION_THEME_2, action_theme_2},
        { ACTION_THEME_3, action_theme_3},
        { ACTION_THEME_4, action_theme_4},
        { ACTION_THEME_5, action_theme_5},
        { ACTION_THEME_6, action_theme_6},
        { ACTION_THEME_7, action_theme_7},
        { ACTION_THEME_8, action_theme_8},
        { ACTION_THEME_9, action_theme_9},
        { ACTION_THEME_0, action_theme_0},
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

        var headerbar = new Gtk.HeaderBar () {
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

        popover = new Jorts.PopoverView (this);
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
    } 


        /********************************************/
        /*                  METHODS                 */
        /********************************************/

    /**
    * Show Actionbar shortly after the window is shown
    * This is more for the Aesthetic
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

    /**
    * Debouncer to avoid writing to disk all the time constantly
    * Called when something has changed
    */
    private void debounce_save () {
        debug ("Changed! Timer: %s".printf (debounce_timer_id.to_string ()));

        if (debounce_timer_id != 0) {
            GLib.Source.remove (debounce_timer_id);
        }

        debounce_timer_id = Timeout.add (Jorts.Constants.DEBOUNCE, () => {
            debounce_timer_id = 0;
            ((Jorts.Application)application).manager.save_all ();
            return GLib.Source.REMOVE;
        });
    }

    /**
    * Simple handler for the EditableLabel
    */
    private void on_editable_changed () {
        title = editableheader.text + _(" - Jorts");
        debounce_save ();
    }

    /**
    * Handler for scribbly mode settings changed
    */
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

    /**
    * Changes the stylesheet accents to the notes color
    * Add or remove the Redacted font if the setting is active
    */
    private void on_focus_changed () {
        debug ("Focus changed!");

        if (this.is_active) {
            var stylesheet = "io.elementary.stylesheet." + popover.color.to_string ().ascii_down ();
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
    * Package the note into a NoteData and pass it back.
    * Used by NoteManager to pass all informations conveniently for storage
    */
    public NoteData packaged () {
        debug ("Packaging into a noteData…");

        var content = this.view.textview.buffer.text;

        int width ; int height;
        this.get_default_size (out width, out height);

        var data = new NoteData (
                editableheader.text,
                popover.color,
                content,
                popover.monospace,
                popover.zoom,
                width,
                height);

                print (" " + popover.color.to_string ());

        return data;
    }

    /**
    * Propagate the content of a NoteData into the various UI elements. Used when creating a new window
    */    
    private void load_data (NoteData data) {
        debug ("Loading noteData…");

        set_default_size (data.width, data.height);
        editableheader.text = data.title;
        title = editableheader.text + _(" - Jorts");
        view.textview.buffer.text = data.content;

        popover.zoom = data.zoom;
        popover.monospace = data.monospace;
        popover.color = data.theme;
    }

    private void action_focus_title () {set_focus (editableheader); editableheader.editing = true;}
    private void action_show_emoji () {view.emoji_button.activate ();}
    private void action_show_menu () {view.menu_button.activate ();}
    private void action_delete () {((Jorts.Application)this.application).manager.delete_note (this);}

    private void action_zoom_out () {popover.zoom_out ();}
    private void action_zoom_default () {popover.zoom_default ();}
    private void action_zoom_in () {popover.zoom_in ();}

    private void action_theme_1 () {popover.color = (Jorts.Themes.all ())[0];}
    private void action_theme_2 () {popover.color = (Jorts.Themes.all ())[1];}
    private void action_theme_3 () {popover.color = (Jorts.Themes.all ())[2];}
    private void action_theme_4 () {popover.color = (Jorts.Themes.all ())[3];}
    private void action_theme_5 () {popover.color = (Jorts.Themes.all ())[4];}
    private void action_theme_6 () {popover.color = (Jorts.Themes.all ())[5];}
    private void action_theme_7 () {popover.color = (Jorts.Themes.all ())[6];}
    private void action_theme_8 () {popover.color = (Jorts.Themes.all ())[7];}
    private void action_theme_9 () {popover.color = (Jorts.Themes.all ())[8];}
    private void action_theme_0 () {popover.color = (Jorts.Themes.all ())[9];}
}

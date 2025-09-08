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

    private string _theme;

    public string theme {
        get { return _theme;}
        set {on_theme_changed (value);}
    }


    public bool monospace {
        get { return view.textview.monospace;}
        set {on_monospace_changed (value);}
    }

    private int _zoom;
    public int zoom {
        get { return _zoom;}
        set {do_set_zoom (value);}
    }


    public static uint debounce_timer_id;

    public const string ACTION_PREFIX = "app.";
    public const string ACTION_DELETE = "action_delete";
    public const string ACTION_SHOW_EMOJI = "action_show_emoji";
    public const string ACTION_SHOW_MENU = "action_show_menu";
    public const string ACTION_FOCUS_TITLE = "action_focus_title";
    public const string ACTION_ZOOM_OUT = "action_zoom_out";
    public const string ACTION_ZOOM_DEFAULT = "action_zoom_default";
    public const string ACTION_ZOOM_IN = "action_zoom_in";

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
        debug ("New StickyNoteWindow instance!");

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
 
        set_default_size (data.width, data.height);
        editableheader.text = data.title;
        title = editableheader.text + _(" - Jorts");
        view.textview.buffer.text = data.content;


        popover.color_button_box.set_toggles (data.theme);

        this.zoom = data.zoom;
        this.monospace = data.monospace;
        this.theme = data.theme;


        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        debug ("Built UI. Lets do connects and binds");

        // Save when title or text have changed
        editableheader.changed.connect (on_editable_changed);
        view.textview.buffer.changed.connect (on_buffer_changed);

        // The settings popover tells us a new theme has been chosen!
        popover.theme_changed.connect (on_theme_changed);

        // The settings popover tells us a new zoom has been chosen!
        popover.monospace_changed.connect (on_monospace_changed);

        // The settings popover tells us a new zoom has been chosen!
        popover.zoom_changed.connect (on_zoom_changed);

        // Use the color theme of this sticky note when focused
        this.notify["is-active"].connect (on_focus_changed);

        //The application tells us the squiffly state has changed!
        Application.gsettings.changed["scribbly-mode-active"].connect (on_scribbly_changed);

    } // END OF MAIN CONSTRUCT


        /********************************************/
        /*                  METHODS                 */
        /********************************************/

    // Add a debounce so we aren't writing the entire buffer every character input
    public void on_buffer_changed () {
        debug ("Buffer changed!");

        if (debounce_timer_id != 0) {
            GLib.Source.remove (debounce_timer_id);
        }

        debounce_timer_id = Timeout.add (Jorts.Constants.DEBOUNCE, () => {
            debounce_timer_id = 0;
            ((Application)this.application).manager.save_to_stash ();
            return GLib.Source.REMOVE;
        });
    }

    public void on_editable_changed () {
        title = editableheader.text + _(" - Jorts");
        on_buffer_changed ();
    }

    // Called when a change in settings is detected
    public void on_scribbly_changed () {
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


    // Called when the window is-active property changes
    public void on_focus_changed () {
        debug ("Focus changed!");

        if (this.is_active) {
            var stylesheet = "io.elementary.stylesheet." + this.theme.ascii_down ();
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

    // Package the note into a NoteData and pass it back
    // NOTE: We cannot access the buffer if the window is closed, leading to content loss
    // Hence why we need to constantly save the buffer into this.content when changed
    public NoteData packaged () {
        debug ("Packaging into a noteData…");

        var content = this.view.textview.buffer.text;

        int width ; int height;
        this.get_default_size (out width, out height);

        var data = new NoteData (
                editableheader.text,
            this.theme,
            content,
            view.textview.monospace,
            this.zoom,
                width,
                height);

        return data;
    }

    // Switches stylesheet
    // First use appropriate stylesheet, Then switch the theme classes
    private void on_theme_changed (string new_theme) {
        debug ("Updating theme to %s".printf (new_theme));

        var stylesheet = "io.elementary.stylesheet." + new_theme.ascii_down ();
        this.gtk_settings.gtk_theme_name = stylesheet;

        if (_theme in css_classes) {
            remove_css_class (_theme);
        }

        _theme = new_theme;
        add_css_class (new_theme);

        ((Application)this.application).manager.save_to_stash ();
    }


    // Switches stylesheet
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
        popover.monospace_box.monospace = monospace;
        ((Application)this.application).manager.save_to_stash ();
    }


    /*********************************************/
    /*              ZOOM feature                 */
    /*********************************************/

    // Called when a signal from the popover says stuff got changed
    public void on_zoom_changed (string zoomkind) {
        debug ("Zoom changed!");

        switch (zoomkind) {
            case "zoom_in":     zoom_in (); break;
            case "zoom_out":    zoom_out (); break;
            case "reset":       zoom = 100; break;
            default:            zoom = 100; break;
        }
        ((Jorts.Application)this.application).manager.save_to_stash ();
    }

    // First check an increase doesnt go above limit
    public void zoom_in () {
        if ((_zoom + 20) <= Jorts.Constants.ZOOM_MAX) {
            zoom = _zoom + 20;
        }
    }

    public void zoom_default () {
        zoom = Jorts.Constants.DEFAULT_ZOOM;
    }

    // First check an increase doesnt go below limit
    public void zoom_out () {
        if ((_zoom - 20) >= Jorts.Constants.ZOOM_MIN) {
            zoom = _zoom - 20;
        }
    }

    // Switch zoom classes, then reflect in the UI and tell the application
    public void do_set_zoom (int zoom) {
        debug ("Setting zoom: " + zoom.to_string ());

        // Switches the classes that control font size
        this.remove_css_class (Jorts.Utils.zoom_to_class ( _zoom));
        _zoom = zoom;
        this.add_css_class (Jorts.Utils.zoom_to_class ( _zoom));

        this.headerbar.height_request = Jorts.Utils.zoom_to_UIsize (_zoom);

        // Reflect the number in the popover
        popover.font_size_box.zoom = zoom;

        // Keep it for next new notes
        //((Application)this.application).latest_zoom = zoom;
        ((Jorts.Application)this.application).manager.latest_zoom = zoom;
    }

    public void action_focus_title () {set_focus (editableheader); editableheader.editing = true;}
    public void action_show_emoji () {view.emoji_button.activate ();}
    public void action_show_menu () {view.menu_button.activate ();}
    private void action_delete () {((Jorts.Application)this.application).manager.delete_note (this);}

    private void action_zoom_out () {zoom_out ();}
    private void action_zoom_default () {zoom_default ();}
    private void action_zoom_in () {zoom_in ();}
}

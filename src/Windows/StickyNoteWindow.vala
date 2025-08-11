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
public class Jorts.StickyNoteWindow : Gtk.Window {
    public Gtk.Settings gtk_settings;

    public Gtk.EditableLabel editableheader;
    private Jorts.StickyView view;
    private Gtk.HeaderBar headerbar;
    private Gtk.ActionBar actionbar;
    private Gtk.Button new_item;
    private Gtk.Button delete_item;
    private Gtk.MenuButton emoji_button;
    private Gtk.MenuButton menu_button;
    private PopoverView popover;

    public Jorts.NoteData data;

    public string title_name;
    public string theme;
    public string content;
    public int zoom;

    public uint debounce_timer_id;

    /*************************************************/
    /*           Lets build a window                 */
    /*************************************************/

    public StickyNoteWindow (Gtk.Application app, NoteData data) {
        Intl.setlocale ();
        debug ("New StickyNoteWindow instance: " + data.title);

        application = app;

        this.gtk_settings = Gtk.Settings.get_default ();


        /*****************************************/
        /*              LOAD NOTE                */
        /*****************************************/

        this.data = data;
        this.title_name = data.title;
        this.theme = data.theme;
        this.zoom = data.zoom;
        this.content = data.content;

        title = data.title + _(" - Jorts");

        this.set_default_size (
            data.width,
            data.height
        );

        // Rebuild the whole theming
        this.on_theme_updated (this.theme);

        // add required base classes
        this.add_css_class ("rounded");

        if (gtk_settings.gtk_enable_animations) {
            this.add_css_class ("animated");
        }

        /*****************************************/
        /*              HEADERBAR                */
        /*****************************************/

        this.headerbar = new Gtk.HeaderBar ();
        headerbar.add_css_class ("flat");
        headerbar.add_css_class ("headertitle");
        //header.has_subtitle = false;

        //headerbar.decoration_layout = "close:";
        headerbar.set_show_title_buttons (false);
        headerbar.height_request = Jorts.Utils.zoom_to_UIsize (this.zoom);

        // Defime the label you can edit. Which is editable.
        editableheader = new Gtk.EditableLabel (this.title_name) {
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>L"},
                _("Click to edit the title")
            ),
            halign = Gtk.Align.CENTER,
            xalign = 0.5f
        };
        editableheader.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);
        headerbar.set_title_widget (editableheader);
        this.set_titlebar (headerbar);


        /**********************************************/
        /*              USER INTERFACE                */
        /**********************************************/


        // Define the text thingy
        var scrolled = new Gtk.ScrolledWindow ();
        view = new Jorts.StickyView (this.content);

        scrolled.set_child (view);


        /*****************************************/
        /*              ACTIONBAR                */
        /*****************************************/

        actionbar = new Gtk.ActionBar () {
            hexpand = true
        };

        new_item = new Gtk.Button () {
            icon_name = "list-add-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>n"},
                _("New sticky note")
            )
        };
        new_item.action_name = Application.ACTION_PREFIX + Application.ACTION_NEW;
        new_item.add_css_class ("themedbutton");

        delete_item = new Gtk.Button () {
            icon_name = "edit-delete-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>w"},
                _("Delete sticky note")
            )
        };
        delete_item.action_name = Application.ACTION_PREFIX + Application.ACTION_DELETE;
        delete_item.add_css_class ("themedbutton");



        var emojichooser_popover = new Gtk.EmojiChooser ();

        emoji_button = new Gtk.MenuButton () {
            icon_name = Jorts.Utils.random_emote (),
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>period"},
                _("Insert emoji")
            )
        };
        emoji_button.add_css_class ("themedbutton");
        emoji_button.popover = emojichooser_popover;

        popover = new PopoverView () {
            theme = theme,
            zoom = zoom
        };
        popover.color_button_box.set_toggles (theme);

        set_zoom (data.zoom);


        menu_button = new Gtk.MenuButton () {
            icon_name = "open-menu-symbolic",
            width_request = 32,
            height_request = 32,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>M"},
                _("Preferences for this sticky note")
            )
        };
        menu_button.direction = Gtk.ArrowType.UP;
        menu_button.add_css_class ("themedbutton");
        menu_button.popover = popover;

        actionbar.pack_start (new_item);
        actionbar.pack_start (delete_item);
        actionbar.pack_end (menu_button);
        actionbar.pack_end (emoji_button);

        // Define the grid 
        var mainbox = new Gtk.Box (Gtk.Orientation.VERTICAL,0);
        mainbox.append (scrolled);

        var handle = new Gtk.WindowHandle () {
            child = actionbar
        };
        mainbox.append (handle);

        set_child (mainbox);
        set_focus (view);
        on_scribbly_changed ();


        /***************************************************/
        /*              CONNECTS AND BINDS                 */
        /***************************************************/

        debug ("Built UI. Lets do connects and binds");

        // Save when title or text have changed
        editableheader.changed.connect (on_editable_changed);
        view.buffer.changed.connect (on_buffer_changed);

        // Display the current zoom level when the popover opens
        // Else it does not get set
        emojichooser_popover.show.connect (on_emoji_popover);

        // User chose emoji, add it to buffer
        emojichooser_popover.emoji_picked.connect ((emoji) => {
            view.buffer.insert_at_cursor (emoji, -1);
        });

        // The settings popover tells us a new theme has been chosen!
        this.popover.theme_changed.connect (on_theme_updated);

        // The settings popover tells us a new zoom has been chosen!
        this.popover.zoom_changed.connect (on_zoom_changed);

        // Use the color theme of this sticky note when focused
        this.notify["is-active"].connect (on_focus_changed);

        //The application tells us the squiffly state has changed!
        Application.gsettings.changed["scribbly-mode-active"].connect (on_scribbly_changed);

        //The application tells us the show/hide bar state has changed!
        Application.gsettings.bind (
            "hide-bar",
            actionbar,
            "revealed",
            SettingsBindFlags.INVERT_BOOLEAN);

        gtk_settings.notify["enable-animations"].connect (on_reduceanimation_changed);

        /* LETS GO */
        show ();

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
        } else {
            this.remove_css_class ("scribbly");
        }
    }

    // Randomize the button emoji when clicked
    public void on_emoji_popover () {
        debug ("Emote requested!");

        emoji_button.set_icon_name (
            Jorts.Utils.random_emote (
                emoji_button.get_icon_name ()
            )
        );
    }

    // Called when the window is-active property changes
    public void on_reduceanimation_changed () {
        debug ("Reduce animation changed!");

        if (gtk_settings.gtk_enable_animations) {
            this.add_css_class ("animated");
        } else {
            this.remove_css_class ("animated");
        }
    }

    // Package the note into a NoteData and pass it back
    // NOTE: We cannot access the buffer if the window is closed, leading to content loss
    // Hence why we need to constantly save the buffer into this.content when changed
    public NoteData packaged () {
        debug ("Packaging into a noteData…");

        this.content = this.view.get_content ();

        int width ; int height;
        this.get_default_size (out width, out height);

        var data = new NoteData (
                editableheader.text,
            this.theme,
            this.content,
            this.zoom,
                width,
                height);

        return data;
    }

    public void zoom_default () {
        this.set_zoom (Jorts.Constants.DEFAULT_ZOOM);
    }

    // Switches stylesheet
    // First use appropriate stylesheet, Then switch the theme classes
    private void on_theme_updated (string theme) {
        debug ("Updating theme!");

        var stylesheet = "io.elementary.stylesheet." + theme.ascii_down ();
        this.gtk_settings.gtk_theme_name = stylesheet;

        remove_css_class (this.theme);
        this.theme = theme;
        add_css_class (this.theme);

        ((Application)this.application).manager.save_to_stash ();
    }


    /*********************************************/
    /*              ZOOM feature                 */
    /*********************************************/

    // Called when a signal from the popover says stuff got changed
    public void on_zoom_changed (string zoomkind) {
        debug ("Zoom changed!");

        if (zoomkind == "zoom_in") {
            this.zoom_in ();
        } else if (zoomkind == "zoom_out") {
            this.zoom_out ();
        } else if (zoomkind == "reset") {
            this.set_zoom (100);
        }
        ((Application)this.application).manager.save_to_stash ();
    }

    // First check an increase doesnt go above limit
    public void zoom_in () {
        if ((this.zoom + 20) <= Jorts.Constants.ZOOM_MAX) {
            this.set_zoom ((this.zoom + 20));
        }
    }

    // First check an increase doesnt go below limit
    public void zoom_out () {
        if ((this.zoom - 20) >= Jorts.Constants.ZOOM_MIN) {
            this.set_zoom ((this.zoom - 20));
        }
    }

    // Switch zoom classes, then reflect in the UI and tell the application
    public void set_zoom (int zoom) {
        debug ("Setting zoom: " + zoom.to_string ());

        // Switches the classes that control font size
        this.remove_css_class (Jorts.Utils.zoom_to_class ( this.zoom));
        this.zoom = zoom;
        this.add_css_class (Jorts.Utils.zoom_to_class ( this.zoom));

        this.headerbar.height_request = Jorts.Utils.zoom_to_UIsize (this.zoom);

        // Reflect the number in the popover
        this.popover.on_zoom_changed (zoom);

        // Keep it for next new notes
        //((Application)this.application).latest_zoom = zoom;
        ((Application)this.application).manager.latest_zoom = zoom;
    }

    public void action_focus_title () {
        set_focus (editableheader);
        editableheader.editing = true;
    }

    public void action_show_emoji () {
        emoji_button.activate ();
    }

    public void action_show_menu () {
        menu_button.activate ();
    }
}

/*
* Copyright (c) 2017-2024 Lains
* Copyright (c) 2025 Stella (teamcons on GitHub) and the Ellie_Commons community
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
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
namespace Jorts {

    public class StickyNoteWindow : Gtk.Window {

        public Gtk.EditableLabel notetitle;
        private Jorts.StickyView view;
        private Gtk.HeaderBar headerbar;

        private Gtk.ActionBar actionbar;


        private Gtk.Button new_item;
        private Gtk.Button delete_item;
        private Gtk.MenuButton emoji_button;
        private SettingsPopover popover;

        public Jorts.NoteData data;

        public Gtk.Settings gtk_settings;

        public string title_name;
        public string theme;
        public string content;
        public int zoom;

        public uint debounce_timer_id;

        public SimpleActionGroup actions { get; construct; }

        public const string ACTION_PREFIX = "app.";
        public const string ACTION_NEW = "action_new";
        public const string ACTION_DELETE = "action_delete";

        public const string ACTION_ZOOM_OUT = "zoom_out";
        public const string ACTION_ZOOM_DEFAULT = "zoom_default";
        public const string ACTION_ZOOM_IN = "zoom_in";

        public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

        private const GLib.ActionEntry[] ACTION_ENTRIES = {
            { ACTION_NEW, action_new },
            { ACTION_DELETE, action_delete},
            { ACTION_ZOOM_OUT, zoom_out},
            { ACTION_ZOOM_DEFAULT, zoom_default},
            { ACTION_ZOOM_IN, zoom_in}
        };

        /*************************************************/
        /*           Lets build a window                 */
        /*************************************************/

        public StickyNoteWindow (Gtk.Application app, NoteData data) {
            Object (application: app);
            Intl.setlocale ();
            debug ("New StickyNoteWindow instance: " + data.title);

            var actions = new SimpleActionGroup ();
            actions.add_action_entries (ACTION_ENTRIES, this);
            insert_action_group ("app", actions);

            this.gtk_settings = Gtk.Settings.get_default ();


            /*****************************************/
            /*              LOAD NOTE                */
            /*****************************************/

            this.data = data;
            this.title_name = data.title;
            this.theme = data.theme;
            this.zoom = data.zoom;
            this.content = data.content;

            this.set_title (this.title_name);
            this.set_default_size (
                data.width,
                data.height
            );

            // Rebuild the whole theming
            this.update_theme (this.theme);

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
            notetitle = new Gtk.EditableLabel (this.title_name);
            notetitle.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);
            notetitle.halign = Gtk.Align.CENTER;
            notetitle.set_tooltip_text (_("Edit title"));
            notetitle.xalign = 0.5f;

            headerbar.set_title_widget (notetitle);
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
            new_item.action_name = StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_NEW;
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
            delete_item.action_name = StickyNoteWindow.ACTION_PREFIX + StickyNoteWindow.ACTION_DELETE;
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




            this.popover = new SettingsPopover (theme);
            this.set_zoom (data.zoom);


            var app_button = new Gtk.MenuButton () {
                icon_name = "open-menu-symbolic",
                width_request = 32,
                height_request = 32,
                tooltip_text = _("Preferences for this sticky note")
            };
            app_button.direction = Gtk.ArrowType.UP;
            app_button.add_css_class ("themedbutton");
            app_button.popover = popover;

            actionbar.pack_start (new_item);
            actionbar.pack_start (delete_item);
            actionbar.pack_end (app_button);
            actionbar.pack_end (emoji_button);

            // Define the grid 
            var mainbox = new Gtk.Box (Gtk.Orientation.VERTICAL,0);
            mainbox.append (scrolled);

            mainbox.append (actionbar);

            var handle = new Gtk.WindowHandle () {
                child = mainbox
            };

            set_child (handle);
            on_scribbly_changed ();


            /***************************************************/
            /*              CONNECTS AND BINDS                 */
            /***************************************************/

            debug ("Built UI. Lets do connects and binds");

            // Save when title has changed. And ALSO set the WM title so multitasking has the new one
            notetitle.changed.connect (() => {
                this.set_title (notetitle.text);
                on_buffer_changed ();
            });

            //
            view.buffer.changed.connect (on_buffer_changed);

            // Display the current zoom level when the popover opens
            // Else it does not get set
            emojichooser_popover.show.connect (on_emoji_popover);


            // User chose emoji, add it to buffer
            emojichooser_popover.emoji_picked.connect ((emoji) => {
                view.buffer.insert_at_cursor (emoji, -1);
            });


            // The settings popover tells us a new theme has been chosen!
            this.popover.theme_changed.connect (update_theme);

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
                ((Application)this.application).save_to_stash ();
                return GLib.Source.REMOVE;
            });
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

        // TITLE IS TITLE
        public new void set_title (string title) {
            this.title = title;
        }

        // Package the note into a NoteData and pass it back
        // NOTE: We cannot access the buffer if the window is closed, leading to content loss
        // Hence why we need to constantly save the buffer into this.content when changed
        public NoteData packaged () {
            debug ("Packaging into a noteData…");

            var current_title = notetitle.get_text ();
            this.content = this.view.get_content ();

            int width ; int height;
            this.get_default_size (out width, out height);

            var data = new NoteData (
                current_title,
                this.theme,
                this.content,
                this.zoom,
                    width,
                    height);

            return data;
        }

        private void action_new () {
            ((Application)this.application).create_note ();
        }

        private void action_delete () {
            ((Application)this.application).remove_note (this);
            this.close ();
        }

        private void zoom_default () {
            this.set_zoom (Jorts.Constants.DEFAULT_ZOOM);
        }

        // Switches stylesheet
        // First use appropriate stylesheet, Then switch the theme classes
        private void update_theme (string theme) {
            debug ("Updating theme!");

            var stylesheet = "io.elementary.stylesheet." + theme.ascii_down ();
            this.gtk_settings.gtk_theme_name = stylesheet;

            remove_css_class (this.theme);
            this.theme = theme;
            add_css_class (this.theme);

            ((Application)this.application).save_to_stash ();
        }





        /*************************************************/
        /*              ZOOM feature                 */
        /*************************************************/

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
            ((Application)this.application).save_to_stash ();
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
            this.popover.set_zoomlevel (zoom);

            // Keep it for next new notes
            ((Application)this.application).latest_zoom = zoom;
        }
    }
}

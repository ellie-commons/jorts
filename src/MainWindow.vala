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

/*



*/
namespace jorts {

    // Every notice is an instance of MainWindow
    public class MainWindow : Gtk.Window {
        private new Gtk.SourceBuffer buffer;
        private Gtk.SourceView view;
        private Gtk.HeaderBar header;
        private Gtk.ActionBar actionbar;
        private int uid;
        private static int uid_counter = 0;

        public string title_name = _("My little notes");
        public string theme = "BLUEBERRY";
        public string content = _("All my little thoughts!");

        public jorts.EditableLabel label; // GTK4: HAS GTK:EDITABLELABEL
        //public Gtk.)EditableLabel label = new Gtk.EditableLabel();

        public SimpleActionGroup actions { get; construct; }

        public const string ACTION_PREFIX   = "win.";
        public const string ACTION_NEW      = "action_new";
        public const string ACTION_DELETE   = "action_delete";
        public const string ACTION_UNDO     = "action_undo";
        public const string ACTION_REDO     = "action_redo";

        public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

        private const GLib.ActionEntry[] action_entries = {
            { ACTION_NEW,       action_new      },
            { ACTION_DELETE,    action_delete   },
            { ACTION_UNDO,      action_new      },
            { ACTION_REDO,      action_delete   }
        };


        // Init or something
        public MainWindow (Gtk.Application app, Storage? storage) {
            Object (application: app);

            var actions = new SimpleActionGroup ();
            actions.add_action_entries (action_entries, this);
            insert_action_group ("win", actions);

            // If storage is not empty, load from it
            // Else do a new with theme at random
            if (storage != null) {
                init_from_storage(storage);


            } else {

                this.title_name = jorts.Utils.random_title();
                set_title (this.title_name);

                // First sticky is always blue - signature look!
                // After that, it is random
                //if (uid_counter == 0) {
                    var allthemes = jorts.Utils.themearray();
                    this.theme = allthemes[Random.int_range (0,(allthemes.length - 1))];
                //} else {
                //    this.theme = "BLUEBERRY";
                //}
                // Wrong alert uid is rotten
                
                this.content = "";
            }

            // add required base classes
            this.get_style_context().add_class("rounded");

            this.uid = uid_counter++;

            // Rebuild the whole theming
            update_theme(this.theme);


            // HEADER
            // Define the header
            header = new Gtk.HeaderBar();
            header.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            //header.get_style_context().add_class("jorts-title");
            header.has_subtitle = false;
            header.set_show_close_button (true);
            header.decoration_layout = "close:";

            // Defime the label you can edit. Which is editable.
            label = new jorts.EditableLabel (this.title_name);
            header.set_custom_title(label);
            this.set_titlebar(header);



            // Bar at the bottom
            actionbar = new Gtk.ActionBar ();
            actionbar.get_style_context().add_class("actionbar");
            create_actionbar ();
            create_app_menu ();

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.set_size_request (330,270);


            // Define the text thingy
            buffer = new Gtk.SourceBuffer (null);
            buffer.set_highlight_matching_brackets (false);
            view = new Gtk.SourceView.with_buffer (buffer);
            view.bottom_margin = 10;
            view.buffer.text = this.content;
            view.get_style_context().add_class("jorts-view");
            view.expand = true;
            view.left_margin = 10;
            view.margin = 2;
            view.right_margin = 10;
            view.set_wrap_mode (Gtk.WrapMode.WORD_CHAR);
            view.top_margin = 10;
            scrolled.add (view);
            this.show_all();

            // Define the grid 
            var grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.expand = true;
            grid.add (scrolled);
            grid.add (actionbar);
            grid.show_all ();
            this.add (grid);

            // EVENTS
            
            // Save when user focuses elsewhere
            focus_out_event.connect (() => {
                update_storage ();
                return false;
            });

            // Save when user changes the label
            label.changed.connect (() => {
                update_storage ();
            });

            // Save when the text thingy has changed
            view.buffer.changed.connect (() => {
                update_storage ();
            });

            // Undo Redo shit
            key_press_event.connect ((e) => {
                uint keycode = e.hardware_keycode;
                if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    if (match_keycode (Gdk.Key.z, keycode)) {
                        action_undo ();
                    }
                }
                if ((e.state & Gdk.ModifierType.CONTROL_MASK + Gdk.ModifierType.SHIFT_MASK) != 0) {
                    if (match_keycode (Gdk.Key.z, keycode)) {
                        action_redo ();
                    }
                }
                return false;
            });
        }

        // TITLE IS TITLE
        public new void set_title (string title) {
            this.title = title;
        }

        // Save everything
        private void update_storage () {
            int width, height;

            get_storage_note();
            ((Application)this.application).update_storage();

            this.get_size (out width, out height);

            var everythingnote = new noteData(this.uid, this.title, this.theme, this.content, 0, width, height);

            Stash.save_to_stash(everythingnote);
        }




        // Content of the action bar
        private void create_actionbar () {
            var new_item = new Gtk.Button ();
            new_item.tooltip_text = (_("New note"));
            new_item.set_image (new Gtk.Image.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            new_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_NEW;

            var delete_item = new Gtk.Button ();
            delete_item.tooltip_text = (_("Delete note"));
            delete_item.set_image (new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            delete_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_DELETE;
            delete_item.get_style_context ().add_class ("trashcan");

/*              var undo = new Gtk.Button ();
            undo.tooltip_text = (_("Undo"));
            undo.set_image (new Gtk.Image.from_icon_name ("edit-undo-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            undo.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_UNDO;

            var redo = new Gtk.Button ();
            redo.tooltip_text = (_("Redo"));
            redo.set_image (new Gtk.Image.from_icon_name ("edit-redo-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            redo.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_REDO;  */

            // GTK4: append
            actionbar.pack_start (new_item);
            actionbar.pack_start (delete_item);
            //  actionbar.pack_start (undo);
            //  actionbar.pack_start (redo);
        }


        // Create the inside of the settings button
        // This is a label and several colored bubbles
        // TODO : Shorten this by doing a Widget 
        private void create_app_menu () {

            var color_button_strawberry = new Gtk.Button ();
            color_button_strawberry.has_focus = false;
            color_button_strawberry.halign = Gtk.Align.CENTER;
            color_button_strawberry.height_request = 24;
            color_button_strawberry.width_request = 24;
            color_button_strawberry.tooltip_text = _("Strawberry");
            color_button_strawberry.get_style_context ().add_class ("color-button");
            color_button_strawberry.get_style_context ().add_class ("strawberry");

            var color_button_orange = new Gtk.Button ();
            color_button_orange.has_focus = false;
            color_button_orange.halign = Gtk.Align.CENTER;
            color_button_orange.height_request = 24;
            color_button_orange.width_request = 24;
            color_button_orange.tooltip_text = _("Orange");

            var color_button_orange_context = color_button_orange.get_style_context ();
            color_button_orange_context.add_class ("color-button");
            color_button_orange_context.add_class ("orange");

            var color_button_banana = new Gtk.Button ();
            color_button_banana.has_focus = false;
            color_button_banana.halign = Gtk.Align.CENTER;
            color_button_banana.height_request = 24;
            color_button_banana.width_request = 24;
            color_button_banana.tooltip_text = _("Banana");

            var color_button_banana_context = color_button_banana.get_style_context ();
            color_button_banana_context.add_class ("color-button");
            color_button_banana_context.add_class ("banana");

            var color_button_lime = new Gtk.Button ();
            color_button_lime.has_focus = false;
            color_button_lime.halign = Gtk.Align.CENTER;
            color_button_lime.height_request = 24;
            color_button_lime.width_request = 24;
            color_button_lime.tooltip_text = _("Lime");

            var color_button_lime_context = color_button_lime.get_style_context ();
            color_button_lime_context.add_class ("color-button");
            color_button_lime_context.add_class ("lime");

            var color_button_blueberry = new Gtk.Button ();
            color_button_blueberry.has_focus = false;
            color_button_blueberry.halign = Gtk.Align.CENTER;
            color_button_blueberry.height_request = 24;
            color_button_blueberry.width_request = 24;
            color_button_blueberry.tooltip_text = _("Blueberry");

            var color_button_blueberry_context = color_button_blueberry.get_style_context ();
            color_button_blueberry_context.add_class ("color-button");
            color_button_blueberry_context.add_class ("blueberry");


            var color_button_bubblegum = new Gtk.Button ();
            color_button_bubblegum.has_focus = false;
            color_button_bubblegum.halign = Gtk.Align.CENTER;
            color_button_bubblegum.height_request = 24;
            color_button_bubblegum.width_request = 24;
            color_button_bubblegum.tooltip_text = _("Bubblegum");

            var color_button_bubblegum_context = color_button_bubblegum.get_style_context ();
            color_button_bubblegum_context.add_class ("color-button");
            color_button_bubblegum_context.add_class ("bubblegum");


            var color_button_grape = new Gtk.Button ();
            color_button_grape.has_focus = false;
            color_button_grape.halign = Gtk.Align.CENTER;
            color_button_grape.height_request = 24;
            color_button_grape.width_request = 24;
            color_button_grape.tooltip_text = _("Grape");

            var color_button_grape_context = color_button_grape.get_style_context ();
            color_button_grape_context.add_class ("color-button");
            color_button_grape_context.add_class ("grape");

            var color_button_cocoa = new Gtk.Button ();
            color_button_cocoa.has_focus = false;
            color_button_cocoa.halign = Gtk.Align.CENTER;
            color_button_cocoa.height_request = 24;
            color_button_cocoa.width_request = 24;
            color_button_cocoa.tooltip_text = _("Cocoa");

            var color_button_cocoa_context = color_button_cocoa.get_style_context ();
            color_button_cocoa_context.add_class ("color-button");
            color_button_cocoa_context.add_class ("cocoa");

            var color_button_silver = new Gtk.Button ();
            color_button_silver.has_focus = false;
            color_button_silver.halign = Gtk.Align.CENTER;
            color_button_silver.height_request = 24;
            color_button_silver.width_request = 24;
            color_button_silver.tooltip_text = _("Silver");

            var color_button_silver_context = color_button_silver.get_style_context ();
            color_button_silver_context.add_class ("color-button");
            color_button_silver_context.add_class ("silver");


            var color_button_slate = new Gtk.Button ();
            color_button_slate.has_focus = false;
            color_button_slate.halign = Gtk.Align.CENTER;
            color_button_slate.height_request = 24;
            color_button_slate.width_request = 24;
            color_button_slate.tooltip_text = _("Slate");

            var color_button_slate_context = color_button_slate.get_style_context ();
            color_button_slate_context.add_class ("color-button");
            color_button_slate_context.add_class ("slate");

            var color_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            // GTK4: append
            // THE HECK IS THESE
            color_button_box.pack_start (color_button_strawberry, false, true, 0);
            color_button_box.pack_start (color_button_orange, false, true, 0);
            color_button_box.pack_start (color_button_banana, false, true, 0);
            color_button_box.pack_start (color_button_lime, false, true, 0);
            color_button_box.pack_start (color_button_blueberry, false, true, 0);
            color_button_box.pack_start (color_button_bubblegum, false, true, 0);
            color_button_box.pack_start (color_button_grape, false, true, 0);
            color_button_box.pack_start (color_button_cocoa, false, true, 0);
            color_button_box.pack_start (color_button_silver, false, true, 0);
            color_button_box.pack_start (color_button_slate, false, true, 0);

            var color_button_label = new Granite.HeaderLabel (_("Note Color"));

            var setting_grid = new Gtk.Grid ();
            setting_grid.margin = 12;
            setting_grid.column_spacing = 6;
            setting_grid.row_spacing = 6;
            setting_grid.orientation = Gtk.Orientation.VERTICAL;
            setting_grid.attach (color_button_label, 0, 0, 1, 1);
            setting_grid.attach (color_button_box, 0, 1, 1, 1);
            setting_grid.show_all ();

            var popover = new Gtk.Popover (null);
            popover.add (setting_grid);

            var app_button = new Gtk.MenuButton();
            app_button.has_tooltip = true;
            app_button.tooltip_text = (_("Settings"));
            app_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            app_button.popover = popover;


            // All the "change theme when theme button changed"
            // TODO: cleaner theme management
            color_button_strawberry.clicked.connect (() => {
                update_theme("STRAWBERRY");
                ((Application)this.application).update_storage();
            });

            color_button_orange.clicked.connect (() => {
                update_theme("ORANGE");
                ((Application)this.application).update_storage();
            });

            color_button_banana.clicked.connect (() => {
                update_theme("BANANA");
                ((Application)this.application).update_storage();
            });

            color_button_lime.clicked.connect (() => {
                update_theme("LIME");
                ((Application)this.application).update_storage();
            });

            color_button_blueberry.clicked.connect (() => {
                update_theme("BLUEBERRY");
                ((Application)this.application).update_storage();
            });

            color_button_bubblegum.clicked.connect (() => {
                update_theme("BUBBLEGUM");
                ((Application)this.application).update_storage();
            });

            color_button_grape.clicked.connect (() => {
                update_theme("GRAPE");
                ((Application)this.application).update_storage();
            });

            color_button_cocoa.clicked.connect (() => {
                update_theme("COCOA");
                ((Application)this.application).update_storage();
            });

            color_button_silver.clicked.connect (() => {
                update_theme("SILVER");
                ((Application)this.application).update_storage();
            });

            color_button_slate.clicked.connect (() => {
                update_theme("SLATE");
                ((Application)this.application).update_storage();
            });

            // GTK4: Append
            actionbar.pack_end (app_button);
        }

        // When recreating the window from storage
        private void init_from_storage(Storage storage) {
            this.title_name = storage.title;
            this.theme = storage.theme;
            this.content = storage.content;
            if ((int)storage.w != 0 && (int)storage.h != 0) {
                this.resize ((int)storage.w, (int)storage.h);
            }

            set_title (this.title_name);
        }


        // Some rando actions
        private void action_new () {
            ((Application)this.application).create_note(null);
        }

        private void action_delete () {
            ((Application)this.application).remove_note(this);
            this.close ();
        }

        private void action_undo () {
            buffer.undo ();
        }

        private void action_redo () {
            buffer.redo ();
        }

        // Prepare for storage
        public Storage get_storage_note() {
            int x, y, w, h;
            Gtk.TextIter start,end;
            view.buffer.get_bounds (out start, out end);
            this.content = view.buffer.get_text (start, end, true);
            this.title_name = label.title.get_label ();
            set_title (this.title_name);
            string note_theme = this.theme;

            this.get_position (out x, out y);
            this.get_size (out w, out h);

            return new Storage.from_storage(title_name,note_theme,content,x, y, w, h );
        }


        // TODO: Understand this
#if VALA_0_42
        protected bool match_keycode (uint keyval, uint code) {
#else
        protected bool match_keycode (int keyval, uint code) {
#endif
            Gdk.KeymapKey [] keys;
            Gdk.Keymap keymap = Gdk.Keymap.get_for_display (Gdk.Display.get_default ());
            if (keymap.get_entries_for_keyval (keyval, out keys)) {
                foreach (var key in keys) {
                    if (code == key.keycode)
                        return true;
                    }
                }

            return false;
        }

        // Note gets deleted
        public override bool delete_event (Gdk.EventAny event) {
            int x, y;
            this.get_position (out x, out y);
            jorts.Application.gsettings.set_int("window-x", x);
            jorts.Application.gsettings.set_int("window-y", y);
            return false;
        }

        // Replace stylesheet
        private void update_theme(string theme) {

            // in GTK4 we can replace this with setting css_classes
            string old_theme = this.theme;
            this.theme = theme;
            get_style_context().remove_class (old_theme);
            get_style_context().add_class (theme);
        }
    }


}



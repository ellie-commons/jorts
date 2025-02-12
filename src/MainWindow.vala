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

MainWindow --> Each MainWindow instance is its own sticky note.
Initialization:
unpack notedata


Window
> Header
-> EditableLabel

> Grid
->ScrolledWindow
--> Sourceview

->Actionbar
--> new, delete, settings (settingspopover)


*/
namespace jorts {

    // Every notice is an instance of MainWindow
    public class MainWindow : Gtk.Window {
        private new Gtk.SourceBuffer buffer;
        private Gtk.SourceView view;
        private Gtk.HeaderBar header;
        private Gtk.ActionBar actionbar;

        public string title_name;
        public string theme;
        public string content;
        public int64 zoom;

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
        public MainWindow (Gtk.Application app, noteData data) {
            Object (application: app);
            Intl.setlocale ();

            var actions = new SimpleActionGroup ();
            actions.add_action_entries (action_entries, this);
            insert_action_group ("win", actions);

            // First get the thing
            this.unpackage (data);

            // Rebuild the whole theming
            this.update_theme(this.theme);

            // add required base classes
            this.get_style_context().add_class("rounded");

            // HEADER
            // Define the header
            header = new Gtk.HeaderBar();
            header.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            header.get_style_context().add_class("headertitle");
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

            
            var new_item = new Gtk.Button ();
            new_item.tooltip_text = (_("New note"));
            new_item.set_image (new Gtk.Image.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            new_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_NEW;

            var delete_item = new Gtk.Button ();
            delete_item.tooltip_text = (_("Delete note"));
            delete_item.set_image (new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            delete_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_DELETE;
            delete_item.get_style_context ().add_class ("trashcan");

            // GTK4: append
            actionbar.pack_start (new_item);
            actionbar.pack_start (delete_item);
            //  actionbar.pack_start (undo);
            //  actionbar.pack_start (redo);


            var color_button_label = new Granite.HeaderLabel (_("Note Color"));

            var color_button_blueberry = new ColorPill (_("Blueberry"), "blueberry");
            var color_button_lime = new ColorPill (_("Lime"), "lime");
            var color_button_mint = new ColorPill (_("Mint"), "mint");
            var color_button_banana = new ColorPill (_("Banana"), "banana");
            var color_button_strawberry = new ColorPill (_("Strawberry"), "strawberry");
            var color_button_orange = new ColorPill (_("Orange"), "orange");
            var color_button_bubblegum = new ColorPill (_("Bubblegum"), "bubblegum");
            var color_button_grape = new ColorPill (_("Grape"),"grape");
            var color_button_latte = new ColorPill (_("Latte"),"latte");
            var color_button_cocoa = new ColorPill (_("Cocoa"), "cocoa");
            var color_button_slate = new ColorPill (_("Slate"),"slate");

            //TODO: Multiline
            var color_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            // GTK4: append
            color_button_box.pack_start (color_button_blueberry, false, true, 0);
            color_button_box.pack_start (color_button_mint, false, true, 0);
            color_button_box.pack_start (color_button_lime, false, true, 0);
            color_button_box.pack_start (color_button_banana, false, true, 0);
            color_button_box.pack_start (color_button_orange, false, true, 0);
            color_button_box.pack_start (color_button_strawberry, false, true, 0);
            color_button_box.pack_start (color_button_bubblegum, false, true, 0);
            color_button_box.pack_start (color_button_grape, false, true, 0);
            color_button_box.pack_start (color_button_latte, false, true, 0);
            color_button_box.pack_start (color_button_cocoa, false, true, 0);
            color_button_box.pack_start (color_button_slate, false, true, 0);



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
                this.update_theme("STRAWBERRY");
            });

            color_button_orange.clicked.connect (() => {
                this.update_theme("ORANGE");
            });

            color_button_mint.clicked.connect (() => {
                this.update_theme("MINT");
            });

            color_button_banana.clicked.connect (() => {
                this.update_theme("BANANA");
            });

            color_button_lime.clicked.connect (() => {
                this.update_theme("LIME");
            });

            color_button_blueberry.clicked.connect (() => {
                this.update_theme("BLUEBERRY");
            });

            color_button_bubblegum.clicked.connect (() => {
                this.update_theme("BUBBLEGUM");
            });

            color_button_grape.clicked.connect (() => {
                this.update_theme("GRAPE");
            });


            color_button_latte.clicked.connect (() => {
                this.update_theme("LATTE");
            });

            color_button_cocoa.clicked.connect (() => {
                this.update_theme("COCOA");
            });

            color_button_slate.clicked.connect (() => {
                this.update_theme("SLATE");
            });

            // GTK4: Append
            actionbar.pack_end (app_button);

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.set_size_request (330,270);


            // Define the text thingy
            buffer = new Gtk.SourceBuffer (null);
            buffer.set_highlight_matching_brackets (false);

            
            view = new Gtk.SourceView.with_buffer (buffer);
            view.bottom_margin = 10;
            view.buffer.text = this.content;
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
                ((Application)this.application).save_to_stash ();
                return false;
            });

            // Save when user changes the label
            label.changed.connect (() => {
                ((Application)this.application).save_to_stash ();
            });

            // Save when the window thingy closed
            this.destroy.connect (() => {
                ((Application)this.application).save_to_stash ();
            });            

            // Save when the text thingy has changed
            view.buffer.changed.connect (() => {
                Gtk.TextIter start,end;
                view.buffer.get_bounds (out start, out end);
                this.content = view.buffer.get_text (start, end, true);
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


        // Package the note into a noteData and pass it back
        // NOTE: We cannot access the buffer if the window is closed, leading to content loss
        // Hence why we need to constantly save the buffer into this.content when changed
        public noteData packaged() {
            int width, height;
            var current_title = label.title.get_label ();
            this.get_size (out width, out height);
            var data = new noteData(current_title, this.theme, this.content , 100, width, height );
            return data;
        }


        // Take a notedata and unpack it
        private void unpackage(noteData data) {
            this.title_name = data.title;
            this.theme = data.theme;
            this.content = data.content;
            this.zoom = data.zoom;

            if ((int)data.width != 0 && (int)data.height != 0) {
                this.resize ((int)data.width, (int)data.height);
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
            ((Application)this.application).save_to_stash ();
            return false;
        }

        // Strip old stylesheet, apply the new
        private void update_theme(string theme) {
            // in GTK4 we can replace this with setting css_classes
            get_style_context().remove_class (this.theme);
            this.theme = theme;
            get_style_context().add_class (this.theme);
            ((Application)this.application).save_to_stash ();
        }
    }


}
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

    public class MainWindow : Gtk.Window {

        private Gtk.HeaderBar header;
        private new jorts.StickyView view;
        private Gtk.ActionBar actionbar;

        //public noteData data;
        public string title_name;
        public string theme;
        public string content;
        public int64 zoom;

        public static int max_zoom = 200;
        public static int min_zoom = 60;
                

        public Gtk.EditableLabel notetitle;

        public SimpleActionGroup actions { get; construct; }

        public const string ACTION_PREFIX   = "win.";
        public const string ACTION_NEW      = "action_new";
        public const string ACTION_DELETE   = "action_delete";

        public const string ACTION_ZOOM_DEFAULT = "action_zoom_default";
        public const string ACTION_ZOOM_IN = "zoom_in";
        public const string ACTION_ZOOM_OUT = "zoom_out";

        public const string[] ACCELS_ZOOM_DEFAULT = { "<control>0", "<Control>KP_0", null };
        public const string[] ACCELS_ZOOM_IN = { "<Control>plus", "<Control>equal", "<Control>KP_Add", null };
        public const string[] ACCELS_ZOOM_OUT = { "<Control>minus", "<Control>KP_Subtract", null };


        public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

        private const GLib.ActionEntry[] action_entries = {
            { ACTION_NEW,               action_new      },
            { ACTION_DELETE,            action_delete   },
            { ACTION_ZOOM_DEFAULT,      action_zoom_default   },
            { ACTION_ZOOM_IN,           zoom_in   },
            { ACTION_ZOOM_OUT,          zoom_out   },
        };

        // Init or something
        public MainWindow (Gtk.Application app, noteData data) {
            Object (application: app);
            Intl.setlocale ();
            debug("New MainWindow instance: " + data.title);

            var actions = new SimpleActionGroup ();
            actions.add_action_entries (action_entries, this);
            insert_action_group ("win", actions);


            set_accels_for_action (ACTION_ZOOM_DEFAULT, ACCELS_ZOOM_DEFAULT);
            set_accels_for_action (ACTION_ZOOM_IN, ACCELS_ZOOM_IN);
            set_accels_for_action (ACTION_ZOOM_OUT, ACCELS_ZOOM_OUT);
    


            this.set_hexpand (false);
            this.set_vexpand (false);



            // First get the thing
            this.unpackage (data);

            // Rebuild the whole theming
            this.update_theme(this.theme);

            // add required base classes
            this.add_css_class("rounded");
            this.add_css_class ("animations");

            header = new Gtk.HeaderBar();
            header.add_css_class ("flat");
            header.add_css_class("headertitle");
            //header.has_subtitle = false;
            header.set_show_title_buttons (true);
            header.decoration_layout = "close:";

            // Defime the label you can edit. Which is editable.
            notetitle = new Gtk.EditableLabel (this.title_name);
            notetitle.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);
            notetitle.halign = Gtk.Align.CENTER;
            notetitle.set_tooltip_text (_("Edit title"));
            notetitle.xalign = 0.5f;

            header.set_title_widget(notetitle);
            this.set_titlebar(header);

            // Define the text thingy
            var scrolled = new Gtk.ScrolledWindow ();
            scrolled.set_size_request (66,54);
            view = new jorts.StickyView (100, this.content);
            scrolled.set_child (view);


            // Bar at the bottom
            actionbar = new Gtk.ActionBar ();
            actionbar.set_hexpand (true);
            
            var new_item = new Gtk.Button ();
            new_item.tooltip_text = (_("New sticky note (Ctrl+N)"));
            new_item.set_icon_name ("list-add-symbolic");
            new_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_NEW;
            new_item.width_request = 32;
            new_item.height_request = 32;

            new_item.add_css_class("themedbutton");

            var delete_item = new Gtk.Button ();
            delete_item.tooltip_text = (_("Delete sticky note (Ctrl+W)"));
            delete_item.set_icon_name ("edit-delete-symbolic");
            delete_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_DELETE;
            delete_item.width_request = 32;
            delete_item.height_request = 32;
            delete_item.add_css_class("themedbutton");


            var popover = new SettingsPopover (this.theme, this.zoom);


            var app_button = new Gtk.MenuButton();
            app_button.has_tooltip = true;
            app_button.tooltip_text = (_("Settings"));
            app_button.set_icon_name("open-menu-symbolic");
            app_button.direction = Gtk.ArrowType.UP;
            app_button.add_css_class("themedbutton");
            app_button.popover = popover;


            app_button.width_request = 32;
            app_button.height_request = 32;

            actionbar.pack_start (new_item);
            actionbar.pack_start (delete_item);
            actionbar.pack_end (app_button);

            // Define the grid 
            var grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.attach(scrolled, 0, 0, 1, 1);
            grid.attach(actionbar, 0, 1, 1, 1);
            grid.show ();
            this.set_child (grid);
            this.show();

            // ================================================================ //
            // EVENTS            
            //  //  //Save when the text thingy has changed
            view.buffer.changed.connect (() => {
                ((Application)this.application).save_to_stash ();            
            });

            notetitle.changed.connect (() => {
                ((Application)this.application).save_to_stash ();            
            });

            this.close_request.connect (() => {
                ((Application)this.application).save_to_stash (); 
                return false;           
            });

            popover.show.connect(() => {
                popover.set_zoomlevel(this.zoom);
            });

            
            popover.theme_changed.connect ((selected) => {
                this.update_theme(selected);
            });

            popover.zoom_changed.connect ((zoomkind) => {
                if (zoomkind == "zoom_in") {
                    this.zoom_in();
                } else if (zoomkind == "zoom_out") {
                    this.zoom_out();
                } else if (zoomkind == "reset") {
                    this.set_zoom(100);
                }
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
            var current_title = notetitle.get_text ();
            this.content = this.view.get_content ();
            this.get_default_size(out width, out height);
            var data = new noteData(current_title, this.theme, this.content , this.zoom, width, height );
            return data;
        }

        // Take a notedata and unpack it
        private void unpackage(noteData data) {
            this.title_name = data.title;
            this.theme = data.theme;
            this.content = data.content;
            this.set_zoom(data.zoom);
            this.set_default_size ((int)data.width, (int)data.height);
            this.set_title (this.title_name);
        }

        // Some rando actions
        private void action_new () {
            ((Application)this.application).create_note(null);
        }

        private void action_delete () {
            ((Application)this.application).remove_note(this);
            this.close ();
        }

        private void action_zoom_default () {
            this.set_zoom(100);
        }

        // Strip old stylesheet, apply the new
        private void update_theme(string theme) {
            // in GTK4 we can replace this with setting css_classes
            remove_css_class (this.theme);
            this.theme = theme;
            add_css_class (this.theme);
        }



        public string zoom_to_class(int64 zoom) {
            switch (zoom) {
                case 40: return "muchsmaller";
                case 60: return "smaller";
                case 80: return "small";
                case 100: return "normal_zoom";
                case 120: return "big";
                case 140: return "bigger";
                case 160: return "muchbigger";
                case 180: return "muchmuchbigger";
                case 200: return "huge";
                default: return "default";
            }
        }

        public void zoom_in() {
            if ((this.zoom + 20) <= jorts.Utils.max_zoom) {
                this.set_zoom((this.zoom + 20));
            }
        }

        public void zoom_out() {
            if ((this.zoom - 20) >= jorts.Utils.min_zoom) {
                this.set_zoom((this.zoom - 20));
            }
        }

        public void set_zoom(int64 zoom) {
            this.remove_css_class (zoom_to_class( this.zoom));
            this.zoom = zoom;
            this.add_css_class (zoom_to_class( this.zoom));
            ((Application)this.application).latest_zoom = zoom;

            var label = "%.0f%%".printf(zoom.to_string);
            popovover.zoom_default_button.set_label(this.zoom);
            

        }
    }
}
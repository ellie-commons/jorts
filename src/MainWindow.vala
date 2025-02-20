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

        private Gtk.HeaderBar header;
        private new jorts.StickyView view;
        private Gtk.ActionBar actionbar;

        public string title_name;
        public string theme;
        public string content;
        public int64 zoom;

        public Gtk.EditableLabel notetitle;

        public SimpleActionGroup actions { get; construct; }

        public const string ACTION_PREFIX   = "win.";
        public const string ACTION_NEW      = "action_new";
        public const string ACTION_DELETE   = "action_delete";

        public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

        private const GLib.ActionEntry[] action_entries = {
            { ACTION_NEW,       action_new      },
            { ACTION_DELETE,    action_delete   }
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
            this.add_css_class("rounded");


            // ================================================================ //
            // HEADER            // Define the header
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
            notetitle.set_hexpand (false);
            notetitle.set_vexpand (true);
            notetitle.set_tooltip_text (_("Edit title"));

            header.set_title_widget(notetitle);
            this.set_titlebar(header);

            // Define the text thingy
            var scrolled = new Gtk.ScrolledWindow ();
            scrolled.set_size_request (330,270);

            view = new jorts.StickyView (this.content);

            scrolled.set_child (view);
            this.show();

            // Bar at the bottom
            actionbar = new Gtk.ActionBar ();
            actionbar.set_hexpand (true);
            
            var new_item = new Gtk.Button ();
            new_item.tooltip_text = (_("New sticky note (Ctrl+N)"));
            new_item.set_icon_name ("list-add-symbolic");
            new_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_NEW;
            new_item.width_request = 32;
            new_item.height_request = 32;

            var delete_item = new Gtk.Button ();
            delete_item.tooltip_text = (_("Delete sticky note (Ctrl+W)"));
            delete_item.set_icon_name ("edit-delete-symbolic");
            delete_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_DELETE;

            delete_item.width_request = 32;
            delete_item.height_request = 32;

            var popover = new SettingsPopover (this.theme);
            popover.theme_changed.connect ((selected) => {
                this.update_theme(selected);
            });

            var app_button = new Gtk.MenuButton();
            app_button.has_tooltip = true;
            app_button.tooltip_text = (_("Settings"));
            app_button.set_icon_name("open-menu-symbolic");
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
            

            // ================================================================ //
            // EVENTS            
            // Save when user focuses elsewhere
            this.activate_focus.connect (() => {
                ((Application)this.application).save_to_stash ();
            });

            // Save when user changes the label
            notetitle.changed.connect (() => {

                this.title_name = notetitle.get_text ();
                //header.set_title (this.title_name);
                this.set_title(this.title_name);

                ((Application)this.application).save_to_stash ();
            });

            // Save when the window thingy closed
            this.close_request.connect (() => {
                ((Application)this.application).save_to_stash ();
                return false;
            });            

            //  //Save when the text thingy has changed
            //  view.buffer.changed.connect (() => {
            //      this.content = view.get_content ();
            //  });
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
            var data = new noteData(current_title, this.theme, this.content , 100, width, height );
            return data;
        }


        // Take a notedata and unpack it
        private void unpackage(noteData data) {
            this.title_name = data.title;
            this.theme = data.theme;
            this.content = data.content;
            this.zoom = data.zoom;
            this.set_default_size ((int)data.width, (int)data.height);
            this.set_title (this.title_name);
        }


        // Some rando actions
        private void action_new () {
            ((Application)this.application).create_note(null);
            ((Application)this.application).save_to_stash ();
        }

        private void action_delete () {
            ((Application)this.application).remove_note(this);
            ((Application)this.application).save_to_stash ();
            this.close ();
            this.destroy ();
        }


        // TODO: Understand this
#if VALA_0_42
        protected bool match_keycode (uint keyval, uint code) {
#else
        protected bool match_keycode (int keyval, uint code) {
#endif
            //  Gdk.KeymapKey [] keys;
            //  Gdk.Keymap keymap = Gdk.Keymap.get_for_display (Gdk.Display.get_default ());
            //  if (keymap.get_entries_for_keyval (keyval, out keys)) {
            //      foreach (var key in keys) {
            //          if (code == key.keycode)
            //              return true;
            //          }
            //      }

            return false;
        }

        // Note gets deleted
        //  public override bool delete_event (Gdk.EventAny event) {
        //      //((Application)this.application).save_to_stash ();
        //      return false;
        //  }

        // Strip old stylesheet, apply the new
        private void update_theme(string theme) {
            // in GTK4 we can replace this with setting css_classes
            remove_css_class (this.theme);
            this.theme = theme;
            add_css_class (this.theme);
            ((Application)this.application).save_to_stash ();
        }
    }
}
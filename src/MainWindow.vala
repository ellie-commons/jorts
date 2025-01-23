/*
* Copyright (c) 2417 Lains
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

namespace jorts {

    // Every notice is an instance of MainWindow
    public class MainWindow : Gtk.Window {
        private Gtk.Button delete_item;
        private new Gtk.SourceBuffer buffer;
        private Gtk.SourceView view;
        private Gtk.HeaderBar header;
        private Gtk.ActionBar actionbar;
        private int uid;
        private static int uid_counter = 0;
        public string color = "#8cd5ff";
        public string selected_color_text = "#002e99";
        public bool pinned = false;
        public string content = "";
        public string title_name = "Jorts";
        public jorts.EditableLabel label; // GTK4: HAS GTK:EDITABLELABEL
        //public Gtk.EditableLabel label = new Gtk.EditableLabel();
        
        public string theme = "Blueberry";

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
            // Else do a new
            if (storage != null) {
                init_from_storage(storage);
            } else {
                this.color = "#8cd5ff";
                this.selected_color_text = "#002e99";
                this.content = "";
                this.title_name = "Jorts";
                set_title (this.title_name);
            }

            // add required base classes
            this.get_style_context().add_class("rounded");
            this.get_style_context().add_class("default-decoration");
            this.get_style_context().add_class("jorts-window");
            this.uid = uid_counter++;

            // Rebuild the whole theming
            update_theme("BLUEBERRY");


            // HEADER
            // Define the header
            header = new Gtk.HeaderBar();
            header.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            header.get_style_context().add_class("jorts-title");
            header.has_subtitle = false;
            header.set_show_close_button (true);
            header.decoration_layout = "close:";

            // Defime the label you can edit. Which is editable.
            label = new jorts.EditableLabel (this.title_name);
            header.set_custom_title(label);
            this.set_titlebar(header);



            // Bar at the bottom
            actionbar = new Gtk.ActionBar ();
            actionbar.get_style_context().add_class("jorts-bar");
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
            get_storage_note();
            ((Application)this.application).update_storage();
        }

        // TODO: A theming service or something. Something cleaner than this in all cases
        // Basically the menu button defines two public variables
        // And then this reconstructs a whole ass theme out of these two
        // Either it can be a service, or just all defined in CSS and add/remove css
        private void update_theme(string theme) {
            var css_provider = new Gtk.CssProvider();
            this.get_style_context().add_class("mainwindow-%d".printf(uid));
            this.get_style_context().add_class("window-%d".printf(uid));

            string style = generate_css(uid, theme);
            
            try {
                css_provider.load_from_data(style, -1);
            } catch (GLib.Error e) {
                warning ("Failed to parse css style : %s", e.message);
            }

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }



        // Content of the action bar
        private void create_actionbar () {
            var new_item = new Gtk.Button ();
            new_item.tooltip_text = (_("New note"));
            new_item.set_image (new Gtk.Image.from_icon_name ("list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            new_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_NEW;

            delete_item = new Gtk.Button ();
            delete_item.tooltip_text = (_("Delete note"));
            delete_item.set_image (new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            delete_item.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_DELETE;

            // GTK4: append
            actionbar.pack_start (new_item);
            actionbar.pack_start (delete_item);
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
            color_button_strawberry.get_style_context ().add_class ("color-strawberry");

            var color_button_orange = new Gtk.Button ();
            color_button_orange.has_focus = false;
            color_button_orange.halign = Gtk.Align.CENTER;
            color_button_orange.height_request = 24;
            color_button_orange.width_request = 24;
            color_button_orange.tooltip_text = _("Orange");

            var color_button_orange_context = color_button_orange.get_style_context ();
            color_button_orange_context.add_class ("color-button");
            color_button_orange_context.add_class ("color-orange");

            var color_button_banana = new Gtk.Button ();
            color_button_banana.has_focus = false;
            color_button_banana.halign = Gtk.Align.CENTER;
            color_button_banana.height_request = 24;
            color_button_banana.width_request = 24;
            color_button_banana.tooltip_text = _("Banana");

            var color_button_banana_context = color_button_banana.get_style_context ();
            color_button_banana_context.add_class ("color-button");
            color_button_banana_context.add_class ("color-banana");

            var color_button_lime = new Gtk.Button ();
            color_button_lime.has_focus = false;
            color_button_lime.halign = Gtk.Align.CENTER;
            color_button_lime.height_request = 24;
            color_button_lime.width_request = 24;
            color_button_lime.tooltip_text = _("Lime");

            var color_button_lime_context = color_button_lime.get_style_context ();
            color_button_lime_context.add_class ("color-button");
            color_button_lime_context.add_class ("color-lime");

            var color_button_blueberry = new Gtk.Button ();
            color_button_blueberry.has_focus = false;
            color_button_blueberry.halign = Gtk.Align.CENTER;
            color_button_blueberry.height_request = 24;
            color_button_blueberry.width_request = 24;
            color_button_blueberry.tooltip_text = _("Blueberry");

            var color_button_blueberry_context = color_button_blueberry.get_style_context ();
            color_button_blueberry_context.add_class ("color-button");
            color_button_blueberry_context.add_class ("color-blueberry");


            var color_button_bubblegum = new Gtk.Button ();
            color_button_bubblegum.has_focus = false;
            color_button_bubblegum.halign = Gtk.Align.CENTER;
            color_button_bubblegum.height_request = 24;
            color_button_bubblegum.width_request = 24;
            color_button_bubblegum.tooltip_text = _("Bubblegum");

            var color_button_bubblegum_context = color_button_blueberry.get_style_context ();
            color_button_bubblegum_context.add_class ("color-button");
            color_button_bubblegum_context.add_class ("color-bubblegum");


            var color_button_grape = new Gtk.Button ();
            color_button_grape.has_focus = false;
            color_button_grape.halign = Gtk.Align.CENTER;
            color_button_grape.height_request = 24;
            color_button_grape.width_request = 24;
            color_button_grape.tooltip_text = _("Grape");

            var color_button_grape_context = color_button_grape.get_style_context ();
            color_button_grape_context.add_class ("color-button");
            color_button_grape_context.add_class ("color-grape");

            var color_button_cocoa = new Gtk.Button ();
            color_button_cocoa.has_focus = false;
            color_button_cocoa.halign = Gtk.Align.CENTER;
            color_button_cocoa.height_request = 24;
            color_button_cocoa.width_request = 24;
            color_button_cocoa.tooltip_text = _("Cocoa");

            var color_button_cocoa_context = color_button_cocoa.get_style_context ();
            color_button_cocoa_context.add_class ("color-button");
            color_button_cocoa_context.add_class ("color-cocoa");

            var color_button_silver = new Gtk.Button ();
            color_button_silver.has_focus = false;
            color_button_silver.halign = Gtk.Align.CENTER;
            color_button_silver.height_request = 24;
            color_button_silver.width_request = 24;
            color_button_silver.tooltip_text = _("Silver");

            var color_button_silver_context = color_button_silver.get_style_context ();
            color_button_silver_context.add_class ("color-button");
            color_button_silver_context.add_class ("color-silver");


            var color_button_slate = new Gtk.Button ();
            color_button_slate.has_focus = false;
            color_button_slate.halign = Gtk.Align.CENTER;
            color_button_slate.height_request = 24;
            color_button_slate.width_request = 24;
            color_button_slate.tooltip_text = _("Slate");

            var color_button_slate_context = color_button_slate.get_style_context ();
            color_button_slate_context.add_class ("color-button");
            color_button_slate_context.add_class ("color-slate");

            var color_button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            // GTK4: append
            // THE HECK IS THESE
            color_button_box.pack_start (color_button_strawberry, false, true, 0);
            color_button_box.pack_start (color_button_orange, false, true, 0);
            color_button_box.pack_start (color_button_banana, false, true, 0);
            color_button_box.pack_start (color_button_lime, false, true, 0);
            color_button_box.pack_start (color_button_blueberry, false, true, 0);
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
            this.color = storage.color;
            this.selected_color_text = storage.selected_color_text;
            this.content = storage.content;
            this.move((int)storage.x, (int)storage.y);
            if ((int)storage.w != 0 && (int)storage.h != 0) {
                this.resize ((int)storage.w, (int)storage.h);
            }
            this.title_name = storage.title;
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
            string color = this.color;
            string selected_color_text = this.selected_color_text;
            Gtk.TextIter start,end;
            view.buffer.get_bounds (out start, out end);
            this.content = view.buffer.get_text (start, end, true);
            this.title_name = label.title.get_label ();
            set_title (this.title_name);

            this.get_position (out x, out y);
            this.get_size (out w, out h);

            return new Storage.from_storage(x, y, w, h, color, selected_color_text, content, title_name);
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
    }


    /* Get a name, spit an array with colours from standard granite stylesheet */
    /* EX: STRAWBERRY --> { "@STRAWBERRY_100" "@STRAWBERRY_900" }*/
    public static string[] generate_palette (string theme) {
        var string_palette = new string[2];

        string_palette = {
            "@" + theme + "_100",
            "@" + theme + "_900"
        };

        return string_palette;
    }

    /* Get a name, spit a whole CSS */
    /* We kinda need better tbh but it is better than before */
    public static string generate_css (int uid, string theme) {
            var palette = generate_palette(theme);

            string style = "";

            style = (N_("""
                @define-color textColorPrimary #323232;

                .mainwindow-%d {
                    background-color: %s;
                    transition: background-color 800ms cubic-bezier(0.4, 0, 0.2, 1);
                }

                .mainwindow-%d undershoot.top {
                    background:
                        linear-gradient(
                            %s 0%,
                            alpha(%s, 0) 50%
                        );
                }
                
                .mainwindow-%d undershoot.bottom {
                    background:
                        linear-gradient(
                            alpha(%s, 0) 50%,
                            %s 100%
                        );
                }

                .jorts-view text selection {
                    color: shade(%s, 1.88);
                    transition: color 800ms cubic-bezier(0.4, 0, 0.2, 1);
                    background-color: %s;
                    transition: background-color 800ms cubic-bezier(0.4, 0, 0.2, 1);
                }

                entry.flat {
                    background: transparent;
                }

                .window-%d .jorts-title image,
                .window-%d .jorts-label {
                    color: %s;
                    box-shadow: none;
                }

                .window-%d .jorts-bar {
                    color: %s;
                    background-color: %s;
                    border-top-color: %s;
                    box-shadow: none;
                    background-image: none;
                    padding: 3px;
                    transition: background-color 800ms cubic-bezier(0.4, 0, 0.2, 1);
                }

                .window-%d .jorts-bar image {
                    color: %s;
                    padding: 3px;
                    box-shadow: none;
                    background-image: none;
                }

                .window-%d .jorts-view,
                .window-%d .jorts-view text,
                .window-%d .jorts-title {
                    background-color: %s;
                    transition: background-color 800ms cubic-bezier(0.4, 0, 0.2, 1);
                    background-image: none;
                    border-bottom-color: %s;
                    font-weight: 500;
                    font-size: 1.2em;
                    color: shade(%s, 0.77);
                    box-shadow: none;
                }

                .window-%d .rotated > widget > box > image {
                    -gtk-icon-transform: rotate(90deg);
                }

                .color-button {
                    border-radius: 50%;
                    background-image: none;
                    border: 1px solid alpha(#333, 0.25);
                    box-shadow:
                        inset 0 1px 0 0 alpha (@inset_dark_color, 0.7),
                        inset 0 0 0 1px alpha (@inset_dark_color, 0.3),
                        0 1px 0 0 alpha (@bg_highlight_color, 0.3);
                }

                .color-button:hover,
                .color_button:focus {
                    border: 1px solid @inset_dark_color;
                }

                .color-slate {
                    background-color: @SLATE_100;
                }

                .color-silver {
                    background-color: @SILVER_100;
                }

                .color-strawberry {
                    background-color: @STRAWBERRY_100;
                }

                .color-orange {
                    background-color: @ORANGE_100;
                }

                .color-banana {
                    background-color: @BANANA_100;
                }

                .color-lime {
                    background-color: @LIME_100;
                }

                .color-blueberry {
                    background-color: @BLUEBERRY_100;
                }

                .color-grape {
                    background-color: @GRAPE_100;
                }

                .color-cocoa {
                    background-color: @COCOA_100;
                }

                .jorts-bar box {
                    border: none;
                }

                .image-button,
                .titlebutton {
                    background-color: transparent;
                    background-image: none;
                    border: 1px solid transparent;
                    padding: 3px;
                    box-shadow: none;
                }

                .image-button:hover,
                .image-button:focus,
                .titlebutton:hover,
                .titlebutton:focus {
                    background-color: alpha(@fg_color, 0.3);
                    background-image: none;
                    border: 1px solid transparent;
                    box-shadow: none;
                }
                """)).printf(uid, palette[0], uid, palette[0], palette[0], uid, palette[0], palette[0], palette[0], palette[1], uid, uid, palette[1], uid, palette[1], palette[0], palette[0], uid, palette[1], uid, uid, uid, palette[0], palette[0], palette[1], uid);

        return style;
    }






}

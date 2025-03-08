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
Move the text view elsewhere so we can extend it more comfortably

Notably:
-recognize links to open in fav browser
-recognize local links to open in Files
-Allow a zoom unzoom

Hypertextview is a Granite widget derived from TextView

Formatting code courtesy of Colin Kiama
https://github.com/colinkiama/vala-gtk4-text-formatting-demo/tree/main

*/

public class jorts.StickyView : Granite.HyperTextView {

        public int zoom;
        public int max_zoom;
        public int min_zoom;

        private SimpleActionGroup actions;
        private Gee.ArrayQueue<FormattingRequest?> formatting_queue = new Gee.ArrayQueue<FormattingRequest?> ();
    
        public const string FORMAT_ACTION_GROUP_PREFIX = "format";
        public const string FORMAT_ACTION_PREFIX = FORMAT_ACTION_GROUP_PREFIX + ".";
        public const string FORMAT_ACTION_BOLD = "bold";
        public const string FORMAT_ACTION_ITALIC = "italic";
        public const string FORMAT_ACTION_UNDERLINE = "underline";
    
        public const string ICON_NAME_BOLD = "format-text-bold-symbolic";
        public const string ICON_NAME_ITALIC = "format-text-italic-symbolic";
        public const string ICON_NAME_UNDERLINE = "format-text-underline-symbolic";
    
        private static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

        static construct {
                action_accelerators[FORMAT_ACTION_BOLD] = "<Control>B";
                action_accelerators[FORMAT_ACTION_ITALIC] = "<Control>I";
                action_accelerators[FORMAT_ACTION_UNDERLINE] = "<Control>U";
        }


        public StickyView (int zoom, string? content) {

                this.buffer = new Gtk.TextBuffer (null);
                this.buffer.text = content;
                this.set_wrap_mode (Gtk.WrapMode.WORD_CHAR);    
                this.bottom_margin = 10;
                this.left_margin = 10;
                this.right_margin = 10;
                this.top_margin = 10;
                this.set_hexpand (true);
                this.set_vexpand (true);

                this.buffer.create_tag (FORMAT_ACTION_BOLD, "weight", 700);
                this.buffer.create_tag (FORMAT_ACTION_ITALIC, "style", 2);
                this.buffer.create_tag (FORMAT_ACTION_UNDERLINE, "underline", Pango.Underline.SINGLE);
                this.buffer.changed.connect (this.handle_text_buffer_change);
                this.buffer.insert_text.connect (this.handle_text_buffer_inserted_text);
                this.buffer.mark_set.connect (this.handle_text_buffer_mark_set);


                this.actions = this.create_formatting_actions ();
                this.register_action_accelerators ();

                //Menu menu = this.create_formatting_menu ();
                //this.set_extra_menu (menu);
        }


        public string get_content() {
                Gtk.TextIter start,end;
                this.buffer.get_bounds (out start, out end);
                return this.buffer.get_text (start, end, true);
        }




        private void register_action_accelerators () {
                this.insert_action_group (FORMAT_ACTION_GROUP_PREFIX, actions);
        
                foreach (var action_name in action_accelerators.get_keys ()) {
                    ((Gtk.Application) GLib.Application.get_default ()).set_accels_for_action (
                        FORMAT_ACTION_PREFIX + action_name,
                        action_accelerators[action_name].to_array ()
                    );
                }
            }

        private SimpleActionGroup create_formatting_actions () {
                var actions_to_return = new SimpleActionGroup ();
        
                ActionEntry[] entries = {
                    { FORMAT_ACTION_BOLD, null, null, "false", this.toggle_format},
                    { FORMAT_ACTION_ITALIC, null, null, "false", this.toggle_format },
                    { FORMAT_ACTION_UNDERLINE, null, null, "false", this.toggle_format },
                };
        
                SimpleAction action;
        
                actions_to_return.add_action_entries (entries, this);
        
                action = (SimpleAction)actions_to_return.lookup_action (FORMAT_ACTION_BOLD);
                action.set_enabled (true);
        
                action = (SimpleAction)actions_to_return.lookup_action (FORMAT_ACTION_ITALIC);
                action.set_enabled (true);
        
                action = (SimpleAction)actions_to_return.lookup_action (FORMAT_ACTION_UNDERLINE);
                action.set_enabled (true);
        
                return actions_to_return;
            }



    private void handle_text_buffer_inserted_text (ref Gtk.TextIter iter, string new_text, int new_text_length) {
        Gtk.TextTagTable text_buffer_tags = this.buffer.get_tag_table ();
        Gtk.TextTag bold_tag = text_buffer_tags.lookup (FORMAT_ACTION_BOLD);
        Gtk.TextTag italic_tag = text_buffer_tags.lookup (FORMAT_ACTION_ITALIC);
        Gtk.TextTag underline_tag = text_buffer_tags.lookup (FORMAT_ACTION_UNDERLINE);

        Gee.ArrayList<FormattingType?> formatting_types_to_add = new Gee.ArrayList<FormattingType?> ();


        if (!iter.has_tag (bold_tag) && (bool)this.get_formatting_action (FORMAT_ACTION_BOLD).get_state ()) {
            formatting_types_to_add.add (FormattingType.BOLD);
        }

        if (!iter.has_tag (italic_tag) && (bool)this.get_formatting_action (FORMAT_ACTION_ITALIC).get_state ()) {
            formatting_types_to_add.add (FormattingType.ITALIC);
        }

        if (!iter.has_tag (underline_tag) && (bool)this.get_formatting_action (FORMAT_ACTION_UNDERLINE).get_state ()) {
            formatting_types_to_add.add (FormattingType.UNDERLINE);
        }

        if (formatting_types_to_add.size == 0) {
            return;
        }

        this.formatting_queue.offer (FormattingRequest () {
            formatting_types = formatting_types_to_add,
            insert_offset = iter.get_offset (),
            insert_length = new_text.length,
        });
    }



        private Menu create_formatting_menu () {
                Menu menu = new Menu ();
                MenuItem item;
        
                this.insert_action_group (FORMAT_ACTION_GROUP_PREFIX, this.actions);
        
                item = new MenuItem (_("Bold"), FORMAT_ACTION_PREFIX + FORMAT_ACTION_BOLD);
                item.set_attribute ("touch-icon", "s", ICON_NAME_BOLD);
                menu.append_item (item);
        
                item = new MenuItem (_("Italic"), FORMAT_ACTION_PREFIX + FORMAT_ACTION_ITALIC);
                item.set_attribute ("touch-icon", "s", ICON_NAME_ITALIC);
                menu.append_item (item);
        
                item = new MenuItem (_("Underline"), FORMAT_ACTION_PREFIX + FORMAT_ACTION_UNDERLINE);
                item.set_attribute ("touch-icon", "s", ICON_NAME_UNDERLINE);
                menu.append_item (item);
        
                return menu;
            }



        private void process_formatting_queue (Gtk.TextBuffer buffer) {
                while (this.formatting_queue.size > 0) {
                    FormattingRequest formatting_request = this.formatting_queue.poll ();
        
                    foreach (FormattingType? formatting_type in formatting_request.formatting_types) {
                        Gtk.TextIter start_iterator;
                        Gtk.TextIter end_iterator;
                        buffer.get_iter_at_offset (out start_iterator, formatting_request.insert_offset);
                        buffer.get_iter_at_offset (
                            out end_iterator,
                            formatting_request.insert_offset + formatting_request.insert_length);
                        buffer.apply_tag_by_name (enum_to_nick (
                            (int)formatting_type,
                            typeof (FormattingType)),
                            start_iterator,
                            end_iterator
                        );
                    }
                }
            }
        
            private void handle_text_cursor_movement_with_no_selection (
                Gtk.TextIter cursor_iter,
                Gee.HashMap<string, Gtk.TextTag> formatting_tags,
                Gee.HashMap<string, SimpleAction> formatting_actions) {
                    // Get cursor position and set action state
                    // based on if tag is applied in cursor position
                    bool has_bold_tag = cursor_iter.has_tag (formatting_tags[FORMAT_ACTION_BOLD]);
                    bool has_italic_tag = cursor_iter.has_tag (formatting_tags[FORMAT_ACTION_ITALIC]);
                    bool has_underline_tag = cursor_iter.has_tag (formatting_tags[FORMAT_ACTION_UNDERLINE]);
                    bool has_formatting = has_bold_tag || has_italic_tag || has_underline_tag;
        
                    if (!has_formatting) {
                        bool could_move_back = cursor_iter.backward_char ();
                        if (could_move_back) {
                            has_bold_tag = cursor_iter.has_tag (formatting_tags[FORMAT_ACTION_BOLD]);
                            has_italic_tag = cursor_iter.has_tag (formatting_tags[FORMAT_ACTION_ITALIC]);
                            has_underline_tag = cursor_iter.has_tag (formatting_tags[FORMAT_ACTION_UNDERLINE]);
        
                            formatting_actions[FORMAT_ACTION_BOLD].set_state (has_bold_tag);
                            formatting_actions[FORMAT_ACTION_ITALIC].set_state (has_italic_tag);
                            formatting_actions[FORMAT_ACTION_UNDERLINE].set_state (has_underline_tag);
                            return;
                        }
                    }
        
                    formatting_actions[FORMAT_ACTION_BOLD].set_state (has_bold_tag);
                    formatting_actions[FORMAT_ACTION_ITALIC].set_state (has_italic_tag);
                    formatting_actions[FORMAT_ACTION_UNDERLINE].set_state (has_underline_tag);
                    return;
            }
        
            private void handle_text_buffer_change (Gtk.TextBuffer buffer) {
                if (this.formatting_queue.size > 0) {
                    this.process_formatting_queue (buffer);
                    return;
                }
        
                SimpleAction bold_action = this.get_formatting_action (FORMAT_ACTION_BOLD);
                SimpleAction italic_action = this.get_formatting_action (FORMAT_ACTION_ITALIC);
                SimpleAction underline_action = this.get_formatting_action (FORMAT_ACTION_UNDERLINE);
                Gtk.TextTagTable text_buffer_tags = this.buffer.get_tag_table ();
                Gtk.TextTag bold_tag = text_buffer_tags.lookup (FORMAT_ACTION_BOLD);
                Gtk.TextTag italic_tag = text_buffer_tags.lookup (FORMAT_ACTION_ITALIC);
                Gtk.TextTag underline_tag = text_buffer_tags.lookup (FORMAT_ACTION_UNDERLINE);
                Gtk.TextIter iterator = Gtk.TextIter ();
                Gtk.TextIter start_iterator, end_iterator;
                bool is_all_bold = true;
                bool is_all_italic = true;
                bool is_all_underline = true;
                bool has_selection = this.buffer.get_selection_bounds (out start_iterator, out end_iterator);
        
                if (!has_selection) {
                    int cursor_position = this.buffer.cursor_position;
                    Gtk.TextIter cursor_iter;
        
                    this.buffer.get_iter_at_offset (out cursor_iter, cursor_position);
                    var formatting_tags = new Gee.HashMap<string, Gtk.TextTag> ();
                    formatting_tags[FORMAT_ACTION_BOLD] = bold_tag;
                    formatting_tags[FORMAT_ACTION_ITALIC] = italic_tag;
                    formatting_tags[FORMAT_ACTION_UNDERLINE] = underline_tag;
        
                    var formatting_actions = new Gee.HashMap<string, SimpleAction> ();
                    formatting_actions[FORMAT_ACTION_BOLD] = bold_action;
                    formatting_actions[FORMAT_ACTION_ITALIC] = italic_action;
                    formatting_actions[FORMAT_ACTION_UNDERLINE] = underline_action;
        
                    this.handle_text_cursor_movement_with_no_selection (cursor_iter, formatting_tags, formatting_actions);
                    return;
                }
        
                iterator.assign (start_iterator);
        
                // For each formatting option, check if selected text is all within
                // the respective formatting tags
                while (!iterator.equal (end_iterator)) {
                    is_all_bold &= iterator.has_tag (bold_tag);
                    is_all_italic &= iterator.has_tag (italic_tag);
                    is_all_underline &= iterator.has_tag (underline_tag);
                    iterator.forward_char ();
                }
        
                bold_action.set_state (is_all_bold);
                italic_action.set_state (is_all_italic);
                underline_action.set_state (is_all_underline);
            }
        
            // Is called whenever a text selection is made and in each time the caret moves   
            private void handle_text_buffer_mark_set (Gtk.TextBuffer buffer, Gtk.TextIter iterator, Gtk.TextMark mark) {
                if (mark.name != "insert") {
                    return;
                }
        
                this.handle_text_buffer_change (buffer);
            }
        
            private void toggle_format (SimpleAction action, Variant value) {
                Gtk.TextIter start_iterator, end_iterator;
                string name = action.get_name ();
        
                action.set_state (value);
        
                this.buffer.get_selection_bounds (out start_iterator, out end_iterator);
        
                if (value.get_boolean ()) {
                    this.buffer.apply_tag_by_name (name, start_iterator, end_iterator);
                } else {
                    this.buffer.remove_tag_by_name (name, start_iterator, end_iterator);
                }
            }
        
            private SimpleAction get_formatting_action (string name) {
                return this.actions.lookup_action (name) as SimpleAction;
            }
        
            string enum_to_nick (int @value, Type enum_type) {
                var enum_class = (EnumClass) enum_type.class_ref ();
        
                if (enum_class == null) {
                    return "%i".printf (@value);
                }
        
                unowned var enum_value = enum_class.get_value (@value);
        
                if (enum_value == null) {
                    return "%i".printf (@value);
                }
        
                return enum_value.value_nick;
            }




}

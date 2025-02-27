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

*/

public class jorts.StickyView : Granite.HyperTextView {

        public int zoom;
        public int max_zoom;
        public int min_zoom;

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
        }


        public string get_content() {
                Gtk.TextIter start,end;
                this.buffer.get_bounds (out start, out end);
                return this.buffer.get_text (start, end, true);
        }
}

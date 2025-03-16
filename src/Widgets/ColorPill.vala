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
I just dont wanna rewrite the same button over and over

*/

public class jorts.ColorPill : Gtk.CheckButton {
        public ColorPill (string tooltip, string colorclass) {
                add_css_class("colorpill");
                add_css_class(colorclass);
                set_size_request (24, 24);
                set_tooltip_text (tooltip);
                add_css_class (Granite.STYLE_CLASS_COLOR_BUTTON);
        }
}


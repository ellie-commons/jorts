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

public class jorts.ColorPill : Gtk.Button {

        public new bool has_focus = false;
        public new Gtk.Align halign = Gtk.Align.CENTER;
        public new string tooltip_text;

        public ColorPill (string tooltip, string colorclass) {
                this.tooltip_text = tooltip;
                this.get_style_context().add_class("color-button");
                this.get_style_context().add_class(colorclass);

                this.set_size_request (24, 24);
        }

}

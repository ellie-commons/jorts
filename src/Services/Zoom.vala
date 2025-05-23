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


namespace Jorts.Zoom {


        // Called when a signal from the popover says stuff got changed
        public void on_zoom_changed(jorts.StickyNoteWindow note, string zoomkind) {
            if (zoomkind == "zoom_in") {
                jorts.Zoom.zoom_in(note);
            } else if (zoomkind == "zoom_out") {
                jorts.Zoom.zoom_out(note);
            } else if (zoomkind == "reset") {
                jorts.Zoom.zoom_default(note);
            }
        }


        // First check an increase doesnt go above limit
        public void zoom_in(jorts.StickyNoteWindow note) {
            if ((note.zoom + 20) <= Jorts.Constants.ZOOM_MAX) {
                jorts.Zoom.set_zoom(note, (note.zoom + 20));
            }
        }

        // First check an increase doesnt go below limit
        public void zoom_out(jorts.StickyNoteWindow note) {
            if ((note.zoom - 20) >= Jorts.Constants.ZOOM_MIN) {
                set_zoom(note, (note.zoom - 20));
            }
        }

        // First check an increase doesnt go below limit
        public void zoom_default(jorts.StickyNoteWindow note) {
            jorts.Zoom.set_zoom(note, Jorts.Constants.DEFAULT_ZOOM);
        }


        // Switch zoom classes, then reflect in the UI and tell the application
        public void set_zoom(jorts.StickyNoteWindow note, int zoom) {
            // Switches the classes that control font size
            note.remove_css_class (Jorts.Utils.zoom_to_class( note.zoom));
            note.zoom = zoom;
            note.add_css_class (Jorts.Utils.zoom_to_class( note.zoom));

            // Reflect the number in the popover
            //note.popover.set_zoomlevel(zoom);

            // Keep it for next new notes
            //((Application)this.application).latest_zoom = zoom;

        }



}
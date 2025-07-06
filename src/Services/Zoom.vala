/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2017-2024 Lains
 * SPDX-FileCopyrightText: 2025 Stella & Charlie (teamcons.carrd.co)
 * SPDX-FileCopyrightText: 2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


namespace Jorts.Zoom {

        // Called when a signal from the popover says stuff got changed
        public void on_zoom_changed (Jorts.StickyNoteWindow note, string zoomkind) {
            if (zoomkind == "zoom_in") {
                Jorts.Zoom.zoom_in (note);
            } else if (zoomkind == "zoom_out") {
                Jorts.Zoom.zoom_out (note);
            } else if (zoomkind == "reset") {
                Jorts.Zoom.zoom_default (note);
            }
        }


        // First check an increase doesnt go above limit
        public void zoom_in(Jorts.StickyNoteWindow note) {
            if ((note.zoom + 20) <= Jorts.Constants.ZOOM_MAX) {
                Jorts.Zoom.set_zoom (note, (note.zoom + 20));
            }
        }

        // First check an increase doesnt go below limit
        public void zoom_out (Jorts.StickyNoteWindow note) {
            if ((note.zoom - 20) >= Jorts.Constants.ZOOM_MIN) {
                set_zoom (note, (note.zoom - 20));
            }
        }

        // First check an increase doesnt go below limit
        public void zoom_default (Jorts.StickyNoteWindow note) {
            Jorts.Zoom.set_zoom (note, Jorts.Constants.DEFAULT_ZOOM);
        }


        // Switch zoom classes, then reflect in the UI and tell the application
        public void set_zoom (Jorts.StickyNoteWindow note, int zoom) {
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

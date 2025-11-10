/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

/*************************************************/
/**
* A register of all possible zoom values we have
*/
public class Jorts.ZoomController : Object {

    private Jorts.StickyNoteWindow window;

    private uint16 _old_zoom;
    public uint16 zoom {
        get {return _old_zoom;}
        set {do_set_zoom (value);}
    }

    public ZoomController (Jorts.StickyNoteWindow window) {
        this.window = window;
    }

    /*********************************************/
    /*              ZOOM feature                 */
    /*********************************************/

    /**
    * Called when a signal from the popover says stuff got changed
    */
    public void zoom_changed (Jorts.Zoomkind zoomkind) {
        debug ("Zoom changed!");

        switch (zoomkind) {
            case Zoomkind.ZOOM_IN:              zoom_in (); break;          // vala-lint=double-spaces
            case Zoomkind.DEFAULT_ZOOM:         zoom_default (); break;     // vala-lint=double-spaces
            case Zoomkind.ZOOM_OUT:             zoom_out (); break;         // vala-lint=double-spaces
            default:                            zoom_default (); break;     // vala-lint=double-spaces
        }
    }

    /**
    * Wrapper to check an increase doesnt go above limit
    */
    public void zoom_in () {
        if ((_old_zoom + 20) <= Jorts.Constants.ZOOM_MAX) {
            zoom = _old_zoom + 20;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    public void zoom_default () {
        if (_old_zoom != Jorts.Constants.DEFAULT_ZOOM ) {
            zoom = Jorts.Constants.DEFAULT_ZOOM;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    /**
    * Wrapper to check an increase doesnt go below limit
    */
    public void zoom_out () {
        if ((_old_zoom - 20) >= Jorts.Constants.ZOOM_MIN) {
            zoom = _old_zoom - 20;
        } else {
            Gdk.Display.get_default ().beep ();
        }
    }

    /**
    * Switch zoom classes, then reflect in the UI and tell the application
    */
    private void do_set_zoom (uint16 new_zoom) {
        debug ("Setting zoom: " + zoom.to_string ());

        // Switches the classes that control font size
        window.remove_css_class (Jorts.Zoom.from_int ( _old_zoom).to_css_class ());
        _old_zoom = new_zoom;
        window.add_css_class (Jorts.Zoom.from_int ( new_zoom).to_css_class ());

        // Adapt headerbar size to avoid weird flickering
        window.view.headerbar.height_request = Jorts.Zoom.from_int (new_zoom).to_ui_size ();

        // Reflect the number in the popover
        window.popover.zoom = new_zoom;

        // Keep it for next new notes
        NoteData.latest_zoom = zoom;

        ((Jorts.Application)window.application).manager.save_all ();
    }
}

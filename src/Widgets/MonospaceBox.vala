/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

public class Jorts.MonospaceBox : Gtk.Box {

    private Gtk.ToggleButton mono_monospace_toggle;

    public bool monospace {
        get { return mono_monospace_toggle.active;}
        set { mono_monospace_toggle.active = value;}
    }

    public signal void monospace_changed (bool monospace);

    construct {
        homogeneous = true;
        hexpand = true;
        margin_start = 12;
        margin_end = 12;

        var mono_default_toggle = new Gtk.ToggleButton () {
            child = new Gtk.Label (_("Default")),
            tooltip_text = _("Click to use default text font")
        };

        mono_monospace_toggle = new Gtk.ToggleButton () {
            child = new Gtk.Label (_("Monospace")),
            tooltip_text = _("Click to use monospaced font")
        };
        mono_monospace_toggle.add_css_class ("monospace");

        append (mono_default_toggle);
        append (mono_monospace_toggle);
        add_css_class (Granite.STYLE_CLASS_LINKED);

        mono_monospace_toggle.bind_property (
            "active",
            mono_default_toggle,
            "active",
            GLib.BindingFlags.BIDIRECTIONAL | GLib.BindingFlags.INVERT_BOOLEAN
        );
    
        mono_monospace_toggle.notify["active"].connect (on_monospace_changed);
    }


    public void on_monospace_changed () {
        monospace_changed (mono_monospace_toggle.active);
        print (mono_monospace_toggle.active.to_string());
    }

}
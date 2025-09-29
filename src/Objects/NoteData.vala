/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */


/*************************************************/
/**
* An object used to package all data conveniently as needed.
*/
public class Jorts.NoteData : Object {

    // Will determine properties (or lack thereof) for any new note
    public static Jorts.Themes latest_theme = Jorts.Constants.DEFAULT_THEME;
    public static uint8? latest_zoom = Jorts.Constants.DEFAULT_ZOOM;
    public static bool latest_mono = Jorts.Constants.DEFAULT_MONO;

    public string title;
    public Jorts.Themes theme;
    public string content;
    public bool monospace;
    public uint8 zoom;
    public int width;
    public int height;

    /*************************************************/
    /**
    * Convert into a Json.Object()
    */
    public NoteData (string? title = null, Jorts.Themes? theme = null, string? content = null,
                    bool? monospace = null, uint8? zoom = null, int? width = null, int? height = null)
    {
        // We assign defaults in case theres args missing
        this.title = title ?? Jorts.Utils.random_title ();
        this.theme = theme ?? Jorts.Utils.random_theme ();
        this.content = content ?? "";
        this.monospace = monospace ?? Jorts.Constants.DEFAULT_MONO;
        this.zoom = zoom ?? Jorts.Constants.DEFAULT_ZOOM;
        this.width = width ?? Jorts.Constants.DEFAULT_WIDTH;
        this.height = height ?? Jorts.Constants.DEFAULT_HEIGHT;
    }

    /*************************************************/
    /**
    * Parse a node to create an associated NoteData object
    */
    public NoteData.from_json (Json.Object node) {

        print ("\nload json");
        title       = node.get_string_member_with_default ("title",(_("Forgot title!")));
        var themestring       = node.get_string_member_with_default ("theme",Jorts.Utils.random_theme (null).to_string ());
        theme = Jorts.Themes.from_string (themestring);
        content     = node.get_string_member_with_default ("content","");
        monospace   = node.get_boolean_member_with_default ("monospace",Jorts.Constants.DEFAULT_MONO);
        zoom        = (uint8)node.get_int_member_with_default ("zoom",Jorts.Constants.DEFAULT_ZOOM);

        // Make sure the values are nothing crazy
        if (zoom < Jorts.Constants.ZOOM_MIN)        { zoom = Jorts.Constants.ZOOM_MIN;}
        else if (zoom > Jorts.Constants.ZOOM_MAX)   { zoom = Jorts.Constants.ZOOM_MAX;}

        width       = (int)node.get_int_member_with_default ("width",Jorts.Constants.DEFAULT_WIDTH);
        height      = (int)node.get_int_member_with_default ("height",Jorts.Constants.DEFAULT_HEIGHT);
    }

    /*************************************************/
    /**
    * Parse a node to create an associated NoteData object
    * We skip last chosen theme, and reuse latest set zoom and whether user prefers monospace
    */
    public NoteData.from_random () {
        title = title ?? Jorts.Utils.random_title ();
        theme = Jorts.Utils.random_theme (latest_theme);
        content = content ?? "";
        monospace = latest_mono;
        zoom = latest_zoom;
        width = Jorts.Constants.DEFAULT_WIDTH;
        height = Jorts.Constants.DEFAULT_HEIGHT;
    }

    /*************************************************/
    /**
    * Used for storing NoteData inside disk storage
    */
    public Json.Object to_json () {
        var builder = new Json.Builder ();

		// Lets fkin gooo
        builder.begin_object ();
        builder.set_member_name ("title");
        builder.add_string_value (title);
        builder.set_member_name ("theme");
        builder.add_string_value (theme.to_string ());
        builder.set_member_name ("content");
        builder.add_string_value (content);
        builder.set_member_name ("monospace");
        builder.add_boolean_value (monospace);
		builder.set_member_name ("zoom");
        builder.add_int_value (zoom);
        builder.set_member_name ("height");
        builder.add_int_value (height);
        builder.set_member_name ("width");
        builder.add_int_value (width);
        builder.end_object ();

        return builder.get_root ().get_object ();
    }
}

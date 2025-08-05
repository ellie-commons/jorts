/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2017-2024 Lains
 *                          2025 Stella & Charlie (teamcons.carrd.co)
 *                          2025 Contributions from the ellie_Commons community (github.com/ellie-commons/)
 */

// The NoteData object is just packaging to pass off data from and to storage
public class Jorts.NoteData : Object {

    public string title;
    public string theme;
    public string content;
    public int zoom;
    public int width;
    public int height;

    public NoteData (
        string? title = null,
        string? theme = null,
        string? content = null,
        int? zoom = null,
        int? width = null, int? height = null)
    {
        // We assign defaults in case theres args missing
        this.title = title ?? Jorts.Utils.random_title ();
        this.theme = theme ?? Jorts.Utils.random_theme ();
        this.content = content ?? "";
        this.zoom = zoom ?? Jorts.Constants.DEFAULT_ZOOM;
        this.width = width ?? Jorts.Constants.DEFAULT_WIDTH;
        this.height = height ?? Jorts.Constants.DEFAULT_HEIGHT;
    }

    public Json.Object to_json () {
        var builder = new Json.Builder ();

		// Lets fkin gooo
        builder.begin_object ();
        builder.set_member_name ("title");
        builder.add_string_value (title);
        builder.set_member_name ("theme");
        builder.add_string_value (theme);
        builder.set_member_name ("content");
        builder.add_string_value (content);
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

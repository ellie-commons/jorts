/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2025 Stella & Charlie (teamcons.carrd.co) and the Ellie_Commons community (github.com/ellie-commons/)
 */

// The NoteData object is just packaging to pass off data from and to storage
namespace Jorts {

    public class NoteData : Object {
        public string title;
        public string theme;
        public string content;
        public int zoom;
        public int width;
        public int height;

        public NoteData (
            string? title = null, string? theme = null, string? content = null,
            int? zoom = null, int? width = null, int? height = null)
        {

            // We assign defaults in case theres args missing
            this.title = title ?? Jorts.Utils.random_title ();
            this.theme = theme ?? Jorts.Utils.random_theme ();
            this.content = content ?? "";
            this.zoom = zoom ?? Jorts.Constants.DEFAULT_ZOOM;
            this.width = width ?? Jorts.Constants.DEFAULT_WIDTH;
            this.height = height ?? Jorts.Constants.DEFAULT_HEIGHT;
        }
    }
}

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

// The noteData object is just packaging to pass off data from and to storage
namespace jorts {

    public class noteData : Object {
        public int uid;
        public string title;
        public string theme;
        public string content;
        public int zoom;
        public int64 width;
        public int64 height;

        public noteData(int uid, string title, string theme, string content, int zoom, int64 width, int64 height )
        {
            this.uid = uid;
            this.title = title;
            this.theme = theme;
            this.content = content;
            this.zoom = zoom;
            this.width = width;
            this.height = height;
        }
    }
}

# Issue Extensions plugin for Redmine
# Copyright (C) 2010-2012  Takashi Takebayashi
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module IssueExtensions
  class ViewHooks < Redmine::Hook::ViewListener
    # 関連したチケット・複製したチケットの作成ページへのリンクを追記する
    render_on :view_issues_show_description_bottom, :partial => 'issues/issue_extensions_form'
    # 関連元のチケットのID埋め込みと「自分を選ぶ」ボタンを追記する
    render_on :view_issues_form_details_bottom, :partial => 'issues/issue_extensions_view_issues_form_details_bottom'
  end
end

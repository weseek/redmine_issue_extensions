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

Redmine::Plugin.register :redmine_issue_extensions do
  name 'Redmine Issue Extensions plugin'
  author 'Takashi Takebayashi'
  url 'https://github.com/weseek/redmine_issue_extensions'
  description 'This is a Issue Extensions plugin for Redmine'
  version '0.2.0-1'
  requires_redmine :version_or_higher => '5.1.0'

  project_module :issue_extensions do
    # 設定画面(ステータスの自動変更)は廃止したため、紐づくアクションはない。
    # モジュールをプロジェクト設定に表示するために permission だけ残している。
    permission :manage_issue_extensions, {}, :require => :member
  end
end

# hook は再読み込みの対象にしないため、初期化の最後に一度だけ読み込む
Rails.application.config.after_initialize do
  require File.expand_path('lib/issue_extensions/issue_hooks', __dir__)
  require File.expand_path('lib/issue_extensions/view_hooks', __dir__)
end

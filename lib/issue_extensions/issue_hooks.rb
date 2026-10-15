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
  class IssueHooks < Redmine::Hook::Listener
    def controller_issues_edit_before_save(context = {})
      issue = context[:issue]
      return unless IssueExtensions.enabled?(issue.project)

      set_done_ratio_when_closed(issue)
    end

    def controller_issues_edit_after_save(context = {})
      issue = context[:issue]
      return unless IssueExtensions.enabled?(issue.project)

      add_current_user_to_watchers(issue)
    end

    def controller_issues_bulk_edit_before_save(context = {})
      issue = context[:issue]
      return unless IssueExtensions.enabled?(issue.project)

      set_done_ratio_when_closed(issue)
    end

    def controller_issues_new_after_save(context = {})
      issue = context[:issue]
      return unless IssueExtensions.enabled?(issue.project)

      add_relation_from(issue, context[:params][:relation_issue_id])
    end

    private

    # チケットがクローズされている場合、進捗を100%に変更する
    def set_done_ratio_when_closed(issue)
      return if Issue.use_status_for_done_ratio?
      return if issue.disabled_core_fields.include?('done_ratio')
      return unless issue.status&.is_closed?

      issue.done_ratio = 100 if issue.done_ratio != 100
    end

    # チケットを更新した場合、更新者をウォッチャーに追加する
    def add_current_user_to_watchers(issue)
      user = User.current
      return unless user.logged?
      return if issue.watched_by?(user)

      issue.add_watcher(user)
    end

    # 関連元のチケットが指定されている場合、関連付けする
    def add_relation_from(issue, relation_issue_id)
      return if relation_issue_id.blank?
      return unless User.current.allowed_to?(:manage_issue_relations, issue.project)

      from_issue = Issue.visible.find_by(:id => relation_issue_id.to_i)
      return if from_issue.nil? || from_issue == issue

      relation = IssueRelation.new(:relation_type => IssueRelation::TYPE_RELATES)
      relation.issue_from = from_issue
      relation.issue_to = issue
      relation.init_journals(User.current)
      relation.save
    end
  end
end

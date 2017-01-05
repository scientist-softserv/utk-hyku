module Hyku
  class Group < ApplicationRecord
    self.table_name = 'hyku_groups'
    resourcify

    MEMBERSHIP_ROLE = :member
    DEFAULT_MEMBER_CLASS = User

    def self.add_members_by_id(ids:, group:, member_class: DEFAULT_MEMBER_CLASS)
      new_member_ids = Array.wrap(ids)
      new_members = member_class.find(new_member_ids)
      new_members.collect { |m| m.add_role MEMBERSHIP_ROLE, group }
    end

    def add_members_by_id(ids, member_class: DEFAULT_MEMBER_CLASS)
      self.class.add_members_by_id(ids: ids, group: self, member_class: member_class)
    end

    def members(member_class: DEFAULT_MEMBER_CLASS)
      member_class.with_role(MEMBERSHIP_ROLE, self)
    end

    def number_of_users
      members.count
    end
  end
end

module Hyku
  class Group < ApplicationRecord
    self.table_name = 'hyku_groups'
    resourcify

    MEMBERSHIP_ROLE = :member
    DEFAULT_MEMBER_CLASS = User

    def add_members_by_id(ids, member_class: DEFAULT_MEMBER_CLASS)
      new_members = member_class.find(Array.wrap(ids))
      new_members.collect { |m| m.add_role(MEMBERSHIP_ROLE, self) }
    end

    def remove_members_by_id(ids, member_class: DEFAULT_MEMBER_CLASS)
      old_members = member_class.find(Array.wrap(ids))
      old_members.collect { |m| m.remove_role(MEMBERSHIP_ROLE, self) }
    end

    def members(member_class: DEFAULT_MEMBER_CLASS)
      member_class.with_role(MEMBERSHIP_ROLE, self)
    end

    def number_of_users
      members.count
    end
  end
end

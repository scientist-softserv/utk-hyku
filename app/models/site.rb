class Site < ActiveRecord::Base
  resourcify

  validates :application_name, presence: true, allow_nil: true

  # Allow for uploading of site's banner image
  mount_uploader :banner_image, BannerImageUploader

  belongs_to :account
  has_many :content_blocks
  accepts_nested_attributes_for :account, update_only: true

  delegate :announcement_text, :marketing_text, :featured_researcher,
           :announcement_text=, :marketing_text=, :featured_researcher=,
           :about_page, :about_page=,
           to: :content_blocks

  class << self
    delegate :account, :application_name, :institution_name,
             :institution_name_full, :reload, :update, :announcement_text,
             :marketing_text, :featured_researcher, :announcement_text=,
             :marketing_text=, :featured_researcher=,
             :about_page, :about_page=,
             to: :instance

    def instance
      first_or_create
    end
  end
end

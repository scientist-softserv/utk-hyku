# frozen_string_literal: true

module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior
  # OVERRIDE some Hyrax helper behavior methods
  include Hyrax::HyraxHelperBehaviorOverrides
  include Hyrax::CollectionCountHelper

  include AllinsonFlex::AllinsonFlexHelper
  include Hyrax::WorkFormHelperDecorator

  def application_name
    Site.application_name || super
  end

  def institution_name
    Site.institution_name || super
  end

  def institution_name_full
    Site.institution_name_full || super
  end

  def banner_images
    Site.instance.banner_images.any? ? Site.instance.banner_images.map(&:url) : [banner_image]
  end

  def logo_image
    Site.instance.logo_image? ? Site.instance.logo_image.url : false
  end

  def block_for(name:)
    block = ContentBlock.find_by(name: name)
    has_value = block&.value.present?
    has_value ? block.value : false
  end

  def directory_image
    Site.instance.directory_image? ? Site.instance.directory_image.url : false
  end

  def default_collction_image
    Site.instance.default_collection_image? ? Site.instance.default_collection_image.url : false
  end

  def default_work_image
    Site.instance.default_work_image? ? Site.instance.default_work_image.url : 'work.png'
  end
end

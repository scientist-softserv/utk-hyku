module ContentBlockHelper
  include Sufia::ContentBlockHelperBehavior

  # rubocop:disable Rails/OutputSafety
  def displayable_content_block(content_block, **options)
    return if content_block.value.blank?
    content_tag :div, raw(content_block.value), options
  end
  # rubocop:enable Rails/OutputSafety
end

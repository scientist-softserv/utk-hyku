# frozen_string_literal: true

Flipflop.configure do
  feature :show_featured_researcher,
          default: true,
          description: "Shows the Featured Researcher tab on the homepage."

  feature :show_share_button,
          default: true,
          description: "Shows the 'Share Your Work' button on the homepage."

  # Commenting this out means all tenants won't get this the show_featured_works flipper
  # TODO: We should find a way to make this tenant specific
  # ref: https://github.com/scientist-softserv/utk-hyku/issues/47
  #   feature :show_featured_works,
  #           default: true,
  #           description: "Shows the Featured Works tab on the homepage."

  feature :show_recently_uploaded,
          default: true,
          description: "Shows the Recently Uploaded tab on the homepage."
end

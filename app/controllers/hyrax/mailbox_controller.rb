require File.join(Hyrax::Engine.paths['app/controllers'].first, 'hyrax/mailbox_controller.rb')

module Hyrax
  class MailboxController
    layout 'admin'
  end
end

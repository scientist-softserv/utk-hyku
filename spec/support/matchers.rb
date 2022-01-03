# frozen_string_literal: true

# Thank you, David Chelimsky: http://stackoverflow.com/a/11337889
RSpec::Matchers.define :have_constant do |const|
  match do |owner|
    owner.const_defined?(const)
  end
end

RSpec::Matchers.define :be_cname do |subdomain|
  target_cname = if ENV['HYKU_DEFAULT_HOST'].present?
                   # rubocop:disable Style/FormatStringToken
                   ENV['HYKU_DEFAULT_HOST'].gsub('%{tenant}', subdomain)
                   # rubocop:enable Style/FormatStringToken
                 else
                   "#{subdomain}.localhost"
                 end

  match do |cname|
    cname == target_cname
  end
end

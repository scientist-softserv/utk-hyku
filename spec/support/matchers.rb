# Thank you, David Chelimsky: http://stackoverflow.com/a/11337889
RSpec::Matchers.define :have_constant do |const|
  match do |owner|
    owner.const_defined?(const)
  end
end

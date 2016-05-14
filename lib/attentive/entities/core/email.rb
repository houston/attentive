require "attentive/entity"

# Email regex asserts that there are no @ symbols or whitespaces in either the
# localpart or the domain, and that there is a single @ symbol separating the
# localpart and the domain.
Attentive::Entity.define "core.email", %q{(?<email>[^@\s]+@[^@\s]+)} do |match|
  match["email"]
end

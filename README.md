# Attentive

Attentive is a library for matching messages to natural-language listeners.


<br/>

## Usage

Its basic usage is like this:

```ruby
include Attentive

listen_for "hi", context: { in: :any } do
  puts "nice to meet you!"
end

hear! "hi!" # => "nice to meet you!"
```

In the snippet above,

  1. We defined a [listener](#listeners) that is active in any [context](#contexts).
  2. We received a message.
  3. Attentive matched the message to our listener and invoked the block.

<br/>

#### Optional Characters

You'll notice that we listened for `"hi"` but _heard_ `"hi!"`. Attentive treats punctuation and emojis as optional; but we can make them required by putting them in the listener:

```ruby
listen_for "hi!", context: { in: :any } do
  puts "nice to meet you!"
end

hear! "hi" # => nothing happened, the listener is expecting the exclamation mark
```

> It's best to leave all but the most necessary punctuation out of listeners.

<br/>

#### Contractions and Abbreviations

Attentive understands contractions and abbreviations and can match those:

```ruby
listen_for "hi", context: { in: :any } do
  puts "nice to meet you!"
end

hear! "hello!" # => "nice to meet you!"

listen_for "what is for lunch", context: { in: :any } do
  puts "HAMBURGERS!"
end

hear! "what's for lunch?" # => "HAMBURGERS!"
```

> Although you _can_ use contractions and abbreviations in listeners, it's a good habit not to. Attentive will not let you define listeners that use ambiguous contractions like `"where's"` (`"where's"` might be a contraction for `"where is"`, `"where does"`, or `"where has"`, or `"where was"`).

<br/>

#### Listeners

Listeners are defined with three things:

  1. One or more phrases
  2. A set of [contexts](#contexts) where they're active
  3. A block to be invoked when the listener is matched

Here's an example of a listener that matches more than one phrase:

```ruby
listen_for "what is for lunch",
           "what is for lunch {{date:core.date.relative.future}}",
           "what is for lunch on {{date:core.date}}",
           "show me the menu for {{date:core.date.relative.future}}",
           "show me the menu for {{date:core.date}}" do
  # ...
end
```

(In the example above, the phrases `{{date:core.date.relative.future}}` and `{{date:core.date}}` are [entities](#entities): which we'll cover in a minute.)

<br/>

#### Contexts

A listener can require that messages be heard in a certain context in order to be matched or it can ignore messages if they are heard in certain contexts.

The following is a listener that will only match messages heard in the "#general" channel and only then if the conversation is not "serious".

```ruby
listen_for "ouch", context: { in: %i{general}, not_in: %i{serious} } do
  puts "On a scale of 1 to 10, how would you rate your pain?"
end

hear! "ouch" # => message has no context, listener isn't triggered
hear! "ouch", contexts: %i{general} # => "On a scale of 1 to 10..."
hear! "ouch", contexts: %i{general serious} # => listener ignores "serious" messages
```

If you don't specify context requirements for listeners, Attentive requires `conversation` and prohibits `quotation` by default:

```ruby
# These two are the same:
listen_for "ouch"
listen_for "ouch", context: { in: %i{conversation}, not_in: %i{quotation} }
```


<br/>

#### Entities

Entities allow Attentive to match **_concepts_** rather than specific words.

There are built-in entities like `core.date`, `core.number`, and `core.email` for recognizing dates, numbers, and email addresses (see [Core Entities](https://github.com/houston/attentive/wiki/Core-Entities) for a complete list); but you can also define entities for domain-specific concepts. For example:

```ruby
Attentive::Entity.define "deweys.menu.beers",
  "Bell's Oberon",
  "Rogue Dead Guy Ale",
  "Schalfly Dry Hopped IPA",
  "4 Hands Contact High",
  "Scrimshaw Pilsner"
```

Now we can take drink orders:

```ruby
listen_for "I will have a pint of the {{deweys.menu.beers}}" do
  puts "Good choice"
end
```

> It is a good idea to namespace entities (i.e. `deweys.menu.beers`). Attentive's convention is to treat namespaces as a taxonomy for concepts.

<br/>

#### Regular Expressions

As useful as enumerations are, entities can also be defined with regular expressions and with a block that converts the matched part of the message to a more useful value:

```ruby
# Usernames can be up to 21 characters long.
# They can contain lowercase letters a to z
# (without accents), and numbers 0 to 9.

Attentive::Entity.define "slack.user", %q{(?<username>[a-z0-9]{1,21})} do |match|
  Slack::User.find match["username"]
end
```

> Whenever possible, though, prefer composing entities to using regular expressions.
> For example:
> ```ruby
Attentive::Entity.define "core.date.relative.future",
  "next {{core.date.wday}}"
```
> is better than:
> ```ruby
Attentive::Entity.define "core.date.relative.future",
  "next (?<weekday>(:sun|mon|tues|wednes|thurs|fri|satur)day)"
```


<br/>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attentive'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attentive


<br/>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


<br/>

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/houston/attentive.


<br/>

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

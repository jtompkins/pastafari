# Pastafari

Pastafari is a library for building simple finite state machines in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pastafari'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pastafari

## Usage

```ruby
# Define an FSM with the Pastafari FSM DSL:
fsm = Pastafari::FSM.build do
  # Set the order of operations with #transition.
  # :before runs the current state's transition functions before processing the input.
  # :after runs the transition function after input processing.
  transition :after # :after is the default value

  # Set the initial state:
  initial_state :first_state
  # If #initial_state isn't called, the first state defined by the DSL will be
  # assumed to be the initial FSM state.

  state :first_state do
    # Define the input processing function:
    process { |i| puts i }

    # If this state can transition into another state, define the transition
    # conditions:
    transition_to(:second_state).when { |i| i == 1 }
    # The transition function is a predicate - it should return a truthy or falsey
    # value. If the function returns a truthy value, the FSM will transition into
    # the new state.

    # You can define as many transitions as you'd like:
    transition_to(:third_state).when { |i| i == 2 }
    # If a transition references a state that isn't defined, Pastafari will
    # raise an error.    
  end

  state :second_state do
    # The processing function MUST be called; if it isn't, Pastafari will
    # raise an error.
    process { |i| puts i / 2 }
  end

  state :third_state do
    process { |i| puts i / 3 }

    # Transition functions are optional.
  end
end

# Run the FSM with #run. Pass in an array, or a value that can be converted to an
# Array with #Array.
fsm.run([1, 2, 3]) # => should print 1, 1, 1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pastafari. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

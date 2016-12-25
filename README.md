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
# Pastafari offers a simple DSL for defining state machines:
fsm = Pastafari::FSM.build do
  # Define when the state transition functions run:
  transition :after # Valid values are :before & :after (default)

  initial_state :first_state
  # If the initial state isn't called, the first state defined is the initial.

  state :first_state do
    # You must define a processing function:
    process { |i| puts i }
    # Pastafari raises an error if #process isn't called.

    # State change is defined with transition functions:
    transition_to(:second_state).when { |i| i == 1 }
    # The transition function must return a boolean value. If it returns `true`,
    # the FSM will transition to the new state.

    # A state can define more than one transition function:
    transition_to(:third_state).when { |i| i == 2 }

    # If a transition references a state that isn't defined, Pastafari will
    # raise an error.    
  end

  state :second_state do
    process { |i| puts i / 2 }

    transition_to(:third_state).when { |i| i == 2 }
  end

  # A state without any transition functions is final - the FSM will remain
  # in that state once it reaches it.
  state :third_state do
    process { |i| puts i / 3 }
  end
end

# Process input by calling #run, passing in an array, or a value that can be
# converted into an Array.
fsm.run([1, 2, 3]) # => should print 1, 1, 1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pastafari. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

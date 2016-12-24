require 'pastafari'

fsm = Pastafari::Fsm.build do
  transition :after

  state :process_a do
    process { 1 }

    transition_to(:process_b).when { |i| i == 'a' }
  end

  state :process_b do
    process { 2 }

    transition_to(:process_c).when { |i| i == 'b' }
  end

  state :process_c do
    process { 3 }
  end
end

input = %w(a b c)

puts "Running FSM for input: '#{input.join(', ')}'. Expected output: '1, 2, 3'"

output = fsm.run(%w(a b c)).join(', ')

puts "Received output: #{output}"

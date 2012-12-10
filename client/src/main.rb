require_relative 'client.rb'
require_relative 'gui/main.rb'


def main
  # Create a new client
  client = Client.new()

  # Create a new GUI and run it.
  gui = GUI.new(client)
  gui.run()

  # That's all we need!
end

main

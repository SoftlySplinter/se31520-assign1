require_relative('client.rb')
require_relative('gui/main.rb')

client = Client.new()
gui = GUI.new(client)
gui.run()

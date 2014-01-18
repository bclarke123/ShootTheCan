require 'yaml'

class Settings
  @@settings_file = File.join(File.dirname(__FILE__), 'settings.yml')

  def load
    @@items = YAML::load_file(@@settings_file)
  end
  
  def [](key)
    @@items[key]
  end

end

SETTINGS = Settings.new
SETTINGS.load

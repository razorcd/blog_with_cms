# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( nav.css )

#adds all ./app/assets/stylesheets/*.css files
=begin
Dir.foreach('./app/assets/stylesheets') do |f|
  if File.file?('./app/assets/stylesheets/' +f) 
    #puts f
    Rails.application.config.assets.precompile += [f] #%w( nav.css )
  end
end
=end


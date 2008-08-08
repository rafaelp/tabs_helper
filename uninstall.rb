# Uninstall hook code here

require 'fileutils'

directory = File.dirname(__FILE__)

[ :stylesheets, :javascripts, :images].each do |asset_type|
  path = File.join(directory, "../../../public/#{asset_type}/tabs")
  FileUtils.rm_r(path)
end

task :environment do |_, _| 
  require File.expand_path('../lib/colors', __FILE__)
end

task :colors, [:file_path] => :environment do |_, args|
  puts " "
  Colors.execute(args[:file_path])
  puts " "
end

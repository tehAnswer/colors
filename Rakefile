task :environment do
  require File.expand_path('lib/colors', __FILE__)
end

task colors: [:file_path] => :environment do
  puts " "
  Colors.execute(file_path)
  puts " "
end

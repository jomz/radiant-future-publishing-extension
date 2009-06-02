namespace :radiant do
  namespace :extensions do
    namespace :future_publishing do
      
      desc "Runs the migration of the Future Publishing extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FuturePublishingExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FuturePublishingExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Future Publishing to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from FuturePublishingExtension"
        Dir[FuturePublishingExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(FuturePublishingExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end

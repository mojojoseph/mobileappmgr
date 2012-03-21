Capistrano::Configuration.instance.load do

  namespace :mobileappmgr do

    desc "Symlink"
    task :symlink_mobileapps do
      run ("mkdir #{shared_path}/mobileapps")
      run ("ln -s #{shared_path}/mobileapps #{current_path}/public/mobileapps")
    end


    desc "Publish an IPA to a remote deployment server"
    task :publish do
      puts "Uploading IPA to #{current_release}"
      puts "#{shared_path}"

      cap_root   = Pathname.getwd
      build_root = cap_root.join "mobileapps"

      configuration_file = build_root.join 'mobileapps.yml'
      build_config       = YAML::load(File.open(configuration_file))
      ios_build_dir      = build_root.join build_config['ios']['directory']

      # Dirty way, just iterate over all of the files and pick the ones
      # we want, namely the .ipa and .plist
      ios_build_dir.each_child do |f|
        if f.extname == ".ipa" then
          fname = f.basename
          upload(f.to_s, "#{shared_path}/mobileapps/#{fname}")
        end
        
        if f.extname == ".plist" then
          fname = f.basename
          upload(f.to_s, "#{shared_path}/mobileapps/#{fname}")
        end
      end
    end
  end
end

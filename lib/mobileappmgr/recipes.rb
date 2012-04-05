Capistrano::Configuration.instance.load do

  namespace :mobileappmgr do

    # type needs be 'ipa' or 'apk'
    def workhorse(type)

      configuration_file = Pathname.getwd.join 'mobileapps.yml'
      build_config       = YAML::load(File.open(configuration_file))
      app_build_dir      = Pathname.getwd.join build_config['application']['directory']
      
      apps = Dir["#{app_build_dir}/*.#{type}"]

      apps.each do |app|
          
        fname = File.basename(app)
        puts "APP = #{fname}"
        upload(app.to_s, "#{shared_path}/mobileapps/#{fname}")
          
        apptarget = build_config['application']['apptarget']
        fname =~ /#{apptarget}\.(.*)\.#{type}/ # Get the version
        version = $1                       # Perl, save us
        uploaded = Time.now.strftime("%Y-%m-%d %H:%M:%S %Z").to_yaml
        whoami   = `whoami`.chop

        type == "apk" ? platform = "android" : platform = "iOS"
        if type == "ios"
          bundleid = build_config['ios']['bundleid']
        else
          bundleid = ""
        end
          
        yml_content = <<-YML_DOCUMENT
platform:  #{platform}
uploaded:  #{uploaded}
creator:  #{whoami}
apptarget:  #{build_config['application']['apptarget']}
bundleid:  #{bundleid}
name:  #{build_config['application']['name']}
version:  #{version}
YML_DOCUMENT

        yml_fname = "#{build_config['application']['name']}_#{type}_#{version}.yml"
        File.open(yml_fname, 'w') {|f| f.write(yml_content)}
        upload(yml_fname, "#{shared_path}/mobileapps/#{yml_fname}")
      end
      

    end

    desc "Symlink"
    task :symlink_mobileapps do
      run ("mkdir #{shared_path}/mobileapps")
      run ("ln -s #{shared_path}/mobileapps #{current_path}/public/mobileapps")
    end

    desc "Publish an Android APK to a remote deployment server"
    namespace :publish do
      task :apk do
        workhorse "apk"
      end

      desc "Publish an IPA to a remote deployment server"
      task :ipa do
        puts "Uploading IPA to #{current_release}"
        
        configuration_file = Pathname.getwd.join 'mobileapps.yml'
        build_config       = YAML::load(File.open(configuration_file))
        ios_build_dir      = Pathname.getwd.join build_config['application']['directory']
        
        ipas = Dir["#{ios_build_dir}/*.ipa"]
        
        ipas.each do |ipa|
          
          fname = File.basename(ipa)
          puts "IPA = #{fname}"
          upload(ipa.to_s, "#{shared_path}/mobileapps/#{fname}")
          
          apptarget = build_config['application']['apptarget']
          fname =~ /#{apptarget}\.(.*)\.ipa/ # Get the version
          version = $1                       # Perl, save us
          uploaded = Time.now.strftime("%Y-%m-%d %H:%M:%S %Z").to_yaml
          whoami   = `whoami`.chop
          
          yml_content = <<-YML_DOCUMENT
platform:  ios
uploaded:  #{uploaded}
creator:  #{whoami}
apptarget:  #{build_config['application']['apptarget']}
bundleid:  #{build_config['ios']['bundleid']}
name:  #{build_config['application']['name']}
version:  #{version}
YML_DOCUMENT

          yml_fname = "#{build_config['application']['name']}_ipa_#{version}.yml"
          File.open(yml_fname, 'w') {|f| f.write(yml_content)}
          upload(yml_fname, "#{shared_path}/mobileapps/#{yml_fname}")
        end
      end
    end
  end
end

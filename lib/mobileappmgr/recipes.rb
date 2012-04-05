Capistrano::Configuration.instance.load do

  namespace :mobileappmgr do

    desc "Symlink"
    task :symlink_mobileapps do
      run ("mkdir #{shared_path}/mobileapps")
      run ("ln -s #{shared_path}/mobileapps #{current_path}/public/mobileapps")
    end

    desc "Publish an Android APK to a remote deployment server"
    namespace :publish do
      task :apk do

        configuration_file = Pathname.getwd.join 'mobileapps.yml'
        build_config       = YAML::load(File.open(configuration_file))
        ios_build_dir      = Pathname.getwd.join build_config['android']['directory']

        apks = Dir["#{apk_build_dir}/*.apk"]

        ipas.each do |ipa|

          fname = File.basename(ipa)
          puts "IPA = #{fname}"
          upload(ipa.to_s, "#{shared_path}/mobileapps/#{fname}")
          
          apptarget = build_config['ios']['apptarget']
          fname =~ /#{apptarget}\.(.*)\.apk/ # Get the version
          version = $1                       # Perl, save us
          uploaded = Time.now.strftime("%Y-%m-%d %H:%M:%S %Z").to_yaml
          whoami   = `whoami`.chop
          
          yml_content = <<-YML_DOCUMENT
platform:  android
uploaded:  #{uploaded}
creator:  #{whoami}
apptarget:  #{build_config['android']['apptarget']}
bundleid:  #{build_config['android']['bundleid']}
name:  #{build_config['application']['name']}
version:  #{version}
YML_DOCUMENT

        yml_fname = "#{build_config['application']['name']}_#{version}.yml"
        File.open(yml_fname, 'w') {|f| f.write(yml_content)}
        upload(yml_fname, "#{shared_path}/mobileapps/#{yml_fname}")
      end




        
      end
    end

    desc "Publish an IPA to a remote deployment server"
    task :ipa do
      puts "Uploading IPA to #{current_release}"

      configuration_file = Pathname.getwd.join 'mobileapps.yml'
      build_config       = YAML::load(File.open(configuration_file))
      ios_build_dir      = Pathname.getwd.join build_config['ios']['directory']

      ipas = Dir["#{ios_build_dir}/*.ipa"]

      ipas.each do |ipa|

        fname = File.basename(ipa)
        puts "IPA = #{fname}"
        upload(ipa.to_s, "#{shared_path}/mobileapps/#{fname}")

        apptarget = build_config['ios']['apptarget']
        fname =~ /#{apptarget}\.(.*)\.ipa/ # Get the version
        version = $1                       # Perl, save us
        uploaded = Time.now.strftime("%Y-%m-%d %H:%M:%S %Z").to_yaml
        whoami   = `whoami`.chop

        yml_content = <<-YML_DOCUMENT
platform:  ios
uploaded:  #{uploaded}
creator:  #{whoami}
apptarget:  #{build_config['ios']['apptarget']}
bundleid:  #{build_config['ios']['bundleid']}
name:  #{build_config['application']['name']}
version:  #{version}
YML_DOCUMENT

        yml_fname = "#{build_config['application']['name']}_#{version}.yml"
        File.open(yml_fname, 'w') {|f| f.write(yml_content)}
        upload(yml_fname, "#{shared_path}/mobileapps/#{yml_fname}")
      end
    end
  end
end
end

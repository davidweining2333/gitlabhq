namespace :plugins do
  desc 'Generate skeleton for new plugin'
  task generate: :environment do
    ARGV.each { |a| task a.to_sym { } }
    name = ARGV[1]

    unless name.present?
      puts 'Error. You need to specify a name for the plugin'
      exit 1
    end

    class_name = name.classify
    param = name.underscore
    file_path = Rails.root.join('plugins', param + '_plugin.rb')
    template = File.read(Rails.root.join('generator_templates', 'plugins', 'template.rb'))
    template.gsub!('$NAME', class_name)

    if File.write(file_path, template)
      puts "Done. Your plugin saved under #{file_path}."
      puts 'Feel free to edit it.'
    else
      puts "Failed to save #{file_path}."
    end
  end

  desc 'Validate existing plugins'
  task validate: :environment do
    puts 'Validating plugins from /plugins directory'

    Gitlab::Plugin.files.each do |file|
      result = Gitlab::Plugin.execute(file, Gitlab::DataBuilder::Push::SAMPLE_DATA)

      if result
        puts "* #{file} succeed (zero exit code)"
      else
        puts "* #{file} failure (non-zero exit code)"
      end
    end
  end
end

def parse_file(path)
  theme_delimeter = /(^\s*\/\* THEME|THEME \*\/\s*$)/
  selector_delimiter = /[\{\}]\s*$/
  empty_selector = /^.*\{[\s\n]*\}\s*$/
  empty_line = /^$\n/
  function = /([\w-]+)\(([\w-]+)\)/

  in_theme_block = false

  #keep selector open/close lines and rules inside THEME comment blocks
  lines = IO.readlines(path).select do |line|
    if line =~ theme_delimeter
      in_theme_block = !in_theme_block
      false
    else
      in_theme_block || line =~ selector_delimiter
    end
  end

  #merge lines into a string
  css = lines.join

  #strip empty selectors then empty media queries on 2nd pass
  2.times { css.gsub!(empty_selector, '') }
  #strip left over empty lines
  css.gsub!(empty_line, '')
  #translate CSS-style functions to valid ERB
  css.gsub!(function, '<%= theme.\1(:\2) %>')
end

namespace :theme do
  task :update do
    old_assets_prefix = Rails.application.config.assets.prefix
    tmp_folder = '/theme_assets_tmp'
    tmp_folder_path = "#{Rails.public_path}#{tmp_folder}"
    begin
      Rails.application.config.assets.prefix = tmp_folder
      quietly { Rake::Task['assets:precompile'].invoke }
      theme_css = parse_file(Dir["#{tmp_folder_path}/application-*.css"][0])
      IO.write(Rails.root.join('app', 'views', 'themes', 'show.css.erb'), theme_css)
    ensure
      FileUtils.remove_dir(tmp_folder_path)
      Rails.application.config.assets.prefix = old_assets_prefix
    end
  end
end

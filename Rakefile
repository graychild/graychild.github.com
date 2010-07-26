def read_env_var(name, validation = nil, default = nil)
  var = ENV[name.to_s.upcase]
  validation.nil? || var =~ validation ? var : default
end

desc "Create a new blog post"
task :post do
  title  = read_env_var(:title, /[-\w]/)
  slug   = title.to_s.downcase.delete('^a-z0-9_ -').tr('_ ', '-')
  date   = read_env_var( :date, /\A\d{4}-\d{2}-\d{2}\z/,
                                Time.now.strftime("%Y-%m-%d") )
  images = read_env_var(:images, /\S/).to_s.split
  author = read_env_var(:user).to_s.capitalize
  file   = "#{date}-#{slug}.html"
  path   = File.join(File.dirname(__FILE__), *%W[_posts #{file}])
  
  if title.nil?
    abort "USAGE:  rake post TITLE='My Post' "     +
                            "[IMAGES='']"          +
                            "[DATE='2010-07-25'] " +
                            "[AUTHOR='James']"
  end
  if File.exist? path
    abort "Error:  That post already exists."
  end
  
  open(path, "w") do |f|
    f.puts "---\ntitle: #{title}\nlayout: post\n---"
    unless images.empty?
      image_layout = case images.size
                     when 1    then "one_per_row"
                     when 2..6 then "two_per_row"
                     else           "four_per_row"
                     end
      f.puts %Q{<div class="#{image_layout}">}
      images.each do |image|
        f.puts %Q{    <a class="photo" rel="#{slug}" href="/#{image}" } +
                      %Q{title="Caption goes here.">}
        f.puts %Q{        <img src="/#{image}" />}
        f.puts "    </a>"
      end
      f.puts "</div>"
      f.puts
    end
    f.puts %Q{<p class="author">by #{author}</p>}
    f.puts
    f.puts "<p>\n    Post content goes here.\n</p>"
  end
end

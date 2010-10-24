require "fileutils"

IMAGE_WIDTH  = 640
IMAGE_HEIGHT = 480

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
  
  images.each do |image|
    params =  [ ]
    params << image
    w, h   =  `identify -format %wx%h #{image}`.
              to_s.scan(/\d+/).map { |n| n.to_f }
    if h <= w
      rw, rh = IMAGE_WIDTH / w, IMAGE_HEIGHT / h
      if rh <= rw
        scale_geometry = "%dx"         % IMAGE_WIDTH
        crop_geometry  = "%dx%d+%d+%d" % [ IMAGE_WIDTH,
                                           IMAGE_HEIGHT,
                                           0,
                                           (h * rw - IMAGE_HEIGHT) / 2 ]
      else
        scale_geometry = "x%d"         % IMAGE_HEIGHT
        crop_geometry  = "%dx%d+%d+%d" % [ IMAGE_WIDTH, 
                                           IMAGE_HEIGHT,
                                           (w * rh - IMAGE_WIDTH) / 2,
                                           0 ]
      end
      params << "-resize" << %Q{"#{scale_geometry}"}
      params << "-crop"   << %Q{"#{crop_geometry}"} << "+repage"
    else
      params << "-resize" << "#{IMAGE_WIDTH}x#{IMAGE_HEIGHT}"
    end
    resized =  "images/#{File.basename(image, '.jpg')}_resized.jpg"
    params  << resized
    system("convert #{params.join(' ')}")
    if h <= w
      FileUtils.mv(resized, image)
    else
      system( "composite -gravity center " +
              "#{resized} images/white_background.gif #{image}" )
      FileUtils.rm(resized)
    end
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
    f.puts %Q{<p class="date">{{ page.date|date:"%B %d, %Y" }}</p>}
    f.puts %Q{<p class="author">by #{author}</p>}
    f.puts
    f.puts "<p>\n    Post content goes here.\n</p>"
  end
end

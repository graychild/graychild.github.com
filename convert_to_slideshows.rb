require "cgi"

Dir.glob("_posts/*.html") do |path|
  html = File.read(path)
  if photos = html[%r{^<div\s+class="\w+_per_row">.+?</div>[^ \t]*\n}m]
    slideshow = %Q{<ul class="slideshow">\n}
    photos.scan(%r{<a\s*[^>]*\btitle="([^"]+)"[^>]*>\s*<img\s*src="([^"]+)"}) do
      slideshow << %Q{    <li>\n}                                     +
                   %Q{        <a href="#{$2}">\n}                     +
                   %Q{            <img src="#{$2}" />\n}              +
                   %Q{        </a>\n}                                 +
                   %Q{        <span>#{CGI.unescapeHTML($1)}</span>\n} +
                   %Q{    </li>\n}
    end
    slideshow << %Q{</ul>}
    if html.sub!(photos, slideshow)
      open(path, "w") { |f| f.write html }
    end
    puts photos
    puts slideshow
    puts
  end
end
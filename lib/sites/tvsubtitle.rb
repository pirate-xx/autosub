require 'simple-rss'
require 'open-uri'
require 'zip/zip'
require 'cgi'
require 'mechanize'

# http://www.tvsubtitles.net/
class TVSubtitle
  
  def initialize(inspector)
    @inspector = inspector
    episodes = @inspector.episodes.select { |e| e.need_srt?(@inspector.langs) }
    
    $stdout.print "--------------------------------------------\n"
    $stdout.print "Searching for srt in www.tvsubtitles.net RSS\n"
    $stdout.print "--------------------------------------------\n"
    @inspector.langs.each do |l|
      rss(l).items.each do |item|
        episodes.each do |e|
          unless e.srt.include?(l)
            if episode_title(e, l) == item_title(item)
              download_srt(item, e, l)
              inspector.log.info "#{e.episode_name_with_format} [#{l}] // TVSubtitle // #{@srt_name}"
              $stdout.print "FOUND: #{e.episode_name_with_format} [#{l}]\n"
              e.srt << l
              @inspector.growl_episode(e, l)
            end
          end
        end
      end
    end
  end
  
private
  
  def download_srt(item, episode, lang)
    found = false
    agent = WWW::Mechanize.new
    id = item_id(item)
    Tempfile.open("srt") do |tempfile|
      agent.get("http://www.tvsubtitles.net/subtitle-#{id}.html") # set cookie
      tempfile.write(agent.get_file("http://www.tvsubtitles.net/download-#{id}.html")) # download the srt
      tempfile.close
      Zip::ZipFile.open(tempfile.path) do |zip_file|
        zip_file.each do |f|
          if f.size > 5000
            @srt_name = f.name
            zip_file.extract(f, episode.srt_filename(lang))
            found = true
          end
        end
      end
    end
  rescue => e
    @inspector.log.fatal "TVSubtitle // #{episode.episode_name_with_format} [#{lang}] // #{e}"
    found = false
  else
    found
  end
  
  def rss(lang)
    SimpleRSS.parse open("http://fr.tvsubtitles.net/rss#{lang}.xml") 
  end
  
  def num(episode)
    "#{episode.season}X#{episode.number < 10 ? "0#{episode.number}" : episode.number}"
  end
  
  def episode_title(episode, lang)
    "#{episode.tv_show} #{num(episode)} #{lang} #{episode.format}".downcase
  end

  def item_title(item)
    "#{item.title} #{item.description.include?('720p') ? 'hd' : 'sd'}".downcase
  end
  
  def item_id(item)
    item.link.match(/([0-9]+)/)[1]
  end
  
end
require 'simple-rss'
require 'open-uri'
require 'zip/zip'
require 'cgi'

# http://www.tvsubtitles.net/
class TVSubtitle
  
  def initialize(inspector)
    @inspector = inspector
    episodes = @inspector.episodes.select { |e| e.need_srt?(@inspector.langs) }
    
    $stdout.print "--------------------------------------------\n"
    $stdout.print "Searching fot srt in www.tvsubtitles.net RSS\n"
    $stdout.print "--------------------------------------------\n"
    @inspector.langs.each do |l|
      rss(l).items.each do |item|
        episodes.each do |e|
          unless e.srt.include?(l) 
            if episode_title(e, l) == item_title(item)
              $stdout.print "FOUND: #{e.episode_name_with_format} [#{l}]\n"
              download_srt(item, e, l)
              e.srt << l
              @inspector.growl_episode(e, l)
            end
          end
        end
      end
    end
  end
  
private

  def srt_link(item)
    id = item.link.match(/([0-9]+)/)[1]
    http = Net::HTTP.new('www.tvsubtitles.net')
    resp, data = http.get("/download-#{id}.html")
    "http://www.tvsubtitles.net/#{resp.response['Location'].gsub(/\s/, '%20')}"
  end

  def download_srt(item, episode, lang)
    url = srt_link(item)
    Tempfile.open("srt") do |tempfile|
      tempfile.write(open(url).read) # download the srt
      tempfile.close
      Zip::ZipFile.open(tempfile.path) do |zip_file|
        zip_file.each do |f|
          zip_file.extract(f, episode.srt_filename(lang))
        end
      end
    end
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
  
end
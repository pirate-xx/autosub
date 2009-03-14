require 'hpricot'
require 'open-uri'
require 'zip/zip'
require 'cgi'

# http://www.podnapisi.net/ | http://www.sub-titles.net/
class Podnapisi
  
  def initialize(inspector)
    @inspector = inspector
    episodes = @inspector.episodes.select { |e| e.need_srt?(@inspector.langs) }

    $stdout.print "------------------------------------------\n"
    $stdout.print "Start srt searching from www.podnapisi.net\n"
    $stdout.print "------------------------------------------\n"
    episodes.each do |e|
      @inspector.langs.each do |l|
        unless e.srt.include?(l) 
          $stdout.print "#{e.episode_name_with_format} [#{l}]: "
          if get_srt(e, l)
            @inspector.log.info "#{e.episode_name_with_format} [#{l}] // Podnapisi // #{@srt_name}"
            $stdout.print "FOUND\n"
            e.srt << l
            @inspector.growl_episode(e, l)
            break
          else
            $stdout.print "NOT FOUND\n"
          end
        end
      end
    end
  end
    
private
  
  def get_srt(episode, lang)
    found = false
    doc = Hpricot(open(url(episode, lang)))
    doc.search("table.list tr").each do |el|
      if !found && have_srt_format?(el) && !hearing_impaired?(el) && url = open(download_url(el))
        Tempfile.open("tv.zip") do |tempfile|
          tempfile.write(open(url).read) # download the zip
          tempfile.close # tempfile need to be closed for unzip it
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
      end
    end
  rescue => e
    @inspector.log.fatal "Podnapisi // #{episode.episode_name_with_format} [#{lang}] // #{e}"
    found = false
  else
    found
  end

  def url(episode, lang)
    "http://simple.podnapisi.net/ppodnapisi/search?tbsl=3&asdp=1&sK=#{tv_show(episode)}&sJ=#{lang_num(lang)}&sO=desc&sS=time&submit=Search&sTS=#{episode.season}&sTE=#{episode.number}&sY=&sR=#{format(episode)}&sT=1"
  end
  
  def tv_show(episode)
    CGI.escape(episode.tv_show)
  end
  
  def format(episode)
    case episode.format
    when 'hd'
      "720"
    when 'sd'
      ""
    end
  end
  
  def lang_num(lang)
    case lang
    when 'fr'
      8
    when 'en'
      2
    end
  end
  
  def have_srt_format?(el)
    !el.search("td[text()*='SubRip']").empty?
  end
  
  def hearing_impaired?(el)
    !el.search("img[@title='Subtitle is for hearing impaired']").empty?
  end
  
  def download_url(el)
    "http://simple.podnapisi.net#{el.search("a[text()*='download subtitle']").first[:href]}"
  end
  
end
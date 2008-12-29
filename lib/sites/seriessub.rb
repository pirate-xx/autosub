require 'hpricot'
require 'open-uri'
require 'zip/zip'

# http://www.seriessub.com/
class SeriesSub
  
  def initialize(inspector)
    @inspector = inspector
    episodes = @inspector.episodes.select { |e| e.need_srt?(@inspector.langs) }

    $stdout.print "------------------------------------------\n"
    $stdout.print "Start srt searching from www.seriessub.com\n"
    $stdout.print "------------------------------------------\n"
    episodes.each do |e|
      @inspector.langs.each do |l|
        unless e.srt.include?(l) 
          $stdout.print "#{e.episode_name_with_format} [#{l}]: "
          if get_srt(e, l)
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
    doc = Hpricot(open(url(episode)))
    doc.search("td.gst_fichier a").each do |el|
      text = el.inner_text.gsub(/(\_|\.)/, ' ')
      if good_episode?(episode, text) && text.include?(lang_version(lang))
        if text.include?('zip')
          Tempfile.open("tv.zip") do |tempfile|
            tempfile.write(open(el[:href]).read) # download the zip
            tempfile.close # tempfile need to be closed for unzip it
            Zip::ZipFile.open(tempfile.path) do |zip_file|
              zip_file.each do |f|
                if good_episode?(episode, f.name) && f.name.include?(lang_version(lang)) && episode.good_format?(f.name) && no_tag?(f.name)
                  zip_file.extract(f, episode.srt_filename(lang))
                  found = true
                end
              end
            end
          end
        elsif episode.good_format?(text) && no_tag?(text) # just a single srt file
          Tempfile.open("tv.srt") do |tempfile|
            tempfile.write(open(el[:href]).read) # download the zip
            tempfile.close
            File.move(tempfile.path, episode.srt_filename(lang))
            found = true
          end
        end
      end
    end
    found
  end

  
  def url(episode)
    "http://www.seriessub.com/sous-titres/#{tv_show(episode)}/#{season(episode)}"
  end
  
  def tv_show(episode)
    name = episode.tv_show.gsub(/\s\([0-9]{4}\)/,'')
    case name
    when "Terminator The Sarah Connor Chronicles"
      "The Sarah Connor Chronicles"
    when "The IT Crowd"
      "IT Crowd"
    else
      name
    end.downcase.gsub(/\s/, '_')
  end
  
  def season(episode)
    "saison_#{episode.season}"
  end
  
  def lang_version(lang)
    case lang
    when 'fr'
      "VF"
    when 'en'
      "VO"
    end
  end
  
  def num(episode)
    "#{episode.season}#{episode.number < 10 ? "0#{episode.number}" : episode.number}"
  end
  
  def good_episode?(episode, name)
    num2 = "S#{episode.season < 10 ? "0#{episode.season}" : episode.season}E#{episode.number < 10 ? "0#{episode.number}" : episode.number}"
    name.include?(num(episode)) || name.include?(num2)
  end
  
  def no_tag?(filename)
    case filename
    when /notag/i
      true
    when /tag/i
      false
    else
      true
    end
  end
  
end
require File.join(File.dirname(__FILE__), '..', 'lib', 'episode')
require File.join(File.dirname(__FILE__), '..', 'lib', 'sites', 'seriessub')
require File.join(File.dirname(__FILE__), '..', 'lib', 'sites', 'tvsubtitle')

class Inspector
  
  attr_accessor :tv_shows, :episodes, :langs
  
  def initialize(path , langs = nil)
    @path = path.gsub(/\/$/,'')
    @langs = langs ? langs.split(',') : ['fr','en']

    @tv_shows = [] # {:name => ..., :path => ...}
    initialize_tv_shows
    $stdout.print "Found #{@tv_shows.size} TV Show(s) in #{@path}\n"
    
    @episodes = []
    initialize_episodes
    # keep only episodes who needs srt
    $stdout.print "Found #{@episodes.select { |e| e.need_srt?(@langs) }.size} episode(s) who need(s) srt\n"
    
    # Find new srt
    TVSubtitle.new(self)
    SeriesSub.new(self)
  end
  
  def growl_episode(episode, lang)
    Inspector.growl episode.episode_name_with_format, "#{lang_name(lang)} srt added", "srt.png"
  end
  
  def self.growl(title, msg, icon, pri = 0)
    system("/usr/local/bin/growlnotify -w -n autosub --image #{File.dirname(__FILE__) + "/../asset/#{icon}"} -p #{pri} -m #{msg.inspect} #{title} &") 
  end
  
private
  
  def initialize_tv_shows
    # path is a dir with many tv_shows dir
    base_dir = clean_dir(Dir.new(@path))
    base_dir.each do |tv_show_name|
      @tv_shows << { :name => tv_show_name, :path => "#{@path}/#{tv_show_name}" }
    end
  end
  
  def initialize_episodes
    @tv_shows.each do |tv_show|
      search_episodes(tv_show[:name], tv_show[:path])
    end
  end
  
  def search_episodes(tv_show_name, path)
    elements = clean_dir(Dir.new(path))
    elements.each do |el|
      el_path = "#{path}/#{el}"
      if File.directory?(el_path)
        search_episodes(tv_show_name, el_path)
      elsif Episode.valid?(el)
        episodes << Episode.new(tv_show_name, el_path)
      end
    end
  end
  
  def clean_dir(dir)
    dir.select { |e| !["..", ".", ".DS_Store", ".com.apple.timemachine.supported", "Icon\r"].include?(e) }
  end

  def lang_name(lang)
    case lang
    when 'en'
      'English'
    when 'fr'
      'French'
    end
  end
  
end
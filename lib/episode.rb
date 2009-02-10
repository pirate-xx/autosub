class Episode
  
  attr_accessor :path, :name, :ext, :format, :srt, :tv_show, :season, :number
  
  def initialize(tv_show, path)
    @path = path
    @ext  = File.extname(@path)
    @name = File.basename(path, @ext)
    @tv_show = tv_show.gsub(/\s\([0-9]{4}\)/,'').chomp(' ')
    @srt = []
    
    search_existing_srt
    define_format
    define_season_and_episode_number
  end
  
  def filename
    @name + @ext
  end
  
  def episode_name
    "#{@tv_show} S#{@season < 10 ? "0#{@season}" : @season}E#{@number < 10 ? "0#{@number}" : @number}"
  end
  
  def episode_name_with_format    
    episode_name + "#{format == 'hd' ? ' 720p' : ''}"
  end
  
  def need_srt?(langs)
    need = -1
    langs = langs.reverse
    langs.each do |lang|
      need = langs.index(lang) if @srt.include?(lang) && need < langs.index(lang)
    end
    need != langs.size - 1
  end
  
  def srt_filename(lang)
    "#{File.dirname(path)}/#{name}.#{lang}.srt"
  end
  
  def self.valid?(filename)
    filename.match(/.*(([0-9]{1,2}X[0-9]{1,2})|(S[0-9][0-9]E[0-9][0-9])).*((\.avi)|(\.mkv))$/i)
  end
  
  def good_format?(filename)
    case @format
    when 'hd'
      filename.include?('720p') || filename.include?('720')
    when 'sd'
      !filename.include?('720p')
    end
  end
  
private
  
  def search_existing_srt
    dir = Dir.new(File.dirname(@path))
    dir.select { |el| File.extname(el) == '.srt' && el.include?(@name) && !el.include?('._') }.each do |srt|
      case srt
      when /\.(french|fr|fre|fra)\.srt/i
        @srt << 'fr'
      when /\.(english|en|eng)\.srt/i
        @srt << 'en'
      end
    end
  end
  
  def define_format
    case @ext
    when '.mkv'
      @format = 'hd'
    when '.avi'
      @format = 'sd'
    end
  end
  
  def define_season_and_episode_number
    case @name
    when /S[0-9][0-9]E[0-9][0-9]/i # S02E03
      @season = @name.match(/.*S([0-9]{1,2})E.*$/i)[1].to_i
      @number = @name.match(/.*E([0-9]{1,2}).*$/i)[1].to_i
    when /[0-9]{1,2}X[0-9]{1,2}/i  # 2X03
      @season = @name.match(/.*([0-9]{1,2})X[0-9]{1,2}.*$/i)[1].to_i
      @number = @name.match(/.*[0-9]{1,2}X([0-9]{1,2}).*$/i)[1].to_i
    end
  end
  
end
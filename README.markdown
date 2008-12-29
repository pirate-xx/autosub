# AutoSub
  
Ruby tool to automatically download subtitles (srt) inside your TV Shows folder.
Currently only english and french subtitles are supported.
  
## Install

    sudo gem install pirate-autosub --source http://gems.github.com

## Usage

In your terminal:

    autosub -p /path/of/your/TV Shows/folder -lang fr,en

more details with:

    autosub -h
    
## Folder Name Convention

AutoNZB use (and needs) specific folders/episodes name for your TV Shows:
  
    + TV Shows
      + Dexter (TV Show's name needs to be 'clean')
        + Season 01
          - Dexter S01E01.mkv (.mkv for 720p HD episode)
          - Dexter 1x02.avi (.avi for SD episode)
          - S01E03.mkv (TV Show's name in episode file's name not needed)
          - S01E03.fr.srt (.fr.srt used to define subtitle's language)
    + Fringe
      - (season folder not needed)
      - Fringe S01E01.mkv
      - 1x01.avi
  
## License

Copyright (c) 2008 Pirate
 
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
 
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
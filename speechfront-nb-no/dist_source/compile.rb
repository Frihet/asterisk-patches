#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-
# vim: set fileencoding=UTF-8 :

# Transcode asterisk sound files to all encodings 
# Copyright (C) 2008 FreeCode AS, Egil Moeller <egil.moller@freecode.no>
# Copyright (C) 2008 FreeCode AS, Tommy Botten Jensen <tommy.jensen@freecode.no>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


if system("which sox > /dev/null")
  puts "sox installed:"
    if system("sox -h | grep FORMATS | grep ul > /dev/null")
      puts("ulaw support")
      @codecs = {"ul" => "-U"}
    else
      puts("no ulaw")
      @codecs = {"0" => "0"}
    end

    if system("sox -h | grep FORMATS | grep al > /dev/null")
      puts("alaw support")
      @codecs.merge!({"al" => "-A"})
    else
      puts("no alaw")
    end

    if system("sox -h | grep FORMATS | grep gsm > /dev/null")
      puts("gsm support")
      @codecs.merge!({"gsm" => "-g"})
    else
      puts("no gsm")
    end
else
  puts "Sox is not installed. Please install sox"
  exit 0
end

def sox_convert(hash)
  puts "converting...."
  $int=0
  hash.keys.each do |codec|
    system("mkdir -p ../dist_" + hash.keys[$int] + "/digits")
    Dir.entries('nb_NO').each do |file|
      system("sox nb_NO/" + file + " " + hash[codec] + " ../dist_" + hash.keys[$int] + "/" + file.gsub(/\.\w{2,5}$/,"") + "." + hash.keys[$int] + " 2> /dev/null")
    end
    Dir.entries('nb_NO/digits').each do |file|
      system("sox nb_NO/digits/" + file + " " + hash[codec] + " ../dist_" + hash.keys[$int] + "/digits/" + file.gsub(/\.\w{2,5}$/,"") + "." + hash.keys[$int] + " 2> /dev/null")
    end
    system ("cp COPYRIGHT ../dist_" + hash.keys[$int])
    system ("cp LICENSE ../dist_" + hash.keys[$int])
    system ("cp INSTALL.BINARY ../dist_" + hash.keys[$int])
    $int = $int + 1
  end
  puts "done!"
end

sox_convert(@codecs)

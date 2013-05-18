######################## BEGIN LICENSE BLOCK ########################
# The Original Code is mozilla.org code.
#
# The Initial Developer of the Original Code is
# Netscape Communications Corporation.
# Portions created by the Initial Developer are Copyright (C) 1998
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Hui (zhengzhengzheng@gmail.com) - port to Ruby
#   Mark Pilgrim - first port to Python
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301  USA
######################### END LICENSE BLOCK #########################

require "EscCharSetProber"
require "MBCSGroupProber"
require "SBCSGroupProber"
require "Latin1Prober"
require "string_shim"
require "singleton"

module UniversalDetector

    class << self
        def is18?
          RUBY_VERSION =~ /^1\.8/
        end

        def encoding(data)
            chardet(data)['encoding']
        end

        def chardet(data)
            u = UniversalDetector::Detector.instance
            u.reset()
            u.feed(data)
            u.close()
            u.result
        end
    end
    
    DEBUG = nil
  
    Detectiong = 0
    FoundIt = 1
    NotMe = 2

    Start = 0
    Error = 1
    ItsMe = 2
  
    MINIMUM_THRESHOLD = 0.20
    PureAscii = 0
    EscAscii = 1
    Highbyte = 2

    SHORTCUT_THRESHOLD = 0.95
  
    class Detector
        
        include Singleton
        
        attr_reader :result
    
        def initialize
            @_highBitDetector = /[\x80-\xFF]/n
            @_escDetector = /\033|~\{/n
            @_mEscCharSetProber = nil
            @_mCharSetProbers = []
            reset
        end
    
        def reset
            @result = {"encoding"=> nil, "confidence"=> 0.0}
            @done = false
            @_mStart = true
            @_mGotData = false
            @_mInputState = :PureAscii
            @_mLastChar = ""
            if @_mEscCharSetProber
                @_mEscCharSetProber.reset
            end
            for prober in @_mCharSetProbers
                prober.reset
            end
        end    
    
        def feed(data)
            if @done || data.empty?
                return 
            end
            unless  @_mGotData
                # If the data starts with BOM, we know it is UTF
                if data[0,3] == "\xEF\xBB\xBF"
                    # EF BB BF  UTF-8 with BOM
                    @result = {"encoding"=> "UTF-8", "confidence"=> 1.0}
                elsif data[0,4] == "\xFF\xFE\x00\x00"
                    # FF FE 00 00  UTF-32, little-endian BOM
                    @result = {"encoding"=> "UTF-32LE", "confidence"=> 1.0}
                elsif data[0,4] == "\x00\x00\xFE\xFF" 
                    # 00 00 FE FF  UTF-32, big-endian BOM
                    @result = {"encoding"=> "UTF-32BE", "confidence"=> 1.0}
                elsif data[0,4] == "\xFE\xFF\x00\x00"
                    # FE FF 00 00  UCS-4, unusual octet order BOM (3412)
                    @result = {"encoding"=> "X-ISO-10646-UCS-4-3412", "confidence"=> 1.0}
                elsif data[0,4] == "\x00\x00\xFF\xFE"
                    # 00 00 FF FE  UCS-4, unusual octet order BOM (2143)
                    @result = {"encoding"=> "X-ISO-10646-UCS-4-2143", "confidence"=> 1.0}
                elsif data[0,4] == "\xFF\xFE"
                    # FF FE  UTF-16, little endian BOM
                    @result = {"encoding"=> "UTF-16LE", "confidence"=> 1.0}
                elsif data[0,2] == "\xFE\xFF"
                    # FE FF  UTF-16, big endian BOM
                    @result = {"encoding"=> "UTF-16BE", "confidence"=> 1.0}          
                end
            end
            @_mGotData = true
            if @result["encoding"] && @result["confidence"] > 0.0
                @done = true
                return
            end            
            
            if @_mInputState == :PureAscii
                if data =~ @_highBitDetector
                    @_mInputState = :Highbyte
                elsif (@_mLastChar + data) =~ @_escDetector
                    @_mInputState = :EscAscii
                end
            end                        
            
            @_mLastChar = data[-1]
            if @_mInputState == :EscAscii
                unless @_mEscCharSetProber
                    @_mEscCharSetProber = EscCharSetProber.new
                end
                if @_mEscCharSetProber.feed(data) == constants.eFoundIt
                    @result = {"encoding"=> @_mEscCharSetProber.get_charset_name() ,"confidence"=> @_mEscCharSetProber.get_confidence()}
                    @done = true          
                end  
            elsif @_mInputState == :Highbyte
                if @_mCharSetProbers.empty?
                    @_mCharSetProbers = MBCSGroupProber.new.mProbers + SBCSGroupProber.new.mProbers + [Latin1Prober.new]
                end                                
                @_mCharSetProbers.each do |prober|                    
                    if prober.feed(data) == :FoundIt
                        @result = {"encoding"=> prober.get_charset_name(), "confidence"=> prober.get_confidence()}
                        @done = true
                        break
                    end
                end #for
            end
        end #feed
  
        def close
            if @done then return end
            unless @_mGotData
                if DEBUG
                    p("no data received!\n")
                end
                return
            end
            @done = true
            
            if @_mInputState == :PureAscii
                @result = {"encoding" =>  "ascii", "confidence" => 1.0}
                return @result
            end

            if @_mInputState == :Highbyte
                proberConfidence = nil
                maxProberConfidence = 0.0
                maxProber = nil
                for prober in @_mCharSetProbers
                    unless prober then next end
                    proberConfidence = prober.get_confidence()
                    if proberConfidence > maxProberConfidence
                        maxProberConfidence = proberConfidence
                        maxProber = prober
                    end
                end
                if maxProber and (maxProberConfidence > MINIMUM_THRESHOLD)
                    @result = {"encoding" => maxProber.get_charset_name(),
                                   "confidence" => maxProber.get_confidence()}
                    return @result
                end
            end #if
            
            if DEBUG
                p("no probers hit minimum threshhold\n")
                for prober in @_mCharSetProbers
                    unless prober then next end
                    p("%s confidence = %s\n" % \
                                     [prober.get_charset_name(), \
                                      prober.get_confidence()])
                end
            end            
        end #close
    end #class
                       
end #module

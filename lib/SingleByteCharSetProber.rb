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

require 'UniversalDetector'
require 'CharSetProber'

module UniversalDetector
    
    SAMPLE_SIZE = 64
    SB_ENOUGH_REL_THRESHOLD = 1024
    POSITIVE_SHORTCUT_THRESHOLD = 0.95
    NEGATIVE_SHORTCUT_THRESHOLD = 0.05
    SYMBOL_CAT_ORDER = 250
    NUMBER_OF_SEQ_CAT = 4
    POSITIVE_CAT = NUMBER_OF_SEQ_CAT - 1
    
    class SingleByteCharSetProber < CharSetProber
        def initialize(model, reversed=false, nameProber=nil)
            super()
            @_mModel = model
            @_mReversed = reversed # TRUE if we need to reverse every pair in the model lookup
            @_mNameProber = nameProber # Optional auxiliary prober for name decision
            reset()
        end

        def reset
            super
            @_mLastOrder = 255 # char order of last character
            @_mSeqCounters = [0] * NUMBER_OF_SEQ_CAT
            @_mTotalSeqs = 0
            @_mTotalChar = 0
            @_mFreqChar = 0 # characters that fall in our sampling range
        end

        def get_charset_name
            if @_mNameProber
                return @_mNameProber.get_charset_name()
            else
                return @_mModel['charsetName']
            end
        end

        def feed(aBuf)
            unless @_mModel['keepEnglishLetter']
                aBuf = filter_without_english_letters(aBuf)
            end
            aLen = aBuf.length
            unless aLen
                return get_state()
            end                        
            
            for i in 0...aLen
                c = aBuf[i]
                order = @_mModel['charToOrderMap'][c]
                if order < SYMBOL_CAT_ORDER
                    @_mTotalChar += 1
                end
                if order < SAMPLE_SIZE                    
                    @_mFreqChar += 1
                    if @_mLastOrder < SAMPLE_SIZE
                        @_mTotalSeqs += 1
                        unless @_mReversed
                            @_mSeqCounters[@_mModel['precedenceMatrix'][(@_mLastOrder * SAMPLE_SIZE) + order]] += 1                        
                        else # reverse the order of the letters in the lookup
                            @_mSeqCounters[@_mModel['precedenceMatrix'][(order * SAMPLE_SIZE) + @_mLastOrder]] += 1
                        end
                    end
                end
                @_mLastOrder = order
            end

            if get_state() == :Detecting
                if @_mTotalSeqs > SB_ENOUGH_REL_THRESHOLD
                    cf = get_confidence()
                    if cf > POSITIVE_SHORTCUT_THRESHOLD
                        if DEBUG
                            p('%s confidence = %s, we have a winner\n' % [@_mModel['charsetName'], cf])
                        end
                        @_mState = :FoundIt
                    elsif cf < NEGATIVE_SHORTCUT_THRESHOLD
                        if DEBUG
                            p('%s confidence = %s, below negative shortcut threshhold %s\n' % [@_mModel['charsetName'], cf, NEGATIVE_SHORTCUT_THRESHOLD])
                        end
                        @_mState = :NotMe
                    end
                end
            end

            return get_state()
        end

        def get_confidence
            r = 0.01
            if @_mTotalSeqs > 0
    #            print @_mSeqCounters[POSITIVE_CAT], @_mTotalSeqs, @_mModel['mTypicalPositiveRatio']
                r = (1.0 * @_mSeqCounters[POSITIVE_CAT]) / @_mTotalSeqs / @_mModel['mTypicalPositiveRatio']
    #            print r, @_mFreqChar, @_mTotalChar
                r = r * @_mFreqChar / @_mTotalChar
                if r >= 1.0
                    r = 0.99
                end
            end
            return r
        end
    end
end
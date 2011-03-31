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

module  UniversalDetector
    class CharSetGroupProber < CharSetProber
        def initialize
            @_mActiveNum = 0
            @_mProbers = []
            @_mBestGuessProber = nil
        end

        def reset
            super
            @_mActiveNum = 0
            for prober in @_mProbers
                if prober
                    prober.reset()
                    prober.active = true
                    @_mActiveNum += 1
                end
            end
            @_mBestGuessProber = nil
        end

        def get_charset_name
            unless @_mBestGuessProber
                get_confidence()
                unless @_mBestGuessProber then return nil end
    #                @_mBestGuessProber = @_mProbers[0]
            end
            return @_mBestGuessProber.get_charset_name()
        end

        def feed(aBuf)
            for prober in @_mProbers
                unless prober then next end
                unless prober.active then next end
                st = prober.feed(aBuf)
                unless st then next end
                if st == :FoundIt
                    @_mBestGuessProber = prober
                    return get_state()                
                elsif st == :NotMe
                    prober.active = false
                    @_mActiveNum -= 1
                    if @_mActiveNum <= 0
                        @_mState = :NotMe
                        return get_state()
                    end                            
                end
            end
            return get_state()
        end

        def get_confidence
            st = get_state()
            if st == :FoundIt
                return 0.99
            elsif st == :NotMe
                return 0.01
            end
            
            bestConf = 0.0
            @_mBestGuessProber = nil
            for prober in @_mProbers
                unless prober then next end
                unless prober.active
                    if UniversalDetector::DEBUG
                        p(prober.get_charset_name() + ' not active\n')
                    end
                    next
                end
                cf = prober.get_confidence()
                if UniversalDetector::DEBUG
                    p('%s confidence = %s\n' % [prober.get_charset_name(), cf])
                end
                if bestConf < cf
                    bestConf = cf
                    @_mBestGuessProber = prober
                end
            end
            unless @_mBestGuessProber then return 0.0 end
            return bestConf
        end
    end
end

######################## BEGIN LICENSE BLOCK ########################
# The Original Code is mozilla.org code.
#
# The Initial Developer of the Original Code is
# Netscape Communications Corporation.
# Portions created by the Initial Developer are Copyright (C) 1998
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Mark Pilgrim - first port to Python
#   Hui (zhengzhengzheng@gmail.com) - port to Ruby
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

module  UniversalDetector
    class CodingStateMachine
        attr_accessor :active

        def initialize(sm)
            @_mModel = sm
            @active = false
            @_mCurrentBytePos = 0
            @_mCurrentCharLen = 0
            reset()
        end

        def reset
            @_mCurrentState = :Start
        end

        def next_state(c)
            # for each byte we get its class
            # if it is first byte, we also get byte length
            byteCls = @_mModel['classTable'][c]

            if @_mCurrentState == :Start
                @_mCurrentBytePos = 0
                @_mCurrentCharLen = @_mModel['charLenTable'][byteCls]
            end
            # from byte's class and stateTable, we get its next state
            stateValue = {:Start => 0, :Error  => 1, :ItsMe  => 2}
            unless stateValue[@_mCurrentState]
                v = @_mCurrentState
            else
                v = stateValue[@_mCurrentState]
            end
            @_mCurrentState = @_mModel['stateTable'][v * @_mModel['classFactor'] + byteCls]

            @_mCurrentBytePos += 1
            return @_mCurrentState
        end

        def get_current_charlen
            return @_mCurrentCharLen
        end

        def get_coding_state_machine
            return @_mModel['name']
        end
    end
end

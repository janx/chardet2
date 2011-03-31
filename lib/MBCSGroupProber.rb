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
require 'CharSetGroupProber'
require 'UTF8Prober'
require 'SJISProber'
require 'EUCJPProber'
require 'GB2312Prober'
require 'EUCKRProber'
require 'Big5Prober'
require 'EUCTWProber'

module UniversalDetector
    class MBCSGroupProber < CharSetGroupProber
        
        attr_reader :mProbers
        
        def initialize
            super
            @mProbers = [ \
                UTF8Prober.new,
                SJISProber.new,
                EUCJPProber.new,
                GB2312Prober.new,
                EUCKRProber.new,
                Big5Prober.new,
                EUCTWProber.new]
            reset()
        end
    end
end
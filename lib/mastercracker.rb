require "mastercracker/version"
require 'yaml'

class Mastercracker
    # Your code goes here...
end

class Locks < Array
    SET1 = [
        [0,4,8,12,16,20,24,28,32,36],
        [0,6,10,14,18,22,26,30,34,38],
        [0,4,8,12,16,20,24,28,32,36]
    ]
    SET2 = [
        [1,5,9,13,17,21,25,29,33,37],
        [1,7,11,15,19,23,27,31,35,39],
        [1,5,9,13,17,21,25,29,33,37]
    ]
    SET3 = [
        [2,6,10,14,18,22,26,30,34,38],
        [0,2,8,12,16,20,24,28,32,36],
        [2,6,10,14,18,22,26,30,34,38]
    ]
    SET4 = [
        [3,7,11,15,19,23,27,31,35,39],
        [1,3,9,13,17,21,25,29,22,27],
        [3,7,11,15,19,23,27,31,35,39]
    ]

end

class Lock
    attr_accessor :name, :sticking_points, :last_number, :solutions
    def initialize
        @name = ''
        @sticking_points = []
        @last_number = ''
        @solutions = []
    end

end

class Solution
    attr_accessor :combo, :tried, :works
    def initialize
        @combo = []
        @tried = ''
        @works = ''
    end
end

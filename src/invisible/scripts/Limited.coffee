
class Limited

    constructor: ->
        @max        = 100
        @maxMax     = 999
        @min        = 0
        @now        = 100

    setNow: (now) ->
        @now = Math.min Math.max(@min, now), @max

    setMin: (@min) ->
        @setMax @max

    setMax: (max) ->
        @max = Math.min Math.max(@min, max), @maxMax
        @setNow @now

    setMaxMax: (@maxMax) ->
        @setMax @max

    isMin: -> @now is @min
    isMax: -> @now is @max

    maximize: -> @now = @max


class Timer

    constructor: (@root) ->
        @game = @root.game

        @isRunning = false

        @text = @game.add.text GameWidth * 15 / 16, GameHeight * 3 / 4 + SquareSize * (SquareLine + 2) / 4 + 3, '',
            fill: '#fff'
            font: '18px Gennokaku'
        @text.anchor.set 1, 0.5

    draw: (time) ->
        t = (time - @begin + 999) // 1000
        @text.text = t // 60 + ' 分 ' + ('0' + t % 60)[-2..] + ' 秒'

    init: ->
        @text.visible = @root.option.timer
        @isRunning = true
        @begin = new Date().getTime() + 500
        @draw @begin

    stop: (visible) ->
        @text.visible = visible
        @isRunning = false
        @end = new Date().getTime()
        @draw @end

    update: ->
        if @isRunning and @text.visible
            @draw new Date().getTime()

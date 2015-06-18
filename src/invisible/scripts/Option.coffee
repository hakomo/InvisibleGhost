
class Option

    constructor: (@root) ->
        @game = @root.game

        @container = @game.add.sprite()
        @container.visible = false

        @selected = @game.add.graphics GameWidth * 3 / 8 - 200
            .beginFill 0xffffff, 0.7
            .drawPolygon -8, 6, -8, LineHeight - 6, -20, LineHeight / 2
            .drawPolygon 208, 6, 208, LineHeight - 6, 220, LineHeight / 2

            .beginFill(0xffffff, 0.3).lineStyle 1, 0xffffff
            .drawRect 0, 0, 200 - 1, LineHeight - 1

        @container.addChild @selected
        @game.add.tween(@selected).to alpha: 0.4,
            750, Phaser.Easing.Default, true, 0, -1, true

        @texts = for name, i in ['OPTION', 'SOUND', 'TIMER', 'BACK']
            text = @game.add.text GameWidth * 3 / 8 - 192, (i - 0.5) * LineHeight + GameHeight * 5 / 8 + 3, name,
                fill: '#fff'
                font: '18px Gennokaku'
            text.anchor.y = 0.5
            @container.addChild text

            if 0 < i < 3
                text = @game.add.text GameWidth * 3 / 8 - 8, (i - 0.5) * LineHeight + GameHeight * 5 / 8 + 3, '',
                    fill: '#fff'
                    font: '18px Gennokaku'
                text.anchor.set 1, 0.5
                @container.addChild text
                text

            else
                null
        @texts = @texts[1...3]

        @sound = localStorage.getItem 'sound'
        @sound ?= 100
        @sound |= 0

        @timer = localStorage.getItem 'timer'
        if @timer is 'true'
            @timer = true
        else
            @timer = false

    draw: ->
        @selected.y = @index * LineHeight + GameHeight * 5 / 8

        @texts[0].text = @sound + '%'
        @texts[1].text = if @timer then 'VISIBLE' else 'INVISIBLE'

    begin: (@title) ->
        @index = 0

        @game.world.addChild @container
        @container.visible = true

        @container.x = GameWidth / -2
        @game.add.tween(@container).to x: 0,
            500, Phaser.Easing.Quadratic.Out, true

        @draw()
        @root.state.set @

    end: ->
        @game.add.tween(@container).to x: -GameWidth,# / -2,
            500, Phaser.Easing.Quadratic.In, true

        @title.selected.visible = true
        @root.state.set @title

        @game.sound.play 'ok', @root.option.sound / 100

    update: (keys) ->
        y = keys.downJustDown - keys.upJustDown
        x = keys.rightJustDown - keys.leftJustDown

        if y
            @index = (@index + y) %% 3
            @draw()
            @game.sound.play 'ok', @root.option.sound / 100

        else if x
            if @index is 0
                @sound = Math.min Math.max(0, @sound + x * 5), 100
                localStorage.setItem 'sound', @sound
                @draw()
                @game.sound.play 'ok', @root.option.sound / 100

            else if @index is 1
                @timer = not @timer
                localStorage.setItem 'timer', @timer
                @draw()
                @game.sound.play 'ok', @root.option.sound / 100

        else if keys.zJustDown
            if @index is 1
                @timer = not @timer
                localStorage.setItem 'timer', @timer
                @draw()
                @game.sound.play 'ok', @root.option.sound / 100

            else if @index is 2
                @end()

        else if keys.xJustDown
            @end()

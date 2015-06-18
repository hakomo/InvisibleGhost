
class Selection

    constructor: (@root) ->
        @game = @root.game

        @Width = 200

        @container = @game.add.graphics (GameWidth - @Width) / 2, 0
        @container.visible = false

        @selected = @game.add.graphics()
            .beginFill(0, 0.3).lineStyle 1, 0
            .drawRect 0, 0, @Width - 1, LineHeight - 1
        @container.addChild @selected
        @game.add.tween(@selected).to alpha: 0.4,
            750, Phaser.Easing.Default, true, 0, -1, true

        @texts = for i in [0...3]
            text = @game.add.text 8, (i + 0.5) * LineHeight + 11, '',
                fill: '#fff'
                font: '18px Gennokaku'
            text.anchor.y = 0.5
            @container.addChild text
            text

    draw: ->
        @selected.y = (@index + 1) * LineHeight + 8

    begin: (@ss) ->
        @index = 0

        @game.sound.play 'ok', @root.option.sound / 100

        @container.visible = true
        @container.alpha = 0.5
        @container.y = (GameHeight - @ss.length * LineHeight) / 2 - 4
        @container.clear()
            .beginFill Color.number 0.5, 0.2, 0.5
            .lineStyle 2, Color.number 0.5, 0.2, 0.2
            .drawRect 0, 0, @Width, @ss.length * LineHeight + 16
        tween = @game.add.tween(@container).to alpha: 1, y: @container.y - 4,
            100, Phaser.Easing.Default, true

        for text, i in @texts
            text.text = if i < @ss.length then @ss[i].name else ''
        @draw()
        @root.state.set @

    end: ->
        @container.visible = false
        @root.state.set null

    update: (keys) ->
        y = keys.downJustDown - keys.upJustDown

        if y
            @index = (@index + y) %% (@ss.length - 1)
            @draw()
            @game.sound.play 'ok', @root.option.sound / 100

        else if keys.xJustDown
            @ss[0].callback.call @ss[0].context

        else if keys.zJustDown
            @ss[@index + 1].callback.call @ss[@index + 1].context


class Skills

    constructor: (@root) ->
        @game = @root.game

        @skills = for [w, h, p, r, n, e], i in [
                [1, 3, 0,  28, '列探', new Effect1 @root]
                [8, 3, 0,   6, '全探', new Effect2 @root]
                [1, 1, 1, 138, '単撃', new Effect3 @root]
                [2, 2, 1,  44, '広撃', new Effect4 @root]
                [1, 3, 2,  28, '強撃', new Effect5 @root]]

            icon = @game.add.graphics 0, i * SquareSize + (GameHeight - SquareSize * 5) / 2
                # .lineStyle(2, 0xffffff).drawRect 0, 0,
                #     SquareSize, SquareSize

            text = @game.add.text 54, 34, '',
                font: '18px Gennokaku'
            text.anchor.x = 1
            icon.addChild text

            text = @game.add.text SquareSize / 2 - 1, 6, n,
                fill: '#fff'
                font: '24px Gennokaku'
            text.anchor.x = 0.5
            icon.addChild text

            new Skill @root, w, h, p, r, icon, e

        @selected = @game.add.graphics GameWidth - SquareSize, 0
            .lineStyle 4, 0xffffff, 0.5
            .drawRect SquareSize * -9 / 16, SquareSize * -9 / 16,
                SquareSize * 9 / 8, SquareSize * 9 / 8
        @selected.visible = false
        @game.add.tween(@selected).to angle: 360,
            6000, Phaser.Easing.Default, true, 0, -1

        @ss = [{
            name: 'ターンを進める？'
            callback: ->
                @root.state.end()
                @root.skills.resume()
                @game.sound.play 'ok', @root.option.sound / 100
            context: @
        }, {
            name: 'うん'
            callback: ->
                @state.end()
                @skills.end()
                @squares.turn1()
            context: @root
        }, {
            name: 'やだ'
            callback: ->
                @root.state.end()
                @root.skills.resume()
                @game.sound.play 'ok', @root.option.sound / 100
            context: @
        }]

    init: ->
        for skill in @skills
            skill.init()

    draw: ->
        @selected.y = (@index + 0.5) * SquareSize +
            (GameHeight - SquareSize * @skills.length) / 2

        for skill, i in @skills
            if i is @index
                skill.select()
            else
                skill.unselect()

    resume: ->
        @selected.visible = true
        @skills[@index].show()
        @root.state.set @

    pause: ->
        @selected.visible = false
        @skills[@index].hide()
        @root.state.set null

    begin: ->
        @index = 0
        @draw()
        @resume()
        @game.sound.play 'end', 0.2 * @root.option.sound / 100

    end: ->
        @skills[@index].unselect()
        @pause()

    turn: ->
        @root.hp.heal()

        for skill in @skills
            skill.turn()

        @begin()

    update: (keys) ->
        y = keys.downJustDown - keys.upJustDown

        if y
            @index = (@index + y) %% @skills.length
            @draw()
            @game.sound.play 'ok', @root.option.sound / 100

        else if keys.xJustDown
            @pause()
            @root.selection.begin @ss

        else
            @skills[@index].update keys

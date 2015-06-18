
class Skill

    constructor: (@root, @width, @height, @power, @recovery, @icon, @effect) ->
        @game = @root.game

        @container = @game.add.text GameWidth / 2, LineHeight / 2 + 3, "#{@icon.children[1].text}      #{@power} ダメ      +#{@recovery}% / Turn",
            fill: '#fff'
            font: '18px Gennokaku'

        @container.anchor.y = 0.5

        range = @game.add.graphics 0, SquareY - LineHeight / 2 - 2
            .beginFill Color.number(0.3 - @power * 0.15, 0.5, 0.5), 0.5
            .drawRect 0, SquareSize * (SquareLine - @height),
                SquareSize * @width - 1, SquareSize * @height - 1
        @container.addChild range
        @game.add.tween(range).to alpha: 0.4,
            750, Phaser.Easing.Default, true, 0, -1, true

    init: ->
        @percent = Math.ceil(@recovery / 20) * 100
        @unselect()
        @draw()

    draw: ->
        @icon.children[0].text = @percent + '%'

        if @canUse()
            @icon.children[0].fill = Color.string 0.3, 1, 0.7
        else
            @icon.children[0].fill = '#fff'

        @container.children[0].x =
            @index * SquareSize + SquareX - LineHeight / 2 - GameWidth / 2 + 17

    show: ->
        @container.visible = true

    hide: ->
        @container.visible = false

    select: ->
        @index = 0
        @icon.x = GameWidth - SquareSize * 3 / 2 + 1
        @show()
        @draw()

    unselect: ->
        @icon.x = GameWidth - SquareSize * 5 / 4 + 1
        @hide()

    canUse: ->
        @percent >= 100

    use: ->
        return unless @canUse()

        @root.notices.callAllExists 'kill', true

        @root.skills.pause()

        @percent -= 100
        @draw()

        if @power
            @game.sound.play 'attack', 0.4 * @root.option.sound / 100
        else
            @game.sound.play 'search', @root.option.sound / 100

        @effect.begin @index

        timer = @game.time.create()
        timer.add 350, (-> @root.squares.damage @), @
        timer.add 850, (->
            @root.skills.resume()
            @root.hp.chara.position.set 0, 0
            ), @
        timer.start()

    turn: ->
        @percent += @recovery
        @draw()

    update: (keys) ->
        x = keys.rightJustDown - keys.leftJustDown

        if x
            @index = (@index + x) %% (SquareRow - @width + 1)
            @draw()
            @game.sound.play 'ok', @root.option.sound / 100

        else if keys.zJustDown
            if @canUse()
                @use()
            else
                @game.sound.play 'ng', 0.8 * @root.option.sound / 100

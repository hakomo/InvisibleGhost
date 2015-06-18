
class Squares

    constructor: (@root) ->
        @game = @root.game

        @squares = {}
        for y in [-1...SquareLine]
            @squares[y] = for x in [0...SquareRow]
                new Square @root, x

        @container = @game.add.sprite SquareX, SquareY
        @buffer = @game.add.sprite SquareX, SquareY
        @buffer.alpha = 0

        for container in [@container, @buffer]
            for _ in [-1...SquareLine]
                sprite = @game.add.sprite()
                container.addChild sprite

                graphics = @game.add.graphics()
                sprite.addChild graphics

                group = @game.add.group sprite
                group.enableBody = true
                group.createMultiple SquareRow, 'enemy'
                group.setAll 'checkWorldBounds', true
                group.setAll 'outOfBoundsKill', true
                group.callAll 'anchor.set', 'anchor', 0.5, 0.5

                group.callAll 'events.onOutOfBounds.add', 'events.onOutOfBounds', (enemy) ->
                    if enemy.parent.countLiving() is 1
                        enemy.owner.root.squares.turn2()

                for i in [0...SquareRow]
                    text = @game.add.text 0, 0, '',
                        fill: '#fff'
                        font: '18px Gennokaku'
                    text.anchor.set 0.5, 0.5
                    sprite.addChild text

    init: ->
        for y, line of @squares
            for square in line
                square.init y | 0
        @draw()

    draw: (animation = true) ->
        if animation
            tmp = @buffer
            @buffer = @container
            @container = tmp

            @game.add.tween(@container).to alpha: 1,
                500, Phaser.Easing.Default, true
            @game.add.tween(@buffer).to alpha: 0,
                500, Phaser.Easing.Default, true

        for y, line of @squares
            y |= 0

            sprite = @container.children[y + 1]
            sprite.alpha = y > -1 | 0
            for text in sprite.children[2..]
                text.visible = false
            sprite.children[0].clear()
            sprite.children[1].callAll 'kill'

            begin = 0

            for square, x in line when square.found
                @drawLine sprite, line[begin...x]
                square.draw sprite

                begin = x + 1
            @drawLine sprite, line[begin...SquareRow]

    drawLine: (sprite, line) ->
        return unless line.length

        if line.length is 1
            if line[0].kind is line[0].Enemy and line[0].hp and
                    not line[0].found
                line[0].notice 0
            line[0].found = true
            line[0].draw sprite
            return

        sprite.children[0].lineStyle 1, 0xffffff
            .drawRect line[0].position.x * SquareSize, line[0].position.y * SquareSize,
                line.length * SquareSize, SquareSize

        sum = line.reduce ((sum, square) ->
            sum + square.power), 0
        return unless sum

        x = (line.reduce(((x, square) ->
            x + square.fazzyX * square.power / sum), 0) + 0.5) * SquareSize
        y = (line[0].position.y + 0.5) * SquareSize + 3

        text = sprite.children[2..].reduce (text1, text2) ->
            if text1.visible then text2 else text1
        text.visible = true
        text.position.set x, y
        text.text = sum.toString()

    damage: (skill) ->
        for _, line of @squares
            for square in line
                square.damage skill

        @draw()

    turn1: ->
        @root.notices.callAllExists 'kill', true

        @game.sound.play 'turn', @root.option.sound / 100

        for square in @squares[SquareLine - 1]
            square.found = true

        @draw()

        @game.add.tween(@container.children[0]).to alpha: 1,
            500, Phaser.Easing.Default, true
        @game.add.tween(@container).to y: @container.y + SquareSize,
            500, Phaser.Easing.Default, true
        tween = @game.add.tween(@buffer).to y: @buffer.y + SquareSize,
            500, Phaser.Easing.Default, true

        @root.turn.sunrise()

        tween.onComplete.addOnce (->
            bottom = @container.children[@container.children.length - 1]
            enemys = bottom.children[1].filter (-> true), true

            if enemys.total
                for delay in [0...enemys.total].map((i) -> i * 300)
                    enemy = @game.rnd.pick enemys.list
                    enemys.remove enemy

                    @root.hp.damage enemy, delay

                @root.hp.begin bottom.children[1]

            else
                @turn2()), @

    turn2: ->
        tween = @game.add.tween(@container.children[@container.children.length - 1]).to alpha: 0,
            500, Phaser.Easing.Default, true

        tween.onComplete.addOnce (->
            for _, line of @squares
                for square in line
                    square.turn()

            tmp = @squares[SquareLine - 1]
            for y in [SquareLine - 1..0]
                @squares[y] = @squares[y - 1]
            @squares[-1] = tmp

            @container.y -= SquareSize
            @buffer.y -= SquareSize

            @draw false

            @root.turn.turn()), @

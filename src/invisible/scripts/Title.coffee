
class Title

    constructor: (@root, @zDown, @index = 0) ->
        @game = @root.game

        @background = @game.add.sprite 0, 0, 'background'

        group = @game.add.group @background
        group.enableBody = true
        group.createMultiple 20, 'enemy'
        group.setAll 'checkWorldBounds', true
        group.setAll 'outOfBoundsKill', true
        group.callAll 'anchor.set', 'anchor', 0.5, 0.5

        group.callAll 'events.onOutOfBounds.add', 'events.onOutOfBounds', (enemy) ->
            enemy.tween.stop()

        @timer = @game.time.create()
        @timer.loop 1700, (->
            enemy = @background.children[0].getFirstExists false
            enemy.reset @game.rnd.between(16, GameWidth - 17),
                @game.rnd.between 16, GameHeight - 17
            enemy.alpha = 0
            enemy.frame = @game.rnd.between 0, 2
            enemy.tween = @game.add.tween(enemy).to alpha: 1,
                2900, Phaser.Easing.Default, true, 0, -1, true

            r = @game.rnd.normal() * Math.PI

            enemy.body.velocity.set Math.cos(r), Math.sin r
            enemy.body.velocity.setMagnitude 40), @

        @container = @game.add.sprite()

        text = @game.add.text GameWidth - 16, 8, '(C) 2015 hakomo / てくてくぺたぺた',
            fill: '#fff'
            font: '18px Gennokaku'
        text.anchor.x = 1
        @container.addChild text

        text = @game.add.text GameWidth / 2, GameHeight / 2 + 3, 'インビジ ゴースト',
            fill: '#fff'
            font: '48px Gennokaku'
        text.anchor.set 0.5, 0.5
        @container.addChild text

        text = @game.add.text 16, 8, 'v1.0 2015/06/18',
            fill: '#fff'
            font: '18px Gennokaku'
        @container.addChild text

        enemy0 = @game.add.image 198, 190, 'enemy', 1
        enemy0.angle = 40
        @container.addChild enemy0

        enemy1 = @game.add.image 308, 274, 'enemy', 0
        enemy1.angle = 260
        @container.addChild enemy1

        enemy2 = @game.add.image 382, 202, 'enemy', 2
        @container.addChild enemy2

        @enemy3 = [enemy0, enemy1, enemy2]

        @pre = @game.add.text GameWidth / 2, GameHeight * 5 / 8 + 3, 'Z キーを押してね（音が出るよ）',
            fill: '#fff'
            font: '18px Gennokaku'
        @pre.anchor.set 0.5, 0.5
        @container.addChild @pre

        @selected = @game.add.graphics GameWidth * 5 / 8
            .beginFill(0xffffff, 0.3).lineStyle(1, 0xffffff)
            .drawRect 0, 0, 200 - 1, LineHeight - 1
        @container.addChild @selected
        @game.add.tween(@selected).to alpha: 0.4,
            750, Phaser.Easing.Default, true, 0, -1, true

        for name, i in ['GAME START', 'TIPS', 'OPTION']
            text = @game.add.text GameWidth * 5 / 8 + 8, (i + 0.5) * LineHeight + GameHeight * 5 / 8 + 3 - (64 - GameHeight / 2), name,
                fill: '#fff'
                font: '18px Gennokaku'
            text.anchor.y = 0.5
            @container.addChild text

        @draw()

        if @zDown
            @pre.alpha = 0
            for enemy in @enemy3
                enemy.alpha = 0

            if @index
                @background.visible = false

                @container.y = 64 - GameHeight * 1.5
                second = @game.add.tween(@container).to y: 64 - GameHeight / 2,
                    1000, Phaser.Easing.Back.Out, true

                second.onComplete.addOnce (->
                    @background.visible = true
                    @timer.start()
                    @root.state.set @), @

            else
                @background.alpha = 0
                first = @game.add.tween(@background).to alpha: 1,
                    200, Phaser.Easing.Default, true

                @container.y = 64 - GameHeight * 1.5
                second = @game.add.tween(@container).to y: 64 - GameHeight / 2,
                    1000, Phaser.Easing.Back.Out
                first.chain second

                second.onComplete.addOnce (->
                    @timer.start()
                    @root.state.set @), @

        else
            @root.state.set @

    draw: ->
        @selected.y = @index  * LineHeight + GameHeight * 5 / 8 - (64 - GameHeight / 2)

    update: (keys) ->
        if @zDown
            y = keys.downJustDown - keys.upJustDown

            if y
                @index = (@index + y) %% 3
                @draw()
                @game.sound.play 'ok', @root.option.sound / 100

            else if keys.zJustDown
                if @index is 0
                    @game.sound.play 'ok', @root.option.sound / 100
                    first = @game.add.tween(@container).to y: 64 - GameHeight * 1.5,
                        700, Phaser.Easing.Quadratic.Out, true
                    second = @game.add.tween(@background).to alpha: 0,
                        500, Phaser.Easing.Default
                    first.chain second

                    first.onComplete.addOnce (->
                        if @index
                            # @root.manual.begin()
                        else
                            @root.init()), @

                    @timer.destroy()
                    second.onComplete.addOnce (->
                        @background.destroy()
                        @container.destroy()), @

                    @root.state.set null

                else if @index is 1
                    first = @game.add.tween(@container).to y: 64 - GameHeight * 1.5,
                        700, Phaser.Easing.Quadratic.Out, true

                    @timer.destroy()

                    @root.state.set null
                    @root.tips.begin (->
                        @background.destroy()
                        @container.destroy()), @

                    @game.sound.play 'ok', @root.option.sound / 100

                else if @index is 2
                    @selected.visible = false
                    @root.state.set null
                    @root.option.begin @
                    @game.sound.play 'ok', @root.option.sound / 100

        else if keys.zJustDown
            @game.add.tween(@container).to y: 64 - GameHeight / 2,
                500, Phaser.Easing.Quadratic.Out, true

            @game.add.tween(@pre).to alpha: 0,
                500, Phaser.Easing.Default, true

            for enemy, i in @enemy3
                @game.add.tween(enemy).to alpha: 0,
                    500, Phaser.Easing.Default, true

            @timer.start()

            @zDown = true

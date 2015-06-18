
class Hp

    constructor: (@root) ->
        @game = @root.game

        @hp = new Limited
        @hp.setMax 200

        @Width = 200

        @container = @game.add.sprite SquareX + SquareWidth / 2,
            GameHeight * 3 / 4 + SquareSize * (SquareLine + 2) / 4
        @game.physics.arcade.enable @container

        @container.addChild @game.add.graphics()
            .beginFill(0xffffff).drawRect @Width / -2 - 1, -8, @Width + 2, 16

        text = @game.add.text @Width / -2 - 66, 3, 'HP',
            fill: '#fff'
            font: '18px Gennokaku'
        text.anchor.y = 0.5
        @container.addChild text

        @text = @game.add.text @Width / -2 - 8, 3, '',
            fill: '#fff'
            font: '18px Gennokaku'
        @text.anchor.set 1, 0.5
        @container.addChild @text

        @bar = @game.add.graphics @Width / -2, -7
            .beginFill Color.number 0.3, 0.5, 0.5
            .drawRect 0, 0, @Width, 14
        @bar.width = 0
        @container.addChild @bar

        @chara = @game.add.sprite 0, 0, 'chara'
        @chara.anchor.x = 0.5
        @container.addChild @chara

        @chara.animations.add('walk', [9, 10, 11, 10], 2, true).play()

    init: ->
        @hp.maximize()
        @draw()

    draw: ->
        width = Math.ceil @Width * (@hp.now - @hp.min) / (@hp.max - @hp.min)
        return if width is @bar.width

        tween = @game.add.tween(@bar).to width: width,
            1500 * Math.abs(width - @bar.width) / @Width,
            Phaser.Easing.Default, true

        i = 0
        tween.onUpdateCallback (->
            ++i
            unless i % 3
                @text.text =
                    Math.ceil(@hp.max * @bar.width / @Width).toString()), @

        tween.onComplete.addOnce (->
            @text.text = @hp.now.toString()), @

    damage: (enemy, delay) ->
        position = enemy.position.clone()
        container = enemy.parent
        while container
            position.add container.x, container.y
            container = container.parent

        angle = (@game.math.angleBetweenPoints(position, @container) *
            180 / Math.PI + 90) % 360
        angle = (if angle < 180 then angle else angle - 360)

        tween = @game.add.tween(enemy).to angle: angle,
            Math.abs(angle) * 3, Phaser.Easing.Default, true, delay

        tween.onComplete.addOnce (->
            Phaser.Point.subtract @container, position, enemy.body.velocity
            enemy.body.velocity.setMagnitude 200), @

    heal: ->
        if @hp.now
            @hp.setNow @hp.now + 10
            @draw()

    begin: (@enemys) ->
        @root.state.set @

    end: ->
        @root.state.set null

    update: (keys) ->
        @game.physics.arcade.overlap @container, @enemys, ((_, enemy) ->
            unless enemy.owner.attacked
                enemy.owner.attacked = true
                @hp.setNow @hp.now - enemy.owner.power
                @draw()
                @game.sound.play 'damage'), null, @

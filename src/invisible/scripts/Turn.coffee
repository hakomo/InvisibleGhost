
class Turn

    constructor: (@root) ->
        @game = @root.game

        @text = @game.add.text GameWidth * 3 / 4, GameHeight * 3 / 4 + SquareSize * (SquareLine + 2) / 4 + 3, '',
            fill: '#fff'
            font: '18px Gennokaku'
        @text.anchor.set 1, 0.5

        @yoake = @game.add.text GameWidth * 3 / 4 - 26, GameHeight * 3 / 4 + SquareSize * (SquareLine + 2) / 4 + 3 - 20, '夜明けまであと',
            fill: '#fff'
            font: '18px Gennokaku'
        @yoake.anchor.set 0.5, 0.5

    init: ->
        @t = 28
        @draw()
        @game.world.children[0].alpha = 1
        @yoake.visible = false

    draw: ->
        @text.text = @t + ' Turn'

    sunrise: ->
        if @t is 2
            @game.stage.backgroundColor = Color.number 0.6, 0.2, 0.5
            @game.add.tween(@game.world.children[0]).to alpha: 0.8,
                500, Phaser.Easing.Default, true

        else if @t is 1
            @game.stage.backgroundColor = Color.number 0.6, 0.4, 0.5
            @game.add.tween(@game.world.children[0]).to alpha: 0.7,
                500, Phaser.Easing.Default, true

    turn: ->
        --@t
        @draw()

        if @t is 2
            @yoake.visible = true

        if @root.hp.hp.isMin()
            new Result @root, false

        else if not @t
            new Result @root, true

        else
            @root.skills.turn()

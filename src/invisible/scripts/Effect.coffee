
class Effect1

    constructor: (@root)->
        @game = @root.game

        @effect = @game.add.graphics()
            .lineStyle 4, 0xffffff, 0.5
            .drawRect SquareSize / -2, SquareSize / -2, SquareSize, SquareSize
        @effect.visible = false

    begin: (@index) ->
        @effect.visible = true
        @game.world.addChild @effect

        @root.hp.chara.position.set (@index - 3.5) * SquareSize, -87

        @effect.alpha = 0
        @effect.position.set SquareX + (@index + 0.5) * SquareSize, SquareY + SquareSize * 2.5

        @game.add.tween(@effect).to alpha: 1,
            350, Phaser.Easing.Default, true, 0, 0, true

        tween = @game.add.tween(@effect).to y: SquareY + SquareSize * 0.5,
            700, Phaser.Easing.Default, true
        tween.onComplete.addOnce (->
            @effect.visible = false), @

class Effect2

    constructor: (@root)->
        @game = @root.game

        @effect = @game.add.graphics()
            .lineStyle 4, 0xffffff, 0.5
            .drawRect SquareSize / -2, SquareSize / -2, SquareSize, SquareSize
        @effect.visible = false
        @effect.scale.set 3, 3

    begin: (_) ->
        @effect.visible = true
        @game.world.addChild @effect

        @effect.alpha = 0
        @effect.position.set SquareX + SquareSize * 1.5, SquareY + SquareHeight / 2

        @root.hp.chara.position.y = -87

        @game.add.tween(@effect).to alpha: 1,
            350, Phaser.Easing.Default, true, 0, 0, true

        tween = @game.add.tween(@effect).to x: SquareX + SquareSize * 6.5,
            700, Phaser.Easing.Default, true
        tween.onComplete.addOnce (->
            @effect.visible = false), @

class Effect3

    constructor: (@root)->
        @game = @root.game

        @effect = @game.add.graphics()
            .lineStyle 4, 0xffffff, 0.5
            .drawRect SquareSize / -2, SquareSize / -2, SquareSize, SquareSize
        @effect.visible = false

    begin: (@index) ->
        @effect.visible = true
        @game.world.addChild @effect

        @root.hp.chara.position.set (@index - 3.5) * SquareSize, -87

        @effect.alpha = 0
        @effect.position.set SquareX + (@index + 0.5) * SquareSize, SquareY + SquareSize * 2.5

        @game.add.tween(@effect).to alpha: 1,
            200, Phaser.Easing.Default, true

        @effect.scale.set 2, 2
        tween = @game.add.tween(@effect.scale).to x: 1, y: 1,
            700, Phaser.Easing.Default, true

        @effect.angle = 0
        @game.add.tween(@effect).to angle: 180,
            700, Phaser.Easing.Default, true

        tween.onComplete.addOnce (->
            @effect.visible = false), @

class Effect4

    constructor: (@root)->
        @game = @root.game

        @effect = @game.add.graphics()
            .lineStyle 4, 0xffffff, 0.5
            .drawRect SquareSize / -2, SquareSize / -2, SquareSize, SquareSize
        @effect.visible = false

    begin: (@index) ->
        @effect.visible = true
        @game.world.addChild @effect

        @root.hp.chara.position.set (@index - 3) * SquareSize, -87

        @effect.alpha = 0
        @effect.position.set SquareX + (@index + 1) * SquareSize, SquareY + SquareSize * 2

        @game.add.tween(@effect).to alpha: 1,
            200, Phaser.Easing.Default, true

        @effect.scale.set 3, 3
        tween = @game.add.tween(@effect.scale).to x: 2, y: 2,
            700, Phaser.Easing.Default, true

        @effect.angle = 0
        @game.add.tween(@effect).to angle: 180,
            700, Phaser.Easing.Default, true

        tween.onComplete.addOnce (->
            @effect.visible = false), @

class Effect5

    constructor: (@root)->
        @game = @root.game

        @effect = @game.add.graphics()
            .lineStyle 4, 0xffffff, 0.5
            .drawRect SquareSize / -2, SquareSize / -2, SquareSize, SquareSize
        @effect.visible = false

    begin: (@index) ->
        @effect.visible = true
        @game.world.addChild @effect

        @root.hp.chara.position.set (@index - 3.5) * SquareSize, -87

        @effect.alpha = 0
        @effect.position.set SquareX + (@index + 0.5) * SquareSize, SquareY + SquareSize * 2.5

        @game.add.tween(@effect).to alpha: 1,
            200, Phaser.Easing.Default, true

        @effect.angle = 0
        tween = @game.add.tween(@effect).to angle: 270,
            700, Phaser.Easing.Default, true

        @game.add.tween(@effect).to y: SquareY + 0.5 * SquareSize,
            350, Phaser.Easing.Default, true, 0, 0, true

        tween.onComplete.addOnce (->
            @effect.visible = false), @

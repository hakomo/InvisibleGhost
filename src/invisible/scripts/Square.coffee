
class Square

    constructor: (@root, x) ->
        @game = @root.game

        @None       = 0
        @Enemy      = 1
        @Length     = 2

        @position = new Phaser.Point x

    init: (y) ->
        @reset()
        @position.y = y

    draw: (sprite) ->
        sprite.children[0].lineStyle 1, 0xffffff
            .drawRect @position.x * SquareSize, @position.y * SquareSize,
                SquareSize, SquareSize

        if @kind is @Enemy and @hp
            @attacked = false
            enemy = sprite.children[1].getFirstExists false
            enemy.angle = 0
            enemy.frame = (@power - 10) // 30
            enemy.owner = @
            enemy.reset (@position.x + 0.5) * SquareSize,
                (@position.y + 0.625) * SquareSize

            text = sprite.children[2..].reduce (text1, text2) ->
                if text1.visible then text2 else text1
            text.visible = true
            text.position.set (@position.x + 0.8) * SquareSize,
                (@position.y + 0.2) * SquareSize + 3
            text.text = @power.toString()

    reset: ->
        @position.y = -1
        @found = false
        @fazzyX = @position.x + @game.rnd.normal() / 16
        @kind = @game.rnd.frac() < 0.33 | 0

        if @kind is @None
            @hp = @power = 0

        else if @kind is @Enemy
            @hp = 2
            @power = @game.rnd.between 10, 99

    notice: (frame) ->
        notice = @root.notices.getFirstExists false
        notice.frame = frame
        notice.reset (@position.x + 0.3) * SquareSize + SquareX,
            (@position.y + 0.15) * SquareSize + SquareY

    damage: (skill) ->
        return unless 0 <= @position.x - skill.index < skill.width and
            SquareLine - skill.height <= @position.y

        if @kind is @Enemy and @hp
            @hp = Math.max 0, @hp - skill.power

            if not @hp
                @notice 2
            else if skill.power
                @notice 1
            else if not @found
                @notice 0

        @found = true

    turn: ->
        @position.y += 1

        if @position.y is SquareLine
            @reset()

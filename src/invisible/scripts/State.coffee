
class State

    constructor: ->
        new Phaser.Game GameWidth, GameHeight, Phaser.CANVAS, 'game', @
        @set null

    preload: ->
        @game.load
            .image 'background', 'images/background.png'

            .spritesheet 'chara', 'images/Actor130.png', 32, 32, 12
            .spritesheet 'enemy', 'images/enemy.png', 32, 32, 3, 0, 1
            .spritesheet 'notice', 'images/notice.png', 46, 26, 3, 0, 1

            .audio 'attack', 'sounds/hit_s06_r.mp3'
            .audio 'bird', 'sounds/bird.mp3'
            .audio 'damage', 'sounds/tm2_hit001.mp3'
            .audio 'end', 'sounds/power21.mp3'
            .audio 'ng', 'sounds/push11.mp3'
            .audio 'ok', 'sounds/type00.mp3'
            .audio 'over', 'sounds/warp03r.mp3'
            .audio 'search', 'sounds/tm2_coin000.mp3'
            .audio 'turn', 'sounds/tm2_shake001.mp3'

    create: ->
        @keys = new Keys @game.input.keyboard
        @root = new Root @game, @

    update: ->
        @keys.update()
        @root.timer.update @keys
        @current?.update @keys

    set: (current) ->
        @current = current

    end: ->
        @current?.end()

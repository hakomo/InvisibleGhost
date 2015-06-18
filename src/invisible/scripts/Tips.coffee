
class Tips

    constructor: (@root) ->
        @game = @root.game

        @play = localStorage.getItem 'play'
        @play ?= 0
        @play |= 0

        @tips = for tip in [
                '1 回 遊ぶたびに TIPS が 1 つ解放される。'
                '赤 > 紫 > 青 の順に霊力が強い。'
                '毎ターン HP は 10 回復する。'
                '重心にはわずかに誤差がある。'
                'ゴーストは 3 マスに 1 体の確率で出現する。'
                '霊力は 10 から 99 まで。'
                'スキルを使える回数は決まっている。'
                'COMPLETE TIPS ! もうクリアはできたかな？']
            tip.split '\n'

    increment: ->
        ++@play
        localStorage.setItem 'play', @play

        @tips[@play % @tips.length]

    begin: (callback, context) ->
        @background = @game.add.sprite 0, 0, 'background'
        @background.visible = false

        @container = @game.add.sprite 0, GameHeight

        text = @game.add.text GameWidth * 3 / 16, 40, "TIPS      #{Math.min @tips.length, @play + 1} / #{@tips.length}",
            fill: '#fff'
            font: '32px Gennokaku'
        @container.addChild text

        for tip, i in @tips
            text = @game.add.text GameWidth * 3 / 16, (i + 2.5) * LineHeight * 1.25, (i + 1).toString(),
                fill: Color.string 0.3, 1, 0.7
                font: '18px Gennokaku'
            @container.addChild text

            if i > @play
                tip = ['?']

            for t, j in tip
                text = @game.add.text GameWidth * 3 / 16 + 24, (i + 2.5) * LineHeight * 1.25 + j * 24, t,
                    fill: '#fff'
                    font: '18px Gennokaku'
                @container.addChild text

        @root.state.set @

        tween = @game.add.tween(@container).to y: 0,
            1000, Phaser.Easing.Back.Out, true
        tween.onComplete.addOnce (->
            @background.visible = true
            callback.call context), @

    update: (keys) ->
        if keys.zJustDown or keys.xJustDown
            tween = @game.add.tween(@container).to y: GameHeight,
                1000, Phaser.Easing.Back.Out, true
            tween.onComplete.addOnce (->
                @background.destroy()
                @container.destroy()
                @background = null
                @container = null), @
            @root.state.set null
            new Title @root, true, 1

            @game.sound.play 'ok', @root.option.sound / 100

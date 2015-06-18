
class Result

    constructor: (@root, @win) ->
        @game = @root.game

        @index = 0

        @root.timer.stop @win or @root.option.timer

        date = new Date
        @name = [date.getMonth() + 1, date.getDate(), date.getHours(),
                date.getMinutes(), date.getSeconds()].reduce(((name, time) ->
            name + ('0' + time)[-2..]), 'ig' + date.getFullYear()) + '.png'

        @container = @game.add.graphics SquareX + SquareWidth / 2 - 200, SquareY + SquareHeight / 2 - 160
            .beginFill Color.number 0.5, 0.2, 0.5
            .lineStyle 2, Color.number 0.5, 0.2, 0.2
            .drawRect 0, 0, 400, 320

        @selected = @game.add.graphics 100, 0
            .beginFill(0, 0.3).lineStyle 1, 0
            .drawRect 0, 0, 200 - 1, LineHeight - 1
        @container.addChild @selected
        @game.add.tween(@selected).to alpha: 0.4,
            750, Phaser.Easing.Default, true, 0, -1, true

        tip = @root.tips.increment()

        @container.addChild @game.add.text 16, 284, tip[0] + (if tip.length is 1 then '' else '...'),
            fill: '#fff'
            font: '18px Gennokaku'

        @state = 2

        if @win
            @game.sound.play('bird', @root.option.sound / 100).fadeOut 3000

            text = @game.add.text 200, 16, 'GAME CLEAR !!',
                fill: '#fff'
                font: '48px Gennokaku'
            text.anchor.x = 0.5
            @container.addChild text

            text = @game.add.text 200, 64, 'Thank you for playing',
                fill: '#fff'
                font: '24px Gennokaku'
            text.anchor.x = 0.5
            @container.addChild text

            @container.alpha = 0
            @container.y += 8
            tween = @game.add.tween(@container).to alpha: 1, y: @container.y - 8,
                500, Phaser.Easing.Default, true
            @root.state.set @

        else
            @game.sound.play 'over', 0.8 * @root.option.sound / 100

            text = @game.add.text 200, 16, 'GAME OVER',
                fill: '#fff'
                font: '48px Gennokaku'
            text.anchor.x = 0.5
            @container.addChild text

            @container.alpha = 0
            @container.y += 8
            tween = @game.add.tween(@container).to alpha: 1, y: @container.y - 8,
                500, Phaser.Easing.Default, true
            @root.state.set @

        if @win
            $('#tweet').attr 'href', @tweet @root.timer.text.text + ' でクリアしました。'
        else
            $('#tweet').attr 'href', @tweet 'あと ' + @root.turn.t + ' ターンのところでやられました。'

        tween.onComplete.addOnce ->
            $('#tweet').show()

        for name, i in ['タイトルに戻る', 'リトライする', '画像を保存する']
            text = @game.add.text 108, i * LineHeight + 142, name,
                fill: '#fff'
                font: '18px Gennokaku'
            text.anchor.y = 0.5
            @container.addChild text

        # @root.state.keys.z.onDown.add ((key) ->
        #     if @state is 2 and @index is 2 and key._justDown
        #         @game.sound.play 'ok', @root.option.sound / 100
        #         if @win
        #             @tweet @root.timer.text.text + ' でクリアしました。'
        #         else
        #             @tweet 'あと ' + @root.turn.t + ' ターンのところでやられました。'), @

        @draw()

    draw: ->
        @selected.y = @index * LineHeight + 124

    tweet: (s) ->
        'https://twitter.com/intent/tweet?text=' +
            encodeURIComponent(s + ' - インビジゴースト') +
            '&url=' + encodeURIComponent 'http://hakomo.github.io/invisible/'

    update: (keys) ->
        if @state is 0
            if keys.zJustDown or keys.xJustDwon
                tween = @game.add.tween(@ending).to x: -140,
                    700, Phaser.Easing.Default, true
                tween.onComplete.addOnce (->
                    @root.state.set @), @
                @state = 1
                @root.state.set null
                @game.sound.play 'ok', @root.option.sound / 100

        else if @state is 1
            if keys.zJustDown or keys.xJustDwon
                @container.visible = true
                tween = @game.add.tween(@ending).to alpha: 0,
                    1000, Phaser.Easing.Default, true
                tween.onComplete.addOnce (->
                    @root.state.set @
                    @ending.destroy()), @
                @state = 2
                @root.state.set null
                @game.sound.play 'ok', @root.option.sound / 100

        else if @state is 2
            y = keys.downJustDown - keys.upJustDown

            if y
                @index = (@index + y) %% 3
                @draw()
                @game.sound.play 'ok', @root.option.sound / 100

            else if keys.zJustDown
                if @index is 0
                    # @root.state.keys.z.onDown.removeAll()
                    $('#tweet').hide()
                    @container.destroy()
                    @root.state.set null
                    new Title @root, true
                    @game.sound.play 'ok', @root.option.sound / 100

                else if @index is 1
                    @game.sound.play 'ok', @root.option.sound / 100
                    # @root.state.keys.z.onDown.removeAll()
                    $('#tweet').hide()
                    @container.destroy()
                    @root.state.set null
                    @root.init()

                else if @index is 2
                    a = document.createElement 'a'
                    a.download = @name
                    a.href = @game.canvas.toDataURL()

                    e = document.createEvent 'MouseEvents'
                    e.initEvent 'click', false, true
                    a.dispatchEvent e

                    @game.sound.play 'ok', @root.option.sound / 100

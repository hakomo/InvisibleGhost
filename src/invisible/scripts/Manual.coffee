
class Manual

    constructor: (@root) ->
        @game = @root.game

        @array = [
            ['君が新しい子かしら？', (-> @switch 1)]
            ['よろしくね。', (-> @switch 2)]
            ['奴ら、そうゴーストは持ち前の霊力と、姿が見えないことをいいことに、夜な夜ないたずらをしかけてくる。でも、今夜でそれもおわり。', (-> @switch 1)]
            'ゴーストは 8 x 3 マスのフィールドに散らばって襲ってくる。'

            # tegatarinai

            # yurei mienai osottekuru

            # kaihatu seiko

            'それがゴーストゴーグル。略してゴーグルね。'
            ['Goggle じゃなくて Gho(st go)ggle よ。発音はちゃんとしなくちゃ。', (-> @switch 2)]
            ['ゴーグルをかければ、範囲に潜むゴーストの霊力の和と霊力の重心がわかるわ。', (-> @switch 1)]
            '表示されている数値が霊力の和で、数値の位置が霊力の重心ね。'
            '例えば、左上の範囲に注目してみるわ。'
            'もし、範囲に潜むゴーストが 1 体なら、数値と同じ位置に、数値と同じ霊力のゴーストがいるはずね。'
            'でも、霊力の低いゴーストがひしめいているかもしれないし、'
            'そうじゃないかもしれない。霊力の高いほうに重心がよっていること・必ずしも重心にゴーストはいないことに注意してね。'
            '範囲が広くてどこにいるのかわからないって？'
            ['そう、そんなゴーグルの欠点を補うのが対ゴースト武器、霊撃。', @reigeki]
            '霊撃がゴーストにダメージを与えるのはもちろんのこと、その力は空間をも切り裂いてしまう。'
            'ためしに黄色の範囲に使ってみるわ。'
            ['・・・。', @expand]
            '空間がアレしたわね。'
            'たまにあるんだけれど、じき元に戻るし安全上の問題も確認されていないから平気よ。'
            'え？そういう問題じゃない？'
            ['まあまあ、画面が見やすくなったんだからいいんじゃなくて？', (-> @switch 3)]
            ['話をもどすわ～。黄色の範囲に霊撃したんだったわね。', (-> @switch 2)]
            ['霊撃をゴーストにあてるとダメージを与え、姿をあばくことができる。さらに、空間を左右に分割する。', (-> @switch 1)]
            'どう？あたりこそしなかったけれど、居所がだいぶ絞りこめたわ。'
            'こんなかんじでターンを進めていくわ。'
            '1 ターンに何回でも霊撃は使えるけれど、回数には限りがあってターンを進めると回復するわ。'
            'ただ、ターンを進めると最前列のゴーストから霊力分のダメージをくらってしまうから注意ね。'
            'さいごに、ゴーストの HP は一律 2 よ。霊撃にはダメージ 0 の索敵専用から、ダメージ 2 の一撃必殺まであるわ。'
            'これで対ゴースト戦のレクチャーはおしまいね。おつかれさま。'
            'そろそろ日が暮れるから君の仕事を決めないとね。'
            '霊撃はまだ私にしか扱えないから私が前に出るわ。君は離れた安全なところからゴーグルをかけて指示をだしてみて。'
            'さあ、奴らが目を覚ますわ。いくわよ！'
        ]

    begin: ->
        @index = 0

        $('#game').append $('<img>').addClass 'stand'
        $('#game').append $('<div>').addClass 'message'

        $('.stand, .message').velocity 'fadeIn', 500

        @root.state.set @
        @advance()

    switch: (n) ->
        $('.stand').attr 'src', "images/stand#{n}.png"

    set: (s) ->
        $('.message').html s

    reigeki: ->
        $e = $('<img>').attr('src', 'images/reigeki.png').addClass 'reigeki'
        $('#game').append $e

        $e.velocity 'fadeIn', 500

    expand: ->
        $('.reigeki').velocity 'fadeOut',
            duration: 500
            complete: ->
                $(this).remove()

        $('.stand').velocity { left: '190px', top: '144px' },
            500

        $('.message').velocity { bottom: '-128px', left: '284px' },
            500

    end: ->
        $('.stand, .message').velocity 'fadeOut',
            duration: 500
            complete: ->
                $(this).remove()

        @root.state.set null
        @root.init()

    advance: ->
        if @index is @array.length
            @end()

        else
            a = @array[@index]
            if typeof a is 'string'
                @set a
            else
                @set a[0]
                a[1].call @
            ++@index

        @game.sound.play 'ok'

    update: (keys) ->
        if keys.zJustDown
            @advance()

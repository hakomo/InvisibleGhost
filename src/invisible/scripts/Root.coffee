
GameWidth       = 640
GameHeight      = 480
SquareSize      = 64
SquareRow       = 8
SquareLine      = 3
SquareWidth     = SquareSize * SquareRow
SquareHeight    = SquareSize * SquareLine
SquareX         = SquareSize / 4
SquareY         = (GameHeight - SquareHeight) / 2
LineHeight      = 32

class Root

    constructor: (@game, @state) ->
        @game.add.image 0, 0, 'background'

        @skills     = new Skills @
        @hp         = new Hp @
        @turn       = new Turn @
        @timer      = new Timer @
        @squares    = new Squares @

        @notices    = @game.add.group()
        @notices.createMultiple SquareRow * SquareLine, 'notice'
        @notices.callAll 'anchor.set', 'anchor', 0.5, 0.5

        @selection  = new Selection @
        @tips       = new Tips @
        @option     = new Option @

        new Title @, false

    init: ->
        @skills.init()
        @hp.init()
        @turn.init()
        @timer.init()
        @squares.init()

        timer = @game.time.create()
        timer.add 500, @skills.begin, @skills
        timer.start()

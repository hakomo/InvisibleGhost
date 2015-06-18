
class Keys

    constructor: (keyboard) ->
        @Keys = ['up', 'down', 'left', 'right', 'z', 'x']

        for key in @Keys
            @[key] = keyboard.addKey Phaser.Keyboard[key.toUpperCase()]

    update: ->
        for key in @Keys
            @[key + 'JustDown'] = @[key].justDown

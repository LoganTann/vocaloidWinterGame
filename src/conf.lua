function love.conf(t)
    t.version = "11.3"
    t.window.width = 1200
    t.window.height = 600
    t.window.title = "Vocaloid Winter Game"
    t.identity = "winterGame"

    t.accelerometerjoystick = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.math = false
    t.modules.thread = false
    t.modules.video = false

    t.window.vsync = -1
end

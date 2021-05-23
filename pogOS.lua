version = "v1.0"
w, h = term.getSize()
selected_app = 1
apps = {}

function draw_header()
    paintutils.drawFilledBox(1,1,w,h,colors.black)
    for i=1,w do
        paintutils.drawPixel(i,1,colors.gray)
        paintutils.drawPixel(i,h,colors.gray)
    end
    
    term.setTextColor(colors.yellow)
    term.setCursorPos(1,1)
    term.write(string.format("pogOS %s",version))

    term.setCursorPos(w - string.len("ID: *****") + 1,1)
    term.write(string.format("ID: %5d",os.getComputerID()))

    term.setCursorPos(1,h)
    term.write(string.format("%d / %d",selected_app,#apps))

    term.setBackgroundColor(colors.black)
    term.setCursorPos(0,0)
end

function draw_apps()
    for i=1,#apps do
        term.setTextColor(colors.white)
        term.setBackgroundColor(colors.black)
        if i == selected_app then
            term.setTextColor(colors.black)
            term.setBackgroundColor(colors.white)
        end
        term.setCursorPos(1,i + 2)
        term.write(apps[i]["name"])
    end
    term.setCursorPos(0,0)
end

function cycle_apps()
    local _,key = os.pullEvent("key")
    sleep(0.05)
    if key == keys.down then
        selected_app = selected_app - 1
        selected_app = (selected_app + 1) % #apps
        selected_app = selected_app + 1
    end
    if key == keys.up then
        selected_app = selected_app - 1
        selected_app = (selected_app - 1) % #apps
        selected_app = selected_app + 1
    end
    if key == keys.enter or key == keys.space then
        apps[selected_app]["func"]()
    end
end

function app_exit()
    term.clear()
    draw_header()
    term.setCursorPos(1,3)
    term.setTextColor(colors.white)
    term.setCursorBlink(false)
    term.write("Shutting down")
    for i=1,3 do
        os.sleep(1)
        term.write(".")
    end
    os.sleep(1)
    os.shutdown()
end

function app_snake()
    shell.run("worm")
end

function app_phone_data_draw_interface()
    term.setCursorPos(1,3)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.write(string.format("Phone ID: %05d",os.getComputerID()))
    term.setCursorPos(1,4)
    term.write("Owner: ")
    term.setCursorPos(1,5)
    term.write(string.format("Firmware Version: %s",version))
    term.setCursorPos(w-3,h-1)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    term.write("Back")
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(0,0)
end

function app_phone_data_exit()
    _,key = os.pullEvent("key")
    os.sleep(0.5)
    return key == keys.enter or key == keys.space
end

function app_phone_data()
    while true do
        term.clear()
        draw_header()
        app_phone_data_draw_interface()
        if app_phone_data_exit then
            break
        end
    end
end

apps = {
    {name="Phone Data",func=app_phone_data},
    {name="Twitter",func=nil},
    {name="Exit",func=app_exit}
}

while true do
    term.clear()
    draw_header()
    draw_apps()
    cycle_apps()
end
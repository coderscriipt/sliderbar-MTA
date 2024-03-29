local screenX,screenY = guiGetScreenSize()
local resX,resY = 1280,720
local x,y =  (screenX/resX), (screenY/resY)

local SLIDE = {};

function dxCreateSlideBar(ID, POS, COLOR_BG, COLOR_SLIDE, MAX)
    if not SLIDE[ID] then
        SLIDE[ID] = {
            POSITION = POS;
            COLOR = {COLOR_BG, COLOR_SLIDE};
            MAX = MAX;
            ACTIVE = false;
            PROGRESS = 0;
            LEVEL = 0;
        }
    end
    if SLIDE[ID]["ACTIVE"] then
        local SCREEN = {guiGetScreenSize()};
        local mx, my = getCursorPosition();
        local cursorx, cursory = mx * SCREEN[1], my * SCREEN[2];
        SLIDE[ID]["PROGRESS"] = math.min(math.max(cursorx - SLIDE[ID]["POSITION"][1], 0), SLIDE[ID]["POSITION"][3]);
    end
    SLIDE[ID]["LEVEL"] = math.floor((SLIDE[ID]["PROGRESS"] / SLIDE[ID]["POSITION"][3]) * SLIDE[ID]["MAX"]);
    dxDrawRectangle(SLIDE[ID]["POSITION"][1], SLIDE[ID]["POSITION"][2], SLIDE[ID]["POSITION"][3], SLIDE[ID]["POSITION"][4], tocolor(SLIDE[ID]["COLOR"][1][1], SLIDE[ID]["COLOR"][1][2], SLIDE[ID]["COLOR"][1][3], SLIDE[ID]["COLOR"][1][4]));
    dxDrawRectangle(SLIDE[ID]["POSITION"][1], SLIDE[ID]["POSITION"][2], SLIDE[ID]["PROGRESS"], SLIDE[ID]["POSITION"][4], tocolor(SLIDE[ID]["COLOR"][2][1], SLIDE[ID]["COLOR"][2][2], SLIDE[ID]["COLOR"][2][3], SLIDE[ID]["COLOR"][2][4]));
end

addEventHandler("onClientClick", getRootElement(), function(button, state)
    if button == "left" then
        for ID, v in pairs(SLIDE) do
            if state == "down" then
                if isCursorOnElement(SLIDE[ID]["POSITION"][1], SLIDE[ID]["POSITION"][2], SLIDE[ID]["POSITION"][3], SLIDE[ID]["POSITION"][4]) then
                    SLIDE[ID]["ACTIVE"] = true;
                    return
                end
            end
            SLIDE[ID]["ACTIVE"] = false;
        end
    end
end)

function dxGetSlideLevel(ID)
    if SLIDE[ID] then
        return SLIDE[ID]["LEVEL"];
    end
    return false;
end

function isCursorOnElement (x, y, w, h)
    if isCursorShowing() then
        local screen = {guiGetScreenSize()};
        local cursor = {getCursorPosition ()}
        local mx, my = cursor[1] * screen[1], cursor[2] * screen[2]
        return (mx > x and mx < x + w and my > y and my < y + h)
    end
    return false;
end

-- EXEMPLO
addEventHandler("onClientRender", getRootElement(), function()
    dxCreateSlideBar("lib:test", {x*229, y*292, x*822, y*136}, {255, 255, 255, 255}, {25, 142, 208}, 1000);
    print(dxGetSlideLevel("lib:test"))
end)
--Scriptet írta: Csoki
--http://facebook.com/csokimtadeveloper/
local sx,sy = guiGetScreenSize();
local font = dxCreateFont("font.ttf",10);
local debugShow = false;
local debugX,debugY = sx/2-300,sy-410;
local isMove,moveX,moveY = false,false,false;
local cache = {};
local colors = {};
table.insert(colors,0,{255,255,255});
table.insert(colors,1,{205,92,92});
table.insert(colors,2,{255,165,0});
table.insert(colors,3,{50,205,50});

addEvent("debug.sendClient",true);
addEventHandler("debug.sendClient",root,function(level,line,message,side)
    local found = false;
    for k, v in ipairs(cache) do 
        if line == v[2] and message == v[3] and v[4] == side then 
            v[5] = v[5] + 1;
            found = true;
            break;
        end
    end
    if not found then 
        table.insert(cache,1,{level,line,message,side,1});
    end
end);

addEventHandler("onClientDebugMessage",root,function(message,level,file,line)
    triggerEvent("debug.sendClient",localPlayer,level,line,message,"client");
end);

function debugRender()
    if isCursorShowing() then 
        if isMove then 
            local cursorX,cursorY = getCursorPosition();
            cursorX,cursorY = cursorX * sx, cursorY * sy;

            debugX, debugY = moveX + cursorX, moveY + cursorY;
        end
    else 
        if isMove then 
            isMove, moveX, moveY = false,false,false;
        end
    end

    if #cache > 10 then 
        table.remove(cache,10);
    end

    dxDrawRectangle(debugX,debugY,600,200,tocolor(0,0,0,130));
    dxDrawRectangle(debugX,debugY-20,600,20,tocolor(0,0,0,160));
    dxDrawText("Debugscript",debugX,debugY-20,debugX+600,debugY,tocolor(255,255,255),1,font,"center","center");

    for k,v in ipairs(cache) do 
        local level, line, message, side, count = unpack(v);
        if count ~= 1 then 
            dxDrawText("["..side.."] [x"..count.."]"..message.. " -> Line: "..line,debugX+10,debugY+200-(k*20),500,200,tocolor(colors[level][1],colors[level][2],colors[level][3]),1,font,"left");
        else 
            dxDrawText("["..side.."] "..message.. " -> Line: "..line,debugX+10,debugY+200-(k*20),500,200,tocolor(colors[level][1],colors[level][2],colors[level][3]),1,font,"left");
        end
    end
end

addEventHandler("onClientClick",root,function(button,state,x,y)
if debugShow then 
    if button == "left" then 
        if state == "down" then 
            if isMouseInPosition(debugX,debugY-20,600,20) and not isMove then 
                isMove,moveX,moveY = true, debugX - x, debugY - y;
            end
        elseif state == "up" then 
            if isMove then 
                isMove, moveX, moveY = false,false,false;
            end
        end
    end
end
end);

addCommandHandler("resetdebug",function()
    debugX,debugY = sx/2-250,sy-210;
    if isMove then 
        isMove, moveX, moveY = false,false,false;
    end
    outputChatBox("Debugscript alap pozícióra helyezve!",0,200,0);
end);

addCommandHandler("cleardebugscript",function()
    cache = {};
    table.insert(cache,1,{3,1,"Debugscript Ürítve.","client",1});
end);

addCommandHandler("debug",function()
    debugShow = not debugShow;
    if debugShow then 
        outputChatBox("Debugscript bekapcsolva!",0,200,0);
        removeEventHandler("onClientRender",root,debugRender);
        addEventHandler("onClientRender",root,debugRender);
    else 
        outputChatBox("Debugscript bekapcsolva!",200,0,0);
        removeEventHandler("onClientRender",root,debugRender);
    end
end);

--UTILS--
function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end
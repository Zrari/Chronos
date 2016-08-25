--[[
********************************************************************************
	Developer:   		Chronos

	Version:    		Open source
	License:    		BSD
	Status:     		beta release
********************************************************************************
]]--

local sx, sy = guiGetScreenSize()
local data = {}
local events = {
	{"aButton[1]", "useTitle"},  --useTitle,removeTitle, pickColor, personal, group, squad
	{"aButton[2]", "removeTitle"},
	{"aButton[3]", "close"},
	{"aButton[4]", "personal"},
	{"aButton[5]", "group"},
	{"aButton[6]", "squad"},
}

function makeGUI()

local aButton, aEdit, aLabel = {}, {}, {}
local x, y = guiGetScreenSize() --To be removed
local screenW, screenH = guiGetScreenSize() --To be removed
local x,y = (screenW-screenH)/2,(screenH-screenH)/2 --To be removed

	customTitles = guiCreateWindow(444, 249, 792, 552, "CIF Custom titles", false)
		guiWindowSetSizable(customTitles, false)
		guiSetAlpha(customTitles, 0.98)

	grid_titles = guiCreateGridList(20, 34, 762, 198, false, customTitles)
		titcol = guiGridListAddColumn(grid_titles, "Titles", 0.5)
		--typeColumn = guiGridListAddColumn(grid_titles, "Type", 0.2)  --Needs an update.
	
	aButton[1] = guiCreateButton(22, 242, 97, 34, "Use title", false, customTitles)
	aButton[2] = guiCreateButton(129, 242, 97, 34, "Remove title", false, customTitles)
	aButton[3] = guiCreateButton(128, 498, 118, 34, "Close", false, customTitles)

	lab_info = guiCreateLabel(348, 242, 437, 500, "A custom title is a short message which appears above your head like your name tag but is very expensive. Here you can manage your custom titles and select one which a group or squad member has bought for your group or squad to have access to.\n\nYou can set whatever message you want in your custom title as long as it's not: religious, political, racist, rude, offensive, inappropriate or impersonation. If a staff member thinks your custom title is unacceptable they will admin jail you and then you should change your custom title.\n\nIf you buy a custom title for your group or squad and then you leave the group or squad, if you no longer want them to have that custom title you can sell it.\n\nTo change a custom titles color, message or to sell it you must be the owner and you must select it in the grid list.", false, customTitles)  
		guiLabelSetHorizontalAlign(lab_info, "left", true) 

	aButton[4] = guiCreateButton(23, 341, 310, 35, "Buy personal custom title for $25,000,000", false, customTitles)
	aButton[5] = guiCreateButton(23, 386, 310, 35, "Buy group custom title for $50,000,000", false, customTitles)
	aButton[6] = guiCreateButton(23, 431, 310, 35, "Buy squad custom title for $40,000,000", false, customTitles)   
	--aButton[7] = guiCreateButton(236, 242, 97, 34, "Pick Color", false, customTitles)

	title = guiCreateEdit(129, 287, 204, 33, "", false, customTitles)

	
		guiSetPosition(customTitles,x,y,false)    
		guiSetVisible(customTitles, false)
		for index, buttonSource in pairs(events) do
			data[aButton[index]] = buttonSource[2]
		end
end
addEventHandler("onClientResourceStart", resourceRoot, makeGUI)

function showTitles()
	guiGridListClear(grid_titles)
	--if (exports.CITsettings:getSetting("ctitles") == "Yes") then
		--exports.CORtexts:output("Enable the titles in settings first", 255, 0, 0)
		--return
	--end
	--triggerServerEvent("CIFtitles.getData", root)
	--triggerServerEvent("CIFtitles.checkAccess", root)
	guiGridListClear(grid_titles)
	--unlockTitles()
	--groupTitles()
	populateGrid()
	guiSetVisible(customTitles, true)
	showCursor(true)
end
addCommandHandler("t", showTitles)

function populateGrid(data)
    guiGridListClear(grid_titles)
	local row = guiGridListAddRow(grid_titles)
	local g = guiGridListAddRow(grid_titles)
	local s = guiGridListAddRow(grid_titles)
	local title = getElementData(localPlayer, "title") 
	local group = getElementData(localPlayer, "grouptitle") 
	local squad = getElementData(localPlayer, "squadtitle") 
	--local titletype = getElementData(localPlayer, "customTitleType")
	guiGridListSetItemText(grid_titles, row, titcol, title, false, false)
	guiGridListSetItemText(grid_titles, g, titcol, group, false, false)
	guiGridListSetItemText(grid_titles, s, titcol, squad, false, false)
	--guiGridListSetItemText(grid_titles, row, typeColumn, titletype, false, false)
end
setTimer(populateGrid, 10000, 0)

function clickButton()
	local d = data[source]
	
	if (not d) then
		return
	end
	--useTitle,removeTitle, pickColor, personal, group, squad
	if (d == "useTitle") then
		--useTitle()
		if (title) then
			outputChatBox("You're already using a custom title!", 255, 0, 0)
			return
		end
		r, c = guiGridListGetSelectedItem(grid_titles)
		ctitle = guiGridListGetItemText(grid_titles, r, c)
		createTitle(ctitle)
		title = true
		outputChatBox("You're now using your custom title.", 0, 255, 0)
		setElementData(localPlayer, "usedtitle", true)
		
		--triggerServerEvent("CRtitle.getData", root, localPlayer, d)
	elseif (d == "removeTitle") then
		--removeTitle()
		if (not guiGridListGetSelectedItem(grid_titles)) then
			outputChatBox("Select the title you want to remove first!", 255, 0, 0)
			return
		end
		if (title) then
			outputChatBox("Title has been removed successfully.", 0, 255, 0)
			setTimer(removeHandler, 1000, 1)
			title = false
			setElementData(localPlayer, "usedtitle", false)
		end
		--triggerServerEvent("CRtitle.getData", root, localPlayer, d)
	elseif (d == "pickColor") then
		--pickColor()
		--triggerServerEvent("CRtitle.getData", root, localPlayer, d)
	elseif (d == "personal") then 
		--personal title()
		local v = guiGetText(title)
		triggerServerEvent("CRtitle.getData", root, localPlayer, d, v)
	elseif (d == "group") then 
		--group title()
		local v = guiGetText(title)
		triggerServerEvent("CRtitle.getData", root, localPlayer, d, v)
	elseif (d == "squad") then 
		--squad title()
		local v = guiGetText(title)
		triggerServerEvent("CRtitle.getData", root, localPlayer, d, v)
	elseif (d == "close") then 
		guiSetVisible(customTitles, false)
		showCursor(false)
	end
end
addEventHandler("onClientGUIClick", resourceRoot, clickButton)

-- Colors

local r3 = 0
local g3 = 255
local b3 = 0

addEventHandler ( "onClientGUIClick", title_color,
	function ( )
		--exports.cpicker:openPicker ( "TitleColor", "#0000FF", "Titles Color's color picker" )
	end, false
)

addEventHandler ( "onColorPickerOK", root,
	function ( element, hex, r, g, b )
		if ( element == "TitleColor" ) then
			hex   = "FF" .. ( { hex:gsub ( "#", "" ) } ) [ 1 ]
			local color = r .. ", " .. g .. ", " .. b
			--guiSetProperty ( title_color, "NormalTextColour", hex )
			setElementData ( title_color, "TitleColor", color )
			outputChatBox("Title color is set to: R: "..r..", G: "..g..", B:"..b, r, g, b)
		end
	end
)

addEventHandler ( "onClientGUIClick", but_close,
function ()
	local r, g, b = unpack(split(getElementData(title_color, "TitleColor"),", "))
	r2, g2, b2 = tonumber(r), tonumber(g), tonumber(b)
	if (r2 and g2 and b2) then
	    r3 = r2
		g3 = g2
		b3 = b2
	end
end)

function setColor(cmd, r2, g2, b2)
for k, v in pairs( getElementsByType( "player", root, true ) ) do
	if (r2 and g2 and b2) then
	    if (tonumber(r2) >= 0 and tonumber(r2) <= 255) then
	    	r3 = tonumber(r2)
	    end
		if (tonumber(g2) >= 0 and tonumber(g2) <= 255) then
			g3 = tonumber (g2) 
		end
		if (tonumber(b2) >= 0 and tonumber(b2) <= 255) then
			b3 = tonumber(b2)
		end	
		end
	end
end
addCommandHandler("titlecolor", setColor)

--Titles creations
local resX, resY = guiGetScreenSize()
function drawTitle()
	--if (exports.CITsettings:getSetting("ctitles") == "Yes") then
		--return
	--end
	for k, v in pairs( getElementsByType( "player", root, true ) ) do
		if (isElementOnScreen( v ) ) then
			local x, y, z = getElementPosition( v )
			local a, b, c = getElementPosition( localPlayer )
			local dist = getDistanceBetweenPoints3D( x, y , z, a, b, c )
			if ( dist < 30 ) then
				x, y, z = getPedBonePosition( v, 4 )
				local tX, tY = getScreenFromWorldPosition( x, y, z+0.4, 0, false )
				if ( tX and tY and isLineOfSightClear( a, b, c, x, y, z, true, false, false, true, true, false, false, v ) ) then
					local muted = getElementData( v, "m" )
					local arrested = getElementData(v, "arrested")
					theText = getElementData(v, "ct")
					local width = dxGetTextWidth( tostring(theText), 0.6, "bankgothic" )
					--if (exports.CITsettings:getSetting("ctitles") == "Yes") then
						--return
					--end
					if ( theText ~= "nil" and not muted and not arrested) then
						dxDrawText( tostring(theText), tX-( width/2), tY, resX, resY, tocolor( tonumber(r3), tonumber(g3), tonumber(b3), 255 ), 0.5, "bankgothic")
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, drawTitle)

function createTitle(ctitle)
	if (type(ctitle) ~= "string") then
		outputDebugString("Expected string at argument one, got "..type(ctitle).."", 1)
		return
	end
	setElementData(localPlayer, "ct", ctitle)
end
addEvent("CRtitle.createTitle", true)
addEventHandler("CRtitle.createTitle", root, createTitle)

function removeHandler()
	setElementData(localPlayer, "ct", "")
end
--[[
********************************************************************************
	Developer:   		Chronos

	Version:    		Open source
	License:    		BSD
	Status:     		beta release
********************************************************************************
]]--

local isInSaveDB = {}
local titles = {}
--Database
local db = dbConnect("sqlite", "titles.db")
dbExec(db, "CREATE TABLE IF NOT EXISTS accounts (acc TEXT, title TEXT)")
dbExec(db, "CREATE TABLE IF NOT EXISTS squads (squad TEXT, title TEXT)")
dbExec(db, "CREATE TABLE IF NOT EXISTS groups (gro TEXT, title TEXT)")

function loadAccounts(query)
	local d = dbPoll(query, 0)
	
	if (not d) then return end
	for ind, data in ipairs(d) do
		isInSaveDB[data.acc] = {data.title}
	end
end
dbQuery(loadAccounts, db, "SELECT * FROM accounts")

function loadGroups(query)
	local d = dbPoll(query, 0)
	
	if (not d) then return end
	for ind, data in ipairs(d) do
		isInSaveDB[data.gro] = {data.title}
	end
end
dbQuery(loadGroups, db, "SELECT * FROM groups")

function loadSquads(query)
	local d = dbPoll(query, 0)
	
	if (not d) then return end
	for ind, data in ipairs(d) do
		isInSaveDB[data.squad] = {data.title}
	end
end
dbQuery(loadSquads, db, "SELECT * FROM squads")

function setData(plr)

	local acc = getAccountName(getPlayerAccount(plr))
	if (acc ~= "guest") then
		
		local title = getElementData(plr, "title", value)
		
		if (isInSaveDB[acc]) then
			dbExec(db, "UPDATE accounts SET title=? WHERE acc=?", tostring(title), tostring(acc))
			isInSaveDB[acc] = {title}
		else
			dbExec(db, "INSERT INTO accounts (acc, title) VALUES (?, ?)", tostring(acc), tostring(title))
			isInSaveDB[acc] = {title}
		end
	end
end

function setGroupData(plr)

	local acc = getAccountName(getPlayerAccount(plr))
	if (acc ~= "guest") then
		
		local gro = getElementData(plr, "group")
		local title = getElementData(plr, "grouptitle")
		
		if (isInSaveDB[gro]) then
			dbExec(db, "UPDATE groups SET title=? WHERE gro=?", tostring(title), tostring(gro))
			isInSaveDB[gro] = {title}
		else
			dbExec(db, "INSERT INTO groups (gro, title) VALUES (?, ?)", tostring(gro), tostring(title))
			isInSaveDB[gro] = {title}
		end
	end
end

function setSquadData(plr)

	local acc = getAccountName(getPlayerAccount(plr))
	if (acc ~= "guest") then
		
		local squad = getElementData(plr, "s")
		local title = getElementData(plr, "grouptitle")
		
		if (isInSaveDB[squad]) then
			dbExec(db, "UPDATE squads SET title=? WHERE squad=?", tostring(title), tostring(squad))
			isInSaveDB[squad] = {title}
		else
			dbExec(db, "INSERT INTO squads (squad, title) VALUES (?, ?)", tostring(squad), tostring(title))
			isInSaveDB[squad] = {title}
		end
	end
end

function executeData()

	local account = getAccountName(getPlayerAccount(source))
	if (isInSaveDB[account] and account ~= "guest") then
		local title = isInSaveDB[account][1]
		
		setElementData(source, "customTitleType", "Personal")
		setElementData(source, "title", tostring(title))
		setElementData(source, "ct", tostring(title))
	end
end
addEventHandler("onPlayerLogin", root, executeData)

function executeGroupData()

	local gro = getElementData(source, "group")
	if (isInSaveDB[gro]) then
		local title = isInSaveDB[gro][1]
		
		setElementData(source, "customTitleType", "group")
		setElementData(source, "grouptitle", tostring(title))
		setElementData(source, "ct", tostring(title))
	end
end
addEventHandler("onPlayerLogin", root, executeGroupData)

function executeSquadData()

	local squad = getElementData(source, "s")
	if (isInSaveDB[squad]) then
		local title = isInSaveDB[squad][1]
		
		setElementData(source, "customTitleType", "squad")
		setElementData(source, "squadtitle", tostring(title))
		setElementData(source, "ct", tostring(title))
	end
end
addEventHandler("onPlayerLogin", root, executeSquadData)

function doAction(plr, action, value)

	if (not action) then
		outputChatBox("Unable to find what action or on what player to perform it on.", client, 255, 0, 0)
		return
	end
	
	--useTitle,removeTitle, pickColor, personal, group, squad
	--triggerServerEvent("CRtitle.getData", root, localPlayer, d)
	if (action == "personal") then
	
		local account = getPlayerAccount(plr)
		local amount = 2
		local isaccount = dbPoll(dbQuery(db, "SELECT * FROM accounts WHERE acc=?", getAccountName(account)), -1)
		if (#isaccount == 0) then
			dbExec(db, "INSERT INTO accounts (acc, title) VALUES (?, ?)", getAccountName(getPlayerAccount(plr)), value)
			log = getPlayerName(plr).." has bought a personal title $"..exports.CRmisc:formatNumber(amount)
			takePlayerMoney(plr, amount)	
			setElementData(plr, "customTitleType", "Personal")
			setElementData(plr, "title", value)
			setElementData(plr, "ct", value)
		else
			outputChatBox("Already own an account title.", plr, 225, 225, 225)	
		end
		
	elseif (action == "group") then
		
		if not getElementData(plr, "group") then return end
		local amount = 5
		local group = getElementData(plr, "group")
		local isgroup = dbPoll(dbQuery(db, "SELECT * FROM groups WHERE gro=?", group), -1)
		if (#isgroup == 0) then
			dbExec(db, "INSERT INTO groups (gro, title) VALUES (?, ?)", group, value)
			log = getPlayerName(plr).." has bought a group title $"..exports.CRmisc:formatNumber(amount)
			takePlayerMoney(plr, amount)
			setElementData(plr, "customTitleType", "Group")
			setElementData(plr, "grouptitle", value)
			setElementData(plr, "ct", value)
		else
			outputChatBox("Already own a group title.", plr, 225, 225, 225)
		end
		
	elseif (action == "squad") then
		
		if not getElementData(plr, "s") then return end
		local amount = 4
		local squad = getElementData(plr, "s") or "Not Available."
		local issquad = dbPoll(dbQuery(db, "SELECT * FROM squads WHERE squad=?", squad), -1)
		if (#issquad == 0) then
			dbExec(db, "INSERT INTO squads (squad, title) VALUES (?, ?)", squad, value)
			log = getPlayerName(plr).." has bought a squad title $"..exports.CRmisc:formatNumber(amount)
			takePlayerMoney(plr, amount)
			setElementData(plr, "customTitleType", "Squad")
			setElementData(plr, "squadtitle", value)
			setElementData(plr, "ct", value)
		else 
			outputChatBox("Already own a squad title.", plr, 225, 225, 225)
		end
		
	end
	if (log) then
		exports.CRlogs:log(plr, log, "moneyLog")
	end
end
addEvent("CRtitle.getData", true)
addEventHandler("CRtitle.getData", root, doAction)
	

	
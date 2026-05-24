--VARIABLES--
local Player = game:GetService("Players")
local DSS = game:GetService("DataStoreService")
local DailyRewardStore = DSS:GetDataStore("DailyRewardDataV7")
local oneday = 86400
local rewards = require(game.ReplicatedStorage.Shared.DailyRewards)
local sendData = game.ReplicatedStorage:WaitForChild("SentRewardData")
local PlayerData = {}

local function loadData(player)
	local success, result = pcall(function()
		return DailyRewardStore:GetAsync(player.UserId)
	end)
	if success then
		PlayerData[player.UserId] = result or {LastClaim = 0, Day = 1}
		return PlayerData[player.UserId]
	else
		warn("Error getting data for player " .. player.Name .. ": " .. result)
		return nil
	end
end

Player.PlayerAdded:Connect(function(player)
	local data = loadData(player)
	print("Player day:", data.Day, "LastClaim:", data.LastClaim)
	if data then
		local timeSinceLastClaim = os.time() - data.LastClaim
		if timeSinceLastClaim >= oneday * 2 then
			data.Day = 1
		end
		sendData:FireClient(player, data.Day, data.LastClaim)
	end
end)

local function giveReward(player)
	print("giveReward called for", player.Name)
	local data = PlayerData[player.UserId]
	print("data:", data)
	if not data then return end
	local timesincelastclaim = os.time() - data.LastClaim
	print("timeSinceLastClaim:", timesincelastclaim, "oneday:", oneday)
	if timesincelastclaim >= oneday then
		print("Giving reward!")
		local reward = rewards[data.Day]
		if reward then
			if reward.type == "speed" then
				player.Character.Humanoid.WalkSpeed += reward.amount
			elseif reward.type == "wins" then
				player.leaderstats.Level.Value += reward.amount
			elseif reward.type == "pet" then
				local pet = game.ServerStorage.Pets:FindFirstChild("Dog"):Clone()
				pet.Parent = player.Backpack
			elseif reward.type == "bobux" then
				player.leaderstats.Bobux.Value += reward.amount
			end
		end
		data.LastClaim = os.time()
		data.Day = data.Day + 1
		if data.Day > #rewards then
			data.Day = 1
		end
		pcall(function()
			DailyRewardStore:SetAsync(player.UserId, data)
			sendData:FireClient(player, data.Day, data.LastClaim)
		end)
	end
end

game.ReplicatedStorage.DailyReward.OnServerEvent:Connect(function(player, day)
	giveReward(player)
end)

Player.PlayerRemoving:Connect(function(player)
	local data = PlayerData[player.UserId]
	if data then
		pcall(function()
			DailyRewardStore:SetAsync(player.UserId, data)
		end)
	end
end)

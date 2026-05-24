local daysContainer = script.Parent
local daycards = {
	day1 = daysContainer:WaitForChild("Day1"),
	day2 = daysContainer:WaitForChild("Day2"),
	day3 = daysContainer:WaitForChild("Day3"),
	day4 = daysContainer:WaitForChild("Day4"),
	day5 = daysContainer:WaitForChild("Day5")
}
local claimbuttons = {
	day1 = daycards.day1:WaitForChild("ClaimButton1"),
	day2 = daycards.day2:WaitForChild("ClaimButton2"),
	day3 = daycards.day3:WaitForChild("ClaimButton3"),
	day4 = daycards.day4:WaitForChild("ClaimButton4"),
	day5 = daycards.day5:WaitForChild("ClaimButton5")
}


local function updateDayCards(day)
	print("Updating cards for day:", day)
	for key, card in pairs(daycards) do
		local button = claimbuttons[key]
		if tonumber(key:sub(4)) < day then
			card:WaitForChild("ClaimedLabel").Visible = true
			button.Visible = false
		else
			card:WaitForChild("ClaimedLabel").Visible = false
			button.Visible = true
			local cardDay = tonumber(key:sub(4))

			if cardDay < day then
				button.Text = "Claimed"
				button.Active = false
				button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			elseif cardDay == day then
				button.Text = "Claim"
				button.Active = true
				button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			else
				button.Text = "Day " .. cardDay
				button.Active = false
				button.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
				
			end
		end
	end
end

game.ReplicatedStorage.SentRewardData.OnClientEvent:Connect(function(day, lastClaim)
	updateDayCards(day)
end)

for key, button in pairs(claimbuttons) do
	button.MouseButton1Click:Connect(function()
		print("Button clicked, Active:", button.Active)
		if button.Active then
			print("Firing remote")
			game.ReplicatedStorage.DailyReward:FireServer()
		end
	end)
end

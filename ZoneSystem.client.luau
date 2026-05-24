local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local zone = game.Workspace:WaitForChild("Zone1")
local sound = game.SoundService:WaitForChild("Atlantis")
local gui = plr.PlayerGui:WaitForChild("Zone1")
local nameLabel = gui:WaitForChild("nameLabel")
local descLabel = gui:WaitForChild("descLabel")
local inZone = false
local runsv = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local typewrite = require(game.ReplicatedStorage.Shared:WaitForChild("TypeWriter"))
local thread = nil

nameLabel.Text = ""
descLabel.Text = ""

runsv.Heartbeat:Connect(function()
	local gpip = workspace:GetPartsInPart(zone)
if table.find (gpip, hrp) then
	if not inZone then
	if thread then task.cancel(thread) end
thread = task.spawn(function()
			inZone = true
			sound:Play()
			lighting.Brightness = 6
			gui.Enabled = true
			typewrite.typewriter(nameLabel, "[ Zone ]", 0.05)
			typewrite.typewriter(descLabel, "Yet another zone.", 0.05)
			task.wait(6)
			gui.Enabled = false
		end)
	end
else
	if inZone then 
		if thread then task.cancel(thread) end
		inZone = false
		sound:Stop()
		gui.Enabled = false
		lighting.Brightness = 2
		end
	end
end)

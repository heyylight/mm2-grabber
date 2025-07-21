local Module = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

return function()
	local LocalPlayer = Players.LocalPlayer
	local ProfileData = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ProfileData"))

	local ItemsFolder = Instance.new("Folder")
	ItemsFolder.Name = "Items"
	ItemsFolder.Parent = workspace

	local function CloneItem(Item, ItemType)
		if not ItemsFolder:FindFirstChild(ProfileData.Weapons.Equipped[ItemType]) then
			local Clone = Item:Clone()
			Clone.Anchored = true
			Clone.Name = ProfileData.Weapons.Equipped[ItemType]
			Clone.Parent = ItemsFolder
			return Clone
		else
			warn("Clone already exists in ItemsFolder!")
		end
	end
	
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.CharacterAdded:Wait()
	end

	local character = LocalPlayer.Character
	local GunDisplay, KnifeDisplay

	while true do
		GunDisplay = character:FindFirstChild("DisplayRefGun")
		KnifeDisplay = character:FindFirstChild("DisplayRefKnife")

		if GunDisplay and KnifeDisplay then
			print("ItemGrabber Started.")
			break
		end

		task.wait(0.5)
	end

	if GunDisplay:IsA("ObjectValue") then
		GunDisplay:GetPropertyChangedSignal("Value"):Connect(function()
			CloneItem(GunDisplay.Value, "Gun")
			print("Gun changed:", GunDisplay.Value)
		end)
	end

	if KnifeDisplay:IsA("ObjectValue") then
		KnifeDisplay:GetPropertyChangedSignal("Value"):Connect(function()
			CloneItem(KnifeDisplay.Value, "Knife")
			print("Knife changed:", KnifeDisplay.Value)
		end)
	end
end

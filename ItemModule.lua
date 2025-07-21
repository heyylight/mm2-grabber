local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local ItemsFolder = Instance.new("Folder")
ItemsFolder.Name = "Items"
ItemsFolder.Parent = workspace

local function getItemTextureId(item)
	if item:IsA("MeshPart") then
		if item.TextureID and item.TextureID ~= "" then
			return item.TextureID
		end
	end

	if item:IsA("BasePart") then
		local mesh = item:FindFirstChild("Mesh")
		if mesh and mesh.TextureId and mesh.TextureId ~= "" then
			return mesh.TextureId
		end
	end

	for _, descendant in ipairs(item:GetDescendants()) do
		if descendant:IsA("Decal") or descendant:IsA("Texture") then
			if descendant.Texture and descendant.Texture ~= "" then
				return descendant.Texture
			end
		end
	end

	return nil
end

local function cloneItemIfNewTexture(item, itemType)
	local newTextureId = getItemTextureId(item)
	if not newTextureId then
		local clone = item:Clone()
		clone.Anchored = true
		clone.Parent = ItemsFolder
		return clone
	end

	for _, existingItem in ipairs(ItemsFolder:GetChildren()) do
		local existingTextureId = getItemTextureId(existingItem)
		if existingTextureId == newTextureId then
			print("Item with this texture already exists. Skipping clone.")
			return nil
		end
	end

	local clone = item:Clone()
	clone.Anchored = true
	clone.Parent = ItemsFolder
	return clone
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
		print("Both DisplayRefGun and DisplayRefKnife are now available!")
		break
	end

	task.wait(0.5)
end

if GunDisplay:IsA("ObjectValue") then
	GunDisplay:GetPropertyChangedSignal("Value"):Connect(function()
		cloneItemIfNewTexture(GunDisplay.Value, "Gun")
		print("Gun changed:", GunDisplay.Value)
	end)
end

if KnifeDisplay:IsA("ObjectValue") then
	KnifeDisplay:GetPropertyChangedSignal("Value"):Connect(function()
		cloneItemIfNewTexture(KnifeDisplay.Value, "Knife")
		print("Knife changed:", KnifeDisplay.Value)
	end)
end

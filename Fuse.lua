_G.autoFuse = true

local PET_TO_FUSE = "Alien Axolotl" -- name of the pet you want to fuse
local FUSE_AMOUNT = 100 -- amount to put into fuse (3 is the minimum)
local IS_SHINY = false
local PET_TYPE = 2 -- change to 2 for Rainbow, 1 for Golden, or 0 for Normal
-- MAKE PET TYPES TO FUSE


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local LocalPlayer = game:GetService("Players").LocalPlayer

local pets = require(Library).Save.Get().Inventory.Pet

local petId
for id, petData in pairs(pets) do
    if petData["id"] == PET_TO_FUSE then
        print("Found pet:")
        if tonumber(petData["pt"]) == PET_TYPE then
            if IS_SHINY then
                if petData["sh"] then
                    petId = id
                    break
                end
            else
                if not petData["sh"] then
                    petId = id
                    break
                end
            end
        else
            petId = id
        end
    end
end

if not petId then
    print("Pet not found")
    return
else
    print("Found pet: " .. petId)
end

local function teleportToFuseMachine()
    if game:GetService("Workspace"):FindFirstChild("Map") then
        local zonePath
        zonePath = game:GetService("Workspace").Map["28 | Shanty Town"]
        LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.PERSISTENT.Teleport.CFrame

        if not zonePath:FindFirstChild("INTERACT") then
            local loaded = false
            local detectLoad = zonePath.ChildAdded:Connect(function(child)
                if child.Name == "INTERACT" then
                    loaded = true
                end
            end)

            repeat
                task.wait()
            until loaded

            detectLoad:Disconnect()
        end

        LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.INTERACT.Machines.FuseMachine.PadGlow.CFrame
    else
        local zonePath
        zonePath = game:GetService("Workspace").Map2["100 | Tech Spawn"]
        LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.PERSISTENT.Teleport.CFrame

        if not zonePath:FindFirstChild("INTERACT") then
            local loaded = false
            local detectLoad = zonePath.ChildAdded:Connect(function(child)
                if child.Name == "INTERACT" then
                    loaded = true
                end
            end)

            repeat
                task.wait()
            until loaded

            detectLoad:Disconnect()
        end

        LocalPlayer.Character.HumanoidRootPart.CFrame = zonePath.INTERACT.Machines.SuperMachine.PadGlow.CFrame
    end
end

teleportToFuseMachine()

while _G.autoFuse do
    local args = {
        [1] = {
            [petId] = FUSE_AMOUNT
        }
    }

    game:GetService("ReplicatedStorage").Network.FuseMachine_Activate:InvokeServer(unpack(args))
    task.wait()
end

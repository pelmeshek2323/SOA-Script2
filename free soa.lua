ocal Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera


local Config = {
    ESP = {
        Enable = true,
        Color = Color3.new(1, 0, 0)
    },
    Player = {
        Speed = 24,
        Noclip = false
    }
}


local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ESPToggle = Instance.new("TextButton")
local SpeedLabel = Instance.new("TextLabel")
local NoclipToggle = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "HyperXCheats"


MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = ScreenGui

Title.Text = "HyperX Cheats (Drag)"
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = MainFrame


ESPToggle.Size = UDim2.new(0.9, 0, 0, 25)
ESPToggle.Position = UDim2.new(0.05, 0, 0.2, 0)
ESPToggle.Text = "ESP: ON"
ESPToggle.Parent = MainFrame


NoclipToggle.Size = UDim2.new(0.9, 0, 0, 25)
NoclipToggle.Position = UDim2.new(0.05, 0, 0.5, 0)
NoclipToggle.Text = "Noclip: OFF"
NoclipToggle.Parent = MainFrame


local dragging, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)


local ESP = {
    Objects = {}
}

function ESP:Update()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local root = character:FindFirstChild("HumanoidRootPart")
            
            if not root then continue end
            
            if not ESP.Objects[player] then
                ESP.Objects[player] = {
                    Box = Drawing.new("Square"),
                    Text = Drawing.new("Text")
                }
            end
            
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                ESP.Objects[player].Box.Visible = Config.ESP.Enable
                ESP.Objects[player].Box.Size = Vector2.new(2000/pos.Z, 3000/pos.Z)
                ESP.Objects[player].Box.Position = Vector2.new(
                    pos.X - ESP.Objects[player].Box.Size.X/2, 
                    pos.Y - ESP.Objects[player].Box.Size.Y/2
                )
                ESP.Objects[player].Box.Color = Config.ESP.Color
                
                ESP.Objects[player].Text.Visible = true
                ESP.Objects[player].Text.Text = player.Name
                ESP.Objects[player].Text.Position = Vector2.new(pos.X, pos.Y - 30)
            else
                ESP.Objects[player].Box.Visible = false
                ESP.Objects[player].Text.Visible = false
            end
        end
    end
end


ESPToggle.MouseButton1Click:Connect(function()
    Config.ESP.Enable = not Config.ESP.Enable
    ESPToggle.Text = "ESP: " .. (Config.ESP.Enable and "ON" or "OFF")
end)

NoclipToggle.MouseButton1Click:Connect(function()
    Config.Player.Noclip = not Config.Player.Noclip
    NoclipToggle.Text = "Noclip: " .. (Config.Player.Noclip and "ON" or "OFF")
end)


RunService.Heartbeat:Connect(function()
    ESP:Update()
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Config.Player.Speed
            
            if Config.Player.Noclip then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)

print("loaded!")

-- PretoneioLib atualizada com novo padrão: apenas Tabs com elementos

local PretoneioLib = {}

print("Carregando PretoneioLib...")

-- Services 
local UIS = game:GetService("UserInputService") 
local Players = game:GetService("Players") 
local LP = Players.LocalPlayer 
local PG = LP:WaitForChild("PlayerGui")

-- Utilitário para pegar nome 
local function getName(data) if typeof(data) == "table" then return tostring(data[1]) else return tostring(data) end end

function PretoneioLib:MakeWindow(data) local title = getName(data.Title or "Window") local subtitle = getName(data.SubTitle or "")

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PretoneioUI"
gui.ResetOnSpawn = false
gui.Parent = PG

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 290)
main.Position = UDim2.new(0.3, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.Text = title
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
titleLabel.Parent = main

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, 0, 0, 20)
subtitleLabel.Position = UDim2.new(0, 0, 0, 30)
subtitleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
subtitleLabel.Text = subtitle
subtitleLabel.Font = Enum.Font.SourceSans
subtitleLabel.TextSize = 16
subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
subtitleLabel.Parent = main

-- Abas horizontais
local tabButtons = Instance.new("Frame")
tabButtons.Size = UDim2.new(1, 0, 0, 30)
tabButtons.Position = UDim2.new(0, 0, 0, 50)
tabButtons.BackgroundTransparency = 1
tabButtons.Parent = main

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -80)
contentFrame.Position = UDim2.new(0, 0, 0, 80)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = main

local window = { Tabs = {} }

function window:MakeTab(tabData)
    local tabName = getName(tabData)

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 100, 1, 0)
    tabBtn.Position = UDim2.new(0, #window.Tabs * 100, 0, 0)
    tabBtn.Text = tabName
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 40)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 16
    tabBtn.Parent = tabButtons

    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = #window.Tabs == 0
    tabFrame.Parent = contentFrame

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(contentFrame:GetChildren()) do
            if t:IsA("Frame") then t.Visible = false end
        end
        tabFrame.Visible = true
    end)

    local tab = { Frame = tabFrame, Elements = {} }

    function tab:AddButton(buttonData)
        local buttonName = getName(buttonData)
        local yOffset = #tab.Elements * 40

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, yOffset)
        btn.Text = buttonName
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 80)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        btn.Parent = tab.Frame

        if typeof(buttonData) == "table" and buttonData.Callback then
            btn.MouseButton1Click:Connect(buttonData.Callback)
        end

        table.insert(tab.Elements, btn)
        return btn
    end

    table.insert(window.Tabs, tab)
    return tab
end

return window

end

return PretoneioLib

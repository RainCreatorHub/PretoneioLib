-- PretoneioLib - Biblioteca de Interface com suporte a sintaxe simplificada

local PretoneioLib = {}

-- serviços...
local UIS = game:GetService("UserInputService") local Players = game:GetService("Players")
local function getName(data) if typeof(data) == "table" then return data.Name or data[1] or "Sem Nome" else return tostring(data) end end
function PretoneioLib:MakeWindow(data) local title = getName(data) local subtitle = data.SubTitle or ""

local gui = Instance.new("ScreenGui")
gui.Name = "PretoneioUI"
gui.ResetOnSpawn = false
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = title
main.Size = UDim2.new(0, 420, 0, 290)
main.Position = UDim2.new(0.3, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = title
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
titleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.Parent = main

local subTitleLabel = Instance.new("TextLabel")
subTitleLabel.Text = subtitle
subTitleLabel.Size = UDim2.new(1, 0, 0, 20)
subTitleLabel.Position = UDim2.new(0, 0, 0, 30)
subTitleLabel.BackgroundTransparency = 1
subTitleLabel.TextColor3 = Color3.fromRGB(130, 130, 255)
subTitleLabel.Font = Enum.Font.SourceSans
subTitleLabel.TextSize = 14
subTitleLabel.Parent = main

if data.Intro then
    local intro = Instance.new("TextLabel")
    intro.Text = getName(data.IntroText or "Carregando...")
    intro.Size = UDim2.new(1, 0, 1, 0)
    intro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    intro.TextColor3 = Color3.fromRGB(255, 255, 255)
    intro.Font = Enum.Font.SourceSansBold
    intro.TextSize = 22
    intro.Parent = main

    task.delay(data.IntroDuration or 3, function()
        intro:Destroy()
    end)
end

local window = {
    Frame = main,
    Tabs = {},
    Name = title
}

function window:MakeTab(tabData)
    local tabName = getName(tabData)

    local tab = {
        Name = tabName,
        Sections = {}
    }

    function tab:AddSection(sectionData)
        local sectionName = getName(sectionData)

        local section = {
            Name = sectionName,
            Elements = {}
        }

        function section:AddButton(buttonData)
            local buttonName = getName(buttonData)

            local button = Instance.new("TextButton")
            button.Text = buttonName
            button.Size = UDim2.new(0, 180, 0, 30)
            button.Position = UDim2.new(0, 10, 0, 60 + (#section.Elements * 35))
            button.BackgroundColor3 = Color3.fromRGB(0, 85, 170)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Font = Enum.Font.SourceSansBold
            button.TextSize = 16
            button.AutoButtonColor = true
            button.BorderSizePixel = 0
            button.Parent = window.Frame

            button.MouseButton1Click:Connect(function()
                if typeof(buttonData) == "table" and buttonData.Callback then
                    buttonData.Callback()
                end
            end)

            table.insert(section.Elements, button)
            return button
        end

        table.insert(tab.Sections, section)
        return section
    end

    table.insert(window.Tabs, tab)
    return tab
end

return window

end

return PretoneioLib


local PretoneioLib = {}

print("Carregando...")

-- Services
local UIS = game:GetService("UserInputService")

function PretoneioLib:MakeWindow(data)
    local gui = Instance.new("ScreenGui")
    gui.Name = "PretoneioUI"
    gui.ResetOnSpawn = false
    gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = tostring(data.Name)
    main.Size = UDim2.new(0, 400, 0, 300)
    main.Position = UDim2.new(0.3, 0, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    local title = Instance.new("TextLabel")
    title.Text = tostring(data.Name)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = main

    -- Intro opcional
    if data.Intro then
        local introLabel = Instance.new("TextLabel")
        introLabel.Size = UDim2.new(1, 0, 1, 0)
        introLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introLabel.BackgroundTransparency = 0.3
        introLabel.Text = tostring(data.IntroText or "Bem-vindo!")
        introLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        introLabel.TextSize = 28
        introLabel.Font = Enum.Font.SourceSansBold
        introLabel.Parent = main
        introLabel.ZIndex = 10

        task.delay(data.IntroDuration or 3, function()
            introLabel:Destroy()
        end)
    end

    local window = {
        Frame = main,
        Tabs = {},
        Name = tostring(data.Name)
    }

    function window:MakeTab(tabData)
        local tab = {
            Name = tostring(tabData.Name),
            Sections = {}
        }

        function tab:AddSection(sectionData)
            local section = {
                Name = tostring(sectionData.Name),
                Elements = {}
            }

            function section:AddButton(buttonData)
                local button = Instance.new("TextButton")
                button.Text = tostring(buttonData.Name)
                button.Size = UDim2.new(1, -10, 0, 30)
                button.Position = UDim2.new(0, 5, 0, 40 + (#section.Elements * 35))
                button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.Font = Enum.Font.SourceSans
                button.TextSize = 18
                button.Parent = main

                button.MouseButton1Click:Connect(function()
                    if buttonData.Callback then
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

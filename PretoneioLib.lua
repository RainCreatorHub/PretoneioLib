local LibTest = {}

local UserInputService = game:GetService("UserInputService")

function LibTest:MakeWindow(properties)
    local titleText = properties.Title
    local subTitleText = properties.SubTitle

    if not titleText and not subTitleText then
        warn("LibTest:MakeWindow chamado sem Title ou SubTitle. Nenhum Gui foi criado.")
        return nil
    end

    local themes = {
        Dark = {
            Background = Color3.fromRGB(30, 30, 30),
            TitleColor = Color3.fromRGB(255, 255, 255),
            SubTitleColor = Color3.fromRGB(180, 180, 180),
            DragBar = Color3.fromRGB(40, 40, 40),
            CloseText = Color3.fromRGB(255, 255, 255)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 240),
            TitleColor = Color3.fromRGB(0, 0, 0),
            SubTitleColor = Color3.fromRGB(80, 80, 80),
            DragBar = Color3.fromRGB(200, 200, 200),
            CloseText = Color3.fromRGB(0, 0, 0)
        }
    }

    local chosenTheme = themes[properties.Theme] or {}

    local Window = Instance.new("ScreenGui")
    Window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    Window.Name = "YorHubWindow"
    Window.DisplayOrder = 10
    Window.ResetOnSpawn = false

    local blocker = Instance.new("Frame")
    blocker.Size = UDim2.new(1, 0, 1, 0)
    blocker.BackgroundTransparency = 1
    blocker.ZIndex = 9
    blocker.Parent = Window

    blocker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            input:Destroy()
        end
    end)

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size = UDim2.new(0, 500, 0, 350)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ZIndex = 10
    frame.Parent = Window
    frame.BackgroundColor3 = properties.BackgroundColor3 or chosenTheme.Background or Color3.fromRGB(50, 50, 50)

    local dragging = false
    local dragInput, dragStart, startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    local dragBar = Instance.new("Frame")
    dragBar.Name = "DragBar"
    dragBar.Size = UDim2.new(1, 0, 0.1, 0)
    dragBar.Position = UDim2.new(0, 0, 0, 0)
    dragBar.BackgroundColor3 = chosenTheme.DragBar or Color3.new(0.15, 0.15, 0.15)
    dragBar.BorderSizePixel = 0
    dragBar.ZIndex = 11
    dragBar.Parent = frame

    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    local offsetY = 0.1

    if typeof(titleText) == "string" and #titleText > 0 then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Text = titleText
        titleLabel.Size = UDim2.new(1, 0, 0.15, 0)
        titleLabel.Position = UDim2.new(0.5, 0, offsetY, 0)
        titleLabel.AnchorPoint = Vector2.new(0.5, 0)
        titleLabel.Font = properties.TitleFont or Enum.Font.SourceSansBold
        titleLabel.TextSize = properties.TitleSize or 20
        titleLabel.TextColor3 = properties.TitleColor or chosenTheme.TitleColor or Color3.new(1, 1, 1)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Parent = frame
        titleLabel.ZIndex = 11
        offsetY = offsetY + 0.2
    end

    if typeof(subTitleText) == "string" and #subTitleText > 0 then
        local subTitleLabel = Instance.new("TextLabel")
        subTitleLabel.Text = subTitleText
        subTitleLabel.Size = UDim2.new(1, 0, 0.15, 0)
        subTitleLabel.Position = UDim2.new(0.5, 0, offsetY, 0)
        subTitleLabel.AnchorPoint = Vector2.new(0.5, 0)
        subTitleLabel.Font = properties.SubTitleFont or Enum.Font.SourceSans
        subTitleLabel.TextSize = properties.SubTitleSize or 14
        subTitleLabel.TextColor3 = properties.SubTitleColor or chosenTheme.SubTitleColor or Color3.new(0.8, 0.8, 0.8)
        subTitleLabel.BackgroundTransparency = 1
        subTitleLabel.Parent = frame
        subTitleLabel.ZIndex = 11
    end

    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0.05, 0, 0.1, 0)
    closeButton.Position = UDim2.new(0.95, 0, 0, 0)
    closeButton.AnchorPoint = Vector2.new(0.5, 0)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 14
    closeButton.TextColor3 = chosenTheme.CloseText or Color3.new(1, 1, 1)
    closeButton.BackgroundTransparency = 1
    closeButton.ZIndex = 12
    closeButton.Parent = frame

    closeButton.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)

    function Window:Close()
        Window:Destroy()
    end

    return Window
end

return LibTest

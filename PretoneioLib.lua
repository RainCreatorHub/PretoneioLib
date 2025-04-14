local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")

local RainLib = {
    Version = "1.2.3",
    Themes = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 25),
            Accent = Color3.fromRGB(60, 160, 255),
            Text = Color3.fromRGB(240, 240, 240),
            Secondary = Color3.fromRGB(45, 45, 45),
            Disabled = Color3.fromRGB(90, 90, 90)
        }
    },
    CurrentTheme = nil,
    CreatedFolders = {},
    GUIState = { Windows = {} }
}

-- Função auxiliar para animações
local function tween(obj, info, properties)
    local t = TweenService:Create(obj, info or TweenInfo.new(0.3, Enum.EasingStyle.Quint), properties)
    t:Play()
    return t
end

-- Função para arrastar janela
local function MakeDraggable(DragPoint, Main)
    local Dragging, DragInput, MousePos, FramePos
    DragPoint.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            MousePos = input.Position
            FramePos = Main.Position
            tween(DragPoint, nil, {BackgroundColor3 = RainLib.CurrentTheme.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.1)})
        end
    end)
    DragPoint.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - MousePos
            Main.Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
        end
    end)
    DragPoint.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
            tween(DragPoint, nil, {BackgroundColor3 = RainLib.CurrentTheme.Secondary})
        end
    end)
end

-- Inicialização
print("[RainLib] Inicializando...")
local success, err = pcall(function()
    RainLib.ScreenGui = Instance.new("ScreenGui")
    RainLib.ScreenGui.Name = "RainLib"
    RainLib.ScreenGui.Parent = game.CoreGui or LocalPlayer:WaitForChild("PlayerGui", 5)
    RainLib.ScreenGui.ResetOnSpawn = false
    RainLib.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    RainLib.CurrentTheme = RainLib.Themes.Dark
end)
if not success then
    warn("[RainLib] Falha na inicialização: " .. err)
    return nil
end
print("[RainLib] Inicializado com sucesso!")

-- Função para criar pastas
function RainLib:CreateFolder(folderName)
    if not folderName or folderName == "" then
        warn("[RainLib] Nome da pasta não especificado!")
        return false
    end
    if makefolder and writefile and not self.CreatedFolders[folderName] then
        if not isfolder(folderName) then
            makefolder(folderName)
            local settingsPath = folderName .. "/Settings.json"
            writefile(settingsPath, HttpService:JSONEncode({ Theme = "Dark", Flags = {} }))
            self:Notify(nil, { Title = "Sucesso", Content = "Pasta '" .. folderName .. "' criada!", Duration = 3 })
        end
        self.CreatedFolders[folderName] = true
        return true
    end
    return false
end

-- Funções para salvar/carregar configurações
function RainLib:SaveSettings(folderName, settings)
    if isfolder(folderName) and writefile then
        writefile(folderName .. "/Settings.json", HttpService:JSONEncode(settings))
    end
end

function RainLib:LoadSettings(folderName)
    if isfolder(folderName) and isfile(folderName .. "/Settings.json") then
        local success, settings = pcall(function()
            return HttpService:JSONDecode(readfile(folderName .. "/Settings.json"))
        end)
        return success and settings or nil
    end
    return nil
end

-- Função para notificações
function RainLib:Notify(window, options)
    local target = window and window.Notifications or RainLib.ScreenGui
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 280, 0, 80)
    notification.Position = UDim2.new(1, 300, 0, (#target:GetChildren() - 1) * 90 + 10)
    notification.BackgroundColor3 = RainLib.CurrentTheme.Background
    notification.Parent = target

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification

    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.7
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = notification

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 20)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.Text = options.Title or "Notificação"
    title.BackgroundTransparency = 1
    title.TextColor3 = RainLib.CurrentTheme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = notification

    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -10, 0, 40)
    message.Position = UDim2.new(0, 5, 0, 30)
    message.Text = options.Content or ""
    message.BackgroundTransparency = 1
    message.TextColor3 = RainLib.CurrentTheme.Text
    message.Font = Enum.Font.SourceSans
    message.TextSize = 14
    message.TextWrapped = true
    message.Parent = notification

    tween(notification, TweenInfo.new(0.5), { Position = UDim2.new(1, -290, 0, notification.Position.Y.Offset), BackgroundTransparency = 0 })
    task.spawn(function()
        task.wait(options.Duration or 3)
        tween(notification, TweenInfo.new(0.5), { Position = UDim2.new(1, 300, 0, notification.Position.Y.Offset), BackgroundTransparency = 1 }).Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- Função para criar janela
function RainLib:Window(options)
    local window = { Tabs = {}, Notifications = Instance.new("Frame") }
    options = options or {}
    window.Options = {
        Title = options.Title or "Rain Lib",
        SubTitle = options.SubTitle or "",
        Position = options.Position or UDim2.new(0.5, -300, 0.5, -200),
        Theme = options.Theme or "Dark",
        MinimizeKey = options.MinimizeKey or Enum.KeyCode.LeftControl,
        SaveSettings = options.SaveSettings or false,
        ConfigFolder = options.ConfigFolder or "RainConfig"
    }

    if window.Options.SaveSettings then
        RainLib:CreateFolder(window.Options.ConfigFolder)
    end

    window.Notifications.Size = UDim2.new(0, 300, 1, -25)
    window.Notifications.Position = UDim2.new(1, -310, 0, 0)
    window.Notifications.BackgroundTransparency = 1
    window.Notifications.Parent = RainLib.ScreenGui

    window.MainFrame = Instance.new("Frame")
    window.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    window.MainFrame.Position = UDim2.new(0.5, -300, 0.5, 300)
    window.MainFrame.BackgroundColor3 = RainLib.CurrentTheme.Background
    window.MainFrame.ClipsDescendants = true
    window.MainFrame.Parent = RainLib.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = window.MainFrame

    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.6
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = window.MainFrame

    window.TitleBar = Instance.new("Frame")
    window.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    window.TitleBar.BackgroundColor3 = RainLib.CurrentTheme.Secondary
    window.TitleBar.Parent = window.MainFrame

    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new(RainLib.CurrentTheme.Secondary, RainLib.CurrentTheme.Background)
    titleGradient.Rotation = 90
    titleGradient.Parent = window.TitleBar

    window.TitleLabel = Instance.new("TextLabel")
    window.TitleLabel.Size = UDim2.new(1, -60, 0, 20)
    window.TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    window.TitleLabel.BackgroundTransparency = 1
    window.TitleLabel.Text = window.Options.Title
    window.TitleLabel.TextColor3 = RainLib.CurrentTheme.Text
    window.TitleLabel.Font = Enum.Font.GothamBold
    window.TitleLabel.TextSize = 16
    window.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    window.TitleLabel.Parent = window.TitleBar

    window.SubTitleLabel = Instance.new("TextLabel")
    window.SubTitleLabel.Size = UDim2.new(1, -60, 0, 15)
    window.SubTitleLabel.Position = UDim2.new(0, 15, 0, 25)
    window.SubTitleLabel.BackgroundTransparency = 1
    window.SubTitleLabel.Text = window.Options.SubTitle
    window.SubTitleLabel.TextColor3 = RainLib.CurrentTheme.Text
    window.SubTitleLabel.Font = Enum.Font.Gotham
    window.SubTitleLabel.TextSize = 12
    window.SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    window.SubTitleLabel.Parent = window.TitleBar

    window.CloseButton = Instance.new("TextButton")
    window.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    window.CloseButton.Position = UDim2.new(1, -40, 0, 10)
    window.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    window.CloseButton.Text = "X"
    window.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.CloseButton.Font = Enum.Font.SourceSansBold
    window.CloseButton.TextSize = 16
    window.CloseButton.Parent = window.TitleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = window.CloseButton

    window.MinimizeBtn = Instance.new("TextButton")
    window.MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    window.MinimizeBtn.Position = UDim2.new(1, -75, 0, 10)
    window.MinimizeBtn.BackgroundColor3 = RainLib.CurrentTheme.Accent
    window.MinimizeBtn.Text = "-"
    window.MinimizeBtn.TextColor3 = RainLib.CurrentTheme.Text
    window.MinimizeBtn.Font = Enum.Font.SourceSansBold
    window.MinimizeBtn.TextSize = 16
    window.MinimizeBtn.Parent = window.TitleBar

    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = window.MinimizeBtn

    window.TabContainer = Instance.new("ScrollingFrame")
    window.TabContainer.Size = UDim2.new(0, 150, 1, -50)
    window.TabContainer.Position = UDim2.new(0, 0, 0, 50)
    window.TabContainer.BackgroundColor3 = RainLib.CurrentTheme.Secondary
    window.TabContainer.ScrollBarThickness = 0
    window.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    window.TabContainer.Parent = window.MainFrame

    window.TabIndicator = Instance.new("Frame")
    window.TabIndicator.Size = UDim2.new(0, 4, 0, 40)
    window.TabIndicator.BackgroundColor3 = RainLib.CurrentTheme.Accent
    window.TabIndicator.Position = UDim2.new(0, 0, 0, 5)
    window.TabIndicator.Parent = window.TabContainer

    -- Animação inicial
    tween(window.MainFrame, TweenInfo.new(0.5), { Position = window.Options.Position, BackgroundTransparency = 0 })

    MakeDraggable(window.TitleBar, window.MainFrame)

    window.CloseButton.MouseButton1Click:Connect(function()
        tween(window.MainFrame, TweenInfo.new(0.5), { Position = UDim2.new(0.5, -300, 0.5, 300), BackgroundTransparency = 1 }).Completed:Connect(function()
            window.MainFrame:Destroy()
            window.Notifications:Destroy()
        end)
    end)

    window.Minimized = false
    window.MinimizeBtn.MouseButton1Click:Connect(function()
        window.Minimized = not window.Minimized
        if window.Minimized then
            tween(window.MainFrame, TweenInfo.new(0.5), { Size = UDim2.new(0, 600, 0, 50) })
            window.MinimizeBtn.Text = "+"
            window.MainFrame.ClipsDescendants = true
            window.TabContainer.Visible = false
        else
            tween(window.MainFrame, TweenInfo.new(0.5), { Size = UDim2.new(0, 600, 0, 400) })
            window.MinimizeBtn.Text = "-"
            window.MainFrame.ClipsDescendants = false
            window.TabContainer.Visible = true
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == window.Options.MinimizeKey then
            window.MinimizeBtn:Fire("MouseButton1Click")
        end
    end)

    -- Salvar estado
    table.insert(RainLib.GUIState.Windows, { Options = window.Options, Tabs = {} })

    function window:Tab(options)
        local tab = { Elements = {} }
        options = options or {}
        tab.Name = options.Title or "Tab"
        tab.Icon = options.Icon
        tab.ElementCount = 0

        tab.Content = Instance.new("ScrollingFrame")
        tab.Content.Size = UDim2.new(1, -160, 1, -60)
        tab.Content.Position = UDim2.new(0, 155, 0, 55)
        tab.Content.BackgroundTransparency = 1
        tab.Content.ScrollBarThickness = 4
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        tab.Content.Visible = false
        tab.Content.Parent = window.MainFrame

        tab.Container = Instance.new("Frame")
        tab.Container.Size = UDim2.new(1, -10, 1, -10)
        tab.Container.Position = UDim2.new(0, 5, 0, 5)
        tab.Container.BackgroundTransparency = 1
        tab.Container.Parent = tab.Content

        tab.Button = Instance.new("TextButton")
        tab.Button.Size = UDim2.new(1, -10, 0, 40)
        tab.Button.Position = UDim2.new(0, 5, 0, #window.Tabs * 45 + 5)
        tab.Button.BackgroundColor3 = RainLib.CurrentTheme.Secondary
        tab.Button.Text = tab.Icon and "" or tab.Name
        tab.Button.TextColor3 = RainLib.CurrentTheme.Text
        tab.Button.Font = Enum.Font.SourceSansBold
        tab.Button.TextSize = 16
        tab.Button.TextXAlignment = Enum.TextXAlignment.Left
        tab.Button.Parent = window.TabContainer
        window.TabContainer.CanvasSize = UDim2.new(0, 0, 0, #window.Tabs * 45 + 50)

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = tab.Button

        if tab.Icon then
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0, 24, 0, 24)
            icon.Position = UDim2.new(0, 10, 0.5, -12)
            icon.BackgroundTransparency = 1
            icon.Image = tab.Icon
            icon.Parent = tab.Button

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, -40, 1, 0)
            text.Position = UDim2.new(0, 40, 0, 0)
            text.BackgroundTransparency = 1
            text.Text = tab.Name
            text.TextColor3 = RainLib.CurrentTheme.Text
            text.Font = Enum.Font.SourceSansBold
            text.TextSize = 16
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.Parent = tab.Button
        end

        table.insert(window.Tabs, tab)
        table.insert(RainLib.GUIState.Windows[#RainLib.GUIState.Windows].Tabs, { Name = tab.Name, Icon = tab.Icon, Elements = {} })

        local function selectTab(index)
            for i, t in pairs(window.Tabs) do
                if i == index then
                    t.Content.Visible = true
                    tween(t.Content, TweenInfo.new(0.3), { BackgroundTransparency = 1, Position = UDim2.new(0, 155, 0, 55) })
                    tween(window.TabIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { Position = UDim2.new(0, 0, 0, (i-1) * 45 + 5) })
                    tween(t.Button, TweenInfo.new(0.2), { BackgroundColor3 = RainLib.CurrentTheme.Accent })
                else
                    tween(t.Content, TweenInfo.new(0.3), { Position = UDim2.new(0, 200, 0, 55) }).Completed:Connect(function()
                        t.Content.Visible = false
                    end)
                    tween(t.Button, TweenInfo.new(0.2), { BackgroundColor3 = RainLib.CurrentTheme.Secondary })
                end
            end
        end

        tab.Button.MouseButton1Click:Connect(function()
            selectTab(table.find(window.Tabs, tab))
        end)
        tab.Button.MouseEnter:Connect(function()
            if not tab.Content.Visible then
                tween(tab.Button, TweenInfo.new(0.2), { BackgroundColor3 = RainLib.CurrentTheme.Secondary:Lerp(RainLib.CurrentTheme.Accent, 0.3) })
            end
        end)
        tab.Button.MouseLeave:Connect(function()
            if not tab.Content.Visible then
                tween(tab.Button, TweenInfo.new(0.2), { BackgroundColor3 = RainLib.CurrentTheme.Secondary })
            end
        end)

        if #window.Tabs == 1 then
            selectTab(1)
        end

        local function getNextPosition(size)
            local padding = 10
            local yOffset = padding + tab.ElementCount * (size.Y.Offset + padding)
            tab.ElementCount = tab.ElementCount + 1
            tab.Content.CanvasSize = UDim2.new(0, 0, 0, yOffset + size.Y.Offset + padding)
            return UDim2.new(0, padding, 0, yOffset)
        end

        local function createContainer(element, size)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(0, size.X.Offset + 20, 0, size.Y.Offset + 20)
            container.Position = getNextPosition(size)
            container.BackgroundTransparency = 1
            container.Parent = tab.Container
            element.Parent = container
            element.Position = UDim2.new(0, 10, 0, 10)
            return container
        end

        function tab:AddToggle(key, options)
            options = options or {}
            local toggleSize = UDim2.new(0, 120, 0, 40)
            local toggle = { Value = options.Default or false }
            local frame = Instance.new("Frame")
            frame.Size = toggleSize
            frame.BackgroundColor3 = RainLib.CurrentTheme.Secondary

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 80, 1, 0)
            label.Text = options.Title or "Toggle"
            label.BackgroundTransparency = 1
            label.TextColor3 = RainLib.CurrentTheme.Text
            label.Font = Enum.Font.SourceSans
            label.TextSize = 16
            label.Parent = frame

            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 20, 0, 20)
            indicator.Position = UDim2.new(1, -30, 0.5, -10)
            indicator.BackgroundColor3 = toggle.Value and RainLib.CurrentTheme.Accent or RainLib.CurrentTheme.Disabled
            indicator.Parent = frame

            local indicatorCorner = Instance.new("UICorner")
            indicatorCorner.CornerRadius = UDim.new(0, 10)
            indicatorCorner.Parent = indicator

            if options.Flag and window.Options.SaveSettings then
                local settings = RainLib:LoadSettings(window.Options.ConfigFolder)
                if settings and settings.Flags[options.Flag] ~= nil then
                    toggle.Value = settings.Flags[options.Flag]
                    indicator.BackgroundColor3 = toggle.Value and RainLib.CurrentTheme.Accent or RainLib.CurrentTheme.Disabled
                end
            end

            createContainer(frame, toggleSize)
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    toggle.Value = not toggle.Value
                    tween(indicator, TweenInfo.new(0.2), {
                        BackgroundColor3 = toggle.Value and RainLib.CurrentTheme.Accent or RainLib.CurrentTheme.Disabled,
                        Size = UDim2.new(0, toggle.Value and 24 or 20, 0, toggle.Value and 24 or 20),
                        Position = UDim2.new(1, toggle.Value and -34 or -30, 0.5, toggle.Value and -12 or -10)
                    })
                    if options.Callback then
                        options.Callback(toggle.Value)
                    end
                    if options.Flag and window.Options.SaveSettings then
                        local settings = RainLib:LoadSettings(window.Options.ConfigFolder) or { Flags = {} }
                        settings.Flags[options.Flag] = toggle.Value
                        RainLib:SaveSettings(window.Options.ConfigFolder, settings)
                    end
                end
            end)

            table.insert(RainLib.GUIState.Windows[#RainLib.GUIState.Windows].Tabs[#RainLib.GUIState.Windows[#RainLib.GUIState.Windows].Tabs].Elements, {
                Type = "Toggle", Key = key, Options = options
            })

            return toggle
        end

        function tab:AddSlider(key, options)
            options = options or {}
            local sliderSize = UDim2.new(0, 120, 0, 40)
            local slider = { Value = options.Default or options.Min or 0 }
            local frame = Instance.new("Frame")
            frame.Size = sliderSize
            frame.BackgroundColor3 = RainLib.CurrentTheme.Secondary

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 80, 0, 20)
            label.Text = options.Title or "Slider"
            label.BackgroundTransparency = 1
            label.TextColor3 = RainLib.CurrentTheme.Text
            label.Font = Enum.Font.SourceSans
            label.TextSize = 12
            label.Parent = frame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 30, 0, 20)
            valueLabel.Position = UDim2.new(1, -35, 0, 0)
            valueLabel.Text = tostring(slider.Value)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextColor3 = RainLib.CurrentTheme.Text
            valueLabel.Font = Enum.Font.SourceSans
            valueLabel.TextSize = 12
            valueLabel.Parent = frame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -10, 0, 8)
            bar.Position = UDim2.new(0, 5, 0, 25)
            bar.BackgroundColor3 = RainLib.CurrentTheme.Disabled
            bar.Parent = frame

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((slider.Value - (options.Min or 0)) / ((options.Max or 100) - (options.Min or 0)), 0, 1, 0)
            fill.BackgroundColor3 = RainLib.CurrentTheme.Accent
            fill.Parent = bar

            local cornerBar = Instance.new("UICorner")
            cornerBar.CornerRadius = UDim.new(0, 4)
            cornerBar.Parent = bar

            local cornerFill = Instance.new("UICorner")
            cornerFill.CornerRadius = UDim.new(0, 4)
            cornerFill.Parent = fill

            if options.Flag and window.Options.SaveSettings then
                local settings = RainLib:LoadSettings(window.Options.ConfigFolder)
                if settings and settings.Flags[options.Flag] ~= nil then
                    slider.Value = settings.Flags[options.Flag]
                    fill.Size = UDim2.new((slider.Value - (options.Min or 0)) / ((options.Max or 100) - (options.Min or 0)), 0, 1, 0)
                    valueLabel.Text = tostring(slider.Value)
                end
            end

            createContainer(frame, sliderSize)
            local dragging
            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    tween(bar, TweenInfo.new(0.2), { BackgroundColor3 = RainLib.CurrentTheme.Disabled:Lerp(RainLib.CurrentTheme.Accent, 0.2) })
                end
            end)
            bar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    tween(bar, TweenInfo.new(0.2), { BackgroundColor3 = RainLib.CurrentTheme.Disabled })
                end
            end)
            RunService.RenderStepped:Connect(function()
                if dragging then
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativeX = math.clamp((mousePos.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    slider.Value = math.floor((options.Min or 0) + relativeX * ((options.Max or 100) - (options.Min or 0)))
                    if options.Rounding then
                        slider.Value = math.floor(slider.Value / options.Rounding) * options.Rounding
                    end
                    tween(fill, TweenInfo.new(0.1), { Size = UDim2.new(relativeX, 0, 1, 0) })
                    valueLabel.Text = tostring(slider.Value)
                    if options.Callback then
                        options.Callback(slider.Value)
                    end
                    if options.Flag and window.Options.SaveSettings then
                        local settings = RainLib:LoadSettings(window.Options.ConfigFolder) or { Flags = {} }
                        settings.Flags[options.Flag] = slider.Value
                        RainLib:SaveSettings(window.Options.ConfigFolder, settings)
                    end
                end
            end)

            table.insert(RainLib.GUIState.Windows[#RainLib.GUIState.Windows].Tabs[#RainLib.GUIState.Windows[#RainLib.GUIState.Windows].Tabs].Elements, {
                Type = "Slider", Key = key, Options = options
            })

            return slider
        end

        function tab:AddButton(options)
            options = options or {}
            local buttonSize = UDim2.new(0, 120, 0, 40)
            local button = Instance.new("TextButton")
            button.Size = buttonSize
            button.Text = options.Title or "Button"
            button.BackgroundColor3 = RainLib.CurrentTheme.Accent
            button.TextColor3 = RainLib.CurrentTheme.Text
            button.Font = Enum.Font.SourceSansBold
            button.TextSize = 16

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = button

            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 1
            stroke.Color = RainLib.CurrentTheme.Accent:Lerp(Color3.fromRGB(0, 0, 0), 0.2)
            stroke.Parent = button

            createContainer(button, buttonSize)
            button.MouseButton1Click:Connect(options.Callback or function() end)
            button.MouseEnter:Connect(function()
                tween(button, TweenInfo.new(0.2), { BackgroundColor3 = RainLib.CurrentTheme.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.2) })
            end)
            button.MouseLeave:Connect(function()
                tween(button, TweenInfo.new(0.2), { BackgroundColor3 = RainLib.CurrentTheme.Accent })
            end)

            table.insert(RainLib.GUIState.Windows[#RainLib.GUIState.Windows].Tabs[#RainLib.GUIState.Windows[#RainLib.GUIState.Windows].Tabs].Elements, {
                Type = "Button", Key = options.Title, Options = options
            })

            return button
        end

        -- Adicione outros elementos (Dropdown, Keybind, etc.) conforme necessário

        return tab
    end

    return window
end

-- Função para recriar GUI
function RainLib:RecreateGUI()
    if RainLib.ScreenGui then
        RainLib.ScreenGui:Destroy()
        RainLib.ScreenGui = Instance.new("ScreenGui")
        RainLib.ScreenGui.Name = "RainLib"
        RainLib.ScreenGui.Parent = game.CoreGui or LocalPlayer:WaitForChild("PlayerGui", 5)
        RainLib.ScreenGui.ResetOnSpawn = false
        RainLib.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    end

    for _, windowState in ipairs(RainLib.GUIState.Windows) do
        local window = RainLib:Window(windowState.Options)
        for _, tabState in ipairs(windowState.Tabs) do
            local tab = window:Tab({ Title = tabState.Name, Icon = tabState.Icon })
            for _, elementState in ipairs(tabState.Elements) do
                if elementState.Type == "Toggle" then
                    tab:AddToggle(elementState.Key, elementState.Options)
                elseif elementState.Type == "Slider" then
                    tab:AddSlider(elementState.Key, elementState.Options)
                elseif elementState.Type == "Button" then
                    tab:AddButton(elementState.Options)
                end
            end
        end
    end
end

-- Função para destruir
function RainLib:Destroy()
    if RainLib.ScreenGui then
        tween(RainLib.ScreenGui, TweenInfo.new(0.5), { BackgroundTransparency = 1 }).Completed:Connect(function()
            RainLib.ScreenGui:Destroy()
        end)
    end
end

print("[RainLib] Biblioteca carregada!")
return RainLib

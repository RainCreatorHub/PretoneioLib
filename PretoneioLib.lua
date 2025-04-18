-- ModuleScript: PretoneioLib
local PretoneioLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Configuração inicial com mais opções
PretoneioLib.Defaults = {
    Theme = {
        BackgroundColor = Color3.fromRGB(30, 30, 30),
        HeaderColor = Color3.fromRGB(40, 40, 40),
        TextColor = Color3.fromRGB(255, 255, 255),
        ButtonColor = Color3.fromRGB(50, 50, 50),
        ButtonHoverColor = Color3.fromRGB(70, 70, 70),
        SelectedTabColor = Color3.fromRGB(60, 60, 60),
        AccentColor = Color3.fromRGB(0, 120, 255),
        BorderColor = Color3.fromRGB(20, 20, 20),
    },
    Font = Enum.Font.SourceSansPro,
    TextSize = {
        Title = 22,
        Subtitle = 16,
        Button = 18,
        Label = 14,
    },
    Animation = {
        Speed = 0.2,
        EasingStyle = Enum.EasingStyle.Quad,
    },
    Sizes = {
        Window = { Width = 500, Height = 350 },
        Header = 60,
        TabButton = 120,
        ElementPadding = 10,
    }
}

-- Função auxiliar para animações
local function createTween(instance, properties, duration)
    return TweenService:Create(
        instance,
        TweenInfo.new(
            duration or PretoneioLib.Defaults.Animation.Speed,
            PretoneioLib.Defaults.Animation.EasingStyle
        ),
        properties
    )
end

-- Função para criar uma nova janela
function PretoneioLib:Window(config)
    config = config or {}
    local title = config.Title or "Pretoneio UI"
    local subtitle = config.SubTitle or ""
    local minimizable = config.Minimizable ~= false
    local draggable = config.Draggable ~= false

    -- Criar elementos principais
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Header = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local SubTitleLabel = Instance.new("TextLabel")
    local MinimizeButton = Instance.new("TextButton")
    local TabButtons = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local TabContents = Instance.new("Frame")
    
    -- Configurações do ScreenGui
    ScreenGui.Name = "PretoneioLibUI_" .. title
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Configuração da janela principal
    MainFrame.Name = "Window"
    MainFrame.Size = UDim2.new(0, self.Defaults.Sizes.Window.Width, 0, self.Defaults.Sizes.Window.Height)
    MainFrame.Position = UDim2.new(0.5, -self.Defaults.Sizes.Window.Width/2, 0.5, -self.Defaults.Sizes.Window.Height/2)
    MainFrame.BackgroundColor3 = self.Defaults.Theme.BackgroundColor
    MainFrame.BorderColor3 = self.Defaults.Theme.BorderColor
    MainFrame.Parent = ScreenGui

    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- Configuração do cabeçalho
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, self.Defaults.Sizes.Header)
    Header.BackgroundColor3 = self.Defaults.Theme.HeaderColor
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    -- Configuração do título
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(0.7, 0, 0, 30)
    TitleLabel.Position = UDim2.new(0, 15, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = self.Defaults.Theme.TextColor
    TitleLabel.Font = self.Defaults.Font
    TitleLabel.TextSize = self.Defaults.TextSize.Title
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    -- Configuração do subtítulo
    SubTitleLabel.Name = "SubTitleLabel"
    SubTitleLabel.Size = UDim2.new(0.7, 0, 0, 20)
    SubTitleLabel.Position = UDim2.new(0, 15, 0, 35)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = subtitle
    SubTitleLabel.TextColor3 = self.Defaults.Theme.TextColor
    SubTitleLabel.Font = self.Defaults.Font
    SubTitleLabel.TextSize = self.Defaults.TextSize.Subtitle
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = Header

    -- Botão de minimizar
    if minimizable then
        MinimizeButton.Name = "MinimizeButton"
        MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
        MinimizeButton.Position = UDim2.new(1, -40, 0, 15)
        MinimizeButton.BackgroundColor3 = self.Defaults.Theme.ButtonColor
        MinimizeButton.Text = "-"
        MinimizeButton.TextColor3 = self.Defaults.Theme.TextColor
        MinimizeButton.Font = self.Defaults.Font
        MinimizeButton.TextSize = self.Defaults.TextSize.Button
        MinimizeButton.Parent = Header

        local UICornerMinimize = Instance.new("UICorner")
        UICornerMinimize.CornerRadius = UDim.new(0, 4)
        UICornerMinimize.Parent = MinimizeButton
    end

    -- Configuração de botões das abas
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 0, 40)
    TabButtons.Position = UDim2.new(0, 0, 0, self.Defaults.Sizes.Header)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = MainFrame

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabButtons

    -- Configuração do conteúdo das abas
    TabContents.Name = "TabContents"
    TabContents.Size = UDim2.new(1, -20, 1, -(self.Defaults.Sizes.Header + 40 + 10))
    TabContents.Position = UDim2.new(0, 10, 0, self.Defaults.Sizes.Header + 40 + 10)
    TabContents.BackgroundTransparency = 1
    TabContents.Parent = MainFrame

    -- Funcionalidade de arrastar
    if draggable then
        local dragging, dragInput, dragStart, startPos
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        Header.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- Estrutura da janela
    local window = {
        Frame = MainFrame,
        Tabs = {},
        TabButtons = TabButtons,
        TabContents = TabContents,
        Visible = true,
        Minimized = false,
    }

    -- Função de minimizar/maximizar
    if minimizable then
        MinimizeButton.MouseButton1Click:Connect(function()
            window.Minimized = not window.Minimized
            local targetSize = window.Minimized and 
                UDim2.new(0, self.Defaults.Sizes.Window.Width, 0, self.Defaults.Sizes.Header) or 
                UDim2.new(0, self.Defaults.Sizes.Window.Width, 0, self.Defaults.Sizes.Window.Height)
            
            createTween(MainFrame, {Size = targetSize}):Play()
            MinimizeButton.Text = window.Minimized and "+" or "-"
            TabButtons.Visible = not window.Minimized
            TabContents.Visible = not window.Minimized
        end)
    end

    -- Método para criar abas
    function window:Tab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local TabButton = Instance.new("TextButton")
        local TabContent = Instance.new("Frame")
        local ContentListLayout = Instance.new("UIListLayout")

        -- Configuração do botão da aba
        TabButton.Size = UDim2.new(0, self.Defaults.Sizes.TabButton, 1, 0)
        TabButton.BackgroundColor3 = self.Defaults.Theme.ButtonColor
        TabButton.Text = tabName
        TabButton.TextColor3 = self.Defaults.Theme.TextColor
        TabButton.Font = self.Defaults.Font
        TabButton.TextSize = self.Defaults.TextSize.Button
        TabButton.Parent = TabButtons

        local UICornerTab = Instance.new("UICorner")
        UICornerTab.CornerRadius = UDim.new(0, 4)
        UICornerTab.Parent = TabButton

        -- Efeito de hover
        TabButton.MouseEnter:Connect(function()
            if TabContent.Visible == false then
                createTween(TabButton, {BackgroundColor3 = self.Defaults.Theme.ButtonHoverColor}):Play()
            end
        end)
        TabButton.MouseLeave:Connect(function()
            if TabContent.Visible == false then
                createTween(TabButton, {BackgroundColor3 = self.Defaults.Theme.ButtonColor}):Play()
            end
        end)

        -- Configuração do conteúdo da aba
        TabContent.Name = tabName
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = TabContents

        ContentListLayout.FillDirection = Enum.FillDirection.Vertical
        ContentListLayout.Padding = UDim.new(0, self.Defaults.Sizes.ElementPadding)
        ContentListLayout.Parent = TabContent

        -- Adicionar comportamento ao botão
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(window.Tabs) do
                tab.Content.Visible = false
                createTween(tab.Button, {BackgroundColor3 = self.Defaults.Theme.ButtonColor}):Play()
            end
            TabContent.Visible = true
            createTween(TabButton, {BackgroundColor3 = self.Defaults.Theme.SelectedTabColor}):Play()
        end)

        -- Adicionar aba à lista de abas
        table.insert(window.Tabs, { Button = TabButton, Content = TabContent })

        -- Métodos da aba
        return {
            AddButton = function(self, buttonConfig)
                return PretoneioLib:CreateButton(TabContent, buttonConfig)
            end,
            AddLabel = function(self, labelConfig)
                return PretoneioLib:CreateLabel(TabContent, labelConfig)
            end,
            AddToggle = function(self, toggleConfig)
                return PretoneioLib:CreateToggle(TabContent, toggleConfig)
            end
        }
    end

    -- Método para destruir a janela
    function window:Destroy()
        ScreenGui:Destroy()
    end

    -- Ativar primeira aba por padrão
    if #window.Tabs > 0 then
        window.Tabs[1].Button:SimulateClick()
    end

    return window
end

-- Função para criar botão
function PretoneioLib:CreateButton(parent, config)
    config = config or {}
    local text = config.Text or "Button"
    local callback = config.Callback

    local Button = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = self.Defaults.Theme.ButtonColor
    Button.Text = text
    Button.TextColor3 = self.Defaults.Theme.TextColor
    Button.Font = self.Defaults.Font
    Button.TextSize = self.Defaults.TextSize.Button
    Button.Parent = parent

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Button

    -- Efeitos de interação
    Button.MouseEnter:Connect(function()
        createTween(Button, {BackgroundColor3 = self.Defaults.Theme.ButtonHoverColor}):Play()
    end)
    Button.MouseLeave:Connect(function()
        createTween(Button, {BackgroundColor3 = self.Defaults.Theme.ButtonColor}):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return Button
end

-- Função para criar label
function PretoneioLib:CreateLabel(parent, config)
    config = config or {}
    local text = config.Text or "Label"

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = self.Defaults.Theme.TextColor
    Label.Font = self.Defaults.Font
    Label.TextSize = self.Defaults.TextSize.Label
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent

    return Label
end

-- Função para criar toggle
function PretoneioLib:CreateToggle(parent, config)
    config = config or {}
    local text = config.Text or "Toggle"
    local callback = config.Callback
    local default = config.Default or false

    local ToggleFrame = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local ToggleButton = Instance.new("TextButton")
    local UICornerFrame = Instance.new("UICorner")
    local UICornerButton = Instance.new("UICorner")

    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    Label.Size = UDim2.new(0.8, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = self.Defaults.Theme.TextColor
    Label.Font = self.Defaults.Font
    Label.TextSize = self.Defaults.TextSize.Button
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    ToggleButton.Size = UDim2.new(0, 50, 0, 30)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -15)
    ToggleButton.BackgroundColor3 = default and self.Defaults.Theme.AccentColor or self.Defaults.Theme.ButtonColor
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame

    UICornerFrame.CornerRadius = UDim.new(0, 4)
    UICornerFrame.Parent = ToggleFrame
    UICornerButton.CornerRadius = UDim.new(0, 4)
    UICornerButton.Parent = ToggleButton

    local state = default
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        createTween(
            ToggleButton,
            {BackgroundColor3 = state and self.Defaults.Theme.AccentColor or self.Defaults.Theme.ButtonColor}
        ):Play()
        if callback then
            callback(state)
        end
    end)

    return {
        Frame = ToggleFrame,
        SetState = function(self, newState)
            state = newState
            createTween(
                ToggleButton,
                {BackgroundColor3 = state and self.Defaults.Theme.AccentColor or self.Defaults.Theme.ButtonColor}
            ):Play()
        end,
        GetState = function(self)
            return state
        end
    }
end

return PretoneioLib

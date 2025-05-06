local PretoneioLib = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Temas disponíveis para a interface
local Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        Tab = Color3.fromRGB(40, 40, 40),
        Button = Color3.fromRGB(50, 50, 50),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Tab = Color3.fromRGB(220, 220, 220),
        Button = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(0, 0, 0)
    },
    Blue = {
        Background = Color3.fromRGB(20, 20, 40),
        Tab = Color3.fromRGB(40, 60, 100),
        Button = Color3.fromRGB(60, 80, 140),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- Função para criar uma janela
function PretoneioLib:MakeWindow(config)
    local theme = Themes[(config.Theme or "Dark"):lower():gsub("^%l", string.upper)] or Themes.Dark

    -- Criação do ScreenGui
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "PretoneioLib"
    gui.ResetOnSpawn = false

    -- Tela de introdução (se ativada)
    if config.Intro then
        local introFrame = Instance.new("Frame", gui)
        introFrame.Size = UDim2.new(1, 0, 1, 0)
        introFrame.BackgroundColor3 = theme.Background
        introFrame.BackgroundTransparency = 1

        local introText = Instance.new("TextLabel", introFrame)
        introText.Size = UDim2.new(0, 200, 0, 50)
        introText.Position = UDim2.new(0.5, -100, 0.5, -25)
        introText.BackgroundTransparency = 1
        introText.Text = config.IntroText or "Carregando..."
        introText.TextColor3 = theme.Text
        introText.Font = Enum.Font.GothamBold
        introText.TextSize = 24
        introText.TextTransparency = 1

        -- Animação de fade-in e fade-out
        local introDuration = config.IntroDuration or 3
        local tweenInfo = TweenInfo.new(introDuration / 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        
        -- Fade-in
        TweenService:Create(introFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
        TweenService:Create(introText, tweenInfo, {TextTransparency = 0}):Play()
        
        -- Espera
        wait(introDuration / 3)
        
        -- Fade-out
        TweenService:Create(introFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(introText, tweenInfo, {TextTransparency = 1}):Play()
        
        -- Remove a tela de introdução após a animação
        wait(introDuration / 3)
        introFrame:Destroy()
    end

    -- Frame principal
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 420, 0, 300)
    main.Position = UDim2.new(0.3, 0, 0.3, 0)
    main.BackgroundColor3 = theme.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    -- Título da janela
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = tostring(config.Title or "Janela")
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18

    -- Subtítulo
    local subtitle = Instance.new("TextLabel", main)
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = tostring(config.SubTitle or "")
    subtitle.TextColor3 = theme.Text
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14

    -- Container das abas
    local tabsFrame = Instance.new("Frame", main)
    tabsFrame.Position = UDim2.new(0, 0, 0, 55)
    tabsFrame.Size = UDim2.new(1, 0, 0, 30)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.LayoutOrder = 1

    -- Frame de conteúdo
    local contentFrame = Instance.new("Frame", main)
    contentFrame.Position = UDim2.new(0, 0, 0, 90)
    contentFrame.Size = UDim2.new(1, 0, 1, -90)
    contentFrame.BackgroundTransparency = 1

    -- Botão de minimizar
    local minimize = Instance.new("TextButton", main)
    minimize.Size = UDim2.new(0, 30, 0, 30)
    minimize.Position = UDim2.new(1, -35, 0, 5)
    minimize.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    minimize.Text = "-"
    minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
    minimize.Font = Enum.Font.GothamBold
    minimize.TextSize = 20
    Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

    local minimized = false
    local originalSize = main.Size
    local minimizedSize = UDim2.new(0, 420, 0, 50)

    -- Função para minimizar/maximizar a janela
    minimize.MouseButton1Click:Connect(function()
        if minimized then
            TweenService:Create(main, TweenInfo.new(0.3), {Size = originalSize}):Play()
            for _, v in pairs(main:GetChildren()) do
                if v:IsA("GuiObject") and v ~= minimize then
                    v.Visible = true
                end
            end
            minimize.Text = "-"
        else
            TweenService:Create(main, TweenInfo.new(0.3), {Size = minimizedSize}):Play()
            for _, v in pairs(main:GetChildren()) do
                if v:IsA("GuiObject") and v ~= minimize and v ~= title and v ~= subtitle then
                    v.Visible = false
                end
            end
            minimize.Text = "+"
        end
        minimized = not minimized
    end)

    -- Botão de fechar
    local deleteButton = Instance.new("TextButton", main)
    deleteButton.Size = UDim2.new(0, 30, 0, 30)
    deleteButton.Position = UDim2.new(1, -70, 0, 5)
    deleteButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    deleteButton.Text = "X"
    deleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    deleteButton.Font = Enum.Font.GothamBold
    deleteButton.TextSize = 20
    Instance.new("UICorner", deleteButton).CornerRadius = UDim.new(1, 0)

    -- Função para fechar a janela
    deleteButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Variáveis para controle de abas
    local currentTab
    local window = {}

    -- Função para criar uma aba
    function window:MakeTab(tabInfo)
        local tabButton = Instance.new("TextButton", tabsFrame)
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = theme.Tab
        tabButton.Text = tabInfo[1] or "Aba"
        tabButton.TextColor3 = theme.Text
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)

        local tabContent = Instance.new("Frame", contentFrame)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false

        local layout = Instance.new("UIListLayout", tabContent)
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then currentTab.Visible = false end
            tabContent.Visible = true
            currentTab = tabContent
        end)

        local tab = {}

        -- Função para adicionar um botão na aba
        function tab:AddButton(btnInfo)
            local button = Instance.new("TextButton", tabContent)
            button.Size = UDim2.new(1, -12, 0, 30)
            button.BackgroundColor3 = theme.Button
            button.TextColor3 = theme.Text
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.Text = btnInfo[1] or "Botão"
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

            button.MouseButton1Click:Connect(function()
                if btnInfo.Callback then
                    btnInfo.Callback()
                end
            end)
        end

        -- Função para adicionar uma seção na aba
        function tab:AddSection(sectionInfo)
            local sectionContainer = Instance.new("Frame", tabContent)
            sectionContainer.Size = UDim2.new(1, 0, 0, 30)
            sectionContainer.BackgroundTransparency = 1
            sectionContainer.LayoutOrder = 1

            local sectionTitle = Instance.new("TextLabel", sectionContainer)
            sectionTitle.Size = UDim2.new(1, 0, 0, 20)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = sectionInfo[1] or "Seção"
            sectionTitle.TextColor3 = theme.Text
            sectionTitle.Font = Enum.Font.Gotham
            sectionTitle.TextSize = 14

            return sectionContainer
        end

        return tab
    end

    return window
end

return PretoneioLib

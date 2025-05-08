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
        Text = Color3.fromRGB(255, 255, 255),
        GradientStart = Color3.fromRGB(50, 50, 50), -- Gradiente inicial
        GradientEnd = Color3.fromRGB(20, 20, 20)    -- Gradiente final
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Tab = Color3.fromRGB(220, 220, 220),
        Button = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(0, 0, 0),
        GradientStart = Color3.fromRGB(255, 255, 255),
        GradientEnd = Color3.fromRGB(200, 200, 200)
    },
    Blue = {
        Background = Color3.fromRGB(20, 20, 40),
        Tab = Color3.fromRGB(40, 60, 100),
        Button = Color3.fromRGB(60, 80, 140),
        Text = Color3.fromRGB(255, 255, 255),
        GradientStart = Color3.fromRGB(40, 60, 120),
        GradientEnd = Color3.fromRGB(20, 30, 60)
    }
}

-- Função para criar um gradiente
local function ApplyGradient(instance, startColor, endColor)
    local gradient = Instance.new("UIGradient", instance)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, startColor),
        ColorSequenceKeypoint.new(1, endColor)
    })
    gradient.Rotation = 45 -- Gradiente diagonal para um visual mais dinâmico
    return gradient
end

-- Função para criar uma partícula simulada
local function CreateParticle(parent, theme)
    local particle = Instance.new("Frame", parent)
    particle.Size = UDim2.new(0, 8, 0, 8)
    particle.BackgroundTransparency = 1
    particle.Position = UDim2.new(0.5, math.random(-50, 50), 0.5, math.random(-50, 50))
    particle.ZIndex = 2

    local particleInner = Instance.new("Frame", particle)
    particleInner.Size = UDim2.new(1, 0, 1, 0)
    particleInner.BackgroundColor3 = theme.Text
    ApplyGradient(particleInner, theme.Text, Color3.fromRGB(255, 255, 255))
    Instance.new("UICorner", particleInner).CornerRadius = UDim.new(1, 0)

    -- Animação da partícula
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local moveTween = TweenService:Create(particle, tweenInfo, {
        Position = UDim2.new(0.5, math.random(-100, 100), 0.5, math.random(-100, 100)),
        BackgroundTransparency = 1
    })
    moveTween:Play()
    moveTween.Completed:Connect(function()
        particle:Destroy()
    end)
end

-- Função para criar uma janela
function PretoneioLib:MakeWindow(config)
    local theme = Themes[(config.Theme or "Dark"):lower():gsub("^%l", string.upper)] or Themes.Dark

    -- Remove qualquer ScreenGui existente com o mesmo nome para garantir prioridade
    local existingGui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("PretoneioLib")
    if existingGui then
        existingGui:Destroy()
    end

    -- Criação do ScreenGui
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "PretoneioLib"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Tela de introdução (se ativada)
    if config.Intro then
        local introFrame = Instance.new("Frame", gui)
        introFrame.Size = UDim2.new(1, 0, 1, 0)
        introFrame.BackgroundColor3 = theme.Background
        introFrame.BackgroundTransparency = 1
        local gradient = ApplyGradient(introFrame, theme.GradientStart, theme.GradientEnd)

        local introText = Instance.new("TextLabel", introFrame)
        introText.Size = UDim2.new(0, 0, 0, 0) -- Começa pequena para animação de escala
        introText.Position = UDim2.new(0.5, 0, 0.5, 0)
        introText.AnchorPoint = Vector2.new(0.5, 0.5)
        introText.BackgroundTransparency = 1
        introText.Text = config.IntroText or "Carregando..."
        introText.TextColor3 = theme.Text
        introText.Font = Enum.Font.GothamBold
        introText.TextSize = 24
        introText.TextTransparency = 1

        -- Adiciona sombra ao texto de introdução
        local shadow = Instance.new("UIStroke", introText)
        shadow.Thickness = 3
        shadow.Color = Color3.fromRGB(0, 0, 0)
        shadow.Transparency = 0.4

        -- Animação de fade-in, escala e gradiente dinâmico
        local introDuration = config.IntroDuration or 3
        local tweenInfoFade = TweenInfo.new(introDuration / 3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local tweenInfoScale = TweenInfo.new(introDuration / 3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

        -- Fade-in e escala do texto
        TweenService:Create(introFrame, tweenInfoFade, {BackgroundTransparency = 0}):Play()
        TweenService:Create(introText, tweenInfoFade, {TextTransparency = 0}):Play()
        TweenService:Create(introText, tweenInfoScale, {Size = UDim2.new(0, 200, 0, 50)}):Play()

        -- Animação do gradiente (mudança de cor)
        local gradientTween = TweenService:Create(gradient, TweenInfo.new(introDuration / 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, theme.GradientEnd),
                ColorSequenceKeypoint.new(1, theme.GradientStart)
            })
        })
        gradientTween:Play()

        -- Adiciona partículas a cada 0.2 segundos
        for i = 1, math.floor(introDuration / 0.2) do
            CreateParticle(introFrame, theme)
            wait(0.2)
        end

        -- Fade-out
        TweenService:Create(introFrame, tweenInfoFade, {BackgroundTransparency = 1}):Play()
        TweenService:Create(introText, tweenInfoFade, {TextTransparency = 1}):Play()
        
        -- Remove a tela de introdução após a animação
        wait(introDuration / 3)
        introFrame:Destroy()
    end

    -- Frame principal
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 420, 0, 300)
    main.Position = UDim2.new(0.3, 0, 0.3, 0)
    main.BackgroundColor3 = theme.Background
    main.BackgroundTransparency = 1 -- Começa invisível para fade-in
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true

    -- Adiciona gradiente ao fundo principal
    ApplyGradient(main, theme.GradientStart, theme.GradientEnd)

    -- Adiciona borda suave com UIStroke
    local stroke = Instance.new("UIStroke", main)
    stroke.Thickness = 2
    stroke.Color = theme.Text
    stroke.Transparency = 0.8

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    -- Título da janela
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = tostring(config.Title or "Janela")
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextStrokeTransparency = 0.8
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    -- Subtítulo
    local subtitle = Instance.new("TextLabel", main)
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = tostring(config.SubTitle or "")
    subtitle.TextColor3 = theme.Text
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextStrokeTransparency = 0.8
    subtitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

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
    ApplyGradient(minimize, Color3.fromRGB(255, 200, 0), Color3.fromRGB(200, 150, 0))
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
    ApplyGradient(deleteButton, Color3.fromRGB(255, 50, 50), Color3.fromRGB(200, 0, 0))
    Instance.new("UICorner", deleteButton).CornerRadius = UDim.new(1, 0)

    -- Função para fechar a janela
    deleteButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Fade-in do frame principal
    TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()

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
        ApplyGradient(tabButton, theme.GradientStart, theme.GradientEnd)
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
        local layoutOrder = 0 -- Variável local para controle da ordem dentro da aba

        -- Função para adicionar um botão na aba
        function tab:AddButton(btnInfo)
            layoutOrder = layoutOrder + 1 -- Incrementa a ordem
            local button = Instance.new("TextButton", tabContent)
            button.Size = UDim2.new(1, -12, 0, 30)
            button.BackgroundColor3 = theme.Button
            button.TextColor3 = theme.Text
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.Text = btnInfo[1] or "Botão"
            button.LayoutOrder = layoutOrder -- Define a ordem
            ApplyGradient(button, theme.GradientStart, theme.GradientEnd)
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

            -- Adiciona borda ao botão
            local buttonStroke = Instance.new("UIStroke", button)
            buttonStroke.Thickness = 1
            buttonStroke.Color = theme.Text
            buttonStroke.Transparency = 0.7

            button.MouseButton1Click:Connect(function()
                if btnInfo.Callback then
                    btnInfo.Callback()
                end
            end)
        end

        -- Função para adicionar uma seção na aba
        function tab:AddSection(sectionInfo)
            layoutOrder = layoutOrder + 1 -- Incrementa a ordem
            local sectionContainer = Instance.new("Frame", tabContent)
            sectionContainer.Size = UDim2.new(1, 0, 0, 30)
            sectionContainer.BackgroundTransparency = 1
            sectionContainer.LayoutOrder = layoutOrder -- Define a ordem

            local sectionTitle = Instance.new("TextLabel", sectionContainer)
            sectionTitle.Size = UDim2.new(1, 0, 0, 20)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = sectionInfo[1] or "Seção"
            sectionTitle.TextColor3 = theme.Text
            sectionTitle.Font = Enum.Font.Gotham
            sectionTitle.TextSize = 14
            sectionTitle.TextStrokeTransparency = 0.8
            sectionTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

            return sectionContainer
        end

        return tab
    end

    return window
end

return PretoneioLib

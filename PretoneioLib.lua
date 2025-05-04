local PretoneioLib = {}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

function PretoneioLib:MakeWindow(data)
    local gui = Instance.new("ScreenGui")
    gui.Name = "PretoneioUI"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Janela principal com bordas arredondadas
    local main = Instance.new("Frame")
    main.Name = tostring(data.Name)
    main.Size = UDim2.new(0, 400, 0, 300)
    main.Position = UDim2.new(0.3, 0, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.BackgroundTransparency = 0.1
    main.Parent = gui

    -- Bordas arredondadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main

    -- Título
    local title = Instance.new("TextLabel")
    title.Text = tostring(data.Title)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(0, 0, 40)  -- Azul escuro
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = main

    -- Subtítulo
    local subTitle = Instance.new("TextLabel")
    subTitle.Text = tostring(data.SubTitle)
    subTitle.Size = UDim2.new(1, 0, 0, 20)
    subTitle.Position = UDim2.new(0, 0, 0, 30)
    subTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 30)  -- Azul mais claro
    subTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    subTitle.Font = Enum.Font.SourceSans
    subTitle.TextSize = 14
    subTitle.Parent = main

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
        introLabel.ZIndex = 10
        introLabel.Parent = main

        task.delay(data.IntroDuration or 3, function()
            introLabel:Destroy()
        end)
    end

    -- Contêiner para as abas
    local tabHolder = Instance.new("Frame")
    tabHolder.Size = UDim2.new(1, 0, 0, 40)
    tabHolder.Position = UDim2.new(0, 0, 0, 50)
    tabHolder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)  -- Fundo preto para abas
    tabHolder.BorderSizePixel = 0
    tabHolder.Parent = main

    -- Conteúdo da janela
    local contentHolder = Instance.new("Frame")
    contentHolder.Size = UDim2.new(1, 0, 1, -90)
    contentHolder.Position = UDim2.new(0, 0, 0, 90)
    contentHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    contentHolder.BorderSizePixel = 0
    contentHolder.Parent = main

    -- Bordas arredondadas para as abas e conteúdo
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentHolder

    local window = {
        Frame = main,
        Tabs = {},
        Name = tostring(data.Name)
    }

    function window:MakeTab(tabData)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 0, 40)
        tabButton.Text = tostring(tabData.Name)
        tabButton.BackgroundColor3 = Color3.fromRGB(0, 0, 50)  -- Azul escuro para a aba
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Font = Enum.Font.SourceSansBold
        tabButton.TextSize = 18
        tabButton.Position = UDim2.new(0, (#window.Tabs * 100), 0, 0)
        tabButton.Parent = tabHolder

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1
        tabContent.Parent = contentHolder

        -- Abrir conteúdo ao clicar na aba
        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.Content.Visible = false
            end
            tabContent.Visible = true
        end)

        local tab = {
            Name = tostring(tabData.Name),
            Content = tabContent,
            Sections = {}
        }

        -- Adicionar seções à aba
        function tab:AddSection(sectionData)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, 0, 0, 40)
            section.Position = UDim2.new(0, 0, 0, 40 + (#tab.Sections * 50))
            section.BackgroundColor3 = Color3.fromRGB(0, 0, 40)  -- Azul escuro
            section.BorderSizePixel = 0
            section.Parent = tabContent

            local title = Instance.new("TextLabel")
            title.Text = tostring(sectionData.Name)
            title.Size = UDim2.new(1, 0, 0, 30)
            title.BackgroundColor3 = Color3.fromRGB(0, 0, 60)  -- Azul mais escuro
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.Font = Enum.Font.SourceSansBold
            title.TextSize = 18
            title.Parent = section

            -- Botão dentro da seção
            function section:AddButton(buttonData)
                local button = Instance.new("TextButton")
                button.Text = tostring(buttonData.Name)
                button.Size = UDim2.new(1, -10, 0, 30)
                button.Position = UDim2.new(0, 5, 0, 40 + (#section:GetChildren() - 1) * 35)
                button.BackgroundColor3 = Color3.fromRGB(0, 0, 80)  -- Azul mais claro
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.Font = Enum.Font.SourceSans
                button.TextSize = 18
                button.Parent = section

                button.MouseButton1Click:Connect(function()
                    if buttonData.Callback then
                        buttonData.Callback()
                    end
                end)

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

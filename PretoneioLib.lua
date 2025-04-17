-- ModuleScript: PretoneioLib
local PretoneioLib = {}

-- Configuração inicial
PretoneioLib.Defaults = {
    Theme = {
        BackgroundColor = Color3.fromRGB(30, 30, 30),
        HeaderColor = Color3.fromRGB(40, 40, 40),
        TextColor = Color3.fromRGB(255, 255, 255),
        ButtonColor = Color3.fromRGB(50, 50, 50),
        SelectedTabColor = Color3.fromRGB(60, 60, 60),
    },
    Font = Enum.Font.SourceSans,
}

-- Função para criar uma janela
function PretoneioLib:Window(config)
    local title = config.Title or "Título"
    local subtitle = config.SubTitle or ""

    -- Criar os elementos principais
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local Header = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local SubTitleLabel = Instance.new("TextLabel")
    local TabContainer = Instance.new("Frame")
    local TabButtons = Instance.new("Frame")
    local TabContents = Instance.new("Frame")

    -- Configurações do ScreenGui
    ScreenGui.Name = "PretoneioLibUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Configuração da janela principal (Frame)
    Frame.Name = "Window"
    Frame.Size = UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    Frame.BackgroundColor3 = self.Defaults.Theme.BackgroundColor
    Frame.Parent = ScreenGui

    -- Configuração do cabeçalho (Header)
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = self.Defaults.Theme.HeaderColor
    Header.Parent = Frame

    -- Configuração do título (TitleLabel)
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Position = UDim2.new(0, 0, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = self.Defaults.Theme.TextColor
    TitleLabel.Font = self.Defaults.Font
    TitleLabel.TextSize = 20
    TitleLabel.Parent = Header

    -- Configuração do subtítulo (SubTitleLabel)
    SubTitleLabel.Name = "SubTitleLabel"
    SubTitleLabel.Size = UDim2.new(1, 0, 0, 20)
    SubTitleLabel.Position = UDim2.new(0, 0, 0, 30)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = subtitle
    SubTitleLabel.TextColor3 = self.Defaults.Theme.TextColor
    SubTitleLabel.Font = self.Defaults.Font
    SubTitleLabel.TextSize = 14
    SubTitleLabel.Parent = Header

    -- Configuração do container de abas (TabContainer)
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -50)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Frame

    -- Configuração para os botões das abas
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 0, 30)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = TabContainer

    -- Configuração para os conteúdos das abas
    TabContents.Name = "TabContents"
    TabContents.Size = UDim2.new(1, 0, 1, -30)
    TabContents.Position = UDim2.new(0, 0, 0, 30)
    TabContents.BackgroundTransparency = 1
    TabContents.Parent = TabContainer

    -- Estrutura da janela
    local window = {
        Frame = Frame,
        Tabs = {},
        TabButtons = TabButtons,
        TabContents = TabContents,
    }

    -- Método para criar abas
    function window:Tab(config)
        local tabName = config.Name or "Aba"
        local TabButton = Instance.new("TextButton")
        local TabContent = Instance.new("Frame")

        -- Configuração do botão da aba
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.BackgroundColor3 = PretoneioLib.Defaults.Theme.ButtonColor
        TabButton.Text = tabName
        TabButton.TextColor3 = PretoneioLib.Defaults.Theme.TextColor
        TabButton.Font = PretoneioLib.Defaults.Font
        TabButton.Parent = self.TabButtons

        -- Configuração do conteúdo da aba
        TabContent.Name = tabName
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = self.TabContents

        -- Adicionar comportamento ao botão
        TabButton.MouseButton1Click:Connect(function()
            -- Esconde todas as abas
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = PretoneioLib.Defaults.Theme.ButtonColor
            end
            -- Mostra a aba atual
            TabContent.Visible = true
            TabButton.BackgroundColor3 = PretoneioLib.Defaults.Theme.SelectedTabColor
        end)

        -- Adicionar aba à lista de abas
        table.insert(self.Tabs, { Button = TabButton, Content = TabContent })

        return TabContent
    end

    return window
end

return PretoneioLib

-- Pretoneio UI Library
local Pretoneio = {}
Pretoneio.__index = Pretoneio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Função para criar a biblioteca
function Pretoneio.new()
    local self = setmetatable({}, Pretoneio)
    
    -- Configurações iniciais
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "PretoneioUI"
    self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui.ResetOnSpawn = false
    
    self.Theme = {
        PrimaryColor = Color3.fromRGB(50, 0, 150), -- Roxo neon
        SecondaryColor = Color3.fromRGB(255, 255, 255), -- Branco
        BackgroundColor = Color3.fromRGB(30, 30, 30), -- Cinza escuro
        AccentColor = Color3.fromRGB(0, 200, 255) -- Azul neon
    }
    
    return self
end

-- Criar uma janela
function Pretoneio:CreateWindow(title)
    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(0, 400, 0, 300)
    Window.Position = UDim2.new(0.5, -200, 0.5, -150)
    Window.BackgroundColor3 = self.Theme.BackgroundColor
    Window.BorderSizePixel = 0
    Window.Parent = self.ScreenGui
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = self.Theme.PrimaryColor
    TitleBar.Parent = Window
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -10, 1, 0)
    TitleText.Position = UDim2.new(0, 5, 0, 0)
    TitleText.Text = title or "Pretoneio Executor"
    TitleText.TextColor3 = self.Theme.SecondaryColor
    TitleText.BackgroundTransparency = 1
    TitleText.Font = Enum.Font.SourceSansBold
    TitleText.TextSize = 18
    TitleText.Parent = TitleBar
    
    -- Arrastar janela
    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    return Window
end

-- Criar um botão
function Pretoneio:CreateButton(window, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 100, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, 40)
    Button.BackgroundColor3 = self.Theme.AccentColor
    Button.Text = text or "Click Me"
    Button.TextColor3 = self.Theme.SecondaryColor
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 16
    Button.Parent = window
    
    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    -- Animação ao passar o mouse
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.PrimaryColor}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.AccentColor}):Play()
    end)
    
    return Button
end

-- Criar um campo de texto para scripts
function Pretoneio:CreateTextBox(window, placeholder)
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.9, 0, 0, 100)
    TextBox.Position = UDim2.new(0.05, 0, 0, 100)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.TextColor3 = self.Theme.SecondaryColor
    TextBox.PlaceholderText = placeholder or "Enter your script here..."
    TextBox.Text = ""
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 14
    TextBox.MultiLine = true
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = window
    
    return TextBox
end

-- Exemplo de uso
local ui = Pretoneio.new()
local window = ui:CreateWindow("Pretoneio Executor")
local executeButton = ui:CreateButton(window, "Execute", function()
    print("Executing script!")
    -- Aqui você integraria com o executor
end)
local scriptBox = ui:CreateTextBox(window, "Paste your Lua script here")

return Pretoneio

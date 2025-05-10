local LibTest = {}

function LibTest:MakeWindow(properties)
  local titleText = properties.Title
  local subTitleText = properties.SubTitle

  if not titleText and not subTitleText then
    warn("LibTest:MakeWindow chamado sem Title ou SubTitle. Nenhum Gui foi criado.")
    return nil
  end

  local Window = Instance.new("ScreenGui")
  Window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
  Window.Name = "YorHubWindow" -- Nomeando o ScreenGui de acordo com o título
  Window.DisplayOrder = 10 -- Garante que fique na frente de outros elementos

  -- Bloco para impedir cliques atrás
  local blocker = Instance.new("Frame")
  blocker.Size = UDim2.new(1, 0, 1, 0)
  blocker.BackgroundTransparency = 1
  blocker.ZIndex = 9 -- Fica atrás da janela principal
  blocker.Parent = Window

  local frame = Instance.new("Frame")
  frame.AnchorPoint = Vector2.new(0.5, 0.5)
  frame.Position = UDim2.new(0.5, 0, 0.5, 0)
  frame.BackgroundTransparency = 0.9
  frame.BorderSizePixel = 0
  frame.Draggable = true -- Habilita a arrastabilidade
  frame.ZIndex = 10 -- Fica na frente do blocker
  frame.Parent = Window

  local offsetY = 0

  if typeof(titleText) == "string" and #titleText > 0 then
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = titleText
    titleLabel.Size = UDim2.new(1, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(0, 0, offsetY, 0)
    titleLabel.AnchorPoint = Vector2.new(0.5, 0)
    titleLabel.Font = properties.TitleFont or Enum.Font.SourceSansBold
    titleLabel.TextSize = properties.TitleSize or 20
    titleLabel.TextColor3 = properties.TitleColor or Color3.new(1, 1, 1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = frame
    offsetY = offsetY + 0.3
  end

  if typeof(subTitleText) == "string" and #subTitleText > 0 then
    local subTitleLabel = Instance.new("TextLabel")
    subTitleLabel.Text = subTitleText
    subTitleLabel.Size = UDim2.new(1, 0, 0.3, 0)
    subTitleLabel.Position = UDim2.new(0, 0, offsetY, 0)
    subTitleLabel.AnchorPoint = Vector2.new(0.5, 0)
    subTitleLabel.Font = properties.SubTitleFont or Enum.Font.SourceSans
    subTitleLabel.TextSize = properties.SubTitleSize or 14
    subTitleLabel.TextColor3 = properties.SubTitleColor or Color3.new(0.8, 0.8, 0.8)
    subTitleLabel.BackgroundTransparency = 1
    subTitleLabel.Parent = frame
  end

  -- Define um tamanho padrão para o frame caso não seja especificado e haja conteúdo
  if not properties.Size and (typeof(titleText) == "string" and #titleText > 0 or typeof(subTitleText) == "string" and #subTitleText > 0) then
    local height = 0.1 -- Altura mínima
    if typeof(titleText) == "string" and #titleText > 0 then
      height = height + 0.3
    end
    if typeof(subTitleText) == "string" and #subTitleText > 0 then
      height = height + 0.3
    end
    frame.Size = UDim2.new(0.4, 0, height, 0)
  end

  -- Define uma cor de fundo padrão para o frame caso não seja especificada e haja conteúdo
  if not properties.BackgroundColor3 and (typeof(titleText) == "string" and #titleText > 0 or typeof(subTitleText) == "string" and #subTitleText > 0) then
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
  end

  return Window
end

return LibTest

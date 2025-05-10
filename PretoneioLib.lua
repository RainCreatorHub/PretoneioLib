local LibTest = {}

function LibTest:MakeDraggableWindow(properties)
  local titleText = properties.Title
  local subTitleText = properties.SubTitle

  if not titleText and not subTitleText then
    warn("LibTest:MakeDraggableWindow chamado sem Title ou SubTitle. Nenhum Gui foi criado.")
    return nil
  end

  local screenGui = Instance.new("ScreenGui")
  screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
  screenGui.Name = "LibTestDraggableWindow"
  screenGui.DisplayOrder = 10 -- Garante que fique na frente de outros elementos

  -- Bloco para impedir cliques atrás
  local blocker = Instance.new("Frame")
  blocker.Size = UDim2.new(1, 0, 1, 0)
  blocker.BackgroundTransparency = 1
  blocker.ZIndex = 9 -- Fica atrás da janela principal
  blocker.Parent = screenGui

  local frame = Instance.new("Frame")
  frame.Size = properties.Size or UDim2.new(0.4, 0, 0.2, 0)
  frame.AnchorPoint = Vector2.new(0.5, 0.5)
  frame.Position = properties.Position or UDim2.new(0.5, 0, 0.5, 0)
  frame.BackgroundTransparency = 0.9
  frame.BackgroundColor3 = properties.BackgroundColor3 or Color3.new(0.2, 0.2, 0.2)
  frame.BorderSizePixel = 0
  frame.Draggable = true -- Habilita a arrastabilidade
  frame.ZIndex = 10 -- Fica na frente do blocker
  frame.Parent = screenGui

  local offsetY = 0

  if titleText then
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

  if subTitleText then
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

  return screenGui
end

return LibTest

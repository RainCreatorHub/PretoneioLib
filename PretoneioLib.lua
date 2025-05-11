local LibTest = {}

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function LibTest:MakeWindow(properties)
	local titleText = properties.Title or ""
	local subTitleText = properties.SubTitle or ""

	local Window = Instance.new("ScreenGui")
	Window.Name = "PretoneioWindow"
	Window.Parent = LocalPlayer:WaitForChild("PlayerGui")
	Window.DisplayOrder = 10
	Window.ResetOnSpawn = false

	local blocker = Instance.new("Frame")
	blocker.Size = UDim2.new(1, 0, 1, 0)
	blocker.BackgroundTransparency = 1
	blocker.ZIndex = 9
	blocker.Parent = Window

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 500, 0, 350)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.BackgroundColor3 = properties.BackgroundColor3 or Color3.fromRGB(35, 35, 35)
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 0
	frame.ZIndex = 10
	frame.Parent = Window
	frame.Visible = true

	local uicorner = Instance.new("UICorner")
	uicorner.CornerRadius = UDim.new(0, 12)
	uicorner.Parent = frame

	local dragBar = Instance.new("Frame")
	dragBar.Name = "DragBar"
	dragBar.Size = UDim2.new(1, 0, 0, 36)
	dragBar.Position = UDim2.new(0, 0, 0, 0)
	dragBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	dragBar.BorderSizePixel = 0
	dragBar.ZIndex = 11
	dragBar.Parent = frame
	dragBar.Active = true

	local dragCorner = Instance.new("UICorner")
	dragCorner.CornerRadius = UDim.new(0, 12)
	dragCorner.Parent = dragBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = titleText
	titleLabel.Font = properties.TitleFont or Enum.Font.GothamBold
	titleLabel.TextSize = properties.TitleSize or 18
	titleLabel.TextColor3 = properties.TitleColor or Color3.new(1, 1, 1)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -90, 0, 18)
	titleLabel.Position = UDim2.new(0, 12, 0, 4)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 12
	titleLabel.Parent = dragBar

	local subTitleLabel = Instance.new("TextLabel")
	subTitleLabel.Text = subTitleText
	subTitleLabel.Font = properties.SubTitleFont or Enum.Font.Gotham
	subTitleLabel.TextSize = properties.SubTitleSize or 13
	subTitleLabel.TextColor3 = properties.SubTitleColor or Color3.fromRGB(180, 180, 180)
	subTitleLabel.BackgroundTransparency = 1
	subTitleLabel.Size = UDim2.new(1, -90, 0, 14)
	subTitleLabel.Position = UDim2.new(0, 12, 0, 20)
	subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	subTitleLabel.ZIndex = 12
	subTitleLabel.Parent = dragBar

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Text = "-"
	minimizeButton.Font = Enum.Font.GothamBold
	minimizeButton.TextSize = 16
	minimizeButton.TextColor3 = Color3.new(1, 1, 1)
	minimizeButton.BackgroundTransparency = 1
	minimizeButton.Size = UDim2.new(0, 30, 0, 30)
	minimizeButton.Position = UDim2.new(1, -68, 0, 3)
	minimizeButton.ZIndex = 12
	minimizeButton.Parent = dragBar

	local closeButton = Instance.new("TextButton")
	closeButton.Text = "X"
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 16
	closeButton.TextColor3 = Color3.new(1, 1, 1)
	closeButton.BackgroundTransparency = 1
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -34, 0, 3)
	closeButton.ZIndex = 12
	closeButton.Parent = dragBar

	local isMinimized = false
	minimizeButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		if isMinimized then
			frame.Size = UDim2.new(0, 500, 0, 36)
			minimizeButton.Text = "+"
		else
			frame.Size = UDim2.new(0, 500, 0, 350)
			minimizeButton.Text = "-"
		end
	end)

	closeButton.MouseButton1Click:Connect(function()
		Window:Destroy()
	end)

	dragBar.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and
			not closeButton:IsAncestorOf(input.Target) and
			not minimizeButton:IsAncestorOf(input.Target) then
			frame.Visible = not frame.Visible
		end
	end)

	local dragging = false
	local dragInput, dragStart, startPos

	local function updateDrag(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	dragBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			local connection
			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					connection:Disconnect()
				end
			end)
		end
	end)

	dragBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			updateDrag(input)
		end
	end)

	-- Botão flutuante estilo Redz v5
	local miniGui = Instance.new("ScreenGui")
	miniGui.Name = "MinimizeGuiButton"
	miniGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	miniGui.DisplayOrder = 999
	miniGui.ResetOnSpawn = false
	miniGui.IgnoreGuiInset = true

	local miniButton = Instance.new("TextButton")
	miniButton.Size = UDim2.new(0, 45, 0, 45)
	miniButton.Position = UDim2.new(0, 20, 0, 200)
	miniButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	miniButton.Text = ""
	miniButton.AutoButtonColor = false
	miniButton.ZIndex = 50
	miniButton.Parent = miniGui

	local icon = Instance.new("TextLabel")
	icon.Text = "⭘"
	icon.Font = Enum.Font.GothamBold
	icon.TextScaled = true
	icon.TextColor3 = Color3.new(1, 1, 1)
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.new(1, 0, 1, 0)
	icon.Position = UDim2.new(0, 0, 0, 0)
	icon.ZIndex = 51
	icon.Parent = miniButton

	local uicornerMini = Instance.new("UICorner")
	uicornerMini.CornerRadius = UDim.new(1, 0)
	uicornerMini.Parent = miniButton

	local uistroke = Instance.new("UIStroke")
	uistroke.Color = Color3.fromRGB(255, 255, 255)
	uistroke.Thickness = 1
	uistroke.Transparency = 0.4
	uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uistroke.Parent = miniButton

	local uishadow = Instance.new("ImageLabel")
	uishadow.BackgroundTransparency = 1
	uishadow.Image = "rbxassetid://1316045217"
	uishadow.ImageColor3 = Color3.new(0, 0, 0)
	uishadow.ImageTransparency = 0.6
	uishadow.ScaleType = Enum.ScaleType.Slice
	uishadow.SliceCenter = Rect.new(10, 10, 118, 118)
	uishadow.Size = UDim2.new(1, 12, 1, 12)
	uishadow.Position = UDim2.new(0, -6, 0, -6)
	uishadow.ZIndex = 49
	uishadow.Parent = miniButton

	local draggingMini = false
	local dragStartMini, startPosMini

	local function updateMiniDrag(input)
		local delta = input.Position - dragStartMini
		miniButton.Position = UDim2.new(
			startPosMini.X.Scale,
			startPosMini.X.Offset + delta.X,
			startPosMini.Y.Scale,
			startPosMini.Y.Offset + delta.Y
		)
	end

	miniButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingMini = true
			dragStartMini = input.Position
			startPosMini = miniButton.Position

			local connection
			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					draggingMini = false
					connection:Disconnect()
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingMini and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateMiniDrag(input)
		end
	end)

	local mainVisible = true
	miniButton.MouseButton1Click:Connect(function()
		mainVisible = not mainVisible
		frame.Visible = mainVisible
	end)

	function Window:Close()
		Window:Destroy()
		miniGui:Destroy()
	end

	return Window
end

return LibTest

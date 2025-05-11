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
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.BorderSizePixel = 0
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
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 18
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -90, 0, 18)
	titleLabel.Position = UDim2.new(0, 12, 0, 4)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 12
	titleLabel.Parent = dragBar

	local subTitleLabel = Instance.new("TextLabel")
	subTitleLabel.Text = subTitleText
	subTitleLabel.Font = Enum.Font.Gotham
	subTitleLabel.TextSize = 13
	subTitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	subTitleLabel.BackgroundTransparency = 1
	subTitleLabel.Size = UDim2.new(1, -90, 0, 14)
	subTitleLabel.Position = UDim2.new(0, 12, 0, 20)
	subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	subTitleLabel.ZIndex = 12
	subTitleLabel.Parent = dragBar

	-- Minimize botão "-" e "+"
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

	-- Fechar
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

	-- Drag
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

	-- MinimizeGuiButton (separado)
	function Window:AddMinimizeButton(info)
		local minimized = false
		local miniButton = Instance.new("ImageButton")
		miniButton.Name = "MinimizeGuiButton"
		miniButton.Size = UDim2.new(0, 40, 0, 40)
		miniButton.Position = UDim2.new(0, 10, 0, 10)
		miniButton.Image = info.Image1 or ""
		miniButton.BackgroundTransparency = 1
		miniButton.Parent = Window
		miniButton.ZIndex = 100

		local nameTag = Instance.new("TextLabel")
		nameTag.Text = info.Name1 or "Minimize"
		nameTag.Size = UDim2.new(0, 80, 0, 20)
		nameTag.Position = UDim2.new(0, 0, 1, 0)
		nameTag.BackgroundTransparency = 1
		nameTag.TextColor3 = Color3.new(1, 1, 1)
		nameTag.Font = Enum.Font.Gotham
		nameTag.TextSize = 14
		nameTag.Parent = miniButton
		nameTag.ZIndex = 100

		-- Draggable
		local dragging = false
		local dragStart, startPos

		local function update(input)
			local delta = input.Position - dragStart
			miniButton.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end

		miniButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = miniButton.Position

				local conn
				conn = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						conn:Disconnect()
					end
				end)
			end
		end)

		miniButton.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)

		-- Toggle principal
		miniButton.MouseButton1Click:Connect(function()
			minimized = not minimized
			frame.Visible = not minimized
			nameTag.Text = minimized and info.Name2 or info.Name1
			miniButton.Image = minimized and info.Image2 or info.Image1
		end)

		return miniButton
	end

	function Window:Close()
		Window:Destroy()
	end

	return Window
end

return LibTest

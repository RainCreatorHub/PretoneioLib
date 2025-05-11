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

	-- Bloqueador de cliques
	local blocker = Instance.new("Frame")
	blocker.Size = UDim2.new(1, 0, 1, 0)
	blocker.BackgroundTransparency = 1
	blocker.ZIndex = 9
	blocker.Parent = Window

	-- Frame principal
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 500, 0, 350)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.BackgroundColor3 = properties.BackgroundColor3 or Color3.fromRGB(35, 35, 35)
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 0
	frame.ZIndex = 10
	frame.Parent = Window

	-- Bordas arredondadas
	local uicorner = Instance.new("UICorner")
	uicorner.CornerRadius = UDim.new(0, 12)
	uicorner.Parent = frame

	-- DragBar
	local dragBar = Instance.new("Frame")
	dragBar.Name = "DragBar"
	dragBar.Size = UDim2.new(1, 0, 0, 36)
	dragBar.Position = UDim2.new(0, 0, 0, 0)
	dragBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	dragBar.BorderSizePixel = 0
	dragBar.ZIndex = 11
	dragBar.Parent = frame

	local dragCorner = Instance.new("UICorner")
	dragCorner.CornerRadius = UDim.new(0, 12)
	dragCorner.Parent = dragBar

	-- Título
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = titleText
	titleLabel.Font = properties.TitleFont or Enum.Font.GothamBold
	titleLabel.TextSize = properties.TitleSize or 18
	titleLabel.TextColor3 = properties.TitleColor or Color3.new(1, 1, 1)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -60, 0, 18)
	titleLabel.Position = UDim2.new(0, 12, 0, 4)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 12
	titleLabel.Parent = dragBar

	-- Subtítulo
	local subTitleLabel = Instance.new("TextLabel")
	subTitleLabel.Text = subTitleText
	subTitleLabel.Font = properties.SubTitleFont or Enum.Font.Gotham
	subTitleLabel.TextSize = properties.SubTitleSize or 13
	subTitleLabel.TextColor3 = properties.SubTitleColor or Color3.fromRGB(180, 180, 180)
	subTitleLabel.BackgroundTransparency = 1
	subTitleLabel.Size = UDim2.new(1, -60, 0, 14)
	subTitleLabel.Position = UDim2.new(0, 12, 0, 20)
	subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	subTitleLabel.ZIndex = 12
	subTitleLabel.Parent = dragBar

	-- Botão de fechar
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

	closeButton.MouseButton1Click:Connect(function()
		Window:Destroy()
	end)

	-- Arrastar (PC e Mobile)
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

	function Window:Close()
		Window:Destroy()
	end

	return Window
end

return LibTest

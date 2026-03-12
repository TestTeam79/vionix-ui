-- ================================================
--   VIONIX HUB - UI Library
--   GitHub: github.com/TestTeam79/vionix-ui
--   Usage:
--     local VionixHub = loadstring(game:HttpGet(
--       "https://raw.githubusercontent.com/TestTeam79/vionix-ui/refs/heads/main/main.lua"
--     ))()
-- ================================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ================================================
-- THEME
-- ================================================
local Theme = {
	WindowBg    = Color3.fromRGB(17, 17, 24),
	SidebarBg   = Color3.fromRGB(13, 13, 20),
	Surface     = Color3.fromRGB(26, 26, 36),
	Surface2    = Color3.fromRGB(32, 32, 44),
	Surface3    = Color3.fromRGB(20, 20, 30),
	Border      = Color3.fromRGB(255, 255, 255),
	Purple      = Color3.fromRGB(98, 87, 232),
	PurpleHover = Color3.fromRGB(120, 114, 245),
	PurpleClick = Color3.fromRGB(75, 69, 200),
	PurpleDim   = Color3.fromRGB(22, 20, 48),
	Accent      = Color3.fromRGB(168, 159, 255),
	Text        = Color3.fromRGB(240, 240, 255),
	Muted       = Color3.fromRGB(90, 90, 112),
	Muted2      = Color3.fromRGB(136, 136, 160),
	Green       = Color3.fromRGB(62, 207, 142),
	Red         = Color3.fromRGB(232, 87, 87),
}

-- ================================================
-- UTILS
-- ================================================
local Utils = {}

function Utils.Spring(duration, style, direction)
	return TweenInfo.new(
		duration or 0.2,
		style or Enum.EasingStyle.Quart,
		direction or Enum.EasingDirection.Out
	)
end

function Utils.AddCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or UDim.new(0, 8)
	c.Parent = parent
	return c
end

function Utils.AddPadding(parent, top, bottom, left, right)
	local p = Instance.new("UIPadding")
	p.PaddingTop    = UDim.new(0, top    or 0)
	p.PaddingBottom = UDim.new(0, bottom or 0)
	p.PaddingLeft   = UDim.new(0, left   or 0)
	p.PaddingRight  = UDim.new(0, right  or 0)
	p.Parent = parent
	return p
end

function Utils.AddStroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color        = color or Color3.fromRGB(255, 255, 255)
	s.Thickness    = thickness or 1
	s.Transparency = transparency or 0.9
	s.Parent = parent
	return s
end

function Utils.AddListLayout(parent, direction, padding)
	local l = Instance.new("UIListLayout")
	l.FillDirection = direction or Enum.FillDirection.Vertical
	l.Padding       = UDim.new(0, padding or 0)
	l.SortOrder     = Enum.SortOrder.LayoutOrder
	l.Parent = parent
	return l
end

function Utils.MakeLine(parent)
	local line = Instance.new("Frame")
	line.Size               = UDim2.new(1, 0, 0, 1)
	line.BackgroundColor3   = Theme.Border
	line.BackgroundTransparency = 0.93
	line.BorderSizePixel    = 0
	line.Parent             = parent
	return line
end

function Utils.IsMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Universal drag setup (PC + Mobile)
function Utils.SetupDrag(handle, getPos, setPos)
	local dragging = false
	local dragStart, startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			startPos  = getPos()
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement or
			input.UserInputType == Enum.UserInputType.Touch
		) then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
			setPos(startPos + delta)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- ================================================
-- TOGGLE COMPONENT
-- ================================================
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(section, name, default, callback)
	local self    = setmetatable({}, Toggle)
	self.Value    = default or false
	self.Callback = callback or function() end

	local row = Instance.new("Frame")
	row.Name             = "Toggle_" .. name
	row.Size             = UDim2.new(1, 0, 0, 38)
	row.BackgroundTransparency = 1
	row.BorderSizePixel  = 0
	row.Parent           = section.Body

	local hover = Instance.new("Frame")
	hover.Size             = UDim2.new(1, 0, 1, 0)
	hover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	hover.BackgroundTransparency = 1
	hover.BorderSizePixel  = 0
	hover.Parent           = row

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -60, 1, 0)
	label.Position            = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.Text
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 13
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = row

	local track = Instance.new("Frame")
	track.Size             = UDim2.new(0, 36, 0, 20)
	track.Position         = UDim2.new(1, -50, 0.5, -10)
	track.BackgroundColor3 = Theme.Surface2
	track.BorderSizePixel  = 0
	track.Parent           = row
	Utils.AddCorner(track, UDim.new(1, 0))
	Utils.AddStroke(track, Theme.Border, 1, 0.92)
	self.Track = track

	local thumb = Instance.new("Frame")
	thumb.Size             = UDim2.new(0, 14, 0, 14)
	thumb.Position         = UDim2.new(0, 3, 0.5, -7)
	thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	thumb.BorderSizePixel  = 0
	thumb.Parent           = track
	Utils.AddCorner(thumb, UDim.new(1, 0))
	self.Thumb = thumb

	local btn = Instance.new("TextButton")
	btn.Size                  = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text                  = ""
	btn.Parent                = row

	if self.Value then
		track.BackgroundColor3 = Theme.Purple
		thumb.Position = UDim2.new(0, 19, 0.5, -7)
	end

	btn.MouseEnter:Connect(function()
		TweenService:Create(hover, TweenInfo.new(0.15), {BackgroundTransparency = 0.97}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(hover, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
	end)
	btn.Activated:Connect(function() self:Set(not self.Value) end)

	return self
end

function Toggle:Set(value)
	self.Value = value
	local spring = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	if value then
		TweenService:Create(self.Track, spring, {BackgroundColor3 = Theme.Purple}):Play()
		TweenService:Create(self.Thumb, spring, {Position = UDim2.new(0, 19, 0.5, -7)}):Play()
	else
		TweenService:Create(self.Track, spring, {BackgroundColor3 = Theme.Surface2}):Play()
		TweenService:Create(self.Thumb, spring, {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
	end
	self.Callback(value)
end

-- ================================================
-- SLIDER COMPONENT
-- ================================================
local Slider = {}
Slider.__index = Slider

function Slider.new(section, name, min, max, default, callback)
	local self    = setmetatable({}, Slider)
	self.Min      = min or 0
	self.Max      = max or 100
	self.Value    = default or min or 0
	self.Callback = callback or function() end
	self.Dragging = false

	local row = Instance.new("Frame")
	row.Name             = "Slider_" .. name
	row.Size             = UDim2.new(1, 0, 0, 50)
	row.BackgroundTransparency = 1
	row.BorderSizePixel  = 0
	row.Parent           = section.Body

	local topRow = Instance.new("Frame")
	topRow.Size             = UDim2.new(1, -28, 0, 20)
	topRow.Position         = UDim2.new(0, 14, 0, 8)
	topRow.BackgroundTransparency = 1
	topRow.Parent           = row

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -50, 1, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.Text
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 13
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = topRow

	local valBadge = Instance.new("TextLabel")
	valBadge.Size             = UDim2.new(0, 44, 1, 0)
	valBadge.Position         = UDim2.new(1, -44, 0, 0)
	valBadge.BackgroundColor3 = Theme.PurpleDim
	valBadge.Text             = tostring(self.Value)
	valBadge.TextColor3       = Theme.Accent
	valBadge.Font             = Enum.Font.GothamBold
	valBadge.TextSize         = 11
	valBadge.Parent           = topRow
	Utils.AddCorner(valBadge, UDim.new(0, 4))
	self.ValBadge = valBadge

	local trackBg = Instance.new("Frame")
	trackBg.Size             = UDim2.new(1, -28, 0, 4)
	trackBg.Position         = UDim2.new(0, 14, 0, 36)
	trackBg.BackgroundColor3 = Theme.Surface2
	trackBg.BorderSizePixel  = 0
	trackBg.Parent           = row
	Utils.AddCorner(trackBg, UDim.new(1, 0))
	self.TrackBg = trackBg

	local fill = Instance.new("Frame")
	fill.Size             = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Theme.Purple
	fill.BorderSizePixel  = 0
	fill.Parent           = trackBg
	Utils.AddCorner(fill, UDim.new(1, 0))
	self.Fill = fill

	local thumb = Instance.new("Frame")
	thumb.Size             = UDim2.new(0, 14, 0, 14)
	thumb.Position         = UDim2.new(0, -7, 0.5, -7)
	thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	thumb.BorderSizePixel  = 0
	thumb.ZIndex           = 2
	thumb.Parent           = trackBg
	Utils.AddCorner(thumb, UDim.new(1, 0))
	self.Thumb = thumb

	local dragBtn = Instance.new("TextButton")
	dragBtn.Size                  = UDim2.new(1, 0, 0, 50)
	dragBtn.Position              = UDim2.new(0, 0, 0, -23)
	dragBtn.BackgroundTransparency = 1
	dragBtn.Text                  = ""
	dragBtn.ZIndex                = 3
	dragBtn.Parent                = trackBg

	local function updateFromX(x)
		local absPos  = trackBg.AbsolutePosition.X
		local absSize = trackBg.AbsoluteSize.X
		local alpha   = math.clamp((x - absPos) / absSize, 0, 1)
		self:Set(math.round(self.Min + (self.Max - self.Min) * alpha))
	end

	dragBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			self.Dragging = true
			updateFromX(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if self.Dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement or
			input.UserInputType == Enum.UserInputType.Touch
		) then
			updateFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			self.Dragging = false
		end
	end)

	self:Set(self.Value, true)
	return self
end

function Slider:Set(value, silent)
	self.Value = math.clamp(math.round(value), self.Min, self.Max)
	local alpha = (self.Value - self.Min) / (self.Max - self.Min)
	self.Fill.Size      = UDim2.new(alpha, 0, 1, 0)
	self.Thumb.Position = UDim2.new(alpha, -7, 0.5, -7)
	self.ValBadge.Text  = tostring(self.Value)
	if not silent then self.Callback(self.Value) end
end

-- ================================================
-- BUTTON COMPONENT
-- ================================================
local Button = {}
Button.__index = Button

function Button.new(section, name, callback)
	local self    = setmetatable({}, Button)
	self.Callback = callback or function() end

	local row = Instance.new("Frame")
	row.Name             = "Button_" .. name
	row.Size             = UDim2.new(1, 0, 0, 38)
	row.BackgroundTransparency = 1
	row.BorderSizePixel  = 0
	row.Parent           = section.Body

	local hover = Instance.new("Frame")
	hover.Size             = UDim2.new(1, 0, 1, 0)
	hover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	hover.BackgroundTransparency = 1
	hover.BorderSizePixel  = 0
	hover.Parent           = row

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -90, 1, 0)
	label.Position            = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.Text
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 13
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = row

	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(0, 70, 0, 26)
	btn.Position         = UDim2.new(1, -82, 0.5, -13)
	btn.BackgroundColor3 = Theme.Purple
	btn.Text             = "Execute"
	btn.TextColor3       = Color3.fromRGB(255, 255, 255)
	btn.Font             = Enum.Font.GothamBold
	btn.TextSize         = 11
	btn.BorderSizePixel  = 0
	btn.AutoButtonColor  = false
	btn.Parent           = row
	Utils.AddCorner(btn, UDim.new(0, 7))

	btn.MouseEnter:Connect(function()
		TweenService:Create(hover, TweenInfo.new(0.15), {BackgroundTransparency = 0.97}):Play()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.PurpleHover}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(hover, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Purple}):Play()
	end)
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {
			BackgroundColor3 = Theme.PurpleClick,
			Size = UDim2.new(0, 67, 0, 24)
		}):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
			BackgroundColor3 = Theme.PurpleHover,
			Size = UDim2.new(0, 70, 0, 26)
		}):Play()
	end)
	btn.Activated:Connect(function() self.Callback() end)

	return self
end

-- ================================================
-- DROPDOWN COMPONENT
-- ================================================
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(section, name, options, default, callback)
	local self    = setmetatable({}, Dropdown)
	self.Options  = options or {}
	self.Value    = default or options[1] or ""
	self.Callback = callback or function() end
	self.Open     = false

	local row = Instance.new("Frame")
	row.Name             = "Dropdown_" .. name
	row.Size             = UDim2.new(1, 0, 0, 38)
	row.BackgroundTransparency = 1
	row.ClipsDescendants = false
	row.BorderSizePixel  = 0
	row.ZIndex           = 5
	row.Parent           = section.Body
	self.Row = row

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -130, 1, 0)
	label.Position            = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.Text
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 13
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = row

	local dropBtn = Instance.new("TextButton")
	dropBtn.Size             = UDim2.new(0, 110, 0, 26)
	dropBtn.Position         = UDim2.new(1, -122, 0.5, -13)
	dropBtn.BackgroundColor3 = Theme.Surface2
	dropBtn.Text             = ""
	dropBtn.BorderSizePixel  = 0
	dropBtn.AutoButtonColor  = false
	dropBtn.ZIndex           = 5
	dropBtn.Parent           = row
	Utils.AddCorner(dropBtn, UDim.new(0, 7))
	Utils.AddStroke(dropBtn, Theme.Border, 1, 0.92)

	local selectedLabel = Instance.new("TextLabel")
	selectedLabel.Size                = UDim2.new(1, -24, 1, 0)
	selectedLabel.Position            = UDim2.new(0, 8, 0, 0)
	selectedLabel.BackgroundTransparency = 1
	selectedLabel.Text                = self.Value
	selectedLabel.TextColor3          = Theme.Text
	selectedLabel.Font                = Enum.Font.Gotham
	selectedLabel.TextSize            = 12
	selectedLabel.TextXAlignment      = Enum.TextXAlignment.Left
	selectedLabel.ZIndex              = 6
	selectedLabel.Parent              = dropBtn
	self.SelectedLabel = selectedLabel

	local arrow = Instance.new("TextLabel")
	arrow.Size                = UDim2.new(0, 16, 1, 0)
	arrow.Position            = UDim2.new(1, -18, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text                = "▾"
	arrow.TextColor3          = Theme.Muted2
	arrow.Font                = Enum.Font.Gotham
	arrow.TextSize            = 12
	arrow.ZIndex              = 6
	arrow.Parent              = dropBtn
	self.Arrow = arrow

	local panel = Instance.new("Frame")
	panel.Size             = UDim2.new(0, 110, 0, 0)
	panel.Position         = UDim2.new(1, -122, 0, 38)
	panel.BackgroundColor3 = Theme.Surface3
	panel.BorderSizePixel  = 0
	panel.ClipsDescendants = true
	panel.ZIndex           = 10
	panel.Parent           = row
	Utils.AddCorner(panel, UDim.new(0, 7))
	Utils.AddStroke(panel, Theme.Border, 1, 0.9)
	Utils.AddPadding(panel, 4, 4, 0, 0)
	Utils.AddListLayout(panel, Enum.FillDirection.Vertical, 0)
	self.Panel = panel

	for _, opt in ipairs(self.Options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size             = UDim2.new(1, 0, 0, 28)
		optBtn.BackgroundTransparency = 1
		optBtn.Text             = opt
		optBtn.TextColor3       = opt == self.Value and Theme.Accent or Theme.Muted2
		optBtn.Font             = opt == self.Value and Enum.Font.GothamBold or Enum.Font.Gotham
		optBtn.TextSize         = 12
		optBtn.BorderSizePixel  = 0
		optBtn.ZIndex           = 11
		optBtn.Parent           = panel
		optBtn.MouseEnter:Connect(function()
			TweenService:Create(optBtn, TweenInfo.new(0.1), {
				BackgroundTransparency = 0.85, BackgroundColor3 = Theme.Purple
			}):Play()
		end)
		optBtn.MouseLeave:Connect(function()
			TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
		end)
		optBtn.Activated:Connect(function()
			self:Set(opt)
			self:Close()
		end)
	end

	dropBtn.Activated:Connect(function()
		if self.Open then self:Close() else self:OpenPanel() end
	end)

	return self
end

function Dropdown:OpenPanel()
	self.Open = true
	TweenService:Create(self.Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
		Size = UDim2.new(0, 110, 0, #self.Options * 28 + 8)
	}):Play()
	TweenService:Create(self.Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
end

function Dropdown:Close()
	self.Open = false
	TweenService:Create(self.Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
		Size = UDim2.new(0, 110, 0, 0)
	}):Play()
	TweenService:Create(self.Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
end

function Dropdown:Set(value)
	self.Value = value
	self.SelectedLabel.Text = value
	self.Callback(value)
end

-- ================================================
-- TEXTINPUT COMPONENT
-- ================================================
local TextInput = {}
TextInput.__index = TextInput

function TextInput.new(section, name, placeholder, callback)
	local self    = setmetatable({}, TextInput)
	self.Value    = ""
	self.Callback = callback or function() end

	local row = Instance.new("Frame")
	row.Name             = "TextInput_" .. name
	row.Size             = UDim2.new(1, 0, 0, 38)
	row.BackgroundTransparency = 1
	row.BorderSizePixel  = 0
	row.Parent           = section.Body

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -140, 1, 0)
	label.Position            = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.Text
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 13
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = row

	local box = Instance.new("TextBox")
	box.Size             = UDim2.new(0, 120, 0, 26)
	box.Position         = UDim2.new(1, -132, 0.5, -13)
	box.BackgroundColor3 = Theme.Surface2
	box.Text             = ""
	box.PlaceholderText  = placeholder or "Enter..."
	box.PlaceholderColor3 = Theme.Muted2
	box.TextColor3       = Theme.Text
	box.Font             = Enum.Font.Gotham
	box.TextSize         = 12
	box.BorderSizePixel  = 0
	box.ClearTextOnFocus = false
	box.Parent           = row
	Utils.AddCorner(box, UDim.new(0, 7))
	Utils.AddStroke(box, Theme.Border, 1, 0.92)
	Utils.AddPadding(box, 0, 0, 8, 8)
	self.Box = box

	box.Focused:Connect(function()
		TweenService:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(38, 36, 58)}):Play()
		for _, v in ipairs(box:GetChildren()) do
			if v:IsA("UIStroke") then
				TweenService:Create(v, TweenInfo.new(0.15), {Color = Theme.Purple, Transparency = 0.3}):Play()
			end
		end
	end)
	box.FocusLost:Connect(function(enterPressed)
		self.Value = box.Text
		TweenService:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Surface2}):Play()
		for _, v in ipairs(box:GetChildren()) do
			if v:IsA("UIStroke") then
				TweenService:Create(v, TweenInfo.new(0.15), {Color = Color3.fromRGB(255,255,255), Transparency = 0.92}):Play()
			end
		end
		if enterPressed then self.Callback(self.Value) end
	end)

	return self
end

function TextInput:Set(value) self.Value = value; self.Box.Text = value end
function TextInput:Get() return self.Value end

-- ================================================
-- SECTION
-- ================================================
local Section = {}
Section.__index = Section

function Section.new(tab, name)
	local self = setmetatable({}, Section)

	local frame = Instance.new("Frame")
	frame.Name             = "Section_" .. name
	frame.Size             = UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize    = Enum.AutomaticSize.Y
	frame.BackgroundColor3 = Theme.Surface
	frame.BorderSizePixel  = 0
	frame.Parent           = tab.ContentFrame
	Utils.AddCorner(frame, UDim.new(0, 10))
	Utils.AddStroke(frame, Theme.Border, 1, 0.93)

	local header = Instance.new("Frame")
	header.Size             = UDim2.new(1, 0, 0, 30)
	header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	header.BackgroundTransparency = 0.8
	header.BorderSizePixel  = 0
	header.Parent           = frame
	Utils.AddCorner(header, UDim.new(0, 10))

	local headerFix = Instance.new("Frame")
	headerFix.Size             = UDim2.new(1, 0, 0, 10)
	headerFix.Position         = UDim2.new(0, 0, 1, -10)
	headerFix.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	headerFix.BackgroundTransparency = 0.8
	headerFix.BorderSizePixel  = 0
	headerFix.Parent           = header

	Utils.MakeLine(header)

	local headerLabel = Instance.new("TextLabel")
	headerLabel.Size                = UDim2.new(1, 0, 1, 0)
	headerLabel.BackgroundTransparency = 1
	headerLabel.Text                = string.upper(name)
	headerLabel.TextColor3          = Theme.Muted
	headerLabel.Font                = Enum.Font.GothamBold
	headerLabel.TextSize            = 10
	headerLabel.Parent              = header
	Utils.AddPadding(header, 0, 0, 14, 0)

	local body = Instance.new("Frame")
	body.Name           = "Body"
	body.Size           = UDim2.new(1, 0, 0, 0)
	body.Position       = UDim2.new(0, 0, 0, 30)
	body.AutomaticSize  = Enum.AutomaticSize.Y
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.Parent         = frame
	Utils.AddListLayout(body, Enum.FillDirection.Vertical, 0)
	self.Body = body

	return self
end

function Section:AddToggle(name, default, callback)   return Toggle.new(self, name, default, callback) end
function Section:AddSlider(name, min, max, def, cb)   return Slider.new(self, name, min, max, def, cb) end
function Section:AddButton(name, callback)            return Button.new(self, name, callback) end
function Section:AddDropdown(name, opts, def, cb)     return Dropdown.new(self, name, opts, def, cb) end
function Section:AddTextInput(name, placeholder, cb)  return TextInput.new(self, name, placeholder, cb) end
function Section:AddLabel(text)
	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, 0, 0, 32)
	label.BackgroundTransparency = 1
	label.Text                = text
	label.TextColor3          = Theme.Muted2
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 12
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = self.Body
	Utils.AddPadding(label, 0, 0, 14, 14)
	return label
end

-- ================================================
-- TAB
-- ================================================
local Tab = {}
Tab.__index = Tab

function Tab.new(window, name, icon)
	local self = setmetatable({}, Tab)
	self.Window   = window
	self.Name     = name
	self.Selected = false
	self.Sections = {}

	local btn = Instance.new("TextButton")
	btn.Name                  = "Tab_" .. name
	btn.Size                  = UDim2.new(1, 0, 0, 34)
	btn.BackgroundTransparency = 1
	btn.Text                  = ""
	btn.BorderSizePixel       = 0
	btn.AutoButtonColor       = false
	btn.Parent                = window.Sidebar
	Utils.AddCorner(btn, UDim.new(0, 8))
	self.Button = btn

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size                = UDim2.new(0, 16, 0, 16)
	iconLabel.Position            = UDim2.new(0, 10, 0.5, -8)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text                = icon or "•"
	iconLabel.TextColor3          = Theme.Muted2
	iconLabel.Font                = Enum.Font.GothamBold
	iconLabel.TextSize            = 13
	iconLabel.Parent              = btn
	self.IconLabel = iconLabel

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -36, 1, 0)
	label.Position            = UDim2.new(0, 32, 0, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.Muted2
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 12
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = btn
	self.Label = label

	local indicator = Instance.new("Frame")
	indicator.Size             = UDim2.new(0, 3, 0, 16)
	indicator.Position         = UDim2.new(0, 0, 0.5, -8)
	indicator.BackgroundColor3 = Theme.Purple
	indicator.BackgroundTransparency = 1
	indicator.BorderSizePixel  = 0
	indicator.Parent           = btn
	Utils.AddCorner(indicator, UDim.new(0, 4))
	self.Indicator = indicator

	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Size                = UDim2.new(1, 0, 1, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel     = 0
	contentFrame.ScrollBarThickness  = 3
	contentFrame.ScrollBarImageColor3 = Theme.Purple
	contentFrame.CanvasSize          = UDim2.new(0, 0, 0, 0)
	contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentFrame.Visible             = false
	contentFrame.Parent              = window.Content
	Utils.AddPadding(contentFrame, 12, 12, 12, 12)
	Utils.AddListLayout(contentFrame, Enum.FillDirection.Vertical, 10)
	self.ContentFrame = contentFrame

	btn.Activated:Connect(function() self:Select() end)
	btn.MouseEnter:Connect(function()
		if self.Selected then return end
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.85}):Play()
		TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = Theme.Text}):Play()
	end)
	btn.MouseLeave:Connect(function()
		if self.Selected then return end
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
		TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = Theme.Muted2}):Play()
	end)

	return self
end

function Tab:Select()
	for _, tab in ipairs(self.Window.Tabs) do
		if tab ~= self then tab:Deselect() end
	end
	self.Selected = true
	self.Window.ActiveTab = self
	self.ContentFrame.Visible = true
	TweenService:Create(self.Button, TweenInfo.new(0.2), {
		BackgroundColor3 = Theme.PurpleDim, BackgroundTransparency = 0
	}):Play()
	TweenService:Create(self.Label, TweenInfo.new(0.2), {TextColor3 = Theme.Accent}):Play()
	TweenService:Create(self.IconLabel, TweenInfo.new(0.2), {TextColor3 = Theme.Purple}):Play()
	TweenService:Create(self.Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end

function Tab:Deselect()
	self.Selected = false
	self.ContentFrame.Visible = false
	TweenService:Create(self.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
	TweenService:Create(self.Label, TweenInfo.new(0.2), {TextColor3 = Theme.Muted2}):Play()
	TweenService:Create(self.IconLabel, TweenInfo.new(0.2), {TextColor3 = Theme.Muted2}):Play()
	TweenService:Create(self.Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
end

function Tab:AddSection(name)
	local section = Section.new(self, name)
	table.insert(self.Sections, section)
	return section
end

-- ================================================
-- WINDOW
-- ================================================
local Window = {}
Window.__index = Window

function Window.new(config)
	local self = setmetatable({}, Window)
	config = config or {}
	self.Title     = config.Title    or "Vionix Hub"
	self.SubTitle  = config.SubTitle or "v1.0.0"
	self.Tabs      = {}
	self.ActiveTab = nil
	self.Minimized = false
	self.Visible   = true

	-- Auto size berdasarkan layar
	local screenSize = workspace.CurrentCamera.ViewportSize
	local isMobile   = Utils.IsMobile()
	local winW = isMobile and math.min(screenSize.X - 24, 400) or math.min(screenSize.X - 40, 580)
	local winH = isMobile and math.min(screenSize.Y - 60, 360) or math.min(screenSize.Y - 80, 440)
	self.Size = Vector2.new(winW, winH)

	local gui = Instance.new("ScreenGui")
	gui.Name             = "VionixHub"
	gui.ResetOnSpawn     = false
	gui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
	gui.IgnoreGuiInset   = true
	gui.Parent           = game:GetService("CoreGui")
	self.Gui = gui

	local main = Instance.new("Frame")
	main.Name             = "MainFrame"
	main.Size             = UDim2.new(0, winW, 0, winH)
	main.Position         = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
	main.BackgroundColor3 = Theme.WindowBg
	main.BorderSizePixel  = 0
	main.ClipsDescendants = true
	main.Parent           = gui
	Utils.AddCorner(main, UDim.new(0, 14))
	Utils.AddStroke(main, Theme.Border, 1, 0.93)
	self.Main = main

	-- Titlebar
	local titlebar = Instance.new("Frame")
	titlebar.Size             = UDim2.new(1, 0, 0, 46)
	titlebar.BackgroundColor3 = Theme.SidebarBg
	titlebar.BorderSizePixel  = 0
	titlebar.Parent           = main
	Utils.MakeLine(titlebar)

	local logo = Instance.new("Frame")
	logo.Size             = UDim2.new(0, 28, 0, 28)
	logo.Position         = UDim2.new(0, 12, 0.5, -14)
	logo.BackgroundColor3 = Theme.Purple
	logo.BorderSizePixel  = 0
	logo.Parent           = titlebar
	Utils.AddCorner(logo, UDim.new(0, 7))

	local logoText = Instance.new("TextLabel")
	logoText.Size = UDim2.new(1,0,1,0); logoText.BackgroundTransparency = 1
	logoText.Text = "V"; logoText.TextColor3 = Color3.fromRGB(255,255,255)
	logoText.Font = Enum.Font.GothamBold; logoText.TextSize = 14
	logoText.Parent = logo

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0,200,0,18); titleLabel.Position = UDim2.new(0,48,0,8)
	titleLabel.BackgroundTransparency = 1; titleLabel.Text = self.Title
	titleLabel.TextColor3 = Theme.Text; titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 13; titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = titlebar

	local subLabel = Instance.new("TextLabel")
	subLabel.Size = UDim2.new(0,200,0,14); subLabel.Position = UDim2.new(0,48,0,26)
	subLabel.BackgroundTransparency = 1; subLabel.Text = self.SubTitle
	subLabel.TextColor3 = Theme.Muted; subLabel.Font = Enum.Font.Gotham
	subLabel.TextSize = 11; subLabel.TextXAlignment = Enum.TextXAlignment.Left
	subLabel.Parent = titlebar

	local minBtn = Instance.new("TextButton")
	minBtn.Size = UDim2.new(0,22,0,22); minBtn.Position = UDim2.new(1,-60,0.5,-11)
	minBtn.BackgroundColor3 = Color3.fromRGB(26,26,36); minBtn.Text = "–"
	minBtn.TextColor3 = Theme.Muted; minBtn.Font = Enum.Font.GothamBold
	minBtn.TextSize = 12; minBtn.BorderSizePixel = 0; minBtn.Parent = titlebar
	Utils.AddCorner(minBtn, UDim.new(0,6)); Utils.AddStroke(minBtn, Theme.Border, 1, 0.93)
	minBtn.Activated:Connect(function() self:Minimize() end)

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0,22,0,22); closeBtn.Position = UDim2.new(1,-34,0.5,-11)
	closeBtn.BackgroundColor3 = Color3.fromRGB(26,26,36); closeBtn.Text = "✕"
	closeBtn.TextColor3 = Theme.Muted; closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 10; closeBtn.BorderSizePixel = 0; closeBtn.Parent = titlebar
	Utils.AddCorner(closeBtn, UDim.new(0,6)); Utils.AddStroke(closeBtn, Theme.Border, 1, 0.93)
	closeBtn.Activated:Connect(function() self:Toggle() end)

	-- Body
	local body = Instance.new("Frame")
	body.Size = UDim2.new(1,0,1,-46-28); body.Position = UDim2.new(0,0,0,46)
	body.BackgroundTransparency = 1; body.BorderSizePixel = 0; body.Parent = main
	self.Body = body

	local sidebarW = isMobile and 90 or 130
	local sidebar = Instance.new("ScrollingFrame")
	sidebar.Size = UDim2.new(0,sidebarW,1,0); sidebar.BackgroundColor3 = Theme.SidebarBg
	sidebar.BorderSizePixel = 0; sidebar.ScrollBarThickness = 0
	sidebar.CanvasSize = UDim2.new(0,0,0,0); sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sidebar.Parent = body
	Utils.AddPadding(sidebar, 10, 10, 6, 6)
	Utils.AddListLayout(sidebar, Enum.FillDirection.Vertical, 2)

	local sideStroke = Instance.new("Frame")
	sideStroke.Size = UDim2.new(0,1,1,0); sideStroke.Position = UDim2.new(1,-1,0,0)
	sideStroke.BackgroundColor3 = Theme.Border; sideStroke.BackgroundTransparency = 0.93
	sideStroke.BorderSizePixel = 0; sideStroke.Parent = sidebar
	self.Sidebar = sidebar

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1,-sidebarW,1,0); content.Position = UDim2.new(0,sidebarW,0,0)
	content.BackgroundTransparency = 1; content.BorderSizePixel = 0
	content.ClipsDescendants = true; content.Parent = body
	self.Content = content

	-- Statusbar
	local statusbar = Instance.new("Frame")
	statusbar.Size = UDim2.new(1,0,0,28); statusbar.Position = UDim2.new(0,0,1,-28)
	statusbar.BackgroundColor3 = Theme.SidebarBg; statusbar.BorderSizePixel = 0
	statusbar.Parent = main
	Utils.MakeLine(statusbar)

	local statusDot = Instance.new("Frame")
	statusDot.Size = UDim2.new(0,6,0,6); statusDot.Position = UDim2.new(0,14,0.5,-3)
	statusDot.BackgroundColor3 = Theme.Green; statusDot.BorderSizePixel = 0
	statusDot.Parent = statusbar
	Utils.AddCorner(statusDot, UDim.new(1,0))

	local statusText = Instance.new("TextLabel")
	statusText.Size = UDim2.new(0,200,1,0); statusText.Position = UDim2.new(0,26,0,0)
	statusText.BackgroundTransparency = 1; statusText.Text = "Connected"
	statusText.TextColor3 = Theme.Muted; statusText.Font = Enum.Font.Gotham
	statusText.TextSize = 11; statusText.TextXAlignment = Enum.TextXAlignment.Left
	statusText.Parent = statusbar
	self.StatusText = statusText

	local brandLabel = Instance.new("TextLabel")
	brandLabel.Size = UDim2.new(0,100,1,0); brandLabel.Position = UDim2.new(1,-110,0,0)
	brandLabel.BackgroundTransparency = 1; brandLabel.Text = "VIONIX HUB"
	brandLabel.TextColor3 = Theme.Muted; brandLabel.Font = Enum.Font.GothamBold
	brandLabel.TextSize = 10; brandLabel.TextXAlignment = Enum.TextXAlignment.Right
	brandLabel.Parent = statusbar

	-- ============================================
	-- RESIZE HANDLE (pojok kiri bawah)
	-- ============================================
	local resizeHandle = Instance.new("TextButton")
	resizeHandle.Size             = UDim2.new(0, 22, 0, 22)
	resizeHandle.Position         = UDim2.new(0, 0, 1, -22)
	resizeHandle.BackgroundColor3 = Theme.Purple
	resizeHandle.BackgroundTransparency = 0.4
	resizeHandle.Text             = "⤡"
	resizeHandle.TextColor3       = Theme.Accent
	resizeHandle.Font             = Enum.Font.GothamBold
	resizeHandle.TextSize         = 13
	resizeHandle.BorderSizePixel  = 0
	resizeHandle.ZIndex           = 10
	resizeHandle.Parent           = main
	Utils.AddCorner(resizeHandle, UDim.new(0, 6))

	local resizing    = false
	local resizeStart, startSz, startPs
	local MIN_W, MIN_H = isMobile and 280 or 320, isMobile and 240 or 280

	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			resizing    = true
			resizeStart = Vector2.new(input.Position.X, input.Position.Y)
			startSz     = Vector2.new(main.AbsoluteSize.X, main.AbsoluteSize.Y)
			startPs     = Vector2.new(main.AbsolutePosition.X, main.AbsolutePosition.Y)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizing and (
			input.UserInputType == Enum.UserInputType.MouseMovement or
			input.UserInputType == Enum.UserInputType.Touch
		) then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - resizeStart
			-- Pojok kiri bawah: lebar melebar ke kiri, tinggi ke bawah
			local newW = math.clamp(startSz.X - delta.X, MIN_W, screenSize.X - 20)
			local newH = math.clamp(startSz.Y + delta.Y, MIN_H, screenSize.Y - 20)
			local newX = math.clamp(startPs.X + (startSz.X - newW), 0, screenSize.X - newW)
			main.Size     = UDim2.new(0, newW, 0, newH)
			main.Position = UDim2.new(0, newX, 0, startPs.Y)
			self.Size     = Vector2.new(newW, newH)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)

	-- ============================================
	-- FLOATING TOGGLE BUTTON (draggable, show/hide)
	-- ============================================
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name             = "VionixToggle"
	toggleBtn.Size             = UDim2.new(0, 44, 0, 44)
	toggleBtn.Position         = UDim2.new(0, 20, 1, -70)
	toggleBtn.BackgroundColor3 = Theme.Purple
	toggleBtn.Text             = "V"
	toggleBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
	toggleBtn.Font             = Enum.Font.GothamBold
	toggleBtn.TextSize         = 18
	toggleBtn.BorderSizePixel  = 0
	toggleBtn.Visible          = false
	toggleBtn.ZIndex           = 99
	toggleBtn.Parent           = gui
	Utils.AddCorner(toggleBtn, UDim.new(1, 0))
	Utils.AddStroke(toggleBtn, Theme.Border, 1.5, 0.75)
	self.ToggleBtn = toggleBtn

	-- Drag toggle button
	local tDragStart, tDragDelta = nil, Vector2.zero
	Utils.SetupDrag(
		toggleBtn,
		function()
			return Vector2.new(toggleBtn.Position.X.Offset, toggleBtn.Position.Y.Offset)
		end,
		function(pos)
			toggleBtn.Position = UDim2.new(0,
				math.clamp(pos.X, 0, screenSize.X - 44), 0,
				math.clamp(pos.Y, 0, screenSize.Y - 44)
			)
		end
	)

	toggleBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			tDragStart = Vector2.new(input.Position.X, input.Position.Y)
			tDragDelta = Vector2.zero
		end
	end)
	toggleBtn.InputChanged:Connect(function(input)
		if tDragStart and (
			input.UserInputType == Enum.UserInputType.MouseMovement or
			input.UserInputType == Enum.UserInputType.Touch
		) then
			tDragDelta = Vector2.new(input.Position.X, input.Position.Y) - tDragStart
		end
	end)
	toggleBtn.Activated:Connect(function()
		if tDragDelta.Magnitude < 6 then
			self:Toggle()
		end
	end)

	-- Drag titlebar
	Utils.SetupDrag(
		titlebar,
		function()
			return Vector2.new(main.Position.X.Offset, main.Position.Y.Offset)
		end,
		function(pos)
			main.Position = UDim2.new(0,
				math.clamp(pos.X, 0, screenSize.X - main.AbsoluteSize.X), 0,
				math.clamp(pos.Y, 0, screenSize.Y - main.AbsoluteSize.Y)
			)
		end
	)

	-- Open animation
	main.Size     = UDim2.new(0, 0, 0, 0)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	TweenService:Create(main, Utils.Spring(0.4, Enum.EasingStyle.Back), {
		Size     = UDim2.new(0, winW, 0, winH),
		Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2),
	}):Play()

	return self
end

function Window:SetStatus(text)
	self.StatusText.Text = text
end

function Window:Toggle()
	self.Visible = not self.Visible
	local main = self.Main

	if not self.Visible then
		TweenService:Create(main, Utils.Spring(0.25), {
			Size     = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
		}):Play()
		task.delay(0.25, function()
			main.Visible = false
			self.ToggleBtn.Visible = true
			self.ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
			TweenService:Create(self.ToggleBtn, Utils.Spring(0.3, Enum.EasingStyle.Back), {
				Size = UDim2.new(0, 44, 0, 44)
			}):Play()
		end)
	else
		TweenService:Create(self.ToggleBtn, Utils.Spring(0.2), {
			Size = UDim2.new(0, 0, 0, 0)
		}):Play()
		task.delay(0.2, function()
			self.ToggleBtn.Visible = false
			main.Visible = true
			local w, h = self.Size.X, self.Size.Y
			TweenService:Create(main, Utils.Spring(0.4, Enum.EasingStyle.Back), {
				Size     = UDim2.new(0, w, 0, h),
				Position = UDim2.new(0.5, -w/2, 0.5, -h/2),
			}):Play()
		end)
	end
end

function Window:Minimize()
	self.Minimized = not self.Minimized
	TweenService:Create(self.Main, Utils.Spring(0.3), {
		Size = self.Minimized
			and UDim2.new(0, self.Size.X, 0, 46)
			or  UDim2.new(0, self.Size.X, 0, self.Size.Y)
	}):Play()
end

function Window:AddTab(name, icon)
	local tab = Tab.new(self, name, icon)
	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then tab:Select() end
	return tab
end

-- ================================================
-- VIONIX HUB - MAIN
-- ================================================
local VionixHub = {}

function VionixHub:CreateWindow(config)
	return Window.new(config)
end

VionixHub.Theme = Theme

return VionixHub

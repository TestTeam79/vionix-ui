-- ================================================
--   VIONIX HUB - UI Library v2.0
--   Style: Charcoal Pink
--   GitHub: github.com/TestTeam79/vionix-ui
-- ================================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ================================================
-- THEME - Style C (Charcoal Pink)
-- ================================================
local Theme = {
	WindowBg    = Color3.fromRGB(24, 24, 24),
	TitleBg     = Color3.fromRGB(31, 31, 31),
	TabBg       = Color3.fromRGB(31, 31, 31),
	Surface     = Color3.fromRGB(28, 28, 28),
	Surface2    = Color3.fromRGB(40, 40, 40),
	Surface3    = Color3.fromRGB(22, 22, 22),
	Border      = Color3.fromRGB(255, 255, 255),
	BorderDark  = Color3.fromRGB(60, 60, 60),
	Pink        = Color3.fromRGB(232, 121, 249),
	PinkHover   = Color3.fromRGB(240, 150, 255),
	PinkClick   = Color3.fromRGB(190, 80, 210),
	PinkDim     = Color3.fromRGB(40, 10, 45),
	Text        = Color3.fromRGB(255, 255, 255),
	TextMid     = Color3.fromRGB(200, 200, 200),
	Muted       = Color3.fromRGB(85, 85, 85),
	Muted2      = Color3.fromRGB(120, 120, 120),
	Green       = Color3.fromRGB(74, 222, 128),
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

function Utils.MakeLine(parent, pos)
	local line = Instance.new("Frame")
	line.Size               = UDim2.new(1, 0, 0, 1)
	line.Position           = pos or UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3   = Theme.BorderDark
	line.BackgroundTransparency = 0
	line.BorderSizePixel    = 0
	line.Parent             = parent
	return line
end

function Utils.IsMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Drag helper — bedain tap vs drag
function Utils.MakeDraggable(handle, getOffset, setOffset)
	local active = false
	local startInput, startOffset

	local function inputPos(input)
		return Vector2.new(input.Position.X, input.Position.Y)
	end

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			active      = true
			startInput  = inputPos(input)
			startOffset = getOffset()
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not active then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local delta = inputPos(input) - startInput
		setOffset(startOffset + delta)
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			active = false
		end
	end)

	-- Return delta magnitude checker untuk bedain tap vs drag
	return function()
		return active
	end
end

-- ================================================
-- TOGGLE
-- ================================================
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(section, name, default, callback)
	local self    = setmetatable({}, Toggle)
	self.Value    = default or false
	self.Callback = callback or function() end

	local row = Instance.new("Frame")
	row.Name             = "Toggle_"..name
	row.Size             = UDim2.new(1, 0, 0, 36)
	row.BackgroundTransparency = 1
	row.BorderSizePixel  = 0
	row.Parent           = section.Body

	local hover = Instance.new("Frame")
	hover.Size             = UDim2.new(1, 0, 1, 0)
	hover.BackgroundColor3 = Color3.fromRGB(255,255,255)
	hover.BackgroundTransparency = 1
	hover.BorderSizePixel  = 0
	hover.Parent           = row

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -56, 1, 0)
	label.Position            = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.TextMid
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 12
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = row

	local track = Instance.new("Frame")
	track.Size             = UDim2.new(0, 34, 0, 18)
	track.Position         = UDim2.new(1, -46, 0.5, -9)
	track.BackgroundColor3 = Theme.Surface2
	track.BorderSizePixel  = 0
	track.Parent           = row
	Utils.AddCorner(track, UDim.new(1, 0))
	Utils.AddStroke(track, Theme.Border, 1, 0.93)
	self.Track = track

	local thumb = Instance.new("Frame")
	thumb.Size             = UDim2.new(0, 12, 0, 12)
	thumb.Position         = UDim2.new(0, 3, 0.5, -6)
	thumb.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
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
		track.BackgroundColor3 = Theme.Pink
		thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		thumb.Position = UDim2.new(0, 19, 0.5, -6)
	end

	btn.MouseEnter:Connect(function()
		TweenService:Create(hover, TweenInfo.new(0.12), {BackgroundTransparency = 0.96}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(hover, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
	end)
	btn.Activated:Connect(function() self:Set(not self.Value) end)

	return self
end

function Toggle:Set(value)
	self.Value = value
	local s = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	if value then
		TweenService:Create(self.Track, s, {BackgroundColor3 = Theme.Pink}):Play()
		TweenService:Create(self.Thumb, s, {
			Position = UDim2.new(0, 19, 0.5, -6),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	else
		TweenService:Create(self.Track, s, {BackgroundColor3 = Theme.Surface2}):Play()
		TweenService:Create(self.Thumb, s, {
			Position = UDim2.new(0, 3, 0.5, -6),
			BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		}):Play()
	end
	self.Callback(value)
end

-- ================================================
-- SLIDER
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
	row.Name             = "Slider_"..name
	row.Size             = UDim2.new(1, 0, 0, 48)
	row.BackgroundTransparency = 1
	row.BorderSizePixel  = 0
	row.Parent           = section.Body

	local topRow = Instance.new("Frame")
	topRow.Size             = UDim2.new(1, -24, 0, 18)
	topRow.Position         = UDim2.new(0, 12, 0, 7)
	topRow.BackgroundTransparency = 1
	topRow.Parent           = row

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -40, 1, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.TextMid
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 12
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = topRow

	local valLabel = Instance.new("TextLabel")
	valLabel.Size             = UDim2.new(0, 36, 1, 0)
	valLabel.Position         = UDim2.new(1, -36, 0, 0)
	valLabel.BackgroundColor3 = Theme.PinkDim
	valLabel.Text             = tostring(self.Value)
	valLabel.TextColor3       = Theme.Pink
	valLabel.Font             = Enum.Font.GothamBold
	valLabel.TextSize         = 10
	valLabel.Parent           = topRow
	Utils.AddCorner(valLabel, UDim.new(0, 4))
	self.ValLabel = valLabel

	local trackBg = Instance.new("Frame")
	trackBg.Size             = UDim2.new(1, -24, 0, 3)
	trackBg.Position         = UDim2.new(0, 12, 0, 34)
	trackBg.BackgroundColor3 = Theme.Surface2
	trackBg.BorderSizePixel  = 0
	trackBg.Parent           = row
	Utils.AddCorner(trackBg, UDim.new(1, 0))
	self.TrackBg = trackBg

	local fill = Instance.new("Frame")
	fill.Size             = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Theme.Pink
	fill.BorderSizePixel  = 0
	fill.Parent           = trackBg
	Utils.AddCorner(fill, UDim.new(1, 0))
	self.Fill = fill

	local thumb = Instance.new("Frame")
	thumb.Size             = UDim2.new(0, 12, 0, 12)
	thumb.Position         = UDim2.new(0, -6, 0.5, -6)
	thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	thumb.BorderSizePixel  = 0
	thumb.ZIndex           = 2
	thumb.Parent           = trackBg
	Utils.AddCorner(thumb, UDim.new(1, 0))
	Utils.AddStroke(thumb, Theme.Pink, 2, 0)
	self.Thumb = thumb

	local dragBtn = Instance.new("TextButton")
	dragBtn.Size                  = UDim2.new(1, 0, 0, 48)
	dragBtn.Position              = UDim2.new(0, 0, 0, -22)
	dragBtn.BackgroundTransparency = 1
	dragBtn.Text                  = ""
	dragBtn.ZIndex                = 3
	dragBtn.Parent                = trackBg

	local function updateFromX(x)
		local a = math.clamp((x - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
		self:Set(math.round(self.Min + (self.Max - self.Min) * a))
	end

	dragBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			self.Dragging = true
			updateFromX(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not self.Dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
			updateFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			self.Dragging = false
		end
	end)

	self:Set(self.Value, true)
	return self
end

function Slider:Set(value, silent)
	self.Value = math.clamp(math.round(value), self.Min, self.Max)
	local a = (self.Value - self.Min) / (self.Max - self.Min)
	self.Fill.Size      = UDim2.new(a, 0, 1, 0)
	self.Thumb.Position = UDim2.new(a, -6, 0.5, -6)
	self.ValLabel.Text  = tostring(self.Value)
	if not silent then self.Callback(self.Value) end
end

-- ================================================
-- BUTTON
-- ================================================
local Button = {}
Button.__index = Button

function Button.new(section, name, callback)
	local self    = setmetatable({}, Button)
	self.Callback = callback or function() end

	local row = Instance.new("Frame")
	row.Name             = "Button_"..name
	row.Size             = UDim2.new(1, 0, 0, 36)
	row.BackgroundTransparency = 1
	row.BorderSizePixel  = 0
	row.Parent           = section.Body

	local hover = Instance.new("Frame")
	hover.Size             = UDim2.new(1, 0, 1, 0)
	hover.BackgroundColor3 = Color3.fromRGB(255,255,255)
	hover.BackgroundTransparency = 1
	hover.BorderSizePixel  = 0
	hover.Parent           = row

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -90, 1, 0)
	label.Position            = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.TextMid
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 12
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = row

	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(0, 64, 0, 22)
	btn.Position         = UDim2.new(1, -76, 0.5, -11)
	btn.BackgroundColor3 = Theme.Pink
	btn.Text             = "Execute"
	btn.TextColor3       = Color3.fromRGB(26, 0, 26)
	btn.Font             = Enum.Font.GothamBold
	btn.TextSize         = 10
	btn.BorderSizePixel  = 0
	btn.AutoButtonColor  = false
	btn.Parent           = row
	Utils.AddCorner(btn, UDim.new(0, 4))
	self.Btn = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(hover, TweenInfo.new(0.12), {BackgroundTransparency = 0.96}):Play()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Theme.PinkHover}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(hover, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Theme.Pink}):Play()
	end)
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08), {
			BackgroundColor3 = Theme.PinkClick,
			Size = UDim2.new(0, 61, 0, 20)
		}):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
			BackgroundColor3 = Theme.PinkHover,
			Size = UDim2.new(0, 64, 0, 22)
		}):Play()
	end)
	btn.Activated:Connect(function() self.Callback() end)

	return self
end

-- ================================================
-- DROPDOWN
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
	row.Name             = "Dropdown_"..name
	row.Size             = UDim2.new(1, 0, 0, 36)
	row.BackgroundTransparency = 1
	row.ClipsDescendants = false
	row.BorderSizePixel  = 0
	row.ZIndex           = 5
	row.Parent           = section.Body
	self.Row = row

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -130, 1, 0)
	label.Position            = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.TextMid
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 12
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = row

	local dropBtn = Instance.new("TextButton")
	dropBtn.Size             = UDim2.new(0, 106, 0, 22)
	dropBtn.Position         = UDim2.new(1, -118, 0.5, -11)
	dropBtn.BackgroundColor3 = Theme.Surface2
	dropBtn.Text             = ""
	dropBtn.BorderSizePixel  = 0
	dropBtn.AutoButtonColor  = false
	dropBtn.ZIndex           = 5
	dropBtn.Parent           = row
	Utils.AddCorner(dropBtn, UDim.new(0, 5))
	Utils.AddStroke(dropBtn, Theme.Border, 1, 0.92)

	local selLabel = Instance.new("TextLabel")
	selLabel.Size                = UDim2.new(1, -20, 1, 0)
	selLabel.Position            = UDim2.new(0, 7, 0, 0)
	selLabel.BackgroundTransparency = 1
	selLabel.Text                = self.Value
	selLabel.TextColor3          = Theme.TextMid
	selLabel.Font                = Enum.Font.Gotham
	selLabel.TextSize            = 11
	selLabel.TextXAlignment      = Enum.TextXAlignment.Left
	selLabel.ZIndex              = 6
	selLabel.Parent              = dropBtn
	self.SelectedLabel = selLabel

	local arrow = Instance.new("TextLabel")
	arrow.Size                = UDim2.new(0, 14, 1, 0)
	arrow.Position            = UDim2.new(1, -16, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text                = "▾"
	arrow.TextColor3          = Theme.Muted2
	arrow.Font                = Enum.Font.Gotham
	arrow.TextSize            = 11
	arrow.ZIndex              = 6
	arrow.Parent              = dropBtn
	self.Arrow = arrow

	local panel = Instance.new("Frame")
	panel.Size             = UDim2.new(0, 106, 0, 0)
	panel.Position         = UDim2.new(1, -118, 0, 26)
	panel.BackgroundColor3 = Theme.Surface3
	panel.BorderSizePixel  = 0
	panel.ClipsDescendants = true
	panel.ZIndex           = 10
	panel.Parent           = row
	Utils.AddCorner(panel, UDim.new(0, 5))
	Utils.AddStroke(panel, Theme.Pink, 1, 0.7)
	Utils.AddPadding(panel, 3, 3, 0, 0)
	Utils.AddListLayout(panel, Enum.FillDirection.Vertical, 0)
	self.Panel = panel

	for _, opt in ipairs(self.Options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size             = UDim2.new(1, 0, 0, 26)
		optBtn.BackgroundTransparency = 1
		optBtn.Text             = opt
		optBtn.TextColor3       = opt == self.Value and Theme.Pink or Theme.Muted2
		optBtn.Font             = opt == self.Value and Enum.Font.GothamBold or Enum.Font.Gotham
		optBtn.TextSize         = 11
		optBtn.BorderSizePixel  = 0
		optBtn.ZIndex           = 11
		optBtn.Parent           = panel
		optBtn.MouseEnter:Connect(function()
			TweenService:Create(optBtn, TweenInfo.new(0.1), {
				BackgroundTransparency = 0.85, BackgroundColor3 = Theme.Pink
			}):Play()
		end)
		optBtn.MouseLeave:Connect(function()
			TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
		end)
		optBtn.Activated:Connect(function() self:Set(opt); self:Close() end)
	end

	dropBtn.Activated:Connect(function()
		if self.Open then self:Close() else self:OpenPanel() end
	end)

	return self
end

function Dropdown:OpenPanel()
	self.Open = true
	TweenService:Create(self.Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
		Size = UDim2.new(0, 106, 0, #self.Options * 26 + 6)
	}):Play()
	TweenService:Create(self.Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
end

function Dropdown:Close()
	self.Open = false
	TweenService:Create(self.Panel, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
		Size = UDim2.new(0, 106, 0, 0)
	}):Play()
	TweenService:Create(self.Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
end

function Dropdown:Set(value)
	self.Value = value
	self.SelectedLabel.Text = value
	self.Callback(value)
end

-- ================================================
-- TEXTINPUT
-- ================================================
local TextInput = {}
TextInput.__index = TextInput

function TextInput.new(section, name, placeholder, callback)
	local self    = setmetatable({}, TextInput)
	self.Value    = ""
	self.Callback = callback or function() end

	local row = Instance.new("Frame")
	row.Name             = "TextInput_"..name
	row.Size             = UDim2.new(1, 0, 0, 36)
	row.BackgroundTransparency = 1
	row.BorderSizePixel  = 0
	row.Parent           = section.Body

	local label = Instance.new("TextLabel")
	label.Size                = UDim2.new(1, -140, 1, 0)
	label.Position            = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text                = name
	label.TextColor3          = Theme.TextMid
	label.Font                = Enum.Font.Gotham
	label.TextSize            = 12
	label.TextXAlignment      = Enum.TextXAlignment.Left
	label.Parent              = row

	local box = Instance.new("TextBox")
	box.Size             = UDim2.new(0, 116, 0, 22)
	box.Position         = UDim2.new(1, -128, 0.5, -11)
	box.BackgroundColor3 = Theme.Surface2
	box.Text             = ""
	box.PlaceholderText  = placeholder or "Enter..."
	box.PlaceholderColor3 = Theme.Muted
	box.TextColor3       = Theme.Text
	box.Font             = Enum.Font.Gotham
	box.TextSize         = 11
	box.BorderSizePixel  = 0
	box.ClearTextOnFocus = false
	box.Parent           = row
	Utils.AddCorner(box, UDim.new(0, 5))
	Utils.AddStroke(box, Theme.Border, 1, 0.92)
	Utils.AddPadding(box, 0, 0, 7, 7)
	self.Box = box

	box.Focused:Connect(function()
		TweenService:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 10, 45)}):Play()
		for _, v in ipairs(box:GetChildren()) do
			if v:IsA("UIStroke") then
				TweenService:Create(v, TweenInfo.new(0.15), {Color = Theme.Pink, Transparency = 0.3}):Play()
			end
		end
	end)
	box.FocusLost:Connect(function(enter)
		self.Value = box.Text
		TweenService:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Surface2}):Play()
		for _, v in ipairs(box:GetChildren()) do
			if v:IsA("UIStroke") then
				TweenService:Create(v, TweenInfo.new(0.15), {Color = Color3.fromRGB(255,255,255), Transparency = 0.92}):Play()
			end
		end
		if enter then self.Callback(self.Value) end
	end)

	return self
end

function TextInput:Set(v) self.Value = v; self.Box.Text = v end
function TextInput:Get() return self.Value end

-- ================================================
-- SECTION
-- ================================================
local Section = {}
Section.__index = Section

function Section.new(tab, name)
	local self = setmetatable({}, Section)

	local frame = Instance.new("Frame")
	frame.Name             = "Section_"..name
	frame.Size             = UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize    = Enum.AutomaticSize.Y
	frame.BackgroundColor3 = Theme.Surface
	frame.BorderSizePixel  = 0
	frame.Parent           = tab.ContentFrame
	Utils.AddCorner(frame, UDim.new(0, 8))
	Utils.AddStroke(frame, Theme.Border, 1, 0.93)

	-- Section header dengan pink accent line
	local header = Instance.new("Frame")
	header.Size             = UDim2.new(1, 0, 0, 28)
	header.BackgroundColor3 = Theme.TitleBg
	header.BorderSizePixel  = 0
	header.Parent           = frame
	Utils.AddCorner(header, UDim.new(0, 8))

	-- Fix rounded corner bawah header
	local fix = Instance.new("Frame")
	fix.Size             = UDim2.new(1, 0, 0, 8)
	fix.Position         = UDim2.new(0, 0, 1, -8)
	fix.BackgroundColor3 = Theme.TitleBg
	fix.BorderSizePixel  = 0
	fix.Parent           = header

	-- Pink accent line kiri
	local accent = Instance.new("Frame")
	accent.Size             = UDim2.new(0, 2, 0, 14)
	accent.Position         = UDim2.new(0, 0, 0.5, -7)
	accent.BackgroundColor3 = Theme.Pink
	accent.BorderSizePixel  = 0
	accent.Parent           = header
	Utils.AddCorner(accent, UDim.new(1, 0))

	-- Garis bawah header
	local line = Instance.new("Frame")
	line.Size               = UDim2.new(1, 0, 0, 1)
	line.Position           = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3   = Theme.Pink
	line.BackgroundTransparency = 0.8
	line.BorderSizePixel    = 0
	line.Parent             = header

	local headerLabel = Instance.new("TextLabel")
	headerLabel.Size                = UDim2.new(1, 0, 1, 0)
	headerLabel.BackgroundTransparency = 1
	headerLabel.Text                = string.upper(name)
	headerLabel.TextColor3          = Theme.Muted2
	headerLabel.Font                = Enum.Font.GothamBold
	headerLabel.TextSize            = 9
	headerLabel.Parent              = header
	Utils.AddPadding(header, 0, 0, 10, 0)

	local body = Instance.new("Frame")
	body.Name           = "Body"
	body.Size           = UDim2.new(1, 0, 0, 0)
	body.Position       = UDim2.new(0, 0, 0, 28)
	body.AutomaticSize  = Enum.AutomaticSize.Y
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.Parent         = frame
	Utils.AddListLayout(body, Enum.FillDirection.Vertical, 0)
	self.Body = body

	return self
end

function Section:AddToggle(n, d, c)    return Toggle.new(self, n, d, c) end
function Section:AddSlider(n, a, b, d, c) return Slider.new(self, n, a, b, d, c) end
function Section:AddButton(n, c)       return Button.new(self, n, c) end
function Section:AddDropdown(n, o, d, c) return Dropdown.new(self, n, o, d, c) end
function Section:AddTextInput(n, p, c) return TextInput.new(self, n, p, c) end
function Section:AddLabel(text)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, 0, 0, 30)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Theme.Muted2
	l.Font = Enum.Font.Gotham
	l.TextSize = 11
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = self.Body
	Utils.AddPadding(l, 0, 0, 12, 12)
	return l
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

	-- Tab button di tab bar (atas)
	local btn = Instance.new("TextButton")
	btn.Name                  = "Tab_"..name
	btn.Size                  = UDim2.new(0, 0, 1, 0)
	btn.AutomaticSize         = Enum.AutomaticSize.X
	btn.BackgroundTransparency = 1
	btn.Text                  = ""
	btn.BorderSizePixel       = 0
	btn.AutoButtonColor       = false
	btn.Parent                = window.TabBar
	self.Button = btn

	-- Tab content (icon + label)
	local inner = Instance.new("Frame")
	inner.Size             = UDim2.new(1, 0, 1, 0)
	inner.BackgroundTransparency = 1
	inner.Parent           = btn
	Utils.AddPadding(inner, 0, 0, 10, 10)

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = inner

	if icon then
		local ic = Instance.new("TextLabel")
		ic.Size = UDim2.new(0, 14, 0, 14)
		ic.BackgroundTransparency = 1
		ic.Text = icon
		ic.TextColor3 = Theme.Muted
		ic.Font = Enum.Font.GothamBold
		ic.TextSize = 12
		ic.LayoutOrder = 1
		ic.Parent = inner
		self.Icon = ic
	end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 0, 1, 0)
	label.AutomaticSize = Enum.AutomaticSize.X
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Theme.Muted
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.LayoutOrder = 2
	label.Parent = inner
	self.Label = label

	-- Active underline
	local underline = Instance.new("Frame")
	underline.Size             = UDim2.new(1, -16, 0, 2)
	underline.Position         = UDim2.new(0, 8, 1, -2)
	underline.BackgroundColor3 = Theme.Pink
	underline.BackgroundTransparency = 1
	underline.BorderSizePixel  = 0
	underline.Parent           = btn
	Utils.AddCorner(underline, UDim.new(1, 0))
	self.Underline = underline

	-- Content frame
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Size                = UDim2.new(1, 0, 1, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel     = 0
	contentFrame.ScrollBarThickness  = 2
	contentFrame.ScrollBarImageColor3 = Theme.Pink
	contentFrame.CanvasSize          = UDim2.new(0, 0, 0, 0)
	contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentFrame.Visible             = false
	contentFrame.Parent              = window.Content
	Utils.AddPadding(contentFrame, 10, 10, 10, 10)
	Utils.AddListLayout(contentFrame, Enum.FillDirection.Vertical, 8)
	self.ContentFrame = contentFrame

	btn.Activated:Connect(function() self:Select() end)
	btn.MouseEnter:Connect(function()
		if self.Selected then return end
		TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = Theme.TextMid}):Play()
	end)
	btn.MouseLeave:Connect(function()
		if self.Selected then return end
		TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = Theme.Muted}):Play()
	end)

	return self
end

function Tab:Select()
	for _, t in ipairs(self.Window.Tabs) do
		if t ~= self then t:Deselect() end
	end
	self.Selected = true
	self.Window.ActiveTab = self
	self.ContentFrame.Visible = true
	TweenService:Create(self.Label, TweenInfo.new(0.15), {TextColor3 = Theme.Pink}):Play()
	TweenService:Create(self.Underline, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
	if self.Icon then
		TweenService:Create(self.Icon, TweenInfo.new(0.15), {TextColor3 = Theme.Pink}):Play()
	end
end

function Tab:Deselect()
	self.Selected = false
	self.ContentFrame.Visible = false
	TweenService:Create(self.Label, TweenInfo.new(0.15), {TextColor3 = Theme.Muted}):Play()
	TweenService:Create(self.Underline, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
	if self.Icon then
		TweenService:Create(self.Icon, TweenInfo.new(0.15), {TextColor3 = Theme.Muted}):Play()
	end
end

function Tab:AddSection(name)
	local s = Section.new(self, name)
	table.insert(self.Sections, s)
	return s
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
	self.SubTitle  = config.SubTitle or "v2.0.0"
	self.Tabs      = {}
	self.ActiveTab = nil
	self.Minimized = false
	self.Visible   = true

	local screen    = workspace.CurrentCamera.ViewportSize
	local isMobile  = Utils.IsMobile()
	local winW = isMobile and math.min(screen.X - 20, 380) or math.min(screen.X - 40, 560)
	local winH = isMobile and math.min(screen.Y - 50, 360) or math.min(screen.Y - 80, 420)
	self.Size = Vector2.new(winW, winH)

	local gui = Instance.new("ScreenGui")
	gui.Name           = "VionixHub"
	gui.ResetOnSpawn   = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.IgnoreGuiInset = true
	gui.Parent         = game:GetService("CoreGui")
	self.Gui = gui

	-- Main frame
	local main = Instance.new("Frame")
	main.Name             = "Main"
	main.Size             = UDim2.new(0, winW, 0, winH)
	main.Position         = UDim2.new(0.5, -winW/2, 0.5, -winH/2)
	main.BackgroundColor3 = Theme.WindowBg
	main.BorderSizePixel  = 0
	main.ClipsDescendants = true
	main.Parent           = gui
	Utils.AddCorner(main, UDim.new(0, 12))
	Utils.AddStroke(main, Theme.BorderDark, 1, 0)
	self.Main = main

	-- Pink top border accent
	local topAccent = Instance.new("Frame")
	topAccent.Size             = UDim2.new(1, 0, 0, 2)
	topAccent.BackgroundColor3 = Theme.Pink
	topAccent.BorderSizePixel  = 0
	topAccent.ZIndex           = 2
	topAccent.Parent           = main

	-- Titlebar
	local titlebar = Instance.new("Frame")
	titlebar.Size             = UDim2.new(1, 0, 0, 42)
	titlebar.BackgroundColor3 = Theme.TitleBg
	titlebar.BorderSizePixel  = 0
	titlebar.Parent           = main
	Utils.MakeLine(titlebar)

	local logo = Instance.new("Frame")
	logo.Size             = UDim2.new(0, 26, 0, 26)
	logo.Position         = UDim2.new(0, 10, 0.5, -13)
	logo.BackgroundColor3 = Theme.Pink
	logo.BorderSizePixel  = 0
	logo.Parent           = titlebar
	Utils.AddCorner(logo, UDim.new(0, 5))

	local logoTxt = Instance.new("TextLabel")
	logoTxt.Size = UDim2.new(1,0,1,0); logoTxt.BackgroundTransparency = 1
	logoTxt.Text = "V"; logoTxt.TextColor3 = Color3.fromRGB(26,0,26)
	logoTxt.Font = Enum.Font.GothamBold; logoTxt.TextSize = 13
	logoTxt.Parent = logo

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(0,180,0,16); titleLbl.Position = UDim2.new(0,44,0,7)
	titleLbl.BackgroundTransparency = 1; titleLbl.Text = self.Title
	titleLbl.TextColor3 = Theme.Text; titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 12; titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = titlebar

	local subLbl = Instance.new("TextLabel")
	subLbl.Size = UDim2.new(0,180,0,12); subLbl.Position = UDim2.new(0,44,0,23)
	subLbl.BackgroundTransparency = 1; subLbl.Text = self.SubTitle
	subLbl.TextColor3 = Theme.Muted; subLbl.Font = Enum.Font.Gotham
	subLbl.TextSize = 9; subLbl.TextXAlignment = Enum.TextXAlignment.Left
	subLbl.Parent = titlebar

	-- Control buttons
	local function makeCtrl(xOff, txt, color)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0,20,0,20); b.Position = UDim2.new(1,xOff,0.5,-10)
		b.BackgroundColor3 = Theme.Surface2; b.Text = txt
		b.TextColor3 = Theme.Muted; b.Font = Enum.Font.GothamBold
		b.TextSize = 9; b.BorderSizePixel = 0; b.Parent = titlebar
		Utils.AddCorner(b, UDim.new(0,5))
		Utils.AddStroke(b, Theme.Border, 1, 0.92)
		b.MouseEnter:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = color or Theme.Surface2}):Play()
		end)
		b.MouseLeave:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Surface2}):Play()
		end)
		return b
	end

	local minBtn   = makeCtrl(-54, "–", Color3.fromRGB(50,50,50))
	local closeBtn = makeCtrl(-30, "✕", Color3.fromRGB(80,20,20))
	minBtn.Activated:Connect(function() self:Minimize() end)
	closeBtn.Activated:Connect(function() self:Toggle() end)

	-- Tab bar (di bawah titlebar)
	local tabBar = Instance.new("ScrollingFrame")
	tabBar.Name                  = "TabBar"
	tabBar.Size                  = UDim2.new(1, 0, 0, 30)
	tabBar.Position              = UDim2.new(0, 0, 0, 42)
	tabBar.BackgroundColor3      = Theme.TabBg
	tabBar.BorderSizePixel       = 0
	tabBar.ScrollBarThickness    = 0
	tabBar.CanvasSize            = UDim2.new(0, 0, 0, 0)
	tabBar.AutomaticCanvasSize   = Enum.AutomaticSize.X
	tabBar.ScrollingDirection    = Enum.ScrollingDirection.X
	tabBar.Parent                = main
	Utils.MakeLine(tabBar)

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection      = Enum.FillDirection.Horizontal
	tabLayout.VerticalAlignment  = Enum.VerticalAlignment.Center
	tabLayout.SortOrder          = Enum.SortOrder.LayoutOrder
	tabLayout.Padding            = UDim.new(0, 0)
	tabLayout.Parent             = tabBar
	self.TabBar = tabBar

	-- Content area
	local content = Instance.new("Frame")
	content.Name             = "Content"
	content.Size             = UDim2.new(1, 0, 1, -42 -30 -24)
	content.Position         = UDim2.new(0, 0, 0, 72)
	content.BackgroundTransparency = 1
	content.BorderSizePixel  = 0
	content.ClipsDescendants = true
	content.Parent           = main
	self.Content = content

	-- Statusbar
	local statusbar = Instance.new("Frame")
	statusbar.Size             = UDim2.new(1, 0, 0, 24)
	statusbar.Position         = UDim2.new(0, 0, 1, -24)
	statusbar.BackgroundColor3 = Theme.TitleBg
	statusbar.BorderSizePixel  = 0
	statusbar.Parent           = main

	local statusLine = Instance.new("Frame")
	statusLine.Size = UDim2.new(1,0,0,1)
	statusLine.BackgroundColor3 = Theme.Pink
	statusLine.BackgroundTransparency = 0.8
	statusLine.BorderSizePixel = 0
	statusLine.Parent = statusbar

	local statusDot = Instance.new("Frame")
	statusDot.Size = UDim2.new(0,5,0,5); statusDot.Position = UDim2.new(0,10,0.5,-2.5)
	statusDot.BackgroundColor3 = Theme.Green; statusDot.BorderSizePixel = 0
	statusDot.Parent = statusbar
	Utils.AddCorner(statusDot, UDim.new(1,0))

	local statusTxt = Instance.new("TextLabel")
	statusTxt.Size = UDim2.new(0,200,1,0); statusTxt.Position = UDim2.new(0,20,0,0)
	statusTxt.BackgroundTransparency = 1; statusTxt.Text = "Connected"
	statusTxt.TextColor3 = Theme.Muted; statusTxt.Font = Enum.Font.Gotham
	statusTxt.TextSize = 9; statusTxt.TextXAlignment = Enum.TextXAlignment.Left
	statusTxt.Parent = statusbar
	self.StatusText = statusTxt

	local brand = Instance.new("TextLabel")
	brand.Size = UDim2.new(0,90,1,0); brand.Position = UDim2.new(1,-98,0,0)
	brand.BackgroundTransparency = 1; brand.Text = "VIONIX HUB"
	brand.TextColor3 = Theme.Muted; brand.Font = Enum.Font.GothamBold
	brand.TextSize = 8; brand.TextXAlignment = Enum.TextXAlignment.Right
	brand.Parent = statusbar

	-- ==========================================
	-- RESIZE HANDLE — pojok KANAN bawah
	-- ==========================================
	local resizeHandle = Instance.new("TextButton")
	resizeHandle.Size             = UDim2.new(0, 20, 0, 20)
	resizeHandle.Position         = UDim2.new(1, -20, 1, -20)
	resizeHandle.BackgroundColor3 = Theme.Pink
	resizeHandle.BackgroundTransparency = 0.5
	resizeHandle.Text             = "⤢"
	resizeHandle.TextColor3       = Color3.fromRGB(26, 0, 26)
	resizeHandle.Font             = Enum.Font.GothamBold
	resizeHandle.TextSize         = 11
	resizeHandle.BorderSizePixel  = 0
	resizeHandle.ZIndex           = 10
	resizeHandle.Parent           = main
	Utils.AddCorner(resizeHandle, UDim.new(0, 4))

	local resizing = false
	local rStart, rSize, rPos
	local MIN_W = isMobile and 260 or 300
	local MIN_H = isMobile and 220 or 260

	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			rStart   = Vector2.new(input.Position.X, input.Position.Y)
			rSize    = Vector2.new(main.AbsoluteSize.X, main.AbsoluteSize.Y)
			rPos     = Vector2.new(main.AbsolutePosition.X, main.AbsolutePosition.Y)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not resizing then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local delta = Vector2.new(input.Position.X, input.Position.Y) - rStart
		local newW  = math.clamp(rSize.X + delta.X, MIN_W, screen.X - 20)
		local newH  = math.clamp(rSize.Y + delta.Y, MIN_H, screen.Y - 20)
		main.Size     = UDim2.new(0, newW, 0, newH)
		self.Size     = Vector2.new(newW, newH)
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)

	-- ==========================================
	-- DRAG TITLEBAR — mulus, tidak kabur
	-- ==========================================
	local dragActive = false
	local dragStart, dragPos

	titlebar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragActive = true
			dragStart  = Vector2.new(input.Position.X, input.Position.Y)
			dragPos    = Vector2.new(main.Position.X.Offset, main.Position.Y.Offset)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragActive then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
		local newX  = math.clamp(dragPos.X + delta.X, 0, screen.X - main.AbsoluteSize.X)
		local newY  = math.clamp(dragPos.Y + delta.Y, 0, screen.Y - main.AbsoluteSize.Y)
		main.Position = UDim2.new(0, newX, 0, newY)
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragActive = false
		end
	end)

	-- ==========================================
	-- TOGGLE BUTTON — floating, draggable, keren
	-- ==========================================
	local toggleBtn = Instance.new("Frame")
	toggleBtn.Name             = "VionixToggle"
	toggleBtn.Size             = UDim2.new(0, 42, 0, 42)
	toggleBtn.Position         = UDim2.new(0, 16, 1, -66)
	toggleBtn.BackgroundColor3 = Theme.TitleBg
	toggleBtn.BorderSizePixel  = 0
	toggleBtn.Visible          = false
	toggleBtn.ZIndex           = 99
	toggleBtn.Parent           = gui
	Utils.AddCorner(toggleBtn, UDim.new(0, 10))
	Utils.AddStroke(toggleBtn, Theme.Pink, 1.5, 0.3)
	self.ToggleBtn = toggleBtn

	-- Pink gradient top strip
	local btnAccent = Instance.new("Frame")
	btnAccent.Size             = UDim2.new(1, 0, 0, 2)
	btnAccent.BackgroundColor3 = Theme.Pink
	btnAccent.BorderSizePixel  = 0
	btnAccent.ZIndex           = 100
	btnAccent.Parent           = toggleBtn
	Utils.AddCorner(btnAccent, UDim.new(0, 10))

	-- Hamburger icon (3 lines)
	for i = 1, 3 do
		local bar = Instance.new("Frame")
		bar.Size             = UDim2.new(0, i == 2 and 14 or 18, 0, 2)
		bar.Position         = UDim2.new(0.5, i == 2 and -7 or -9, 0, 10 + (i-1) * 7)
		bar.BackgroundColor3 = i == 2 and Theme.Pink or Theme.TextMid
		bar.BorderSizePixel  = 0
		bar.ZIndex           = 100
		bar.Parent           = toggleBtn
		Utils.AddCorner(bar, UDim.new(1, 0))
	end

	-- Clickable layer
	local btnClick = Instance.new("TextButton")
	btnClick.Size                  = UDim2.new(1, 0, 1, 0)
	btnClick.BackgroundTransparency = 1
	btnClick.Text                  = ""
	btnClick.ZIndex                = 101
	btnClick.Parent                = toggleBtn

	-- Drag toggle button
	local tbDragActive = false
	local tbDragStart, tbDragPos
	local tbMoved = false

	btnClick.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			tbDragActive = true
			tbMoved      = false
			tbDragStart  = Vector2.new(input.Position.X, input.Position.Y)
			tbDragPos    = Vector2.new(toggleBtn.Position.X.Offset, toggleBtn.Position.Y.Offset)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not tbDragActive then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local delta = Vector2.new(input.Position.X, input.Position.Y) - tbDragStart
		if delta.Magnitude > 5 then tbMoved = true end
		local newX = math.clamp(tbDragPos.X + delta.X, 0, screen.X - 42)
		local newY = math.clamp(tbDragPos.Y + delta.Y, 0, screen.Y - 42)
		toggleBtn.Position = UDim2.new(0, newX, 0, newY)
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			tbDragActive = false
		end
	end)

	btnClick.Activated:Connect(function()
		if not tbMoved then self:Toggle() end
	end)

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
		TweenService:Create(main, Utils.Spring(0.2), {
			Size     = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
		}):Play()
		task.delay(0.2, function()
			main.Visible = false
			self.ToggleBtn.Visible = true
			self.ToggleBtn.Size = UDim2.new(0, 0, 0, 0)
			TweenService:Create(self.ToggleBtn, Utils.Spring(0.3, Enum.EasingStyle.Back), {
				Size = UDim2.new(0, 42, 0, 42)
			}):Play()
		end)
	else
		TweenService:Create(self.ToggleBtn, Utils.Spring(0.15), {
			Size = UDim2.new(0, 0, 0, 0)
		}):Play()
		task.delay(0.15, function()
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
			and UDim2.new(0, self.Size.X, 0, 42)
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

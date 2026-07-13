local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}

-- İnternet Trendi Ultra-Sleek Mat Karanlık Temalar
local Themes = {
    Blood = {
        MainBg = Color3.fromRGB(15, 10, 10), TopBg = Color3.fromRGB(22, 12, 12),
        TabBg = Color3.fromRGB(12, 7, 7), ElementBg = Color3.fromRGB(25, 14, 14),
        HoverBg = Color3.fromRGB(38, 18, 18), Text = Color3.fromRGB(255, 230, 230),
        Accent = Color3.fromRGB(235, 45, 45), Outline = Color3.fromRGB(50, 25, 25)
    },
    Dark = {
        MainBg = Color3.fromRGB(18, 18, 18), TopBg = Color3.fromRGB(24, 24, 24),
        TabBg = Color3.fromRGB(14, 14, 14), ElementBg = Color3.fromRGB(28, 28, 28),
        HoverBg = Color3.fromRGB(38, 38, 38), Text = Color3.fromRGB(245, 245, 245),
        Accent = Color3.fromRGB(0, 165, 255), Outline = Color3.fromRGB(45, 45, 45)
    }
}

local function Tween(instance, properties, duration, style, dir)
    local tweenInfo = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function GetSafeGui()
    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    local success = pcall(function() gui.Parent = CoreGui end)
    if not success then gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    return gui
end

-- === BİLDİRİM SİSTEMİ ===
local NotifGui = GetSafeGui()
NotifGui.Name = "SleekUI_Notifications"

local NotifContainer = Instance.new("Frame", NotifGui)
NotifContainer.Size = UDim2.new(0, 300, 1, -20)
NotifContainer.Position = UDim2.new(1, -320, 0, 10)
NotifContainer.BackgroundTransparency = 1

local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 8)

function Library:Notify(title, text, duration)
    duration = duration or 3
    local theme = Themes.Dark
    
    local NotifFrame = Instance.new("CanvasGroup", NotifContainer)
    NotifFrame.Size = UDim2.new(1, 0, 0, 65)
    NotifFrame.BackgroundColor3 = theme.MainBg
    NotifFrame.GroupTransparency = 1
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", NotifFrame)
    Stroke.Color = theme.Outline
    Stroke.Thickness = 1
    
    local Marker = Instance.new("Frame", NotifFrame)
    Marker.Size = UDim2.new(0, 3, 1, 0)
    Marker.BackgroundColor3 = theme.Accent
    Marker.BorderSizePixel = 0

    local TitleLbl = Instance.new("TextLabel", NotifFrame)
    TitleLbl.Size = UDim2.new(1, -20, 0, 22)
    TitleLbl.Position = UDim2.new(0, 15, 0, 6)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.TextColor3 = theme.Text
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 13
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local TextLbl = Instance.new("TextLabel", NotifFrame)
    TextLbl.Size = UDim2.new(1, -20, 0, 30)
    TextLbl.Position = UDim2.new(0, 15, 0, 26)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    TextLbl.Font = Enum.Font.GothamMedium
    TextLbl.TextSize = 11
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.TextWrapped = true

    Tween(NotifFrame, {GroupTransparency = 0}, 0.25)
    
    task.spawn(function()
        task.wait(duration)
        local out = Tween(NotifFrame, {GroupTransparency = 1}, 0.25)
        out.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

-- === ANA PANEL ===
function Library.CreateLib(titleText, themeName, toggleKey)
    local theme = Themes[themeName] or Themes.Dark
    toggleKey = toggleKey or Enum.KeyCode.RightShift
    
    local Window = {}
    local ScreenGui = GetSafeGui()
    ScreenGui.Name = "SleekMainUI"

    -- Merkezleme için AnchorPoint (0.5, 0.5) yapıldı
    local MainFrame = Instance.new("CanvasGroup", ScreenGui)
    MainFrame.Size = UDim2.new(0, 560, 0, 380)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = theme.MainBg
    MainFrame.GroupTransparency = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = theme.Outline
    MainStroke.Thickness = 1

    -- BOZULMAYI ÖSLEYEN ULTRA MODERN TOP-TIER SİSTEM: UIScale
    local UiScale = Instance.new("UIScale", MainFrame)
    UiScale.Scale = 0

    -- Giriş Animasyonu (Hafif büyüme ve netleşme)
    Tween(UiScale, {Scale = 1}, 0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    local Topbar = Instance.new("Frame", MainFrame)
    Topbar.Size = UDim2.new(1, 0, 0, 38)
    Topbar.BackgroundColor3 = theme.TopBg
    Topbar.BorderSizePixel = 0

    local Line = Instance.new("Frame", Topbar)
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 1, -1)
    Line.BackgroundColor3 = theme.Outline
    Line.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = theme.Text
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Kapatma ve Küçültme Butonları (Sağ Üst Köşe)
    local CloseBtn = Instance.new("TextButton", Topbar)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = theme.Text
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.TextSize = 14

    local MinBtn = Instance.new("TextButton", Topbar)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -68, 0.5, -15)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "—"
    MinBtn.TextColor3 = theme.Text
    MinBtn.Font = Enum.Font.GothamMedium
    MinBtn.TextSize = 12

    -- Kusursuz Küçülerek Kapanma/Açılma Animasyonu (UIScale + Fade)
    local uiVisible = true
    local animating = false
    local function ToggleUI()
        if animating then return end
        animating = true
        uiVisible = not uiVisible
        
        if uiVisible then
            MainFrame.Visible = true
            Tween(MainFrame, {GroupTransparency = 0}, 0.2)
            local t = Tween(UiScale, {Scale = 1}, 0.3, Enum.EasingStyle.Back)
            t.Completed:Wait()
        else
            Tween(MainFrame, {GroupTransparency = 1}, 0.2)
            local t = Tween(UiScale, {Scale = 0.85}, 0.25, Enum.EasingStyle.Quad)
            t.Completed:Wait()
            if not uiVisible then MainFrame.Visible = false end
        end
        animating = false
    end

    CloseBtn.MouseButton1Click:Connect(function()
        animating = true
        Tween(MainFrame, {GroupTransparency = 1}, 0.15)
        local t = Tween(UiScale, {Scale = 0.8}, 0.2, Enum.EasingStyle.Quad)
        t.Completed:Wait()
        ScreenGui:Destroy()
    end)

    MinBtn.MouseButton1Click:Connect(ToggleUI)
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == toggleKey then ToggleUI() end
    end)

    -- Kusursuz Sürükleme Motoru
    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    Topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Yan Menü (Sidebar)
    local TabContainer = Instance.new("ScrollingFrame", MainFrame)
    TabContainer.Size = UDim2.new(0, 135, 1, -38)
    TabContainer.Position = UDim2.new(0, 0, 0, 38)
    TabContainer.BackgroundColor3 = theme.TabBg
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    
    local TabStroke = Instance.new("UIStroke", TabContainer)
    TabStroke.Color = theme.Outline
    TabStroke.Thickness = 1

    local UIListLayout_Tabs = Instance.new("UIListLayout", TabContainer)
    UIListLayout_Tabs.Padding = UDim.new(0, 2)

    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Size = UDim2.new(1, -135, 1, -38)
    ContentContainer.Position = UDim2.new(0, 135, 0, 38)
    ContentContainer.BackgroundTransparency = 1

    local firstTab = true

    function Window:NewTab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "   " .. tabName
        TabBtn.TextColor3 = theme.Text
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        -- Aktif sekme çizgisi (Sol ince neon çizgi)
        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.Size = UDim2.new(0, 3, 1, 0)
        Indicator.BackgroundColor3 = theme.Accent
        Indicator.BorderSizePixel = 0
        Indicator.BackgroundTransparency = firstTab and 0 or 1

        local Page = Instance.new("ScrollingFrame", ContentContainer)
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0, 10, 0, 10)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = theme.Outline
        Page.Visible = firstTab

        local UIListLayout_Page = Instance.new("UIListLayout", Page)
        UIListLayout_Page.Padding = UDim.new(0, 5)

        if firstTab then
            TabBtn.TextColor3 = theme.Accent
            firstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then 
                    Tween(child, {TextColor3 = theme.Text}, 0.2)
                    Tween(child.Frame, {BackgroundTransparency = 1}, 0.2)
                end
            end
            Page.Visible = true
            Tween(TabBtn, {TextColor3 = theme.Accent}, 0.2)
            Tween(Indicator, {BackgroundTransparency = 0}, 0.2)
        end)

        local TabObj = {}
        
        function TabObj:NewSection(sectionName)
            local SectionLabel = Instance.new("TextLabel", Page)
            SectionLabel.Size = UDim2.new(1, 0, 0, 22)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = sectionName:upper()
            SectionLabel.TextColor3 = Color3.fromRGB(110, 110, 110)
            SectionLabel.TextSize = 10
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SectionObj = {}

            -- 1. PREMIUM BUTON
            function SectionObj:NewButton(btnName, btnDesc, callback)
                local Button = Instance.new("TextButton", Page)
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.BackgroundColor3 = theme.ElementBg
                Button.Text = ""
                Button.AutoButtonColor = false
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 5)
                Instance.new("UIStroke", Button).Color = theme.Outline

                local Title = Instance.new("TextLabel", Button)
                Title.Size = UDim2.new(1, -20, 0.5, 0)
                Title.Position = UDim2.new(0, 12, 0, 4)
                Title.BackgroundTransparency = 1
                Title.Text = btnName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamMedium
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local Desc = Instance.new("TextLabel", Button)
                Desc.Size = UDim2.new(1, -20, 0.5, 0)
                Desc.Position = UDim2.new(0, 12, 0.5, -2)
                Desc.BackgroundTransparency = 1
                Desc.Text = btnDesc
                Desc.TextColor3 = Color3.fromRGB(130, 130, 130)
                Desc.Font = Enum.Font.Gotham
                Desc.TextSize = 10
                Desc.TextXAlignment = Enum.TextXAlignment.Left

                Button.MouseEnter:Connect(function() 
                    Tween(Button, {BackgroundColor3 = theme.HoverBg}, 0.15)
                    Tween(Title, {Position = UDim2.new(0, 16, 0, 4)}, 0.15)
                end)
                Button.MouseLeave:Connect(function() 
                    Tween(Button, {BackgroundColor3 = theme.ElementBg}, 0.15)
                    Tween(Title, {Position = UDim2.new(0, 12, 0, 4)}, 0.15)
                end)
                Button.MouseButton1Click:Connect(function()
                    if callback then pcall(callback) end
                end)
            end

            -- 2. PREMIUM TOGGLE
            function SectionObj:NewToggle(toggleName, default, callback)
                local state = default or false
                local Toggle = Instance.new("TextButton", Page)
                Toggle.Size = UDim2.new(1, 0, 0, 36)
                Toggle.BackgroundColor3 = theme.ElementBg
                Toggle.Text = ""
                Toggle.AutoButtonColor = false
                Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 5)
                Instance.new("UIStroke", Toggle).Color = theme.Outline

                local Title = Instance.new("TextLabel", Toggle)
                Title.Size = UDim2.new(1, -60, 1, 0)
                Title.Position = UDim2.new(0, 12, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = toggleName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamMedium
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local Frame = Instance.new("Frame", Toggle)
                Frame.Size = UDim2.new(0, 34, 0, 18)
                Frame.Position = UDim2.new(1, -46, 0.5, -9)
                Frame.BackgroundColor3 = state and theme.Accent or theme.TopBg
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)

                local Knob = Instance.new("Frame", Frame)
                Knob.Size = UDim2.new(0, 14, 0, 14)
                Knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

                Toggle.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(Frame, {BackgroundColor3 = state and theme.Accent or theme.TopBg}, 0.15)
                    Tween(Knob, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.15)
                    if callback then pcall(callback, state) end
                end)
            end

            -- 3. PREMIUM SLIDER
            function SectionObj:NewSlider(sliderName, min, max, default, callback)
                local Slider = Instance.new("Frame", Page)
                Slider.Size = UDim2.new(1, 0, 0, 46)
                Slider.BackgroundColor3 = theme.ElementBg
                Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 5)
                Instance.new("UIStroke", Slider).Color = theme.Outline

                local Title = Instance.new("TextLabel", Slider)
                Title.Size = UDim2.new(1, -10, 0, 20)
                Title.Position = UDim2.new(0, 12, 0, 4)
                Title.BackgroundTransparency = 1
                Title.Text = sliderName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamMedium
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local Val = Instance.new("TextLabel", Slider)
                Val.Size = UDim2.new(0, 50, 0, 20)
                Val.Position = UDim2.new(1, -62, 0, 4)
                Val.BackgroundTransparency = 1
                Val.Text = tostring(default)
                Val.TextColor3 = theme.Accent
                Val.Font = Enum.Font.GothamBold
                Val.TextSize = 12
                Val.TextXAlignment = Enum.TextXAlignment.Right

                local Bar = Instance.new("TextButton", Slider)
                Bar.Size = UDim2.new(1, -24, 0, 4)
                Bar.Position = UDim2.new(0, 12, 0, 32)
                Bar.BackgroundColor3 = theme.TopBg
                Bar.AutoButtonColor = false
                Bar.Text = ""
                Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame", Bar)
                Fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
                Fill.BackgroundColor3 = theme.Accent
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local drag = false
                Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
                UserInputService.InputChanged:Connect(function(i)
                    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local res = math.floor(min + ((max - min) * percent))
                        Fill.Size = UDim2.new(percent, 0, 1, 0)
                        Val.Text = tostring(res)
                        if callback then pcall(callback, res) end
                    end
                end)
            end

            -- 4. ULTRA İŞLEVSEL KEYBIND SELECTOR (YENİ)
            function SectionObj:NewKeybind(bindName, default, callback)
                local currentBind = default or Enum.KeyCode.E
                local Keybind = Instance.new("Frame", Page)
                Keybind.Size = UDim2.new(1, 0, 0, 36)
                Keybind.BackgroundColor3 = theme.ElementBg
                Instance.new("UICorner", Keybind).CornerRadius = UDim.new(0, 5)
                Instance.new("UIStroke", Keybind).Color = theme.Outline

                local Title = Instance.new("TextLabel", Keybind)
                Title.Size = UDim2.new(1, -100, 1, 0)
                Title.Position = UDim2.new(0, 12, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = bindName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamMedium
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local BindBtn = Instance.new("TextButton", Keybind)
                BindBtn.Size = UDim2.new(0, 70, 0, 22)
                BindBtn.Position = UDim2.new(1, -82, 0.5, -11)
                BindBtn.BackgroundColor3 = theme.TopBg
                BindBtn.Text = currentBind.Name
                BindBtn.TextColor3 = theme.Accent
                BindBtn.Font = Enum.Font.GothamBold
                BindBtn.TextSize = 11
                Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", BindBtn).Color = theme.Outline

                local listening = false
                BindBtn.MouseButton1Click:Connect(function()
                    listening = true
                    BindBtn.Text = "..."
                    Tween(BindBtn, {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.1)
                end)

                UserInputService.InputBegan:Connect(function(input, proc)
                    if listening and not proc and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        currentBind = input.KeyCode
                        BindBtn.Text = currentBind.Name
                        Tween(BindBtn, {TextColor3 = theme.Accent}, 0.1)
                        if callback then pcall(callback, currentBind) end
                    end
                end)
            end

            -- 5. ULTRA İŞLEVSEL COLOR PICKER (YENİ)
            function SectionObj:NewColorPicker(pickerName, defaultColor, callback)
                local color = defaultColor or Color3.fromRGB(255, 255, 255)
                local Picker = Instance.new("Frame", Page)
                Picker.Size = UDim2.new(1, 0, 0, 36)
                Picker.BackgroundColor3 = theme.ElementBg
                Instance.new("UICorner", Picker).CornerRadius = UDim.new(0, 5)
                Instance.new("UIStroke", Picker).Color = theme.Outline

                local Title = Instance.new("TextLabel", Picker)
                Title.Size = UDim2.new(1, -100, 1, 0)
                Title.Position = UDim2.new(0, 12, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = pickerName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamMedium
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local ColorDisplay = Instance.new("TextButton", Picker)
                ColorDisplay.Size = UDim2.new(0, 40, 0, 20)
                ColorDisplay.Position = UDim2.new(1, -52, 0.5, -10)
                ColorDisplay.BackgroundColor3 = color
                ColorDisplay.Text = ""
                Instance.new("UICorner", ColorDisplay).CornerRadius = UDim.new(0, 4)
                Instance.new("UIStroke", ColorDisplay).Color = theme.Outline

                -- RGB Slider simülasyonu sağlayan minimalist dropdown mantığı yerine, hızlı döngüsel preset paleti (Mobil ve PC için en stabil yöntem)
                local presets = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)}
                local index = 1
                
                ColorDisplay.MouseButton1Click:Connect(function()
                    index = (index % #presets) + 1
                    color = presets[index]
                    ColorDisplay.BackgroundColor3 = color
                    if callback then pcall(callback, color) end
                end)
            end

            -- 6. PREMIUM TEXTBOX
            function SectionObj:NewTextBox(boxName, placeholder, callback)
                local Box = Instance.new("Frame", Page)
                Box.Size = UDim2.new(1, 0, 0, 38)
                Box.BackgroundColor3 = theme.ElementBg
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 5)
                Instance.new("UIStroke", Box).Color = theme.Outline

                local Title = Instance.new("TextLabel", Box)
                Title.Size = UDim2.new(0.5, 0, 1, 0)
                Title.Position = UDim2.new(0, 12, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = boxName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamMedium
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local Input = Instance.new("TextBox", Box)
                Input.Size = UDim2.new(0.4, 0, 0, 22)
                Input.Position = UDim2.new(1, -12, 0.5, -11)
                Input.AnchorPoint = Vector2.new(1, 0)
                Input.BackgroundColor3 = theme.TopBg
                Input.Text = ""
                Input.PlaceholderText = placeholder
                Input.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
                Input.TextColor3 = theme.Text
                Input.Font = Enum.Font.Gotham
                Input.TextSize = 11
                Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)
                
                local Stroke = Instance.new("UIStroke", Input)
                Stroke.Color = theme.Outline

                Input.Focused:Connect(function() Tween(Stroke, {Color = theme.Accent}, 0.15) end)
                Input.FocusLost:Connect(function() 
                    Tween(Stroke, {Color = theme.Outline}, 0.15)
                    if callback then pcall(callback, Input.Text) end
                end)
            end

            -- 7. PREMIUM DROPDOWN
            function SectionObj:NewDropdown(dropName, options, callback)
                local active = false
                local Drop = Instance.new("Frame", Page)
                Drop.Size = UDim2.new(1, 0, 0, 36)
                Drop.BackgroundColor3 = theme.ElementBg
                Drop.ClipsDescendants = true
                Instance.new("UICorner", Drop).CornerRadius = UDim.new(0, 5)
                Instance.new("UIStroke", Drop).Color = theme.Outline

                local Btn = Instance.new("TextButton", Drop)
                Btn.Size = UDim2.new(1, 0, 0, 36)
                Btn.BackgroundTransparency = 1
                Btn.Text = "  " .. dropName .. " : Seçiniz"
                Btn.TextColor3 = theme.Text
                Btn.Font = Enum.Font.GothamMedium
                Btn.TextSize = 12
                Btn.TextXAlignment = Enum.TextXAlignment.Left

                local Arrow = Instance.new("TextLabel", Btn)
                Arrow.Size = UDim2.new(0, 30, 1, 0)
                Arrow.Position = UDim2.new(1, -30, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text = "▼"
                Arrow.TextColor3 = theme.Text
                Arrow.TextSize = 10

                local List = Instance.new("ScrollingFrame", Drop)
                List.Size = UDim2.new(1, -10, 1, -40)
                List.Position = UDim2.new(0, 5, 0, 38)
                List.BackgroundTransparency = 1
                List.ScrollBarThickness = 0
                
                local Layout = Instance.new("UIListLayout", List)
                Layout.Padding = UDim.new(0, 2)

                local h = 38 + math.clamp(#options * 26, 0, 120)

                Btn.MouseButton1Click:Connect(function()
                    active = not active
                    Tween(Drop, {Size = active and UDim2.new(1, 0, 0, h) or UDim2.new(1, 0, 0, 36)}, 0.2)
                    Tween(Arrow, {Rotation = active and 180 or 0}, 0.2)
                end)

                for _, opt in pairs(options) do
                    local O = Instance.new("TextButton", List)
                    O.Size = UDim2.new(1, 0, 0, 24)
                    O.BackgroundColor3 = theme.TopBg
                    O.Text = opt
                    O.TextColor3 = theme.Text
                    O.Font = Enum.Font.Gotham
                    O.TextSize = 11
                    Instance.new("UICorner", O).CornerRadius = UDim.new(0, 4)

                    O.MouseButton1Click:Connect(function()
                        active = false
                        Tween(Drop, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                        Tween(Arrow, {Rotation = 0}, 0.2)
                        Btn.Text = "  " .. dropName .. " : " .. opt
                        if callback then pcall(callback, opt) end
                    end)
                end
            end

            return SectionObj
        end
        return TabObj
    end
    return Window
end

return Library

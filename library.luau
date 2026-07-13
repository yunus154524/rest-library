local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}

-- İnternet Trendi Ultra-Sleek Mat Karanlık Temalar
local Themes = {
    Blood = {
        MainBg = Color3.fromRGB(13, 9, 9), TopBg = Color3.fromRGB(18, 11, 11),
        TabBg = Color3.fromRGB(10, 6, 6), ElementBg = Color3.fromRGB(22, 13, 13),
        HoverBg = Color3.fromRGB(32, 16, 16), Text = Color3.fromRGB(255, 235, 235),
        Accent = Color3.fromRGB(235, 45, 45), Outline = Color3.fromRGB(45, 22, 22)
    },
    Dark = {
        MainBg = Color3.fromRGB(15, 15, 15), TopBg = Color3.fromRGB(20, 20, 20),
        TabBg = Color3.fromRGB(12, 12, 12), ElementBg = Color3.fromRGB(23, 23, 23),
        HoverBg = Color3.fromRGB(30, 30, 30), Text = Color3.fromRGB(245, 245, 245),
        Accent = Color3.fromRGB(0, 165, 255), Outline = Color3.fromRGB(40, 40, 40)
    }
}

-- Modern Lucide / Vektörel Asset ID'leri
local Icons = {
    Close = "rbxassetid://10747384394",
    Minimize = "rbxassetid://10747373151",
    Chevron = "rbxassetid://10747372702",
    Info = "rbxassetid://10747379701" -- Bildirimler için modern info ikonu
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

-- === ASSET DESTEKLİ BİLDİRİM SİSTEMİ ===
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
    local theme = Themes.Dark -- Varsayılan bildirim teması
    
    local NotifFrame = Instance.new("CanvasGroup", NotifContainer)
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.BackgroundColor3 = theme.MainBg
    NotifFrame.GroupTransparency = 1
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", NotifFrame)
    Stroke.Color = theme.Outline
    Stroke.Thickness = 1
    
    -- Bildirim İkonu
    local NotifIcon = Instance.new("ImageLabel", NotifFrame)
    NotifIcon.Size = UDim2.new(0, 18, 0, 18)
    NotifIcon.Position = UDim2.new(0, 12, 0.5, -9)
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.Image = Icons.Info
    NotifIcon.ImageColor3 = theme.Accent

    local TitleLbl = Instance.new("TextLabel", NotifFrame)
    TitleLbl.Size = UDim2.new(1, -50, 0, 20)
    TitleLbl.Position = UDim2.new(0, 40, 0, 8)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.TextColor3 = theme.Text
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 12
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local TextLbl = Instance.new("TextLabel", NotifFrame)
    TextLbl.Size = UDim2.new(1, -50, 0, 24)
    TextLbl.Position = UDim2.new(0, 40, 0, 26)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
    TextLbl.Font = Enum.Font.GothamMedium
    TextLbl.TextSize = 11
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.TextWrapped = true

    -- Sağa doğru kayarak ve netleşerek açılma efekti
    NotifFrame.Position = UDim2.new(0, 50, 0, 0)
    Tween(NotifFrame, {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint)
    
    task.spawn(function()
        task.wait(duration)
        local out = Tween(NotifFrame, {GroupTransparency = 1, Position = UDim2.new(0, 20, 0, 0)}, 0.2, Enum.EasingStyle.Quad)
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

    local MainFrame = Instance.new("CanvasGroup", ScreenGui)
    MainFrame.Size = UDim2.new(0, 560, 0, 380)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = theme.MainBg
    MainFrame.GroupTransparency = 1
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = theme.Outline
    MainStroke.Thickness = 1

    -- Bozulmaları Önleyen Mikro Ölçekleyici (%4 Esneme Oranı)
    local UiScale = Instance.new("UIScale", MainFrame)
    UiScale.Scale = 0.96

    -- Yumuşak Giriş Animasyonu
    Tween(MainFrame, {GroupTransparency = 0}, 0.25, Enum.EasingStyle.Quint)
    Tween(UiScale, {Scale = 1}, 0.25, Enum.EasingStyle.Quint)

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
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Kapat / Küçült Asset Butonları
    local CloseBtn = Instance.new("ImageButton", Topbar)
    CloseBtn.Size = UDim2.new(0, 16, 0, 16)
    CloseBtn.Position = UDim2.new(1, -28, 0.5, -8)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Image = Icons.Close
    CloseBtn.ImageColor3 = theme.Text

    local MinBtn = Instance.new("ImageButton", Topbar)
    MinBtn.Size = UDim2.new(0, 16, 0, 16)
    MinBtn.Position = UDim2.new(1, -54, 0.5, -8)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Image = Icons.Minimize
    MinBtn.ImageColor3 = theme.Text

    -- Görüntü Kirliliği Yaratmayan Hassas Fade-Scale Mekanizması
    local uiVisible = true
    local animating = false
    local function ToggleUI()
        if animating then return end
        animating = true
        uiVisible = not uiVisible
        
        if uiVisible then
            MainFrame.Visible = true
            Tween(MainFrame, {GroupTransparency = 0}, 0.2, Enum.EasingStyle.Quad)
            local t = Tween(UiScale, {Scale = 1}, 0.2, Enum.EasingStyle.Quad)
            t.Completed:Wait()
        else
            Tween(MainFrame, {GroupTransparency = 1}, 0.18, Enum.EasingStyle.Quad)
            local t = Tween(UiScale, {Scale = 0.96}, 0.18, Enum.EasingStyle.Quad)
            t.Completed:Wait()
            if not uiVisible then MainFrame.Visible = false end
        end
        animating = false
    end

    CloseBtn.MouseButton1Click:Connect(function()
        animating = true
        Tween(MainFrame, {GroupTransparency = 1}, 0.15)
        local t = Tween(UiScale, {Scale = 0.95}, 0.15)
        t.Completed:Wait()
        ScreenGui:Destroy()
    end)

    MinBtn.MouseButton1Click:Connect(ToggleUI)
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == toggleKey then ToggleUI() end
    end)

    -- Sürükleme Sistemi
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

    -- Sidebar
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
            SectionLabel.TextColor3 = Color3.fromRGB(90, 90, 90)
            SectionLabel.TextSize = 10
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SectionObj = {}

            -- 1. Premium Buton
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
                Desc.TextColor3 = Color3.fromRGB(120, 120, 120)
                Desc.Font = Enum.Font.Gotham
                Desc.TextSize = 10
                Desc.TextXAlignment = Enum.TextXAlignment.Left

                Button.MouseEnter:Connect(function() Tween(Button, {BackgroundColor3 = theme.HoverBg}, 0.15) end)
                Button.MouseLeave:Connect(function() Tween(Button, {BackgroundColor3 = theme.ElementBg}, 0.15) end)
                Button.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
            end

            -- 2. Premium Toggle
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

            -- 3. Premium Slider
            function SectionObj:NewSlider(sliderName, min, max, default, callback)
                local Slider = Instance.new("Frame", Page)
                Slider.Size = UDim2.new(1, 0, 0, 44)
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
                Bar.Size = UDim2.new(1, -24, 0, 3)
                Bar.Position = UDim2.new(0, 12, 0, 30)
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

            -- 4. Premium Dropdown (Asset Destekli)
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

                local Arrow = Instance.new("ImageLabel", Btn)
                Arrow.Size = UDim2.new(0, 14, 0, 14)
                Arrow.Position = UDim2.new(1, -28, 0.5, -7)
                Arrow.BackgroundTransparency = 1
                Arrow.Image = Icons.Chevron
                Arrow.ImageColor3 = theme.Text

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

            -- 5. Premium Keybind
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
                end)

                UserInputService.InputBegan:Connect(function(input, proc)
                    if listening and not proc and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        currentBind = input.KeyCode
                        BindBtn.Text = currentBind.Name
                        if callback then pcall(callback, currentBind) end
                    end
                end)
            end

            return SectionObj
        end
        return TabObj
    end
    return Window
end

return Library

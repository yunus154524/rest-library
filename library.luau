local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}

-- Ultra Gelişmiş Temalar (UIGradient Destekli)
local Themes = {
    Blood = {
        MainBg = Color3.fromRGB(20, 8, 8), MainBg2 = Color3.fromRGB(35, 12, 12),
        TopBg = Color3.fromRGB(40, 15, 15), TabBg = Color3.fromRGB(15, 5, 5),
        ElementBg = Color3.fromRGB(45, 16, 16), HoverBg = Color3.fromRGB(70, 25, 25),
        Text = Color3.fromRGB(255, 220, 220), Accent = Color3.fromRGB(235, 35, 35),
        Outline = Color3.fromRGB(80, 25, 25)
    },
    Dark = {
        MainBg = Color3.fromRGB(25, 25, 25), MainBg2 = Color3.fromRGB(40, 40, 40),
        TopBg = Color3.fromRGB(35, 35, 35), TabBg = Color3.fromRGB(20, 20, 20),
        ElementBg = Color3.fromRGB(45, 45, 45), HoverBg = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(255, 255, 255), Accent = Color3.fromRGB(0, 160, 255),
        Outline = Color3.fromRGB(65, 65, 65)
    }
}

-- Gelişmiş Animasyon Fonksiyonu
local function Tween(instance, properties, duration, style)
    local tweenInfo = TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
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

-- === BİLDİRİM SİSTEMİ (NOTIFICATION) ===
local NotifGui = GetSafeGui()
NotifGui.Name = "UltraUI_Notifications"

local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 320, 1, -20)
NotifContainer.Position = UDim2.new(1, -340, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = NotifGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotifContainer
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)

function Library:Notify(title, text, duration)
    duration = duration or 3.5
    local theme = Themes.Dark
    
    local NotifFrame = Instance.new("CanvasGroup")
    NotifFrame.Size = UDim2.new(1, 0, 0, 0) -- Boyut animasyonla büyüyecek
    NotifFrame.BackgroundColor3 = theme.MainBg
    NotifFrame.GroupTransparency = 1
    NotifFrame.Parent = NotifContainer
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", NotifFrame)
    Stroke.Color = theme.Accent
    Stroke.Thickness = 1
    
    local TitleLbl = Instance.new("TextLabel", NotifFrame)
    TitleLbl.Size = UDim2.new(1, -20, 0, 25)
    TitleLbl.Position = UDim2.new(0, 12, 0, 6)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.TextColor3 = theme.Accent
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 14
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local TextLbl = Instance.new("TextLabel", NotifFrame)
    TextLbl.Size = UDim2.new(1, -20, 0, 35)
    TextLbl.Position = UDim2.new(0, 12, 0, 28)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextColor3 = theme.Text
    TextLbl.Font = Enum.Font.GothamMedium
    TextLbl.TextSize = 12
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.TextWrapped = true

    -- Şık Açılış Efekti
    Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, 75), GroupTransparency = 0}, 0.4)
    
    task.spawn(function()
        task.wait(duration)
        local out = Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, 0), GroupTransparency = 1}, 0.4)
        out.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

-- === ANA PANEL YARATMA ===
function Library.CreateLib(titleText, themeName, toggleKey)
    local theme = Themes[themeName] or Themes.Dark
    toggleKey = toggleKey or Enum.KeyCode.RightShift -- Varsayılan gizleme tuşu: Sağ Shift
    
    local Window = {}
    local ScreenGui = GetSafeGui()
    ScreenGui.Name = "UltraUILib"

    -- CanvasGroup sayesinde tüm menü tek bir tıkla pürüzsüzce fade olur
    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Size = UDim2.new(0, 580, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainFrame.GroupTransparency = 1 -- Başlangıçta görünmez (Açılış efekti için)
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    -- Modern Parlayan Kenarlık
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = theme.Outline
    MainStroke.Thickness = 1.2

    -- Arka Plan Renk Geçişi (Gradient)
    local MainGradient = Instance.new("UIGradient", MainFrame)
    MainGradient.Color = ColorSequence.new(theme.MainBg, theme.MainBg2)
    MainGradient.Rotation = 45

    -- Üst Bar
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = theme.TopBg
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 10)
    
    local TopbarFix = Instance.new("Frame", Topbar)
    TopbarFix.Size = UDim2.new(1, 0, 0, 10)
    TopbarFix.Position = UDim2.new(0, 0, 1, -10)
    TopbarFix.BackgroundColor3 = theme.TopBg
    TopbarFix.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Topbar)
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = theme.Text
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- = BUTTONS: CLOSE AND MINIMIZE =
    local CloseBtn = Instance.new("TextButton", Topbar)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = theme.Text
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16

    local MinBtn = Instance.new("TextButton", Topbar)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -75, 0.5, -15)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "—"
    MinBtn.TextColor3 = theme.Text
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14

    -- Kapatma İşlemi (Yok Eder)
    CloseBtn.MouseButton1Click:Connect(function()
        local closeTween = Tween(MainFrame, {GroupTransparency = 1, Size = UDim2.new(0, 550, 0, 370)}, 0.3, Enum.EasingStyle.Quad)
        closeTween.Completed:Wait()
        ScreenGui:Destroy()
    end)

    -- Küçültme/Gizleme İşlemi (Pürüzsüz Kapanış)
    local uiVisible = true
    local function ToggleUI()
        uiVisible = not uiVisible
        if uiVisible then
            MainFrame.Visible = true
            Tween(MainFrame, {GroupTransparency = 0, Size = UDim2.new(0, 580, 0, 400)}, 0.3)
        else
            local t = Tween(MainFrame, {GroupTransparency = 1, Size = UDim2.new(0, 550, 0, 370)}, 0.3)
            t.Completed:Wait()
            if not uiVisible then MainFrame.Visible = false end
        end
    end
    MinBtn.MouseButton1Click:Connect(ToggleUI)

    -- Global Tuş Dinleyici (Kapatıp Açmak İçin)
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == toggleKey then
            ToggleUI()
        end
    end)

    -- Sürükleme (Dragging) Motoru
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

    -- Düzenleyici Konteynerler
    local TabContainer = Instance.new("ScrollingFrame", MainFrame)
    TabContainer.Size = UDim2.new(0, 140, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = theme.TabBg
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    local UIListLayout_Tabs = Instance.new("UIListLayout", TabContainer)

    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Size = UDim2.new(1, -140, 1, -40)
    ContentContainer.Position = UDim2.new(0, 140, 0, 40)
    ContentContainer.BackgroundTransparency = 1

    -- İlk Giriş Animasyonu
    Tween(MainFrame, {GroupTransparency = 0}, 0.5)

    local firstTab = true

    function Window:NewTab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = "  " .. tabName
        TabBtn.TextColor3 = theme.Text
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        local Page = Instance.new("ScrollingFrame", ContentContainer)
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0, 10, 0, 10)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = theme.Accent
        Page.Visible = firstTab

        local UIListLayout_Page = Instance.new("UIListLayout", Page)
        UIListLayout_Page.Padding = UDim.new(0, 6)

        if firstTab then
            TabBtn.TextColor3 = theme.Accent
            TabBtn.Text = " ➔ " .. tabName
            firstTab = false
        end

        -- Sekme Değişme Efekti (Kayma ve Renk Değişimi)
        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then 
                    Tween(child, {TextColor3 = theme.Text}, 0.2)
                    child.Text = "  " .. child.Text:gsub(" ➔ ", "")
                end
            end
            Page.Visible = true
            Tween(TabBtn, {TextColor3 = theme.Accent}, 0.2)
            TabBtn.Text = " ➔ " .. tabName
        end)

        local TabObj = {}
        
        function TabObj:NewSection(sectionName)
            local SectionLabel = Instance.new("TextLabel", Page)
            SectionLabel.Size = UDim2.new(1, 0, 0, 25)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = "— " .. sectionName
            SectionLabel.TextColor3 = theme.Accent
            SectionLabel.TextSize = 13
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SectionObj = {}

            -- 1. PREMIUM BUTON (Mikro Hareketli)
            function SectionObj:NewButton(btnName, btnDesc, callback)
                local Button = Instance.new("TextButton", Page)
                Button.Size = UDim2.new(1, 0, 0, 44)
                Button.BackgroundColor3 = theme.ElementBg
                Button.Text = ""
                Button.AutoButtonColor = false
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
                Instance.new("UIStroke", Button).Color = theme.Outline

                local Title = Instance.new("TextLabel", Button)
                Title.Size = UDim2.new(1, -10, 0.5, 0)
                Title.Position = UDim2.new(0, 12, 0, 5)
                Title.BackgroundTransparency = 1
                Title.Text = btnName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamSemibold
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local Desc = Instance.new("TextLabel", Button)
                Desc.Size = UDim2.new(1, -10, 0.5, 0)
                Desc.Position = UDim2.new(0, 12, 0.5, -1)
                Desc.BackgroundTransparency = 1
                Desc.Text = btnDesc
                Desc.TextColor3 = Color3.fromRGB(160, 160, 160)
                Desc.Font = Enum.Font.Gotham
                Desc.TextSize = 11
                Desc.TextXAlignment = Enum.TextXAlignment.Left

                -- Üst düzey Hover Animasyonu (Hafif Sağa Kayma Efekti)
                Button.MouseEnter:Connect(function() 
                    Tween(Button, {BackgroundColor3 = theme.HoverBg}, 0.2)
                    Tween(Title, {Position = UDim2.new(0, 18, 0, 5)}, 0.2)
                    Tween(Desc, {Position = UDim2.new(0, 18, 0.5, -1)}, 0.2)
                end)
                Button.MouseLeave:Connect(function() 
                    Tween(Button, {BackgroundColor3 = theme.ElementBg}, 0.2)
                    Tween(Title, {Position = UDim2.new(0, 12, 0, 5)}, 0.2)
                    Tween(Desc, {Position = UDim2.new(0, 12, 0.5, -1)}, 0.2)
                end)
                Button.MouseButton1Down:Connect(function() Tween(Button, {Size = UDim2.new(0.97, 0, 0, 42)}, 0.1) end)
                Button.MouseButton1Up:Connect(function()
                    Tween(Button, {Size = UDim2.new(1, 0, 0, 44)}, 0.1)
                    if callback then pcall(callback) end
                end)
            end

            -- 2. PREMIUM TOGGLE (Şalter Efektli)
            function SectionObj:NewToggle(toggleName, default, callback)
                local state = default or false
                local ToggleBg = Instance.new("TextButton", Page)
                ToggleBg.Size = UDim2.new(1, 0, 0, 38)
                ToggleBg.BackgroundColor3 = theme.ElementBg
                ToggleBg.Text = ""
                ToggleBg.AutoButtonColor = false
                Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(0, 6)
                Instance.new("UIStroke", ToggleBg).Color = theme.Outline

                local Title = Instance.new("TextLabel", ToggleBg)
                Title.Size = UDim2.new(1, -60, 1, 0)
                Title.Position = UDim2.new(0, 12, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = toggleName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamSemibold
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local SwitchBg = Instance.new("Frame", ToggleBg)
                SwitchBg.Size = UDim2.new(0, 42, 0, 22)
                SwitchBg.Position = UDim2.new(1, -54, 0.5, -11)
                SwitchBg.BackgroundColor3 = state and theme.Accent or theme.TopBg
                Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

                local SwitchKnob = Instance.new("Frame", SwitchBg)
                SwitchKnob.Size = UDim2.new(0, 16, 0, 16)
                SwitchKnob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0)

                ToggleBg.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(SwitchBg, {BackgroundColor3 = state and theme.Accent or theme.TopBg}, 0.25)
                    Tween(SwitchKnob, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, 0.25)
                    if callback then pcall(callback, state) end
                end)
            end

            -- 3. PREMIUM SLIDER (Kesintisiz Sürtünme)
            function SectionObj:NewSlider(sliderName, min, max, default, callback)
                local SliderBg = Instance.new("Frame", Page)
                SliderBg.Size = UDim2.new(1, 0, 0, 52)
                SliderBg.BackgroundColor3 = theme.ElementBg
                Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(0, 6)
                Instance.new("UIStroke", SliderBg).Color = theme.Outline

                local Title = Instance.new("TextLabel", SliderBg)
                Title.Size = UDim2.new(1, -10, 0, 22)
                Title.Position = UDim2.new(0, 12, 0, 6)
                Title.BackgroundTransparency = 1
                Title.Text = sliderName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamSemibold
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local ValLabel = Instance.new("TextLabel", SliderBg)
                ValLabel.Size = UDim2.new(0, 60, 0, 22)
                ValLabel.Position = UDim2.new(1, -72, 0, 6)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = tostring(default)
                ValLabel.TextColor3 = theme.Accent
                ValLabel.Font = Enum.Font.GothamBold
                ValLabel.TextSize = 13
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right

                local BarBg = Instance.new("TextButton", SliderBg)
                BarBg.Size = UDim2.new(1, -24, 0, 6)
                BarBg.Position = UDim2.new(0, 12, 0, 36)
                BarBg.BackgroundColor3 = theme.TopBg
                BarBg.AutoButtonColor = false
                BarBg.Text = ""
                Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

                local Fill = Instance.new("Frame", BarBg)
                Fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
                Fill.BackgroundColor3 = theme.Accent
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                local isDragging = false
                BarBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = true end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation().X
                        local barPos = BarBg.AbsolutePosition.X
                        local barSize = BarBg.AbsoluteSize.X
                        local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
                        local val = math.floor(min + ((max - min) * percent))
                        
                        Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.05)
                        ValLabel.Text = tostring(val)
                        if callback then pcall(callback, val) end
                    end
                end)
            end

            -- 4. PREMIUM TEXTBOX (Yazı Giriş Alanı)
            function SectionObj:NewTextBox(boxName, placeholder, callback)
                local BoxBg = Instance.new("Frame", Page)
                BoxBg.Size = UDim2.new(1, 0, 0, 40)
                BoxBg.BackgroundColor3 = theme.ElementBg
                Instance.new("UICorner", BoxBg).CornerRadius = UDim.new(0, 6)
                Instance.new("UIStroke", BoxBg).Color = theme.Outline

                local Title = Instance.new("TextLabel", BoxBg)
                Title.Size = UDim2.new(0.5, 0, 1, 0)
                Title.Position = UDim2.new(0, 12, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = boxName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamSemibold
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local Input = Instance.new("TextBox", BoxBg)
                Input.Size = UDim2.new(0.45, 0, 0, 26)
                Input.Position = UDim2.new(1, -12, 0.5, -13)
                Input.AnchorPoint = Vector2.new(1, 0)
                Input.BackgroundColor3 = theme.TopBg
                Input.Text = ""
                Input.PlaceholderText = placeholder or "Yazınız..."
                Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                Input.TextColor3 = theme.Text
                Input.Font = Enum.Font.Gotham
                Input.TextSize = 12
                Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)
                local BoxStroke = Instance.new("UIStroke", Input)
                BoxStroke.Color = theme.Outline

                Input.Focused:Connect(function() Tween(BoxStroke, {Color = theme.Accent}, 0.2) end)
                Input.FocusLost:Connect(function() 
                    Tween(BoxStroke, {Color = theme.Outline}, 0.2)
                    if callback then pcall(callback, Input.Text) end
                end)
            end

            -- 5. PREMIUM DROPDOWN (Akıcı Aşağı Kayma)
            function SectionObj:NewDropdown(dropName, options, callback)
                local isDropped = false
                local DropBg = Instance.new("Frame", Page)
                DropBg.Size = UDim2.new(1, 0, 0, 38)
                DropBg.BackgroundColor3 = theme.ElementBg
                DropBg.ClipsDescendants = true
                Instance.new("UICorner", DropBg).CornerRadius = UDim.new(0, 6)
                Instance.new("UIStroke", DropBg).Color = theme.Outline

                local DropBtn = Instance.new("TextButton", DropBg)
                DropBtn.Size = UDim2.new(1, 0, 0, 38)
                DropBtn.BackgroundTransparency = 1
                DropBtn.Text = "  " .. dropName .. " : Seçiniz"
                DropBtn.TextColor3 = theme.Text
                DropBtn.Font = Enum.Font.GothamSemibold
                DropBtn.TextSize = 13
                DropBtn.TextXAlignment = Enum.TextXAlignment.Left

                local Icon = Instance.new("TextLabel", DropBtn)
                Icon.Size = UDim2.new(0, 30, 1, 0)
                Icon.Position = UDim2.new(1, -30, 0, 0)
                Icon.BackgroundTransparency = 1
                Icon.Text = "▼"
                Icon.TextColor3 = theme.Text
                Icon.Font = Enum.Font.GothamBold
                Icon.TextSize = 12

                local List = Instance.new("ScrollingFrame", DropBg)
                List.Size = UDim2.new(1, -10, 1, -44)
                List.Position = UDim2.new(0, 5, 0, 40)
                List.BackgroundTransparency = 1
                List.ScrollBarThickness = 2
                List.ScrollBarImageColor3 = theme.Accent
                local ListLayout = Instance.new("UIListLayout", List)
                ListLayout.Padding = UDim.new(0, 3)

                local dropHeight = 42 + math.clamp(#options * 28, 0, 140)

                DropBtn.MouseButton1Click:Connect(function()
                    isDropped = not isDropped
                    Tween(DropBg, {Size = isDropped and UDim2.new(1, 0, 0, dropHeight) or UDim2.new(1, 0, 0, 38)}, 0.3)
                    Tween(Icon, {Rotation = isDropped and 180 or 0}, 0.3)
                end)

                for _, option in pairs(options) do
                    local OptBtn = Instance.new("TextButton", List)
                    OptBtn.Size = UDim2.new(1, 0, 0, 26)
                    OptBtn.BackgroundColor3 = theme.TopBg
                    OptBtn.Text = option
                    OptBtn.TextColor3 = theme.Text
                    OptBtn.Font = Enum.Font.GothamMedium
                    OptBtn.TextSize = 12
                    Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

                    OptBtn.MouseButton1Click:Connect(function()
                        isDropped = false
                        Tween(DropBg, {Size = UDim2.new(1, 0, 0, 38)}, 0.3)
                        Tween(Icon, {Rotation = 0}, 0.3)
                        DropBtn.Text = "  " .. dropName .. " : " .. option
                        if callback then pcall(callback, option) end
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

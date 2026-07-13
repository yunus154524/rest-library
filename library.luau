local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Library = {}

-- Temalar
local Themes = {
    Blood = {
        MainBg = Color3.fromRGB(25, 10, 10), TopBg = Color3.fromRGB(35, 15, 15), TabBg = Color3.fromRGB(20, 5, 5),
        ElementBg = Color3.fromRGB(45, 20, 20), HoverBg = Color3.fromRGB(65, 30, 30), Text = Color3.fromRGB(255, 200, 200),
        Accent = Color3.fromRGB(220, 40, 40), Outline = Color3.fromRGB(60, 25, 25)
    },
    Dark = {
        MainBg = Color3.fromRGB(30, 30, 30), TopBg = Color3.fromRGB(40, 40, 40), TabBg = Color3.fromRGB(25, 25, 25),
        ElementBg = Color3.fromRGB(45, 45, 45), HoverBg = Color3.fromRGB(60, 60, 60), Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 150, 255), Outline = Color3.fromRGB(55, 55, 55)
    }
}

-- Animasyon Yardımcısı
local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Ekran GUI'sini Güvenli Oluşturma
local function GetSafeGui()
    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    local success = pcall(function() gui.Parent = CoreGui end)
    if not success then gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    return gui
end

-- === BİLDİRİM SİSTEMİ (NOTIFICATION) ===
local NotifGui = GetSafeGui()
NotifGui.Name = "ModernUI_Notifications"

local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 300, 1, -20)
NotifContainer.Position = UDim2.new(1, -320, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = NotifGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotifContainer
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)

function Library:Notify(title, text, duration)
    duration = duration or 3
    local theme = Themes.Dark -- Bildirimler için varsayılan karanlık tema
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 400, 0, 70) -- Başlangıçta ekran dışı
    NotifFrame.BackgroundColor3 = theme.MainBg
    NotifFrame.Parent = NotifContainer
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
    
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -20, 0, 25)
    TitleLbl.Position = UDim2.new(0, 10, 0, 5)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.TextColor3 = theme.Accent
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 14
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = NotifFrame

    local TextLbl = Instance.new("TextLabel")
    TextLbl.Size = UDim2.new(1, -20, 0, 35)
    TextLbl.Position = UDim2.new(0, 10, 0, 30)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextColor3 = theme.Text
    TextLbl.Font = Enum.Font.Gotham
    TextLbl.TextSize = 12
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.TextWrapped = true
    TextLbl.Parent = NotifFrame

    -- İçeri Kayma Animasyonu
    Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, 70)}, 0.4)
    
    task.spawn(function()
        task.wait(duration)
        local outTween = Tween(NotifFrame, {Size = UDim2.new(1, 400, 0, 70), BackgroundTransparency = 1}, 0.4)
        Tween(TitleLbl, {TextTransparency = 1}, 0.4)
        Tween(TextLbl, {TextTransparency = 1}, 0.4)
        outTween.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

-- === ANA KÜTÜPHANE ===
function Library.CreateLib(titleText, themeName)
    local theme = Themes[themeName] or Themes.Dark
    local Window = {}
    
    local ScreenGui = GetSafeGui()
    ScreenGui.Name = "ModernUILib"

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
    MainFrame.BackgroundColor3 = theme.MainBg
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BackgroundColor3 = theme.TopBg
    Topbar.Parent = MainFrame
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 8)
    
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Size = UDim2.new(1, 0, 0, 5)
    TopbarFix.Position = UDim2.new(0, 0, 1, -5)
    TopbarFix.BackgroundColor3 = theme.TopBg
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Parent = Topbar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = theme.Text
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    -- Sürükleme Mantığı
    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
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

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 130, 1, -35)
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.BackgroundColor3 = theme.TabBg
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = MainFrame
    local UIListLayout_Tabs = Instance.new("UIListLayout")
    UIListLayout_Tabs.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -130, 1, -35)
    ContentContainer.Position = UDim2.new(0, 130, 0, 35)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local firstTab = true

    function Window:NewTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = theme.TabBg
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = tabName
        TabBtn.TextColor3 = theme.Text
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.Parent = TabContainer

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0, 10, 0, 10)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = theme.Accent
        Page.Visible = firstTab
        Page.Parent = ContentContainer

        local UIListLayout_Page = Instance.new("UIListLayout")
        UIListLayout_Page.Parent = Page
        UIListLayout_Page.Padding = UDim.new(0, 6)

        if firstTab then
            TabBtn.TextColor3 = theme.Accent
            firstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then Tween(child, {TextColor3 = theme.Text}) end
            end
            Page.Visible = true
            Tween(TabBtn, {TextColor3 = theme.Accent})
        end)

        local TabObj = {}
        
        function TabObj:NewSection(sectionName)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 0, 25)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = " " .. sectionName
            SectionLabel.TextColor3 = theme.Text
            SectionLabel.TextSize = 14
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = Page

            local SectionObj = {}

            -- BİLEŞEN 1: BUTON
            function SectionObj:NewButton(btnName, btnDesc, callback)
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 42)
                Button.BackgroundColor3 = theme.ElementBg
                Button.Text = ""
                Button.AutoButtonColor = false
                Button.Parent = Page
                Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Button)
                Title.Size = UDim2.new(1, -10, 0.5, 0)
                Title.Position = UDim2.new(0, 10, 0, 4)
                Title.BackgroundTransparency = 1
                Title.Text = btnName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamSemibold
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local Desc = Instance.new("TextLabel", Button)
                Desc.Size = UDim2.new(1, -10, 0.5, 0)
                Desc.Position = UDim2.new(0, 10, 0.5, -2)
                Desc.BackgroundTransparency = 1
                Desc.Text = btnDesc
                Desc.TextColor3 = Color3.fromRGB(150,150,150)
                Desc.Font = Enum.Font.Gotham
                Desc.TextSize = 11
                Desc.TextXAlignment = Enum.TextXAlignment.Left

                Button.MouseEnter:Connect(function() Tween(Button, {BackgroundColor3 = theme.HoverBg}, 0.2) end)
                Button.MouseLeave:Connect(function() Tween(Button, {BackgroundColor3 = theme.ElementBg}, 0.2) end)
                Button.MouseButton1Down:Connect(function() Tween(Button, {Size = UDim2.new(0.98, 0, 0, 40)}, 0.1) end)
                Button.MouseButton1Up:Connect(function()
                    Tween(Button, {Size = UDim2.new(1, 0, 0, 42)}, 0.1)
                    if callback then pcall(callback) end
                end)
            end

            -- BİLEŞEN 2: TOGGLE (Aç/Kapat)
            function SectionObj:NewToggle(toggleName, default, callback)
                local state = default or false
                local ToggleBg = Instance.new("TextButton")
                ToggleBg.Size = UDim2.new(1, 0, 0, 36)
                ToggleBg.BackgroundColor3 = theme.ElementBg
                ToggleBg.Text = ""
                ToggleBg.AutoButtonColor = false
                ToggleBg.Parent = Page
                Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", ToggleBg)
                Title.Size = UDim2.new(1, -60, 1, 0)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = toggleName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamSemibold
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local SwitchBg = Instance.new("Frame", ToggleBg)
                SwitchBg.Size = UDim2.new(0, 40, 0, 20)
                SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
                SwitchBg.BackgroundColor3 = state and theme.Accent or theme.TopBg
                Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

                local SwitchKnob = Instance.new("Frame", SwitchBg)
                SwitchKnob.Size = UDim2.new(0, 16, 0, 16)
                SwitchKnob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0)

                ToggleBg.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(SwitchBg, {BackgroundColor3 = state and theme.Accent or theme.TopBg}, 0.2)
                    Tween(SwitchKnob, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    if callback then pcall(callback, state) end
                end)
            end

            -- BİLEŞEN 3: SLIDER (Değer Kaydırıcı)
            function SectionObj:NewSlider(sliderName, min, max, default, callback)
                local SliderBg = Instance.new("Frame")
                SliderBg.Size = UDim2.new(1, 0, 0, 50)
                SliderBg.BackgroundColor3 = theme.ElementBg
                SliderBg.Parent = Page
                Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", SliderBg)
                Title.Size = UDim2.new(1, -10, 0, 20)
                Title.Position = UDim2.new(0, 10, 0, 5)
                Title.BackgroundTransparency = 1
                Title.Text = sliderName
                Title.TextColor3 = theme.Text
                Title.Font = Enum.Font.GothamSemibold
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left

                local ValLabel = Instance.new("TextLabel", SliderBg)
                ValLabel.Size = UDim2.new(0, 50, 0, 20)
                ValLabel.Position = UDim2.new(1, -60, 0, 5)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = tostring(default)
                ValLabel.TextColor3 = theme.Accent
                ValLabel.Font = Enum.Font.GothamBold
                ValLabel.TextSize = 13
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right

                local BarBg = Instance.new("TextButton", SliderBg)
                BarBg.Size = UDim2.new(1, -20, 0, 6)
                BarBg.Position = UDim2.new(0, 10, 0, 32)
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
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = false
                    end
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

            -- BİLEŞEN 4: DROPDOWN (Açılır Menü)
            function SectionObj:NewDropdown(dropName, options, callback)
                local isDropped = false
                local DropBg = Instance.new("Frame")
                DropBg.Size = UDim2.new(1, 0, 0, 36)
                DropBg.BackgroundColor3 = theme.ElementBg
                DropBg.ClipsDescendants = true
                DropBg.Parent = Page
                Instance.new("UICorner", DropBg).CornerRadius = UDim.new(0, 6)

                local DropBtn = Instance.new("TextButton", DropBg)
                DropBtn.Size = UDim2.new(1, 0, 0, 36)
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
                Icon.Text = "+"
                Icon.TextColor3 = theme.Text
                Icon.Font = Enum.Font.GothamBold
                Icon.TextSize = 16

                local List = Instance.new("ScrollingFrame", DropBg)
                List.Size = UDim2.new(1, -10, 1, -40)
                List.Position = UDim2.new(0, 5, 0, 36)
                List.BackgroundTransparency = 1
                List.ScrollBarThickness = 2
                List.ScrollBarImageColor3 = theme.Accent
                
                local ListLayout = Instance.new("UIListLayout", List)
                ListLayout.Padding = UDim.new(0, 2)

                local dropHeight = 36 + math.clamp(#options * 26, 0, 130)

                DropBtn.MouseButton1Click:Connect(function()
                    isDropped = not isDropped
                    Tween(DropBg, {Size = isDropped and UDim2.new(1, 0, 0, dropHeight) or UDim2.new(1, 0, 0, 36)}, 0.2)
                    Icon.Text = isDropped and "-" or "+"
                end)

                for _, option in pairs(options) do
                    local OptBtn = Instance.new("TextButton", List)
                    OptBtn.Size = UDim2.new(1, 0, 0, 24)
                    OptBtn.BackgroundColor3 = theme.TopBg
                    OptBtn.Text = option
                    OptBtn.TextColor3 = theme.Text
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextSize = 12
                    Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

                    OptBtn.MouseButton1Click:Connect(function()
                        isDropped = false
                        Tween(DropBg, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                        Icon.Text = "+"
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

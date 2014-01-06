local AddOn, Addon = ...
local A, C, T, L = unpack(select(2, ...))
local print = function(...) Addon.print('skin', ...) end

local find = string.find

local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}




function T.SkinTab(tab, bg)
	if (not tab) then return end

	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		if (tex) then
			tex:SetTexture(nil)
		end
	end

	if (tab.GetHighlightTexture and tab:GetHighlightTexture()) then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		tab:Strip()
	end

	tab.backdrop = CreateFrame("Frame", "$parentBackdrop", tab)
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	tab.backdrop:Template()
	tab.backdrop:SetPoint("TOPLEFT", 10, -3)
	tab.backdrop:SetPoint("BOTTOMRIGHT", -10, 3)
end

function T.SkinScrollBar(f)
	if (_G[f:GetName().."BG"]) then
		_G[f:GetName().."BG"]:SetTexture(nil)
	end
	if (_G[f:GetName().."Track"]) then
		_G[f:GetName().."Track"]:SetTexture(nil)
	end
	if (_G[f:GetName().."Top"]) then
		_G[f:GetName().."Top"]:SetTexture(nil)
	end
	if (_G[f:GetName().."Bottom"]) then
		_G[f:GetName().."Bottom"]:SetTexture(nil)
	end
	if (_G[f:GetName().."Middle"]) then
		_G[f:GetName().."Middle"]:SetTexture(nil)
	end
end

function T.SkinPrevNextButton(b, horizonal)
	local normal, pushed, disabled
	local isPrevButton = b:GetName() and (string.find(b:GetName(), "Left") or string.find(b:GetName(), "Prev") or string.find(b:GetName(), "Decrement") or string.find(b:GetName(), "Back"))

	if (b:GetNormalTexture()) then
		normal = b:GetNormalTexture():GetTexture()
	end

	if (b:GetPushedTexture()) then
		pushed = b:GetPushedTexture():GetTexture()
	end

	if (b:GetDisabledTexture()) then
		disabled = b:GetDisabledTexture():GetTexture()
	end

	b:Strip()

	if (not normal and isPrevButton) then
		normal = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up"
	elseif (not normal) then
		normal = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up"
	end

	if (not pushed and isPrevButton) then
		pushed = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down"
	elseif (not pushed) then
		pushed = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down"
	end

	if (not disabled and isPrevButton) then
		disabled = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled"
	elseif (not disabled) then
		disabled = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled"
	end

	b:SetNormalTexture(normal)
	b:SetPushedTexture(pushed)
	b:SetDisabledTexture(disabled)

	b:Template()							-- b:Template("Overlay")
	b:SetSize(b:GetWidth() - 7, b:GetHeight() - 7)

	if (normal and pushed and disabled) then
		if (horizonal) then
			b:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
			b:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
			b:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
			b:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.72, 0.65, 0.29, 0.65, 0.72)

			if (b:GetPushedTexture()) then
				b:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.8, 0.65, 0.35, 0.65, 0.8)
			end

			if (b:GetDisabledTexture()) then
				b:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
			end

		else
			b:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)

			if (b:GetPushedTexture()) then
				b:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
			end

			if (b:GetDisabledTexture()) then
				b:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
			end
		end

		b:GetNormalTexture():ClearAllPoints()
		b:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
		b:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)

		if (b:GetDisabledTexture()) then
			b:GetDisabledTexture():SetAllPoints(b:GetNormalTexture())
		end

		if (b:GetPushedTexture()) then
			b:GetPushedTexture():SetAllPoints(b:GetNormalTexture())
		end

		b:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
		b:GetHighlightTexture():SetAllPoints(b:GetNormalTexture())
	end
end

function T.SkinRotateButton(b)
	b:Template("DEFAULT")
	b:SetSize(b:GetWidth() - 14, b:GetHeight() - 14)

	b:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	b:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)

	b:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)

	b:GetNormalTexture():ClearAllPoints()
	b:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	b:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	b:GetPushedTexture():SetAllPoints(b:GetNormalTexture())
	b:GetHighlightTexture():SetAllPoints(b:GetNormalTexture())
end

function T.SkinEditBox(f)
	if (_G[f:GetName().."Left"]) then _G[f:GetName().."Left"]:Kill() end
	if (_G[f:GetName().."Middle"]) then _G[f:GetName().."Middle"]:Kill() end
	if (_G[f:GetName().."Right"]) then _G[f:GetName().."Right"]:Kill() end
	if (_G[f:GetName().."Mid"]) then _G[f:GetName().."Mid"]:Kill() end

	f:CreateBackdrop("OVERLAY")

	if (f:GetName() and (f:GetName():find("Gold") or f:GetName():find("Silver") or f:GetName():find("Copper"))) then
		if (f:GetName():find("Gold")) then
			f.backdrop:SetPoint("TOPLEFT", -3, 1)
			f.backdrop:SetPoint("BOTTOMRIGHT", -3, 0)
		else
			f.backdrop:SetPoint("TOPLEFT", -3, 1)
			f.backdrop:SetPoint("BOTTOMRIGHT", -13, 0)
		end
	end
end

function T.SkinDropDownBox(f, width)
	local button = _G[f:GetName().."Button"] or _G[f:GetName().."_Button"]
	if (not width) then width = 155 end

	f:StripTextures()
	f:SetWidth(width)

	if (_G[f:GetName().."Text"]) then
		_G[f:GetName().."Text"]:ClearAllPoints()
		_G[f:GetName().."Text"]:SetPoint("RIGHT", button, "LEFT", -2, 0)
	end

	button:ClearAllPoints()
	button:SetPoint("RIGHT", f, "RIGHT", -10, 3)
	button.SetPoint = A["Dummy"]

	T.SkinPrevNextButton(button, true)

	f:CreateBackdrop("OVERLAY")
	f:SetFrameLevel(f:GetFrameLevel() + 2)
	f.backdrop:SetPoint("TOPLEFT", 20, -2)
	f.backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
end

function T.SkinCheckBox(f)
	f:StripTextures()
	f:CreateBackdrop("OVERLAY")
	f:SetFrameLevel(f:GetFrameLevel() + 2)
	f.backdrop:SetPoint("TOPLEFT", 4, -4)
	f.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)

	if (f.SetHighlightTexture) then
		local highligh = f:CreateTexture(nil, nil, self)
		highligh:SetTexture(1, 1, 1, 0.3)
		highligh:SetPoint("TOPLEFT", f, 6, -6)
		highligh:SetPoint("BOTTOMRIGHT", f, -6, 6)
		f:SetHighlightTexture(highligh)
	end

	if (f.SetCheckedTexture) then
		local checked = f:CreateTexture(nil, nil, self)
		checked:SetTexture(1, 0.82, 0, 0.8)
		checked:SetPoint("TOPLEFT", f, 6, -6)
		checked:SetPoint("BOTTOMRIGHT", f, -6, 6)
		f:SetCheckedTexture(checked)
	end

	if (f.SetDisabledCheckedTexture) then
		local disabled = f:CreateTexture(nil, nil, self)
		disabled:SetTexture(0.6, 0.6, 0.6, 0.75)
		disabled:SetPoint("TOPLEFT", f, 6, -6)
		disabled:SetPoint("BOTTOMRIGHT", f, -6, 6)
		f:SetDisabledCheckedTexture(disabled)
	end

	f:HookScript("OnDisable", function(self)
		if (not self.SetDisabledTexture) then return; end
		if (self:GetChecked()) then
			self:SetDisabledTexture(disabled)
		else
			self:SetDisabledTexture("")
		end
	end)
end

function T.SkinCloseButton(f, point) --, text, pixel)
	f:StripTextures()
	f:Template("OVERLAY")
	f:SetSize(18, 18)

	-- if (not text) then text = "x" end

	if (not f.text) then
		f.text = f:FontString(nil, Addon.default.pxfont[1], Addon.default.pxfont[2])
		f.text:SetPoint("CENTER", 0, 0)

		f.text:SetText(text)
	end

	if (point) then
		f:SetPoint("TOPRIGHT", point, "TOPRIGHT", -4, -4)
	else
		f:SetPoint("TOPRIGHT", -4, -4)
	end

	f:HookScript("OnEnter", T.SetModifiedBackdrop)
	f:HookScript("OnLeave", T.SetOriginalBackdrop)
end

function T.SkinSlider(f)
	f:SetBackdrop(nil)

	local bd = CreateFrame("Frame", nil, f)
	bd:Template("OVERLAY")
	bd:SetPoint("TOPLEFT", 14, -2)
	bd:SetPoint("BOTTOMRIGHT", -15, 3)
	bd:SetFrameLevel(f:GetFrameLevel() - 1)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	slider:SetBlendMode("ADD")
end




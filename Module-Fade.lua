local fade = {}
fade.__index= fade

--[[
	
	tips localscript:

	local Fade = require(fide) -- location of this module
	local newFade = Fade.new(
	frame,		| Frame		| your frame
	duration,	| Number		|time of the animation
	type, 		| String		| currently only ("out"/"in")
	exception, 	| boolean	| add exception will ignore the frame, you can add your frame last name with __fade ex: Frame__fade
	Txtlabel,	| boolean	| background transparant
	imglabel,	| boolean	| background transparant
	scroll		| boolean	| background transparant and scrollBar Transparant
	)
	
	newFade:Play() -- run the aniamtion
	
	ex:
	local frame = "LOCATION_FRAME"
	local newFade = Fade.new(frame, 1, "out", true, true, true, true)
	newFade:Play()
	
	created: 25/02/2023
	author : ZeYn-Galaxy (github)
--]]


local TS = game:GetService("TweenService")


function fade.new(frame: Frame, duration: number, type: string, exception: boolean, Txtlabel: boolean, imglabel: boolean, scroll: boolean)
	return setmetatable(
		{
			frame = frame,
			duration = 1,
			type = type,
			exception = exception,
			label = Txtlabel,
			image = imglabel,
			scroll = scroll
		}, fade)
end

function fade:Play()

	local tween = TS:Create(self.frame, TweenInfo.new(self.duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { BackgroundTransparency = 1 })
	tween:Play()
	
	if self.type == "in" then
		local tween = TS:Create(self.frame, TweenInfo.new(self.duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { BackgroundTransparency = 0 })
		tween:Play()
	end
	
	for _,v in pairs(self.frame:GetDescendants()) do
		
		if self.exception and v.Name:reverse():sub(1, 4) == "edaf" then
			v.Active = true
			if self.type == "out" then
				v.Active = false
			end
			continue
		end
		
		if v:IsA("GuiBase") then
			
			local Property = { BackgroundTransparency = 1 }
			local valueOfTransparency = 0

			if self.type == "out" then
				valueOfTransparency = 1
				v.Active = false
				v.Archivable = false
			elseif self.type == "in" then
				valueOfTransparency = 0
				v.Active = true
				v.Archivable = true
			end
			

			if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
				Property = { BackgroundTransparency = valueOfTransparency, TextTransparency = valueOfTransparency}
			end

			if v:IsA("ScrollingFrame") then
				Property = { BackgroundTransparency = valueOfTransparency, ScrollBarImageTransparency = valueOfTransparency }
			end

			if v:IsA("ImageLabel") then
				Property = { BackgroundTransparency = valueOfTransparency, ImageTransparency = valueOfTransparency }
			end
			
			if v:IsA("TextLabel") and self.label then
				Property = { BackgroundTransparency = 1, TextTransparency = valueOfTransparency}
			end
			
			if v:IsA("ImageLabel") and self.image then
				Property = { BackgroundTransparency = 1, ImageTransparency = valueOfTransparency }
			end
			
			if v:IsA("ScrollingFrame") and self.scroll then
				Property = { BackgroundTransparency = 1, ScrollBarImageTransparency = 1 }
			end
			
			local tween = TS:Create(v, TweenInfo.new(self.duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), Property)
			tween:Play()
			
		end
	end
	


end

return fade

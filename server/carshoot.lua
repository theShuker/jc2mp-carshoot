class 'Carshoot'

	function Carshoot:__init()
    	admins = { --Make records like "SteamId("STEAM_X:X:XXXXXXXX")"
    		SteamId("STEAM_0:0:21954898")
    	}
    	adminCheckDisabled = true -- set this to FALSE to check admins
    	launchForce = 120
    	timer = nil
    	veh = nil
    	spawnArgs = {}
    	carshootenabled = false
    	Network:Subscribe("Detonate", self, self.Detonate)
		Network:Subscribe("Fire", self, self.Fire)
    	Events:Subscribe("PlayerChat", self, self.PlayerChat)
    	Events:Subscribe("ModuleUnload", self, self.Disable)
    	Events:Subscribe("PlayerQuit", self, self.Disable)
	end

	function Carshoot:checkAdmin(reqsteamid) --Admin Checking by steamid. Put ur admins steamid to the "admins" table.
    	local admincount
    	for admincount = 1, #admins do
        	if reqsteamid == admins[admincount] then
        		return true
        	end
    	end
	end

	function Carshoot:PlayerChat(args)
    	local cmds = args.text:split(" ")
    	if cmds[1] == "/carshoot" then
    		if adminCheckDisabled or Carshoot:checkAdmin(args.player:GetSteamId()) then
        		if carshootenabled then 
            		Carshoot:Disable(args)
        		else
            		Carshoot:Enable(args)
            		if #cmds == 2 then
                		spawnArgs.model_id = tonumber(cmds[2])
            		else
                		spawnArgs.model_id = 4
            		end
        		end
    		else
    			args.player:SendChatMessage("Admins only!", Color(255,0,0))
    		end
    		return false
    	end
    end

	function Carshoot:Enable(args)
		carshootenabled = true
		Network:Send(args.player, "ChangeState", true)
		args.player:SendChatMessage("Carshoot enabled.", Color(255,0,0))
	end

	function Carshoot:Disable(args)
		carshootenabled = false
		if veh ~= nil then veh:Remove() end
		veh = nil
		if args ~= nil then
			Network:Send(args.player, "ChangeState", false)
			args.player:SendChatMessage("Carshoot disabled.", Color(0,255,0))
		end
	end

	function Carshoot:Fire(args, player)
    	if carshootenabled then
        	spawnArgs.position = player:GetPosition() + Vector3(0,1,0) + args.direction * 10
        	spawnArgs.angle = args.angle
        	spawnArgs.linear_velocity = args. direction * launchForce
        		if veh ~= nil then veh:Remove() end
        		veh = Vehicle.Create(spawnArgs)

    	end
	end

	function Carshoot:Detonate(player)
    	if carshootenabled then
        	if veh ~= nil then
            	veh:SetHealth(0)
        	end
    	end
	end
	
carshoot = Carshoot()

class 'Carshoot'

function Carshoot:__init()
    carshootenabled = false
    timer = nil
    timer2 = nil
    interval = 1
    Network:Subscribe("ChangeState", self, self.ChangeState)
    Events:Subscribe("LocalPlayerInput", LocalPlayerInput)
end

function Carshoot:ChangeState(value)
carshootenabled = value
end

function Carshoot:Fire()
    local args = {}
    args.angle = Camera:GetAngle()
    args.direction = args.angle * Vector3(0,0,-1)
    
    Network:Send("Fire", args)
end

function Carshoot:Detonate()
    Network:Send("Detonate", player)
end

function Carshoot:FireInterval()
    if timer then
        if timer:GetSeconds() >= interval then
            timer = nil
        end
    else
        self.Fire()
        timer = Timer()
    end
end

function Carshoot:DetonateInterval()
    if timer2 then
        if timer2:GetSeconds() >= interval then
            timer2 = nil
        end
    else
        self.Detonate()
        timer2 = Timer()
    end
end


function LocalPlayerInput(args)
if carshootenabled then
    if args.input == Action.FireRight then
        Carshoot:FireInterval()
        return false
    elseif args.input == Action.FireLeft then
        Carshoot:DetonateInterval()
        return false
    else
        return true
    end
    
end
end
Events:Subscribe("LocalPlayerInput", LocalPlayerInput)
carshoot = Carshoot()
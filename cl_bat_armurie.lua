-- cl_bat_armurie.lua


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)     
		Citizen.Wait(0)
	end
end)



--- Créations du Menu ---

local open = false 
local MainMenu = RageUI.CreateMenu('Armurie', 'interaction') 
local subMenu = RageUI.CreateSubMenu(MainMenu, "Armurie", "interaction")
local subMenu2 = RageUI.CreateSubMenu(MainMenu, "Armurie", "interaction")
local subMenu3 = RageUI.CreateSubMenu(MainMenu, "Armurie", "interaction")
local subMenuppa = RageUI.CreateSubMenu(MainMenu, "Armurie", "interaction")
local subMenuppa2 = RageUI.CreateSubMenu(MainMenu, "Armurie", "interaction")
MainMenu.Display.Header = true 
MainMenu.Closed = function()
  open = true
end

--- Ouverture du Menu ---

function MenuArmurieBatOP() 
	if open then 
		open = false
		RageUI.Visible(MainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(MainMenu, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(MainMenu,function() 

            ESX.TriggerServerCallback('batop:jeregardelalicense', function(cb)            
                if cb then
                    ppa = true 
                    else 
                     ppa = false   
                end
              end)

			RageUI.Button("Armes Blanches", nil, {RightLabel = "→→"}, true , {
				onSelected = function() 
               end
		}, subMenu)

   if ppa == false then
        RageUI.Button("Armes Létales", nil, {}, false, {})
        
        RageUI.Button("Acheter PPA", nil, {RightLabel = "→→"}, true , {}, subMenuppa2)
    end
    if ppa == true then
        RageUI.Button("Armes Létales", nil, {RightLabel = "→→"}, true, {}, subMenu2)
    end

        RageUI.Button("Chargeurs d'Armes", nil, {RightLabel = "→→"}, true , { 
            onSelected = function() 
            end
        }, subMenu3) 


    end) 

       

			RageUI.IsVisible(subMenu,function()

                RageUI.Separator("↓ Liste des Armes Blanches ↓")
               for k, v in pairs(Config.Categories.Blanches) do 
               RageUI.Button(v.label, nil, {RightLabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true , {
					onSelected = function()
					   TriggerServerEvent('batop:jepayedesarmes',v.name, v.label, v.price)
                    end,
				})
            end
        end)
        
        RageUI.IsVisible(subMenuppa2, function()

			RageUI.Button("Permis de port d'arme", nil, {RightLabel = "~g~150 000~g~$"}, true , {
				onSelected = function()
					TriggerServerEvent("batop:jepayeleppa","weapon")
					RageUI.CloseAll()
					openAmmunation = false
				end
			})

		end)
        RageUI.IsVisible(subMenu2,function() 
            RageUI.Separator("↓ Liste des Armes Létales ↓")
            for k, v in pairs(Config.Categories.Letale) do 
                RageUI.Button(v.label, nil, {RightLabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true , {
                     onSelected = function()
                        TriggerServerEvent('batop:jepayedesarmes',v.name, v.label, v.price)
	
                    end,
				})
            end
        end)

        RageUI.IsVisible(subMenu3,function()
            RageUI.Separator("↓ Liste des Chargeurs ↓")
            for k, v in pairs(Config.Categories.Chargeur) do 
           RageUI.Button(v.label, nil, {RightLabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true , {
                onSelected = function()
                   TriggerServerEvent('batop:jepayedeschargeurs',v.name, v.label, v.price)
                end,
            })
        end
    end)

		Wait(5)
	end
 end)
end
end 

---- Blips + Position Vendeur ----
Citizen.CreateThread(function()  
    while Config == nil do 
        Wait(5000)
    end 
    for k, v in pairs(Config.Armuries) do 
        -- Blips
        local blips = AddBlipForCoord(v.pos)
        SetBlipSprite(blips, 110)
        SetBlipColour(blips, 38)
        SetBlipScale(blips, 0.9)
        SetBlipDisplay(blips, 4)
        SetBlipAsShortRange(blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("~g~[NON JOB] Armuries")
        EndTextCommandSetBlipName(blips)

        -- Vendeurs (Ped)
        while not HasModelLoaded(v.pedModel) do
            RequestModel(v.pedModel)
            Wait(1)
        end
        Ped = CreatePed(2, GetHashKey(v.pedModel), v.pedPos, v.heading, 0, 0)
        FreezeEntityPosition(Ped, 1)
        TaskStartScenarioInPlace(Ped, v.pedModel, 0, false)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    while true do 
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if not openedMenu then 
            for k, v in pairs(Config.Armuries) do 
                if #(myCoords - v.pos) < 1.0 then 
                    nofps = true
                    Visual.Subtitle("Appuyer sur ~b~[E]~s~ pour parler au ~b~vendeur", 1) 
                    if IsControlJustPressed(0, 38) then 
                        lastPos = GetEntityCoords(PlayerPedId())                 
                        MenuArmurieBatOP()
                    end 
                elseif #(myCoords - v.pos) < 5.0 then 
                    nofps = true 
                    DrawMarker(22, v.pos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)     
                end 
            end 
        end
        if nofps then 
            Wait(1)
        else 
            Wait(2000)
        end 
    end
end)
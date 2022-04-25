-- sv_bat_armurie.lua

ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('batop:jeregardelalicense', function(source, cb, type)
    JeRegardeLaLicense(source, 'weapon', cb)
end)

RegisterServerEvent("batop:jepayedesarmes")
AddEventHandler("batop:jepayedesarmes", function(name, label, price) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= price then
	    xPlayer.removeMoney(price)
    	xPlayer.addWeapon(name, 50) 
        TriggerClientEvent('esx:showNotification', source, "Vous avez bien acheté ~b~1x "..label.."~s~ pour ~g~"..price.."$~s~ !")
     else 
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d'argent sur vous !")    
    end
end)

RegisterServerEvent("batop:jepayedeschargeurs")
AddEventHandler("batop:jepayedeschargeurs", function(name, label, price) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= price then
	    xPlayer.removeMoney(price)
    	xPlayer.addInventoryItem('clip', 1) 
        TriggerClientEvent('esx:showNotification', source, "Vous avez bien acheté ~b~1x "..label.."~s~ pour ~g~"..price.."$~s~ !")
     else 
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d'argent sur vous !")    
    end
end)

function JeRegardeLaLicense(source, type, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	local id = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = id
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

RegisterServerEvent('batop:jepayeleppa')
AddEventHandler('batop:jepayeleppa', function(weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ArgentJoueur = xPlayer.getMoney()

	if ArgentJoueur >= 150000 then
    MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
        ['@type'] = weapon,
        ['@owner'] = xPlayer.identifier
    })
	    xPlayer.removeMoney(150000)
	    TriggerClientEvent('esx:showNotification', source, "~g~Achat effectué !")
	else
		TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez ~r~d'argent sur vous !")
	end
end)
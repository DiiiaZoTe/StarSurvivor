liste_power = {}

sonPowerup = love.audio.newSource("sons/powerup.wav","static")
sonPowerup:setVolume(0.3)
sonPowerupGrow = love.audio.newSource("sons/powerGrow.wav","static")
sonPowerupGrow:setVolume(0.3)

-- GestionPowerUp
-- Gestion des differents stades des powerups
-- Parametre : dt
function GestionPowerUp(dt)
  -- S'il n'y a pas de powerup actif ou recuperable
  if powerUpOption.activeTimer == 0 and not powerUpOption.activated then
    powerUpOption.globalTimer = powerUpOption.globalTimer + dt
    if powerUpOption.globalTimer >= powerUpOption.nextPowerUp then
      --spawn
      SpawnPowerUp(dt)
      powerUpOption.globalTimer = 0
      powerUpOption.nextPowerUp = math.random(15,25)
      sonPowerupGrow:play()
    end
  -- s'il y a un powerup recuperable
  elseif powerUpOption.activeTimer > 0 and not powerUpOption.activated then
    powerUpOption.activeTimer = powerUpOption.activeTimer + dt
    if powerUpOption.activeTimer <= 3 or powerUpOption.activeTimer > 7 then
      PowerUpPop(dt)
    end
    if powerUpOption.activeTimer > powerUpOption.timeToTake then --temps pour recup ecoule
      table.remove(liste_power,1)
      powerUpOption.activeTimer = 0
    elseif Collide(heros,liste_power[1]) then --on recup le powerup
      PowerUpApplyEffet(liste_power[1])
    end
  -- s'il y a un powerup actif
  elseif powerUpOption.activated then
    if powerUpOption.activeTimer < powerUpOption.maxActiveTime then --tant qu'il est actif
      powerUpOption.activeTimer = powerUpOption.activeTimer + dt
    else -- fin du powerup
      PowerUpRemEffet()
    end    
  end
end

-- CreePowerUps
-- Creation d'un powerup
-- Parametre : chemin, x,y
-- return : powerup
function CreePowerUps(pChemin,pType,pX,pY)
  local powerup = CreeSprite(pChemin,pX,pY)
  powerup.scale = 0
  powerup.timer = 0
  powerup.type = pType
  table.insert(liste_power,powerup)
  return powerup
end

-- SpawnPowerUp
-- Spawn un nouveau power up aleatoirement sur la map
-- Parametre : dt
function SpawnPowerUp(dt)
  local nbPowerUp = math.random(1,#powerUpOption.image)
  local randX = math.random(0.1*largeur,0.9*largeur)
  local randY = math.random(0.1*hauteur,0.9*hauteur)
  CreePowerUps(powerUpOption.image[nbPowerUp],nbPowerUp,randX,randY)
  powerUpOption.activeTimer = powerUpOption.activeTimer + dt
end

-- PowerUpPop
-- Faire pop le powerup
-- Parametre :dt
function PowerUpPop(dt)
  for n,powerup in ipairs(liste_power) do
    powerup.timer = powerup.timer + dt
    if powerup.timer < 2 then
      powerup.scale = powerup.timer/2 * globalScale * 1.2
    elseif powerup.timer > 8 then
      powerup.scale = (10-powerup.timer)/2 * globalScale * 1.2
    else
      powerup.scale = 1.2 * globalScale
    end
    
  end
end

-- PowerUpApplyEffet
-- Applique l'effet selon le powerup
-- Parametre : powerup
function PowerUpApplyEffet(powerup)
  powerUpOption.typeActive = powerup.type
  if powerUpOption.typeActive == 1 then
    heros.timeShoot[1] = 0
    heros.timeShoot[2] = 0.5
    powerUpOption.typeActiveName = langage[langage.actuel].texte[24]
  elseif powerUpOption.typeActive == 2 then
    heros.vie = heros.vie + 250
    heros.boostFuel = heros.boostFuel + heros.boostFuelMax/2
    if heros.vie > heros.vieMax then
      heros.vie = heros.vieMax
    end
    if heros.boostFuel > heros.boostFuelMax then
      heros.boostFuel = heros.boostFuelMax
    end
    powerUpOption.typeActiveName = langage[langage.actuel].texte[25]
  elseif powerUpOption.typeActive == 3 then
    heros.isInvinsible = true
    powerUpOption.typeActiveName = langage[langage.actuel].texte[26]
  end
  sonPowerup:play()
  table.remove(liste_power,1)
  powerUpOption.activeTimer = 0
  powerUpOption.activated = true
end

-- PowerUpReset
-- Reset le systeme de powerup a l'etat initiale
function PowerUpReset()
  powerUpOption.globalTimer = 0
  powerUpOption.activeTimer = 0
  powerUpOption.activated = false
  powerUpOption.typeActive = 0
  powerUpOption.nextPowerUp = math.random(10,20)
  table.remove(liste_power,1)
end

-- PowerUpRemEffet
-- Enleve les effets du powerup actif
function PowerUpRemEffet()
    if powerUpOption.typeActive == 1 then
    heros.timeShoot[1] = 0.2
    heros.timeShoot[2] = 2
  elseif powerUpOption.typeActive == 3 then
    heros.isInvinsible = false
  end
  powerUpOption.typeActive = 0
  powerUpOption.activeTimer = 0
  powerUpOption.activated = false
end
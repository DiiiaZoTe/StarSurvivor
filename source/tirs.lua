liste_tirs = {}
liste_explosions = {}
img_explosions = {}

-- CreeTir
-- Creation du tir en fonction du tireur
-- Parametre : entite qui cree le tir, le type du tir, dt
function CreeTir(pEntite,pType,dt)
  --si c'est le heros
  if pEntite == heros then
    local tx = heros.x + math.sin(heros.angle)*heros.scale*40 --position x du depart du tir (avant du vaisseau)
    local ty = heros.y - math.cos(heros.angle)*heros.scale*40 --position y du depart du tir (avant du vaisseau)
    local tir
    if pType == 1 then 
      tir = CreeSprite("images/Lasers/laserGreen13.png", tx, ty)
      tir.scale = 0.6 * globalScale
      tir.vitesse = 1000 * globalScale
      tir.degats = 40
      PlaySonTirExplode(liste_sonTirs.sonShoot1)
    elseif pType == 2 then
      tir = CreeSprite("images/Lasers/laserRed12.png", tx, ty)
      tir.scale = 0.8 * globalScale
      tir.vitesse = 1500 * globalScale
      tir.degats = 200
      PlaySonTirExplode(liste_sonTirs.sonShoot2)
    end
    tir.type = pType
    local mx = love.mouse.getX()
    local my = love.mouse.getY()
    tir.origine = "heros"
    tir.angle = math.atan2(heros.y - my, heros.x - mx) - math.pi /2
    tir.vx = math.sin(tir.angle) * tir.vitesse * dt
    tir.vy = -math.cos(tir.angle) * tir.vitesse * dt
    table.insert(liste_tirs, tir)
    heros.shotEnabler[pType] = 0
    heros.canShoot[pType] = false
    levelOptions.totalHeroShots = levelOptions.totalHeroShots + 1
    if powerUpOption.typeActive == 1 then
      tir.color = {math.random(1,255),math.random(1,255),math.random(1,255)}
      tir.colorDefault = false
    else
      tir.colorDefault = true
    end
    
  else -- si c'est un alien
    --moyen alien
    if pEntite.type == 1 then
      local tx = pEntite.x + math.sin(pEntite.angle)*pEntite.scale*50 --position x du depart du tir (avant du vaisseau)
      local ty = pEntite.y - math.cos(pEntite.angle)*pEntite.scale*50 --position y du depart du tir (avant du vaisseau)
      local tir
      tir = CreeSprite("images/Lasers/laserBlue13.png", tx, ty)
      tir.scale = 0.4 * globalScale
      tir.vitesse = 500 * globalScale
      tir.degats = 20
      tir.type = 1
      tir.origine = "alien"
      PlaySonTirExplode(liste_sonTirs.sonShoot1)
      tir.angle = math.atan2(pEntite.y - heros.y, pEntite.x - heros.x) - math.pi/2
      tir.vx = math.sin(tir.angle) * tir.vitesse * dt
      tir.vy = -math.cos(tir.angle) * tir.vitesse * dt
      table.insert(liste_tirs, tir)
    end
    -- gros alien
    if pEntite.type == 3 then
      local tx = pEntite.x + math.sin(pEntite.angle)*pEntite.scale*60 --position x du depart du tir (avant du vaisseau)
      local ty = pEntite.y - math.cos(pEntite.angle)*pEntite.scale*60 --position y du depart du tir (avant du vaisseau)
      local tir
      tir = CreeSprite("images/Lasers/laserBlue12.png", tx, ty)
      tir.scale = 0.6 * globalScale
      tir.vitesse = 750 * globalScale
      tir.degats = 75
      tir.type = 2
      tir.origine = "alien"
      PlaySonTirExplode(liste_sonTirs.sonShoot2)
      tir.angle = math.atan2(pEntite.y - heros.y, pEntite.x - heros.x) - math.pi /2
      tir.vx = math.sin(tir.angle) * tir.vitesse * dt
      tir.vy = -math.cos(tir.angle) * tir.vitesse * dt
      table.insert(liste_tirs, tir)
    end
  end
end

-- PlaySonTirExplode
-- Joue le son
-- Parametre : son a joue
function PlaySonTirExplode(pSon)
  if pSon == liste_sonTirs.sonShoot1 then
    local pitch = math.random(8,12) / 10
    pSon:setPitch(pitch)
  elseif pSon == liste_sonTirs.sonBoum then
    local pitch = math.random(7,11) / 10
    pSon:setPitch(pitch)
  end
  pSon:play()
end

-- TirGestionSprite
-- Update et gere les tirs et explosion : 
-- lance tirHit, remove ...
-- Parametre : dt
function TirGestionSprite(dt)
  local n
  for n=#liste_tirs,1,-1 do
    local tir = liste_tirs[n]
    tir.x = tir.x + tir.vx
    tir.y = tir.y + tir.vy
    -- Vérifier si le tir n'est pas sorti de l'écran
    if tir.y < 0 or tir.y > hauteur or tir.x < 0 or tir.x > largeur then
      table.remove(liste_tirs, n)
    end
    if TirHit(tir) then
      table.remove(liste_tirs, n)
    end
  end
  for n=#liste_explosions,1,-1 do
    local exp = liste_explosions[n]
    exp.currentImage = exp.currentImage + 1
    if exp.type == 1 then
      if exp.currentImage > 3
        then table.remove(liste_explosions,n)
      end
    else
      if exp.currentImage > 5
        then table.remove(liste_explosions,n)
      end
    end
  end
end

-- TirHit
-- En fonction du tir, verifie s'il touche la bonne cible et applique degats
-- Parametre : tir
-- Return : bool
function TirHit(tir)
  -- on collisionne et hit le decor
  for n,decor in ipairs(liste_decors) do
    local lDecor = decor.l/2*decor.scale
    local hDecor = decor.h/2*decor.scale
    if tir.x>=(decor.x-lDecor) and tir.x<=(decor.x+lDecor) and tir.y>=(decor.y-hDecor) and tir.y<=(decor.y+hDecor) then
      if tir.type == 2 then
        TirDegatZone(tir,decor)
        PlaySonTirExplode(liste_sonTirs.sonExplode)
      end
      CreeExplosion("shot",tir.type,tir.x,tir.y)
      return true
    end
  end
  
  if tir.origine == "heros" then
    local i for i=1,#liste_aliens do
      local alien = liste_aliens[i]
      local lAlien = alien.l/2*alien.scale
      local hAlien = alien.h/2*alien.scale
      if tir.x>=(alien.x-lAlien) and tir.x<=(alien.x+lAlien) and tir.y>=(alien.y-hAlien) and tir.y<=(alien.y+hAlien) then
        alien.vie = alien.vie - tir.degats
        if tir.type == 2 then
          TirDegatZone(tir,alien)
          PlaySonTirExplode(liste_sonTirs.sonExplode)
        end
        CreeExplosion("shot",tir.type,tir.x,tir.y)
        levelOptions.totalHeroShotsHit = levelOptions.totalHeroShotsHit + 1
        return true
      end
    end
    if gamestate[gamestate.currentState] == "menu" then
      local n for n,choix in ipairs(menu.choix) do
        local lchoix = choix.l/2
        local hchoix = choix.h/2
        if tir.x>=(choix.x-lchoix) and tir.x<=(choix.x+lchoix) and tir.y>=(choix.y-hchoix) and tir.y<=(choix.y+hchoix) then
          choix.vie = choix.vie - tir.degats
          if tir.type == 2 then
            TirDegatZone(tir,alien)
            PlaySonTirExplode(liste_sonTirs.sonExplode)
          end
          CreeExplosion("shot",tir.type,tir.x,tir.y)
          return true
        end
      end
    end
    return false
    
  elseif tir.origine == "alien" then
    local lHeros = heros.l/2*heros.scale
    local hHeros = heros.h/2*heros.scale
    if tir.x>=(heros.x-lHeros) and tir.x<=(heros.x+lHeros) and tir.y>=(heros.y-hHeros) and tir.y<=(heros.y+hHeros) then
      if not heros.isInvinsible then
        heros.vie = heros.vie - tir.degats
      end
      if tir.type == 2 then
        TirDegatZone(tir,heros)
        PlaySonTirExplode(liste_sonTirs.sonExplode)
      end
      CreeExplosion("shot",tir.type,tir.x,tir.y)
      return true
    end
    if levelOptions.tkAlien then --bAlienTeamKill then
      local i for i=1,#liste_aliens do
        local alien = liste_aliens[i]
        local lAlien = alien.l/2*alien.scale
        local hAlien = alien.h/2*alien.scale
        if tir.x>=(alien.x-lAlien) and tir.x<=(alien.x+lAlien) and tir.y>=(alien.y-hAlien) and tir.y<=(alien.y+hAlien) then
          alien.vie = alien.vie - tir.degats
          if tir.type == 2 then
            TirDegatZone(tir,alien)
            PlaySonTirExplode(liste_sonTirs.sonExplode)
          end
          CreeExplosion("shot",tir.type,tir.x,tir.y)
          return true
        end
      end
    end
    return false
  else
    print("erreur origine du tir")
  end
end

-- TirGestionSprite
-- Applique degats de zone pour tir type 2
-- Parametre : tir, entite ayant pris le tir
function TirDegatZone(pTir,pEntite)
  local n for n=1,#liste_aliens do
    local alien = liste_aliens[n]
    if alien ~= pEntite then
      local distAlien = math.floor(GetDistance(alien.x,alien.y,pTir.x,pTir.y))
      if distAlien <= pTir.degats/2*globalScale then -- zone de degats = degats/2 (si 200 alors 100 autour)
        -- degats de zone = degats du tir - la distance avec un pas de 2
        -- tous les 1 de distance, l'explosion fait 2 de degats en moins
        alien.vie = alien.vie - (pTir.degats-(distAlien*2))
      end
    end
  end
  local distHero = math.floor(GetDistance(heros.x,heros.y,pTir.x,pTir.y))
  if distHero <= pTir.degats/2*globalScale then
    if not heros.isInvinsible then
      heros.vie = heros.vie - (pTir.degats-(distHero*2))
    end
  end
end

-- CreeExplosion
-- Creer une explosion
-- Parametre : string effet, int type, x, y, entité (si elle est detruite)
function CreeExplosion(pEffect,pTypeExplosion,pX,pY,pEntity)
  local explosion = CreeSprite("images/Effects/explode_1.png", pX, pY)
  if pEffect == "shot" then
    explosion.type = pTypeExplosion
    if explosion.type == 1 then
      explosion.scale = 1.2 * globalScale
    else
        explosion.scale = 4 * globalScale
    end
  elseif pEffect ~= "explosion" and pEntity == nil then
    print("Erreur function CreeExplosion, pEntity nil with explosion")
  elseif pEffect == "explosion" and pEntity ~= nil then
    explosion.type = 2
    explosion.scale = pEntity.scale * 5 * globalScale
  elseif pEffect == "gameover" and pEntity == heros then
    explosion.type = 2
    explosion.scale = pEntity.scale * 15 * globalScale
  end

  explosion.currentImage = 1
  table.insert(liste_explosions,explosion)
end
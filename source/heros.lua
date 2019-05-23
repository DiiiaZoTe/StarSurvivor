heros = {}

-- CreeHeros
-- Creer le heros
function CreeHeros()
  heros = CreeSprite(vaisseauImage[vaisseauImage.current], largeur/2,hauteur/2)
  heros.scale = 0.5 * globalScale
  heros.vx = 0
  heros.vy = 0
  heros.vmax = 3.5 * globalScale
  heros.boostFactor = 1
  heros.boostFuel = 10
  heros.boostFuelMax = heros.boostFuel
  heros.isBoosting = false
  heros.canBoost = true
  heros.boostImg = {}
  heros.boostImg.image = love.graphics.newImage("images/Effects/fire07.png")
  heros.boostImg.l = heros.boostImg.image:getWidth()
  heros.boostImg.h = heros.boostImg.image:getHeight()
  heros.vie = 1000
  heros.vieMax = heros.vie
  heros.vivant = true
  heros.shotEnabler = {}
    heros.shotEnabler[1]=0
    heros.shotEnabler[2]=0
  heros.timeShoot = {}
    heros.timeShoot[1] = 0.2
    heros.timeShoot[2] = 2
  heros.canShoot = {}
    heros.canShoot[1] = false
    heros.canShoot[2] = false
  heros.isInvinsible = true
  heros.shieldImg = {}
    heros.shieldImg.image = love.graphics.newImage("images/Effects/shield1.png")
    heros.shieldImg.l = heros.shieldImg.image:getWidth()
    heros.shieldImg.h = heros.shieldImg.image:getHeight()
end

-- HeroAction
-- Gere le lancement de toutes les actions du hero
-- Parametre : dt
function HeroAction (dt)
  if heros.vivant then
    DeplacementHero(dt)
    TirHero(dt)
    UpdateShotEnabler(dt)
    VerifyHero(dt)
  end
end

-- DeplacementHero
-- Gere le déplacement du hero en appliquant la collision
-- Parametre : dt
function DeplacementHero(dt)
  local mx = love.mouse.getX()
  local my = love.mouse.getY()
  -- angle du vaisseau = endroit ou pointe la souris
  heros.angle = math.atan2(heros.y - my, heros.x - mx) - math.pi /2
  
  --booster
  if love.keyboard.isDown(optionsJeu[2].options[7].valeur) then
    if heros.boostFuel < 0 then
      heros.canBoost = false
    else
      heros.canBoost = true
    end
    if heros.canBoost then
      heros.boostFactor = 2
      heros.vmax = 6 * globalScale
      heros.isBoosting = true
      if not levelOptions.boostInfini then
        heros.boostFuel = heros.boostFuel - dt
      end
    else
      heros.boostFactor = 1
      heros.vmax = 3.5 * globalScale
      heros.isBoosting = false
    end
  else
    heros.boostFactor = 1
    heros.vmax = 3.5 * globalScale
    heros.isBoosting = false
  end
  -- deplacement vertical
  if love.keyboard.isDown(optionsJeu[2].options[3].valeur) then -- haut
    heros.vy = heros.vy - 15 * dt * heros.boostFactor
    if heros.vy < -heros.vmax then
      heros.vy  = -heros.vmax
    end
  elseif love.keyboard.isDown(optionsJeu[2].options[4].valeur) then -- bas
    heros.vy = heros.vy + 15 * dt  * heros.boostFactor
    if heros.vy > heros.vmax then
      heros.vy = heros.vmax
    end
  else
    if heros.vy < 0.1 and heros.vy > 0 then
      heros.vy = 0
    elseif heros.vy > -0.1 and heros.vy < 0 then
      heros.vy = 0
    end
    if heros.vy > 0 then
      if not heros.isBoosting and heros.vy > heros.vmax then
        heros.vy = heros.vmax
      end
      heros.vy = heros.vy - 1* dt
    elseif heros.vy < 0 then
      if not heros.isBoosting and heros.vy < -heros.vmax then
        heros.vy = -heros.vmax
      end
      heros.vy = heros.vy + 1 * dt
    end
  end
  -- deplacement horizontal
  if love.keyboard.isDown(optionsJeu[2].options[5].valeur) then --gauche
    heros.vx = heros.vx - 15 * dt  * heros.boostFactor
    if heros.vx < -heros.vmax then
      heros.vx  = -heros.vmax
    end
  elseif love.keyboard.isDown(optionsJeu[2].options[6].valeur) then --droite
    heros.vx = heros.vx + 15 * dt  * heros.boostFactor
    if heros.vx > heros.vmax then
      heros.vx = heros.vmax
    end
  else
    if heros.vx < 0.1 and heros.vx > 0 then
      heros.vx = 0
    elseif heros.vx > -0.1 and heros.vx < 0 then
      heros.vx = 0
    end
    if heros.vx > 0 then
      if not heros.isBoosting and heros.vx > heros.vmax then
        heros.vx = heros.vmax
      end
      heros.vx = heros.vx - 1 * dt
    elseif heros.vx < 0 then
      if not heros.isBoosting and heros.vx < -heros.vmax then
        heros.vx = -heros.vmax
      end
      heros.vx = heros.vx + 1 * dt
    end
  end
  
  local canHeroMove = CollisionHeroPlay(dt)
  if canHeroMove.x then
    heros.x = heros.x + heros.vx
  else
    heros.vx = 0
  end
  if canHeroMove.y then
    heros.y = heros.y + heros.vy
  else
    heros.vy = 0
  end
end

-- TirHero
-- Gestion du tir du hero et lancement creation des tirs, s'il clic
-- Parametre : dt
function TirHero(dt)
  if love.mouse.isDown(1) or love.keyboard.isDown(optionsJeu[2].options[1].valeur) then
    if heros.canShoot[1] then
      CreeTir(heros,1,dt)
    end
  end
  if love.mouse.isDown(2) or love.keyboard.isDown(optionsJeu[2].options[2].valeur) then
    if heros.canShoot[2] then
      CreeTir(heros,2,dt)
    end
  end
end

-- UpdateShotEnabler
-- Mets a jour le timer pour le shoot du hero
-- Parametre : dt
function UpdateShotEnabler(dt) -- update cursor en meme temps
  heros.shotEnabler[1] = heros.shotEnabler[1] + dt
  heros.shotEnabler[2] = heros.shotEnabler[2] + dt
  -- tir clic gauche (0.2 = 5 tir/sec)
  if heros.shotEnabler[1] >= heros.timeShoot[1] then
    heros.canShoot[1] = true
  end
  -- tir clic droit (2 = 1 tir/2sec) : cursor noncharger en 4 phases soit update cursor chaque 2/4 = 0.5 sec
  local i
  for i=1,#cursor-1 do
    if heros.shotEnabler[2] < i*(heros.timeShoot[2]/(#cursor-1)) then
      love.mouse.setCursor(cursor[i])
      break
    end
  end
  if heros.shotEnabler[2] >= heros.timeShoot[2] then
    love.mouse.setCursor(cursor[#cursor])
    heros.canShoot[2] = true
  end
end

-- CollisionHeroPlay
-- Gere les differents types de collision du heros
-- Parametre : dt
-- return : canMove {x,y}
function CollisionHeroPlay(dt)
  CollisionHeroMur(dt)
  local collisionAlien = CollisionHeroAlien(dt)
  local collisionDecor = CollisionHeroDecor(dt)
  local collisionManager = {}
  if collisionAlien.x and collisionDecor.x then
    collisionManager.x = true
  else
    collisionManager.x = false
  end
  if collisionAlien.y and collisionDecor.y then
    collisionManager.y = true
  else
    collisionManager.y = false
  end
  return collisionManager
end

-- CollisionHeroAlien
-- Test la collision entre hero et aliens
-- Parametre : dt
-- return : canMove {x,y}
function CollisionHeroAlien(dt)
  local canHeroMove = {x=true,y=true}
  local n for n,alien in ipairs(liste_aliens) do
    if Collide(heros,alien) then
      local addLargeur = heros.l/3*heros.scale + alien.l/3*alien.scale
      local addHauteur = heros.h/3*heros.scale + alien.h/3*alien.scale
      local diffX = math.abs(alien.x - heros.x)
      local diffY = math.abs(alien.y - heros.y)
      if math.abs(addLargeur - diffX) > math.abs(addHauteur - diffY) then
        if (heros.vy>0 and heros.y<alien.y) or (heros.vy<0 and heros.y>alien.y) then
          canHeroMove.y = false
        end
      else
        if (heros.vx>0 and heros.x<alien.x) or (heros.vx<0 and heros.x>alien.x) then 
          canHeroMove.x = false
        end 
      end
    end
  end
  return canHeroMove
end

-- CollisionHeroDecor
-- Test la collision entre hero et decor
-- Parametre : dt
-- return : canMove {x,y}
function CollisionHeroDecor(dt)
  local canHeroMove = {x=true,y=true}
  local n for n,decor in ipairs(liste_decors) do
    if Collide(heros,decor) then
      local addLargeur = heros.l/3*heros.scale + decor.l/3*decor.scale
      local addHauteur = heros.h/3*heros.scale + decor.h/3*decor.scale
      local diffX = math.abs(decor.x - heros.x)
      local diffY = math.abs(decor.y - heros.y)
      if math.abs(addLargeur - diffX) > math.abs(addHauteur - diffY) then
        if (heros.vy>0 and heros.y<decor.y) or (heros.vy<0 and heros.y>decor.y) then
          canHeroMove.y = false
        end
      else
        if (heros.vx>0 and heros.x<decor.x) or (heros.vx<0 and heros.x>decor.x) then 
          canHeroMove.x = false
        end 
      end
    end
  end
  return canHeroMove
end

-- CollisionHeroMur
-- Gere la collision du hero avec les murs
-- Parametre : dt
function CollisionHeroMur(dt)
  if heros.y - heros.h/2 * heros.scale < 0 then
    heros.y = heros.h/2 * heros.scale
    heros.vy = heros.vy + 15 * dt
  elseif heros.y + heros.h/2 * heros.scale > hauteur then
    heros.y = hauteur - heros.h/2 * heros.scale
    heros.vy = heros.vy - 15 * dt
  end
  if heros.x - heros.l/2 * heros.scale < 0 then
    heros.x = heros.l/2 * heros.scale
    heros.vx = heros.vx + 15 * dt
  elseif heros.x + heros.l/2 * heros.scale> largeur then
    heros.x = largeur - heros.l/2 * heros.scale
    heros.vx = heros.vx - 15 * dt
  end
end

-- VerifyHero
-- Verifie si le heros et vivant, set le statue et lance animation s'il est mort
-- Parametre : dt
function VerifyHero(dt)
  if heros.vie <= 0 then
    CreeExplosion("gameover",2,heros.x,heros.y,heros)
    PlaySonTirExplode(liste_sonTirs.sonBoum)
    heros.vivant = false
  end
end
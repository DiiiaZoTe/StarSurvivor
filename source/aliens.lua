 liste_aliens ={}

-- CreeAlien
-- Creer un alien et l'insere a la position dans le tableau d'alien
-- Parametre : type d'alien, x, y
-- return : alien creer
function CreeAlien(pType, pX, pY)
  local alien = CreeSprite("images/Enemies/enemyBlack"..pType..".png",pX,pY)
  alien.vx = 0
  alien.vy = 0
  alien.type = pType
  -- type 1
  if pType == 1 then
    alien.vmax = 100  * globalScale
    alien.scale = 0.5 * globalScale
    alien.vie = 100
    alien.shootTimer = math.random(-100,0)/100
    local pos = 1
    for i=1,#liste_aliens do -- on l'insere apres les gros aliens
      local tabAlien = liste_aliens[i]
      if tabAlien.type ~= 3 then
        pos = i
        break
      end
    end
    table.insert(liste_aliens,pos,alien)
  -- type 2
  elseif pType == 2 then
    alien.vmax = 150 * globalScale
    alien.scale = 0.25 * globalScale
    alien.vie = 30
    table.insert(liste_aliens,#liste_aliens+1,alien)
  -- type 3
  else
    alien.vmax = 50 * globalScale
    alien.scale = 1 * globalScale
    alien.vie = 500
    alien.shootTimer = math.random(0,250)/100
    table.insert(liste_aliens,1,alien)
  end
  alien.vieMax = alien.vie
  return alien
end

-- GestionAlien
-- Fonction qui gere les aliens, lance leur movement, leur creation si besoin etc...
-- Parametre : dt
function GestionAlien(dt)
  VerifyAlien()
  UpdateCanAlienShoot(dt)
  ActionAlien(dt)
end

-- AddAlien
-- Fonction qui ajoute un nouvelle alien aleatoire on dehors de l'ecran
-- Parametre : type d'alien
function AddAlien(pType)
  local alien = CreeAlien(pType,0,0)
  -- on place l'alien aleatoirement
  local randxy = math.random(1,2)
  local randUDRL = math.random(0,100)
  if randxy == 1 then -- sur le cote
    alien.x = math.random(0,largeur)
    if randUDRL < 50 then -- haut
      alien.y = 0 - alien.h/2 * alien.scale
    else -- bas
      alien.y = hauteur + alien.h/2 * alien.scale
    end
  elseif randxy == 2 then -- haut ou bas
    alien.y = math.random(0,hauteur)
    if randUDRL < 50 then -- gauche
      alien.x = 0 - alien.l/2 * alien.scale
    else --droite
      alien.x = largeur + alien.l/2 * alien.scale
    end
  end
end

-- MoveAlien
-- Fait bouger les aliens en prenant en compte les collisions
-- Parametre : dt
function ActionAlien(dt)
  local n for n=1,#liste_aliens do
    local alien = liste_aliens[n]
    -- orientation et mouvement
    alien.angle = math.atan2(alien.y - heros.y, alien.x - heros.x ) - math.pi/2
    alien.vx = math.sin(alien.angle) * alien.vmax * dt
    alien.vy = -math.cos(alien.angle) * alien.vmax * dt
    -- test collision, peut tirer...
    local canAlienMove = CollisionAlienManager(alien,dt)
    local canAlienShoot = GetCanAlienShoot(alien,dt)
    -- Applique les comportements tester ci-dessus
    ComportementAlien(alien,canAlienMove,canAlienShoot,dt)
    
    -- pour qu'il regarde le heros
    alien.angle = alien.angle + math.pi
  end
end

function ComportementAlien(alien,canMove,canShoot,dt)
  -- gros alien
  if alien.type == 3 then
    -- bouge et reste a distance
    if GetDistance(alien.x,alien.y,heros.x,heros.y) > 300*globalScale then
      if canMove.x then alien.x = alien.x + alien.vx end
      if canMove.y then alien.y = alien.y + alien.vy end
    end
    -- gere son tir
    if canShoot then
      CreeTir(alien,2,dt)
    end
  end
  
  -- alien moyen
  if alien.type == 1 then
    -- bouge et reste tres proche du heros
    if GetDistance(alien.x,alien.y,heros.x,heros.y) > 100*globalScale then
      if canMove.x then alien.x = alien.x + alien.vx end
      if canMove.y then alien.y = alien.y + alien.vy end
    end
    -- gere son tir
    if canShoot then
      CreeTir(alien,1,dt)
    end
  end
  
  --alien petit kamikaze
  if alien.type == 2 then
    if not CollisionAlienHero(alien,dt) then
      if canMove.x then alien.x = alien.x + alien.vx end
      if canMove.y then alien.y = alien.y + alien.vy end
    else
      ApplyBodyDmg(alien,(1/3))
      KillAlien(alien)
    end
  end
end

function CollisionAlienManager(alien,dt)
  local collisionAlien = CollisionEntreAlien(alien,dt)
  local collisionDecor = CollisionAlienDecor(alien,dt)
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

-- CollisionEntreAlien
-- Gere la collision entre les aliens de même type
-- Parametre : alien, dt
-- Return : bool
function CollisionEntreAlien(alien,dt)
  local canAlienMove = {x=true,y=true}
  for i=1,#liste_aliens do
    local autreAlien = liste_aliens[i]
    if alien.type == autreAlien.type then
      if Collide(alien,autreAlien) then
        local addLargeur = alien.l/2*alien.scale + autreAlien.l/2*autreAlien.scale
        local diffX = math.abs(autreAlien.x - alien.x)
        local diffY = math.abs(autreAlien.y - alien.y)
        local addHauteur = alien.h/2*alien.scale + autreAlien.h/2*autreAlien.scale
        if math.abs(addLargeur - diffX) > math.abs(addHauteur - diffY) then
          if (alien.vy>0 and alien.y<autreAlien.y) or (alien.vy<0 and alien.y>autreAlien.y) then
            canAlienMove.y = false
          end
        else
          if (alien.vx>0 and alien.x<autreAlien.x) or (alien.vx<0 and alien.x>autreAlien.x) then 
            canAlienMove.x = false
          end 
        end
      end
    end
  end
  return canAlienMove
end

-- CollisionAlienDecor
-- Test la collision entre alien et decor
-- Parametre : alien,dt
-- return : canMove {x,y}
function CollisionAlienDecor(alien,dt)
  local canAlienMove = {x=true,y=true}
  local n for n,decor in ipairs(liste_decors) do
    if Collide(alien,decor) then
      local addLargeur = alien.l/3*alien.scale + decor.l/3*decor.scale
      local addHauteur = alien.h/3*alien.scale + decor.h/3*decor.scale
      local diffX = math.abs(decor.x - alien.x)
      local diffY = math.abs(decor.y - alien.y)
      if math.abs(addLargeur - diffX) > math.abs(addHauteur - diffY) then
        if (alien.vy>0 and alien.y<decor.y) or (alien.vy<0 and alien.y>decor.y) then
          canAlienMove.y = false
        end
      else
        if (alien.vx>0 and alien.x<decor.x) or (alien.vx<0 and alien.x>decor.x) then 
          canAlienMove.x = false
        end 
      end
    end
  end
  return canAlienMove
end

-- CollisionAlienHero
-- Gere la collision entre l'alien et le heros. il doit toucher au moins la 1/3 du heros
-- Parametre : alien, dt
-- return bool
function CollisionAlienHero(alien,dt)
  local dx = alien.x - heros.x
  local dy = alien.y - heros.y
  if (math.abs(dx) < alien.l/2*alien.scale+heros.l/3.5*heros.scale) then
    if (math.abs(dy) < alien.h/2*alien.scale+heros.h/3.5*heros.scale) then
      return true
    end
  end
  return false
end

-- VerifyAlien
-- Verifie situation de l'alien, s'il est mort le fait exploser, le remove etc...
function VerifyAlien()
  local i for i,_ in ipairs(liste_aliens) do
    local alien = liste_aliens[i]
    if alien.vie <= 0 then
      UpdateAlienWasKilled()
      AddScorePlayer(alien.type)
      CreeExplosion("explosion",2,alien.x,alien.y,alien)
      PlaySonTirExplode(liste_sonTirs.sonBoum)
      table.remove(liste_aliens,i)
    end
  end
end

-- KillAlien
-- Parametre : alien a tue
function KillAlien(alien)
  alien.vie = 0
end

-- ApplyBodyDmg
-- Applique alien.vie*X  points de degats au heros
-- Parametres : alien, multiplicateur de degats par rapport à la vie de l'alien
function ApplyBodyDmg(alien,pMult)
  heros.vie = heros.vie - math.floor(alien.vie*pMult)
end

-- UpdateCanAlienShoot
-- Update timer shoot pour l'alien
-- Parametres : dt
function UpdateCanAlienShoot(dt)
  local n for n,alien in ipairs(liste_aliens) do
    if alien.type == 1 or alien.type == 3 then
      alien.shootTimer = alien.shootTimer + dt
    end
  end
end

-- GetCanAlienShoot
-- Recupere si l'alien peut tirer et met à jour le timer si c'est le cas
-- Parametres : alien,dt
function GetCanAlienShoot(alien,dt)
  -- alien moyen : timer 1tir/sec
  if alien.type == 1 then
    if alien.shootTimer >= 1 then
      alien.shootTimer = 0
      return true
    else
      return false
    end
  end
  -- alien grand : timer 1tir/4sec
  if alien.type == 3 then
    if alien.shootTimer >= 4 then
      alien.shootTimer = 0
      return true
    else
      return false
    end
  end
  
  return false -- cas petit alien
end

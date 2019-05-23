liste_decors = {}

-- BackgroundUpdate
-- fonction qui sert a anime le background via timer et offset
-- lance aussi les fonction pour les decors
-- Parametre : dt
function BackgroundUpdate(dt)
  --mouvement du backgroud
  backgroundOption.timer = backgroundOption.timer + dt
  if backgroundOption.timer > 10 then
    backgroundOption.dirX = math.random(-50*globalScale,50*globalScale)
    backgroundOption.dirY = math.random(-50*globalScale,50*globalScale)
    backgroundOption.timer = 0
  end  
  --[[ pour que bg se deplace selon heros remplacer ci-dessus par :
  backgroundOption.dirX = heros.vx*globalScale*20
  backgroundOption.dirY = heros.vy*globalScale*20
  --]]
  backgroundOption.offsetX = backgroundOption.offsetX + backgroundOption.dirX * dt
  if backgroundOption.offsetX < 0 then
    backgroundOption.offsetX = backgroundOption.l - backgroundOption.offsetX
  elseif backgroundOption.offsetX > backgroundOption.l then
    backgroundOption.offsetX = backgroundOption.offsetX - backgroundOption.l
  end
  backgroundOption.offsetY = backgroundOption.offsetY + backgroundOption.dirY * dt
  if backgroundOption.offsetY < 0 then
    backgroundOption.offsetY = backgroundOption.h - backgroundOption.offsetY
  elseif backgroundOption.offsetY > backgroundOption.h then
    backgroundOption.offsetY = backgroundOption.offsetY - backgroundOption.h
  end
  
  DecorUpdate(dt)
  if nbDecorVisible() < backgroundOption.nbDecorMax then
    if math.random(1,2) == 1 then
      AddDecor()
    end
  end
end

-- DecorUpdate
-- mise a jour des coordonnées des decors, update aussi la visibilite
-- Parametre : dt
function DecorUpdate(dt)
  for n,decor in ipairs(liste_decors) do 
    decor.x = decor.x + backgroundOption.dirX * dt * 2.5
    decor.y = decor.y + backgroundOption.dirY * dt * 2.5
    local distance = GetDistance(decor.x,decor.y,largeur/2,hauteur/2)
    if distance > backgroundOption.distDiagonal+5 then
      decor.visible = false
    end
    if not decor.visible then
      table.remove(liste_decors,n)
    end
  end
end

-- nbDecorVisible
-- Compte le nombre de decor visible
-- Return : nombre de decor visible
function nbDecorVisible()
  local compteur = 0
  for n,decor in ipairs(liste_decors) do
    if decor.visible then compteur = compteur + 1 end
  end
  return compteur
end

-- CreeDecor
-- Fonction de creation d'un decor
-- Parametre : chemin, x,y
-- return : decor
function CreeDecor(pChemin,pX,pY)
  local decor = CreeSprite(pChemin,pX,pY)
  decor.visible = true
  decor.scale = 0.8 * globalScale
  decor.angle = math.rad(math.random(0,360))
  table.insert(liste_decors,decor)
  return decor
end

-- AddDecor
-- Ajoute un decor a un bord aleatoire en fonction de la direction x et y du background
function AddDecor()
  local randxy = math.random(1,2)
  local numDeco = math.random(1,#backgroundOption.decors)
  local decor = CreeDecor(backgroundOption.decors[numDeco],0,0)
  if backgroundOption.dirX > 0 then
    if backgroundOption.dirY > 0 then
      --spawn gauche ou haut
      if randxy == 1 then --gauche
        decor.x = 0 - decor.l/2*decor.scale
        decor.y = math.random(0,hauteur)
      else --haut
        decor.x = math.random(0,largeur)
        decor.y = 0 - decor.h/2*decor.scale
      end
    else
      --spawn gauche ou bas
      if randxy == 1 then --gauche
        decor.x = 0 - decor.l/2*decor.scale
        decor.y = math.random(0,hauteur)
      else --bas
        decor.x = math.random(0,largeur)
        decor.y = hauteur + decor.h/2*decor.scale
      end
    end
  else
    if backgroundOption.dirY > 0 then
      --spawn droite ou haut
      if randxy == 1 then --droite
        decor.x = largeur + decor.l/2*decor.scale
        decor.y = math.random(0,hauteur)
      else --haut
        decor.x = math.random(0,largeur)
        decor.y = 0 - decor.h/2*decor.scale
      end
    else
      if randxy == 1 then --droite
        decor.x = largeur + decor.l/2*decor.scale
        decor.y = math.random(0,hauteur)
      else --bas
        decor.x = math.random(0,largeur)
        decor.y = hauteur + decor.h/2*decor.scale
      end
    end
  end
end

function ChangeBackgrounColor()
  local rand = math.random(1,#backgroundOption.image)
  while backgroundOption.currentColor == rand do
    rand = math.random(1,#backgroundOption.image)
  end
  backgroundOption.previousColor = backgroundOption.currentColor
  backgroundOption.currentColor = rand
end

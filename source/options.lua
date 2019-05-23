function MoveOptionsMenu(key)
  PlaySoundOptions(key)
  -- si pas de modif en cours
  if not optionsJeu.modification then
    if optionsJeu.choixOption ~= 3 then
      if key=="down" then -- sous option descend
        if optionsJeu[optionsJeu.choixOption].options.choixOption ~= #optionsJeu[optionsJeu.choixOption].options then
          optionsJeu[optionsJeu.choixOption].options.choixOption = optionsJeu[optionsJeu.choixOption].options.choixOption + 1
        end
      end
      if key=="up" then -- sous option remonte
        if optionsJeu[optionsJeu.choixOption].options.choixOption ~= 1 then
          optionsJeu[optionsJeu.choixOption].options.choixOption = optionsJeu[optionsJeu.choixOption].options.choixOption - 1
        end
      end
    end
    if key=="right" then -- menu d'option droit
      if optionsJeu.choixOption < 3 then
        optionsJeu.choixOption = optionsJeu.choixOption + 1
      end
    end
    if key=="left" then -- menu d'option gauche
      if optionsJeu.choixOption > 1 then
        optionsJeu.choixOption = optionsJeu.choixOption - 1
      end      
    end
    if key=="return" then -- on demande a faire un modif
      --if optionsJeu[optionsJeu.choixOption].options[optionsJeu[optionsJeu.choixOption].options.choixOption].modifiable then
        optionsJeu.modification = true
        if optionsJeu.choixOption == 1 then
          optionsJeu.numLastModify = optionsJeu[optionsJeu.choixOption].options[optionsJeu[optionsJeu.choixOption].options.choixOption].numValeur
        end
     -- end
    end
    if key=="escape" then -- on revient a menu
      ResetGame()
      gamestate.currentState = 1
    end
  else -- si modification en cours
    if optionsJeu.choixOption < 3 then
      -- pour les touches, on peut change tout sauf les tirs
      if optionsJeu.choixOption == 2 then
        if key=="escape" then --on annule modif en cours
          optionsJeu.modification = false
        else -- on change la touche
          optionsJeu[2].options[optionsJeu[2].options.choixOption].valeur = key
          optionsJeu.modification = false
        end
      elseif optionsJeu.choixOption == 1 then -- general
        if key=="right" then --valeur suivante dans la liste
          optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur = optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur + 1
          if optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur > #optionsJeu[1].options[optionsJeu[1].options.choixOption].valeurPossible then
            optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur = 1
          end
        end
        if key=="left" then -- valeur precedente dans la liste
          optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur = optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur - 1
          if optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur < 1  then
            optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur = #optionsJeu[1].options[optionsJeu[1].options.choixOption].valeurPossible
          end
        end
        if key == "return" then -- on valide la selection et applique changement
          optionsJeu[1].options[optionsJeu[1].options.choixOption].valeur = optionsJeu[1].options[optionsJeu[1].options.choixOption].valeurPossible[optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur]
          optionsJeu.modification = false
          ApplyGeneralOptions(optionsJeu[1].options.choixOption, optionsJeu[1].options[optionsJeu[1].options.choixOption].valeur, optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur)
        end
      end
      if key  == "escape" then -- on annule la modif
        optionsJeu[1].options[optionsJeu[1].options.choixOption].numValeur = optionsJeu.numLastModify
        optionsJeu.modification = false
      end
    else -- pour personnalisation heros
      if key=="left" then -- valeur precedente dans la liste
        optionsJeu[3].imageNumber = optionsJeu[3].imageNumber-1
        if optionsJeu[3].imageNumber < 1 then
          optionsJeu[3].imageNumber = #vaisseauImage
        end
      end
      if key=="right" then -- valeur suivante dans la liste
        optionsJeu[3].imageNumber = optionsJeu[3].imageNumber+1
        if optionsJeu[3].imageNumber > #vaisseauImage then
          optionsJeu[3].imageNumber = 1
        end
      end
      if key == "return" then -- on valide la selection et applique changement
        vaisseauImage.current = optionsJeu[3].imageNumber
        optionsJeu.modification = false
      end
      if key  == "escape" then -- on annule la modif
        optionsJeu[3].imageNumber = vaisseauImage.current
        optionsJeu.modification = false
      end
    end
  end
end

-- ApplyGeneralOptions
-- on applique la modification du son, video, difficulte
-- Parametres : quelle option a ete modifie (video,...), valeur
function ApplyGeneralOptions(pNumOption, pValeur, pNumValeur)
  if pNumOption==1 then -- difficulté
    levelOptions.difficulty = pValeur
    if levelOptions.difficulty == langage[langage.actuel].texte[5] then
      levelOptions.tkAlien = true
      levelOptions.regenVie = true
      levelOptions.boostInfini = true
    elseif levelOptions.difficulty == langage[langage.actuel].texte[6] then
      levelOptions.tkAlien = false
      levelOptions.regenVie = true
      levelOptions.boostInfini = false
    elseif levelOptions.difficulty == langage[langage.actuel].texte[7] then
      levelOptions.tkAlien = false
      levelOptions.regenVie = false
      levelOptions.boostInfini = false
    end
  elseif pNumOption==2 then -- video/resolution
    local newResolution = {}
    --si fullscreen choisit alors on recup les dim fullscreen
    if pValeur == langage[langage.actuel].texte[13] then
      newResolution[1],newResolution[2] = love.window.getDesktopDimensions(1)
      optionsJeu[1].options[2].numValeur = 1
      optionsJeu[1].options[3].valeur = langage[langage.actuel].texte[14]
      optionsJeu[1].options[3].numValeur = 1
    -- si pas fullscreen choisit
    else
      newResolution = GetNewResolution(pValeur)
      newResolution = CheckResolutionPossible(newResolution,pNumValeur)
    end
    -- on applique la resolution
    love.window.setMode(newResolution[1],newResolution[2])
    if optionsJeu[1].options[3].valeur == langage[langage.actuel].texte[14] then
      love.window.setFullscreen(true)
    end
    largeur,hauteur = love.graphics.getDimensions()
    optionsJeu[1].options[2].valeur = tostring(largeur).."x"..tostring(hauteur)
    globalScale = largeur/1600
    ResetBackground()
    
  elseif pNumOption==3 then -- fullscreen
    -- si OFF
    if pValeur==langage[langage.actuel].texte[15] then
      love.window.setFullscreen(false)
      optionsJeu[1].options[3].valeur = langage[langage.actuel].texte[15]
      optionsJeu[1].options[3].numValeur = 2
      largeur,hauteur = love.graphics.getDimensions()
      globalScale = largeur/1600
    else -- si ON
      love.window.setFullscreen(true)
      optionsJeu[1].options[3].valeur = langage[langage.actuel].texte[14]
      optionsJeu[1].options[3].numValeur = 1
      optionsJeu[1].options[2].valeur = langage[langage.actuel].texte[13]
      optionsJeu[1].options[2].numValeur = 1
      largeur,hauteur = love.graphics.getDimensions()
      globalScale = largeur/1600
    end
    ResetBackground()
    
  elseif pNumOption==4 then -- son/Volume
    masterVolume = tonumber(pValeur)
    ChangeSoundVolume()
    
  else --langue
    langage.actuel = pNumValeur
    optionsJeu[1].options[5].numValeur = pNumValeur
    ChangeLangageOptions()
  end
end

-- GetNewResolution
-- Fonction qui recupere les valeurs des nouvelles resolutions pour les options
-- Parametres : string de resolution
-- return : nouvelle resolution
function GetNewResolution(pRes)
  local res = {}
  local compteur = 1
  for value in string.gmatch(pRes,"[0-9]+") do
    res[compteur]=tonumber(value)
    compteur=compteur+1
  end
  return res
end

-- CheckResolutionPossible
-- Fonction qui verifie si la resolution choisit est +- grande/petite, si oui, la met applique les modif necessaires
-- Parametres : resolution
-- return : nouvelle resolution
function CheckResolutionPossible(pResTest,pNumValeur)
  local changement = false
  local deskWidth, deskHeight = love.window.getDesktopDimensions(1)
  if pResTest[1] > deskWidth then 
    pResTest[1] = deskWidth
    changement = true
  end
  if pResTest[2] > deskHeight then 
    pResTest[2] = deskHeight
    changement = true
  end
  if changement then
    optionsJeu[1].options[2].numValeur = 1
  else
    optionsJeu[1].options[2].numValeur = pNumValeur
  end
  --ci dessus que si newRes >, ci-dessous si <
  if pResTest[1] < largeur or pResTest[2] < hauteur then
    love.window.setFullscreen(false)
    optionsJeu[1].options[3].valeur = langage[langage.actuel].texte[15]
    optionsJeu[1].options[3].numValeur = 2
  end
  return pResTest
end

function ChangeSoundVolume()
  musiqueMenu:setVolume(0.05*masterVolume)
  musiqueJeu:setVolume(0.015*masterVolume)
  liste_sonTirs.sonShoot1:setVolume(0.1*masterVolume)
  liste_sonTirs.sonShoot2:setVolume(0.1*masterVolume)
  liste_sonTirs.sonExplode:setVolume(0.15*masterVolume)
  liste_sonTirs.sonBoum:setVolume(0.3*masterVolume)
  sonMenuSelect:setVolume(0.05*masterVolume)
  sonMenuSwitch:setVolume(0.05*masterVolume)
end

--PlaySoundOptions
--Joue le son selon l'action switch ou select dans menu d'options
function PlaySoundOptions(key)
  if key=="right" or key=="left" or key=="down" or key=="up" then
    sonMenuSwitch:play()
  elseif key=="return" then
    sonMenuSelect:play()
  end
end

function ResetBackground()
  backgroundOption = {}
  liste_decors = {}
  CreeBackground()
end

--ChangeLangageOptions()
--Change les noms dans les options (les autres seront changer au resetgame en quittant options
function ChangeLangageOptions()
  optionsJeu[1].nom = langage[langage.actuel].texte[8]
  optionsJeu[1].options[1].nom = langage[langage.actuel].texte[10]
  optionsJeu[1].options[1].valeurPossible = {langage[langage.actuel].texte[5],langage[langage.actuel].texte[6],langage[langage.actuel].texte[7]}
  optionsJeu[1].options[1].valeur = optionsJeu[1].options[1].valeurPossible[optionsJeu[1].options[1].numValeur]
  optionsJeu[1].options[1].description = langage[langage.actuel].texte[11]
  optionsJeu[1].options[2].nom = langage[langage.actuel].texte[12]
  optionsJeu[1].options[2].valeurPossible = {langage[langage.actuel].texte[13],"640x360","800x450","800x600","1200x675","1366x768","1400x900","1600x900","1920x1080"}
  optionsJeu[1].options[2].valeur = optionsJeu[1].options[2].valeurPossible[optionsJeu[1].options[2].numValeur]
  optionsJeu[1].options[3].nom = langage[langage.actuel].texte[13]
  optionsJeu[1].options[3].valeurPossible = {langage[langage.actuel].texte[14],langage[langage.actuel].texte[15]}
  optionsJeu[1].options[3].valeur = optionsJeu[1].options[3].valeurPossible[optionsJeu[1].options[3].numValeur]
  optionsJeu[1].options[4].nom = langage[langage.actuel].texte[16]
  optionsJeu[1].options[5].nom = langage[langage.actuel].texte[17]
  optionsJeu[1].options[5].valeur = optionsJeu[1].options[5].valeurPossible[optionsJeu[1].options[5].numValeur]
  optionsJeu[2].nom = langage[langage.actuel].texte[9]
  optionsJeu[2].options[1].nom = langage[langage.actuel].texte[18]
  optionsJeu[2].options[2].nom = langage[langage.actuel].texte[19]
  optionsJeu[2].options[3].nom = langage[langage.actuel].texte[20]
  optionsJeu[2].options[4].nom = langage[langage.actuel].texte[21]
  optionsJeu[2].options[5].nom = langage[langage.actuel].texte[23]
  optionsJeu[2].options[6].nom = langage[langage.actuel].texte[22]
end
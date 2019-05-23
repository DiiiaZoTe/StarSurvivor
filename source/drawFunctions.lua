-- DrawBackground
-- dessine le background anime
-- Parametre : image de la couleur du bg
function DrawBackground(pCouleur)
  local nbX = math.floor(largeur/backgroundOption.l)+2
  local nbY = math.floor(hauteur/backgroundOption.h)+2
  local n
  for n=-1,nbX do
    local i
    for i=-1,nbY do
      if levelOptions.transitionLevel and levelOptions.transitionTimer < 5 then
        love.graphics.setColor(255,255,255,255-levelOptions.transitionTimer*51)
        love.graphics.draw(backgroundOption.image[backgroundOption.previousColor],n*backgroundOption.l+backgroundOption.offsetX,i*backgroundOption.h+backgroundOption.offsetY,0,backgroundOption.scale,backgroundOption.scale,backgroundOption.l/2,backgroundOption.h/2)
        love.graphics.setColor(255,255,255,levelOptions.transitionTimer*51)
        love.graphics.draw(pCouleur,n*backgroundOption.l+backgroundOption.offsetX,i*backgroundOption.h+backgroundOption.offsetY,0,backgroundOption.scale,backgroundOption.scale,backgroundOption.l/2,backgroundOption.h/2)
        love.graphics.setColor(255,255,255,255)
      else
        love.graphics.draw(pCouleur,n*backgroundOption.l+backgroundOption.offsetX,i*backgroundOption.h+backgroundOption.offsetY,0,backgroundOption.scale,backgroundOption.scale,backgroundOption.l/2,backgroundOption.h/2)
      end
    end
  end
end

-- DrawDecors
-- Dessine les decors
function DrawDecors()
  for n,decor in ipairs(liste_decors) do
    love.graphics.draw(decor.image,decor.x,decor.y, angle, decor.scale,decor.scale,decor.l/2,decor.h/2)
  end
end

-- DrawTitreMenu
-- Dessine le titre du jeu
function DrawTitreMenu()
  font = love.graphics.newFont("images/font.ttf",150*globalScale)
  local textTitre = love.graphics.newText(font,"Star Survivor")
  local textTitreLargeur = textTitre:getWidth()
  local textTitreHauteur = textTitre:getHeight()
  if menu.titreTimer < 3 then
    love.graphics.setColor(255,255,255,50)
  elseif menu.titreTimer < 4 then
    love.graphics.setColor(255,255,255,50 - Round(50*(menu.titreTimer-3),0))
  else
    love.graphics.setColor(255,255,255,Round(50*(menu.titreTimer-4),0))
  end
  love.graphics.draw(textTitre,largeur/2,hauteur/2,0,1,1,textTitreLargeur/2,textTitreHauteur/2)
  love.graphics.setColor(255,255,255,255)
end

-- DrawChoixMenu
-- Dessine les choix du menu
function DrawChoixMenu()
  for n,choix in ipairs(menu.choix) do
    local pourcentageVie = math.floor((choix.vie/choix.vieMax)*100)
    if pourcentageVie < 100 then
      if pourcentageVie >= 50 then
        love.graphics.setColor(255-2.55*pourcentageVie*2,255,0,255)
      else
        love.graphics.setColor(255,2.55*pourcentageVie*2,0,255)
      end
      love.graphics.rectangle("fill",choix.x-choix.l/2,choix.y-choix.h/2,choix.l*(1-pourcentageVie/100),choix.h,10,10)
    end
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("line",choix.x-choix.l/2,choix.y-choix.h/2,choix.l,choix.h,10,10)
    
    font = love.graphics.newFont("images/font.ttf",70*globalScale)
    local choixMenu = love.graphics.newText(font,choix.text)
    local textLargeur = choixMenu:getWidth()
    local textHauteur = choixMenu:getHeight()
    love.graphics.draw(choixMenu,choix.x,choix.y,0,1,1,textLargeur/2,textHauteur/2)
  end
end

-- DrawHero
-- Dessine le hero s'il est vivant
function DrawHero()
  if heros.vivant then
    --Boost
    if heros.isBoosting then
      local bx = heros.x - math.sin(heros.angle)*heros.scale*50 --position x du depart du tir (avant du vaisseau)
      local by = heros.y + math.cos(heros.angle)*heros.scale*50
      local mx = love.mouse.getX()
      local my = love.mouse.getY()
      local angle = math.atan2(heros.y - my, heros.x - mx) - math.pi/2
      love.graphics.draw(heros.boostImg.image, bx, by, angle, heros.scale*2, heros.scale*2,  heros.boostImg.l/2, heros.boostImg.h/2)
    end
    --hero
    love.graphics.draw(heros.image, heros.x, heros.y, heros.angle, heros.scale, heros.scale, heros.l/2, heros.h/2)
    --shield si powerup etoile
    if powerUpOption.typeActive == 3 then
      --hero
      love.graphics.setColor(255,255,0,255)
      love.graphics.draw(heros.shieldImg.image,heros.x,heros.y,0,heros.scale,heros.scale,heros.shieldImg.l/2,heros.shieldImg.h/2)
      love.graphics.draw(heros.shieldImg.image,heros.x,heros.y,math.rad(90),heros.scale,heros.scale,heros.shieldImg.l/2,heros.shieldImg.h/2)
      love.graphics.draw(heros.shieldImg.image,heros.x,heros.y,math.rad(180),heros.scale,heros.scale,heros.shieldImg.l/2,heros.shieldImg.h/2)
      love.graphics.draw(heros.shieldImg.image,heros.x,heros.y,math.rad(270),heros.scale,heros.scale,heros.shieldImg.l/2,heros.shieldImg.h/2)
    end
  end
end

-- DrawHud
-- Dessine le hud du joueur avec le score
function DrawHud()
  -- stats etendu/ou pas haut gauche
  font = love.graphics.newFont("images/font.ttf",20*globalScale)
  if showStats then
    local textHeight -- pour simplifier l'addition des tailles
    if levelOptions.currentLevel < 10 then
      -- ennemi tué cette vague / ennemi vivant
      local textEnnemiTueVivant = love.graphics.newText(font,langage[langage.actuel].texte[28]..levelOptions.killedEnnemis.." / "..levelOptions.totalEnnemis)
      local textEnnemiTueVivantLargeur = textEnnemiTueVivant:getWidth()
      local textEnnemiTueVivantHauteur = textEnnemiTueVivant:getHeight()
      textHeight = textEnnemiTueVivantHauteur
      love.graphics.draw(textEnnemiTueVivant,textEnnemiTueVivantLargeur/2+5,textEnnemiTueVivantHauteur/2,0,1,1,textEnnemiTueVivantLargeur/2,textEnnemiTueVivantHauteur/2)
    else
      local textSurvive = love.graphics.newText(font,langage[langage.actuel].texte[29])
      local textSurviveLargeur = textSurvive:getWidth()
      local textSurviveHauteur = textSurvive:getHeight()
      textHeight = textSurviveHauteur
      love.graphics.draw(textSurvive,textSurviveLargeur/2+5,textSurviveHauteur/2,0,1,1,textSurviveLargeur/2,textSurviveHauteur/2)
    end
    -- ennemi tué en tout
    local textEnnemiTueTotal = love.graphics.newText(font,langage[langage.actuel].texte[30]..levelOptions.totalEnnemisKilled)
    local textEnnemiTueTotalLargeur = textEnnemiTueTotal:getWidth()
    local textEnnemiTueTotalHauteur = textEnnemiTueTotal:getHeight()
    love.graphics.draw(textEnnemiTueTotal,textEnnemiTueTotalLargeur/2+5,textHeight+textEnnemiTueTotalHauteur/2,0,1,1,textEnnemiTueTotalLargeur/2,textEnnemiTueTotalHauteur/2)
    -- taux de precision
    local textPrecision = love.graphics.newText(font,langage[langage.actuel].texte[31]..Round(levelOptions.totalHeroShotsHit/levelOptions.totalHeroShots*100,2).."%")
    local textPrecisionLargeur = textPrecision:getWidth()
    local textPrecisionHauteur = textPrecision:getHeight()
    textHeight = textHeight + textEnnemiTueTotalHauteur
    love.graphics.draw(textPrecision,textPrecisionLargeur/2+5,textHeight+textPrecisionHauteur/2,0,1,1,textPrecisionLargeur/2,textPrecisionHauteur/2)

  else -- not showStats
    font = love.graphics.newFont("images/font.ttf",30*globalScale)
    if levelOptions.currentLevel < 10 then
      -- ennemi tué cette vague / ennemi vivant
      local textEnnemiTueVivant = love.graphics.newText(font,levelOptions.killedEnnemis.." / "..levelOptions.totalEnnemis)
      local textEnnemiTueVivantLargeur = textEnnemiTueVivant:getWidth()
      local textEnnemiTueVivantHauteur = textEnnemiTueVivant:getHeight()
      love.graphics.draw(textEnnemiTueVivant,textEnnemiTueVivantLargeur/2+5,textEnnemiTueVivantHauteur/2,0,1,1,textEnnemiTueVivantLargeur/2,textEnnemiTueVivantHauteur/2)
    else
      local textSurvive = love.graphics.newText(font,langage[langage.actuel].texte[29])
      local textSurviveLargeur = textSurvive:getWidth()
      local textSurviveHauteur = textSurvive:getHeight()
      love.graphics.draw(textSurvive,textSurviveLargeur/2+5,textSurviveHauteur/2,0,1,1,textSurviveLargeur/2,textSurviveHauteur/2)
    end
  end
  
  -- scoreboard en haut a droite
  font = love.graphics.newFont("images/font.ttf",30*globalScale)
  local textScore = love.graphics.newText(font,"Score : "..levelOptions.score)
  local textScoreLargeur = textScore:getWidth()
  local textScoreHauteur = textScore:getHeight()
  love.graphics.draw(textScore,largeur-textScoreLargeur/2-5,textScoreHauteur/2,0,1,1,textScoreLargeur/2,textScoreHauteur/2)
  local textStage = love.graphics.newText(font,"Stage : "..levelOptions.currentLevel)
  local textStageLargeur = textStage:getWidth()
  local textStageHauteur = textStage:getHeight()
  love.graphics.draw(textStage,largeur-textScoreLargeur-textStageLargeur/2-10,textStageHauteur/2,0,1,1,textStageLargeur/2,textStageHauteur/2)
  
  -- variable pour hud bas droite
  local decalage = 10
  
  -- hud joueur bas droite, vie
  local pourcentageVie = Round(heros.vie/heros.vieMax*100,0)
  if pourcentageVie >= 50 then
    love.graphics.setColor(255-2.55*pourcentageVie*2,255,0,200)
  else
    love.graphics.setColor(255,2.55*pourcentageVie*2,0,200)
  end
  love.graphics.draw(heros.image,largeur-heros.l/2*globalScale-decalage,hauteur-heros.h/2*globalScale-decalage,0,globalScale,globalScale,heros.l/2,heros.h/2)
  love.graphics.setColor(255,255,255,255)
  font = love.graphics.newFont("images/font.ttf",30*globalScale)
  local textPourcentageVie = love.graphics.newText(font,pourcentageVie.."%")
  local textPourcentageVieLargeur = textPourcentageVie:getWidth()
  local textPourcentageVieHauteur = textPourcentageVie:getHeight()
  love.graphics.draw(textPourcentageVie,largeur-heros.l/2*globalScale-decalage,hauteur-heros.h/2*globalScale-decalage/2,0,1,1,textPourcentageVieLargeur/2,textPourcentageVieHauteur/2)
  
  --niveau de boost
  local boostPercentage = Round(heros.boostFuel/heros.boostFuelMax*100,0)
  local boostColors = {}
  if boostPercentage > 50 then
    boostColors = {direction='vertical';{255,0,0};{255,(1-(100-boostPercentage)/100)*255,0};{255-(1-(100-boostPercentage)/50)*255,255,0};}
  elseif boostPercentage > 10 then
    boostColors = {direction='vertical';{255,0,0};{255,(1-(100-boostPercentage)/90)*255,0};{255,(1-(100-boostPercentage)/200)*255,0};}
  else
    boostColors = {direction='vertical';{255,0,0};}
  end
  local boostFuelImg = Gradient(boostColors)
  local boostFuelImgLargeur = boostPercentage*globalScale*heros.l/100
  local boostFuelImgHauteur = 15*globalScale
  DrawInRect(boostFuelImg,largeur-heros.l*globalScale-decalage,hauteur-heros.h*globalScale-boostFuelImgHauteur-decalage-5,boostFuelImgLargeur,boostFuelImgHauteur)
  font = love.graphics.newFont("images/font.ttf",25*globalScale)
  local textBoost = love.graphics.newText(font,"Boost")
  local textBoostLargeur = textBoost:getWidth()
  local textBoostHauteur = textBoost:getHeight()
  love.graphics.draw(textBoost,largeur-heros.l/2*globalScale-decalage,hauteur-heros.h*globalScale-boostFuelImgHauteur-decalage-textBoostHauteur/2-3,0,1,1,textBoostLargeur/2,textBoostHauteur/2)
  
  -- powerup Actif ?
  font = love.graphics.newFont("images/font.ttf",35*globalScale)
  love.graphics.setColor(255,255,255,255)
  if powerUpOption.activated and powerUpOption.activeTimer < 2 then
    local textPower = love.graphics.newText(font,powerUpOption.typeActiveName..langage[langage.actuel].texte[32])
    local textPowerLargeur = textPower:getWidth()
    local textPowerHauteur = textPower:getHeight()
    love.graphics.draw(textPower,largeur/2,hauteur*0.1,0,1,1,textPowerLargeur/2,textPowerHauteur/2)
  elseif powerUpOption.activated and powerUpOption.activeTimer>=powerUpOption.maxActiveTime-4 and powerUpOption.typeActive ~= 2 then
    local textPower = love.graphics.newText(font,powerUpOption.typeActiveName..langage[langage.actuel].texte[33]..Round(powerUpOption.maxActiveTime-powerUpOption.activeTimer,0))
    local textPowerLargeur = textPower:getWidth()
    local textPowerHauteur = textPower:getHeight()
    love.graphics.draw(textPower,largeur/2,hauteur*0.1,0,1,1,textPowerLargeur/2,textPowerHauteur/2)
  end
end

-- DrawTirs
-- Dessine les tirs et les explosions
function DrawTirs()
  love.graphics.setColor(255,255,255,255)
  local n for n=1,#liste_tirs do
    local tir = liste_tirs[n]
    if tir.origine == "heros" and tir.type == 1 and not tir.colorDefault then
      love.graphics.setColor(tir.color[1],tir.color[2],tir.color[3],255)
    else
      love.graphics.setColor(255,255,255,255)
    end
    love.graphics.draw(tir.image, tir.x, tir.y, tir.angle, tir.scale, tir.scale, tir.l/2, tir.h/2)
  end
  love.graphics.setColor(255,255,255,255)
  for n=1,#liste_explosions do
    local tir = liste_explosions[n]
    love.graphics.draw(img_explosions[tir.currentImage], tir.x, tir.y, tir.angle, tir.scale, tir.scale, tir.l/2, tir.h/2)
  end
end

-- DrawAliens
-- Dessine les aliens avec leur barre de vie
function DrawAliens()
  local n for n,alien in ipairs(liste_aliens) do
    love.graphics.draw(alien.image, alien.x, alien.y, alien.angle, alien.scale, alien.scale, alien.l/2, alien.h/2) -- alien
    -- barre de vie de l'alien
    if alien.vie > 0 then
      local pourcentageVie = math.floor((alien.vie / alien.vieMax)*100)
      local barVieLargeur = alien.l/2*alien.scale
      local barVieHauteur
      if alien.type == 1 then
        barVieHauteur = barVieLargeur/6
      elseif alien.type == 2 then
        barVieHauteur = barVieLargeur/4
      elseif alien.type == 3 then
        barVieHauteur = barVieLargeur/8
      end
      barVieLargeur = barVieLargeur * (pourcentageVie/100)
      if pourcentageVie >= 50 then
        love.graphics.setColor(255-2.55*pourcentageVie*2,255,0,255)
      else
        love.graphics.setColor(255,2.55*pourcentageVie*2,0,255)
      end
      love.graphics.rectangle("fill",alien.x-(alien.l/4*alien.scale), alien.y-(alien.h/2*alien.scale)-10,barVieLargeur,barVieHauteur,2,2)
      love.graphics.setColor(255,255,255,255)
    end
  end
end

-- DrawPowerUps
-- Dessine les power ups
function DrawPowerUps()
  for n,powerup in ipairs(liste_power) do
    love.graphics.draw(powerup.image,powerup.x,powerup.y,0,powerup.scale,powerup.scale,powerup.l/2,powerup.h/2)
  end
end

-- DrawLevel
-- Dessin du stage entre les vague
function DrawLevel()
  if levelOptions.transitionLevel then
    font = love.graphics.newFont("images/font.ttf",100*globalScale)
    local transitionText = love.graphics.newText(font,levelOptions.transitionText)
    local textLargeur = transitionText:getWidth()
    local textHauteur = transitionText:getHeight()
    if levelOptions.transitionTimer > 0 and levelOptions.transitionTimer < 2.5 and levelOptions.transitionTimer < 5 then
      local textScale = levelOptions.transitionTimer/2
      love.graphics.draw(transitionText,largeur/2,textHauteur,0,textScale,textScale,textLargeur/2,textHauteur/2)
    elseif levelOptions.transitionTimer >= 2.5 then
      local textScale = 2.5/2
      love.graphics.draw(transitionText,largeur/2,textHauteur,0,textScale,textScale,textLargeur/2,textHauteur/2)
    end
  end
end

-- DrawLose
-- Dessine les textes de gameover
function DrawLose()
  --perdu
  font = love.graphics.newFont("images/font.ttf",200*globalScale)
  local gameoverText = love.graphics.newText(font,langage[langage.actuel].texte[34])
  local textLargeur = gameoverText:getWidth()
  local textHauteur = gameoverText:getHeight()
  if gameoverTimerAnimation <= 2 then
    love.graphics.setColor(255-255/2*gameoverTimerAnimation,gameoverTimerAnimation*255/2,0,255)
  elseif gameoverTimerAnimation <= 4 then
    love.graphics.setColor(0,255-255/2*(gameoverTimerAnimation-2),(gameoverTimerAnimation-2)*255/2,255)
  else
    love.graphics.setColor((gameoverTimerAnimation-4)*255/2,0,255-255/2*(gameoverTimerAnimation-4),255)
  end
  love.graphics.draw(gameoverText,largeur/2,hauteur/3,0,globalScale,globalScale,textLargeur/2,textHauteur/2)
  -- Score
  love.graphics.setColor(255,255,255,255)
  font = love.graphics.newFont("images/font.ttf",150*globalScale)
  local scoreText = love.graphics.newText(font,langage[langage.actuel].texte[35]..levelOptions.score)
  local scoreTextLargeur = scoreText:getWidth()
  local scoreTextHauteur = scoreText:getHeight()
  love.graphics.draw(scoreText,largeur/2,hauteur*0.5,0,globalScale,globalScale,scoreTextLargeur/2,scoreTextHauteur/2)
  -- appuyer sur entrer
  font = love.graphics.newFont("images/font.ttf",100*globalScale)
  local enterText = love.graphics.newText(font,langage[langage.actuel].texte[27])
  local enterTextLargeur = enterText:getWidth()
  local enterTextHauteur = enterText:getHeight()
  if gameoverTimerAnimation <=1 then
    love.graphics.setColor(255,255,255,255*gameoverTimerAnimation)
  elseif gameoverTimerAnimation <= 3 then
    love.graphics.setColor(255,255,255,255)
  elseif gameoverTimerAnimation > 3 then
    love.graphics.setColor(255,255,255,255-(255/2*(gameoverTimerAnimation - 3)))
  end
  love.graphics.draw(enterText,largeur/2,hauteur*0.7,0,globalScale,globalScale,enterTextLargeur/2,enterTextHauteur/2)
  love.graphics.setColor(255,255,255,255)
end

--DrawMenuOptions
--Dessine les options
function DrawMenuOptions()
  local posX = largeur/4
  local posY = 0
  local n for n,menu in ipairs(optionsJeu) do
    if optionsJeu.choixOption == n then
      love.graphics.setColor(255,0,0,255)
    else
      love.graphics.setColor(255,255,255,255)
    end
    font = love.graphics.newFont("images/font.ttf",75*globalScale)
    local textMenuNom = love.graphics.newText(font,menu.nom)
    local textMenuNomLargeur = textMenuNom:getWidth()
    local textMenuNomHauteur = textMenuNom:getHeight()
    love.graphics.draw(textMenuNom,posX,posY+textMenuNomHauteur/2,0,1,1,textMenuNomLargeur/2,textMenuNomHauteur/2)
    love.graphics.setColor(255,0,0,255)
    love.graphics.rectangle("line",largeur/8,textMenuNomHauteur,3*largeur/4,2)
    love.graphics.setColor(255,255,255,255)
    if optionsJeu.choixOption == n then
      if optionsJeu.choixOption ~= 3 then
        posX = largeur/5
        posY = textMenuNomHauteur
        local i for i,options in ipairs(menu.options) do
          if menu.options.choixOption == i then
            if options.modifiable then
              love.graphics.setColor(0,255,0,255)
            else
              love.graphics.setColor(200,0,40,255)
            end
          else
            love.graphics.setColor(255,255,255,255)
          end
          font = love.graphics.newFont("images/font.ttf",50*globalScale)
          local textOptionNom = love.graphics.newText(font,options.nom)
          local textOptionNomLargeur = textOptionNom:getWidth()
          local textOptionNomHauteur = textOptionNom:getHeight()
          posY = posY + textOptionNomHauteur
          love.graphics.rectangle("line",largeur/8,posY+textOptionNomHauteur/2,3*largeur/4,1)
          love.graphics.draw(textOptionNom,posX+textOptionNomLargeur/2,posY,0,1,1,textOptionNomLargeur/2,textOptionNomHauteur/2)
          posX = 3*largeur/4
          if optionsJeu.modification and menu.options.choixOption == i then
            love.graphics.setColor(255,255,0,255)
          else
            love.graphics.setColor(255,255,255,255)
          end
          local heightForDescription
          if optionsJeu.choixOption == 1 and optionsJeu.modification then
            local textOption = love.graphics.newText(font,options.valeurPossible[options.numValeur])
            local textOptionLargeur = textOption:getWidth()
            local textOptionHauteur = textOption:getHeight()
            heightForDescription = textOptionHauteur
            love.graphics.draw(textOption,posX-textOptionLargeur/2,posY,0,1,1,textOptionLargeur/2,textOptionHauteur/2)
          elseif optionsJeu.choixOption == 2 and not options.modifiable then
            local textOption
            if i==1 then
              textOption = love.graphics.newText(font,options.valeur..langage[langage.actuel].texte[38].."Lmouse")
            elseif i==2 then
              textOption = love.graphics.newText(font,options.valeur..langage[langage.actuel].texte[38].." Rmouse")
            end
            local textOptionLargeur = textOption:getWidth()
            local textOptionHauteur = textOption:getHeight()
            heightForDescription = textOptionHauteur
            love.graphics.draw(textOption,posX-textOptionLargeur/2,posY,0,1,1,textOptionLargeur/2,textOptionHauteur/2)
          else
            local textOption = love.graphics.newText(font,options.valeur)
            local textOptionLargeur = textOption:getWidth()
            local textOptionHauteur = textOption:getHeight()
            heightForDescription = textOptionHauteur
            love.graphics.draw(textOption,posX-textOptionLargeur/2,posY,0,1,1,textOptionLargeur/2,textOptionHauteur/2)
          end
          posX=largeur/5
          if options.description then
            posY = posY+heightForDescription
            font = love.graphics.newFont("images/font.ttf",30*globalScale)
            love.graphics.setColor(255,255,255,100)
            local textDescription = love.graphics.newText(font,options.description)
            local textDescriptionLargeur = textDescription:getWidth()
            local textDescriptionHauteur = textDescription:getHeight()
            love.graphics.draw(textDescription,posX+textDescriptionLargeur/2,posY+textDescriptionHauteur/2,0,1,1,textDescriptionLargeur/2,textDescriptionHauteur/2)
            posY = posY + textDescriptionHauteur
          end
          love.graphics.setColor(255,255,255,255)
        end
      else -- personnalisation heros
        -- Vaisseau Actuel
        posX = largeur/3
        posY = hauteur/2
        local shipCurrentImage = love.graphics.newImage(vaisseauImage[vaisseauImage.current])
        local largeurCurrentShip = shipCurrentImage:getWidth()
        local hauteurCurrentShip = shipCurrentImage:getHeight()
        love.graphics.draw(shipCurrentImage,posX,posY,0,2*globalScale,2*globalScale,largeurCurrentShip/2,hauteurCurrentShip/2)
        -- Fleche modification
        posX = largeur/2
        local imageFleche
        if optionsJeu.modification then
          imageFleche = love.graphics.newImage("images/UI/fleche_modification.png")
        else
          imageFleche = love.graphics.newImage("images/UI/fleche_non_modification.png")
        end
        local flecheLargeur = imageFleche:getWidth()
        local flecheHauteur = imageFleche:getHeight()
        love.graphics.draw(imageFleche,posX,posY,0,0.3*globalScale,0.3*globalScale,flecheLargeur/2,flecheHauteur/2)
        -- Vaisseau changer
        posX = 2*largeur/3
        local shipImage = love.graphics.newImage(vaisseauImage[optionsJeu[3].imageNumber])
        local largeurShip = shipImage:getWidth()
        local hauteurShip = shipImage:getHeight()
        love.graphics.draw(shipImage,posX,posY,0,2*globalScale,2*globalScale,largeurShip/2,hauteurShip/2)
      end
    end
    posX=(n+1)*largeur/4
    posY=0
  end
  
  font = love.graphics.newFont("images/font.ttf",30*globalScale)
  local helpText = love.graphics.newText(font,langage[langage.actuel].texte[36])
  local helpTextLargeur = helpText:getWidth()
  local helpTextHauteur = helpText:getHeight()
  love.graphics.draw(helpText,helpTextLargeur/2,hauteur-helpTextHauteur/2,0,1,1,helpTextLargeur/2,helpTextHauteur/2)
end

--DrawTextTuto
--dessine le texte de l'aide
function DrawTextTuto()
  font = love.graphics.newFont("images/font.ttf",40*globalScale)
  local helpText = love.graphics.newText(font,langage[langage.actuel].texte[37])
  local helpTextLargeur = helpText:getWidth()
  local helpTextHauteur = helpText:getHeight()
  love.graphics.draw(helpText,largeur/2,hauteur/3,0,1,1,helpTextLargeur/2,helpTextHauteur/2)
end
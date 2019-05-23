-- PlayLevel
-- Joue le level et lance l'execution des updates du gameplay
-- Parametre : dt
function PlayLevel(dt)
  if levelOptions.aliveEnnemis == 0 or levelOptions.currentLevel == 0 then
    NextLevel()
  elseif levelOptions.transitionLevel then
    LevelWaitTransition(dt)
    HeroAction(dt)
    TirGestionSprite(dt)
  else
    if heros.vivant then
      UpdateLevelInfo()
      SpawnEnnemis()
      HeroAction(dt)
      GestionAlien(dt)
      GestionPowerUp(dt)
    else
      HeroGameOver(dt)
    end
    TirGestionSprite(dt)
  end
end

-- SpawnEnnemis
-- Fonction de spawn des ennemis selon les vagues
function SpawnEnnemis()
  -- level 1 à 9
  if levelOptions.currentLevel < 10 then
    if levelOptions.nbEnnemisOnScreen < levelOptions.maxEnnemisOnScreen and levelOptions.nbEnnemisOnScreen < levelOptions.aliveEnnemis then
      --on check ceux possible
      local possibleAlien = {[1]=false,[2]=false,[3]=false}
      if levelOptions.levels[levelOptions.currentLevel][1] ~= 0 then
        possibleAlien[1] = true
      end
      if levelOptions.levels[levelOptions.currentLevel][2] ~= 0 then
        possibleAlien[2] = true
      end
      if levelOptions.levels[levelOptions.currentLevel][3] ~= 0 then
        possibleAlien[3] = true
      end
      -- on en choisit une aleatoirement sur ceux possible
      if possibleAlien[1] and possibleAlien[2] and possibleAlien[3] then --1,2,3
        local rand = math.random(1,3)
        AddAlien(rand)
        levelOptions.levels[levelOptions.currentLevel][rand] = levelOptions.levels[levelOptions.currentLevel][rand] - 1
      elseif possibleAlien[1] and possibleAlien[2] and not possibleAlien[3] then --1,2
        local rand = math.random(1,2)
        AddAlien(rand)
        levelOptions.levels[levelOptions.currentLevel][rand] = levelOptions.levels[levelOptions.currentLevel][rand] - 1
      elseif not possibleAlien[1] and possibleAlien[2] and possibleAlien[3] then --2,3
        local rand = math.random(2,3)
        AddAlien(rand)
        levelOptions.levels[levelOptions.currentLevel][rand] = levelOptions.levels[levelOptions.currentLevel][rand] - 1
      elseif possibleAlien[1] and not possibleAlien[2] and possibleAlien[3] then --1,3
        if math.random(1,2) == 1 then
          AddAlien(1)
          levelOptions.levels[levelOptions.currentLevel][1] = levelOptions.levels[levelOptions.currentLevel][1] - 1
        else
          AddAlien(3)
          levelOptions.levels[levelOptions.currentLevel][3] = levelOptions.levels[levelOptions.currentLevel][3] - 1
        end
      elseif possibleAlien[1] and not possibleAlien[2] and not possibleAlien[3] then --1
        AddAlien(1)
        levelOptions.levels[levelOptions.currentLevel][1] = levelOptions.levels[levelOptions.currentLevel][1] - 1
      elseif not possibleAlien[1] and possibleAlien[2] and not possibleAlien[3] then --2
        AddAlien(2)
        levelOptions.levels[levelOptions.currentLevel][2] = levelOptions.levels[levelOptions.currentLevel][2] - 1
      elseif not possibleAlien[1] and not possibleAlien[2] and possibleAlien[3] then --3
        AddAlien(3)
        levelOptions.levels[levelOptions.currentLevel][3] = levelOptions.levels[levelOptions.currentLevel][3] - 1
      end
    end
  -- level 10 = survive
  else
    while levelOptions.nbEnnemisOnScreen < levelOptions.maxEnnemisOnScreen do
      local nbGros = 0
      local n for n=1,#liste_aliens do
        local alien = liste_aliens[n]
        if alien.type == 3 then nbGros=nbGros+1 end
      end
      local i
      if nbGros < 5 then i = math.random(1,3)
      else i = math.random(1,2)
      end
      AddAlien(i)
      UpdateLevelInfo()
    end
  end
end

-- UpdateLevelInfo
-- mets a jour le nombre d'alien a l'ecran
function UpdateLevelInfo()
  levelOptions.nbEnnemisOnScreen = #liste_aliens
end

-- UpdateAlienWasKilled
-- Mets a jour les infos si un alien a ete tue (appeler dans aliens.lua)
function UpdateAlienWasKilled()
  levelOptions.totalEnnemisKilled = levelOptions.totalEnnemisKilled + 1
  levelOptions.killedEnnemis = levelOptions.killedEnnemis + 1
  if levelOptions.currentLevel < 10 then
    levelOptions.aliveEnnemis = levelOptions.totalEnnemis - levelOptions.killedEnnemis
  end
end

-- AddScorePlayer
-- Ajouter les points au joueur en fonction de l'alien tué
-- Parametres : type de l'alien
function AddScorePlayer(pType)
  if pType == 1 then
    levelOptions.score = levelOptions.score + 50
  elseif pType == 2 then
    levelOptions.score = levelOptions.score + 10
  else
    levelOptions.score = levelOptions.score + 150
  end
end

-- NextLevel
-- Mets a jour les infos pour changer le level-vague, reset powerups, active transition
function NextLevel()
  levelOptions.currentLevel = levelOptions.currentLevel + 1
  if levelOptions.currentLevel < 10 then
    levelOptions.totalEnnemis = levelOptions.levels[levelOptions.currentLevel][1] + levelOptions.levels[levelOptions.currentLevel][2] + levelOptions.levels[levelOptions.currentLevel][3]
    levelOptions.aliveEnnemis = levelOptions.totalEnnemis
  else
    levelOptions.totalEnnemis = -1 -- pour vague infinie
    levelOptions.aliveEnnemis = -1
  end 
  levelOptions.killedEnnemis = 0
  if levelOptions.regenVie then --ici difficulte hard, regen vie et parti du boost
    heros.vie = heros.vieMax
    heros.boostFuel = heros.boostFuel + heros.boostFuelMax/2
    if heros.boostFuel > heros.boostFuelMax then
      heros.boostFuel = heros.boostFuelMax
    end
  end
  if powerUpOption.activated then
    PowerUpRemEffet()
  end
  PowerUpReset()
  ChangeBackgrounColor()
  levelOptions.transitionLevel = true
  levelOptions.transitionText ="STAGE "..levelOptions.currentLevel
end

-- LevelWaitTransition
-- Gestion de la transition entre les vagues
-- Parametre : dt
function LevelWaitTransition(dt)
  levelOptions.transitionTimer = levelOptions.transitionTimer + dt
  if levelOptions.transitionTimer > 6 then
    levelOptions.transitionLevel = false
    levelOptions.transitionTimer = 0
  end
end

-- HeroGameOver
function HeroGameOver(dt)
  gameoverTimerAnimation = gameoverTimerAnimation + dt
  if gameoverTimerAnimation > 0.5 then
    gameoverTimerAnimation = 0
    gamestate.currentState = 5
    musiqueJeu:stop()
    musiqueMenu:play()
  end
end
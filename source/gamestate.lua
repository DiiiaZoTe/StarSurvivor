gamestate = {}
  gamestate[1] = "menu"
  gamestate[2] = "play"
  gamestate[3] = "pause"
  gamestate[4] = "options"
  gamestate[5] = "gameover"
  gamestate[6] = "tutorial"
  gamestate[7] = "quitter"
  gamestate.currentState = 1
  
function UpdateMenu(dt)
  BackgroundUpdate(dt)
  HeroAction(dt)
  TirGestionSprite(dt)
  GestionMenu(dt)
end

function UpdatePlay(dt)
  BackgroundUpdate(dt)
  PlayLevel(dt)
end

function UpdateOptions(dt)
  BackgroundUpdate(dt)
end

function UpdatePause(dt)
  
end

function UpdateGameover(dt)
  BackgroundUpdate(dt)
  gameoverTimerAnimation = gameoverTimerAnimation + dt
  if gameoverTimerAnimation >= 6 then
    gameoverTimerAnimation = 0
  end
end

function UpdateTutorial(dt)
  BackgroundUpdate(dt)
end

function DrawMenu()
  DrawBackground(backgroundOption.image[backgroundOption.currentColor])
  DrawTitreMenu()
  DrawDecors()
  DrawChoixMenu()
  DrawHero()
  DrawTirs()
end

-- DrawPlay
-- fonction de dessins pour le gameplay
function DrawPlay()
  DrawBackground(backgroundOption.image[backgroundOption.currentColor])
  DrawDecors()
  DrawPowerUps()
  DrawAliens()
  DrawHero()
  DrawTirs()
  DrawHud()
  DrawLevel()
end

function DrawOptions()
  DrawBackground(backgroundOption.image[backgroundOption.currentColor])
  DrawDecors()
  DrawMenuOptions()
end

function DrawPause()
  DrawPlay()
  font = love.graphics.newFont("images/font.ttf",150*globalScale)
  local textPause = love.graphics.newText(font, "Pause")
  local textPauseLargeur = textPause:getWidth()
  local textPauseHauteur = textPause:getHeight()
  love.graphics.draw(textPause,largeur/2,hauteur/3,0,1,1,textPauseLargeur/2,textPauseHauteur/2)
  font = love.graphics.newFont("images/font.ttf",50*globalScale)
  local textPause2 = love.graphics.newText(font, langage[langage.actuel].texte[27])
  local textPause2Largeur = textPause2:getWidth()
  local textPause2Hauteur = textPause2:getHeight()
  love.graphics.draw(textPause2,largeur/2,2*hauteur/3,0,1,1,textPause2Largeur/2,textPause2Hauteur/2)
end

function DrawGameOver()
  DrawBackground(backgroundOption.image[backgroundOption.currentColor])
  DrawDecors()
  DrawAliens()
  DrawLose()
end

function DrawTutorial()
  DrawBackground(backgroundOption.image[backgroundOption.currentColor])
  DrawDecors()
  DrawTextTuto()
end

function InputPlay(key)
  if key == "escape" then
    gamestate.currentState = 3
  end
  if key == optionsJeu[2].options[8].valeur then
    showStats = not showStats
  end
end

function InputPause(key)
  if key == "escape" then
    gamestate.currentState = 2
  elseif key == "return" then
    ResetGame()
    gamestate.currentState = 1
    musiqueJeu:stop()
    musiqueMenu:play()
  end
  if key == optionsJeu[2].options[8].valeur then
    showStats = not showStats
  end
end

function InputOptions(key)
  MoveOptionsMenu(key)
end

function InputGameOver(key)
  if key == "return" then
    ResetGame()
    gamestate.currentState = 1
  end
end

function InputTutorial(key)
  if key == "escape" then
    ResetGame()
    gamestate.currentState = 1
  end
end
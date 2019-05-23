require("gameFunctions")
require("gamestate")
require("heros")
require("aliens")
require("tirs")
require("background")
require("powerups")
require("levels")
require("drawFunctions")
require("menu")
require("options")

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end


function love.load()
  DemarreJeu()
  -- cap fps a 60
  local w,h,f = love.window.getMode()
  min_dt = 1/(f.refreshrate)
  next_time = love.timer.getTime()
end


function love.update(dt)
  next_time = next_time + min_dt --pour cap fps a 60
  if gamestate[gamestate.currentState] == "menu" then
    UpdateMenu(dt)
  elseif gamestate[gamestate.currentState] == "play" then
    UpdatePlay(dt)
  elseif gamestate[gamestate.currentState] == "pause" then
    UpdatePause(dt)
  elseif gamestate[gamestate.currentState] == "options" then
    UpdateOptions(dt)
  elseif gamestate[gamestate.currentState] == "gameover" then
    UpdateGameover(dt)
  elseif gamestate[gamestate.currentState] == "tutorial" then
    UpdateTutorial(dt)
  elseif gamestate[gamestate.currentState] == "quitter" then
    love.event.quit()
  end
end


function love.draw()
  if gamestate[gamestate.currentState] == "menu" then
    DrawMenu()
  elseif gamestate[gamestate.currentState] == "play" then
    DrawPlay()
  elseif gamestate[gamestate.currentState] == "pause" then
    DrawPause()
  elseif gamestate[gamestate.currentState] == "options" then
    DrawOptions()
  elseif gamestate[gamestate.currentState] == "gameover" then
    DrawGameOver()
  elseif gamestate[gamestate.currentState] == "tutorial" then
    DrawTutorial()
  end
  -- Cap fps a 60
  local cur_time = love.timer.getTime()
   if next_time <= cur_time then
      next_time = cur_time
      return
   end
   love.timer.sleep(next_time - cur_time)
end


function love.keypressed(key)
  if gamestate[gamestate.currentState] == "play" then
    InputPlay(key)
  elseif gamestate[gamestate.currentState] == "pause" then
    InputPause(key)
  elseif gamestate[gamestate.currentState] == "options" then
    InputOptions(key)
  elseif gamestate[gamestate.currentState] == "gameover" then
    InputGameOver(key)
  elseif gamestate[gamestate.currentState] == "tutorial" then
    InputTutorial(key)
  end
end

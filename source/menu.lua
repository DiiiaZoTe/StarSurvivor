-- GestionMenu
-- Fonction gerant le menu
function GestionMenu(dt)
  GestionVieChoixMenu(dt)
  UpdateTitreMenu(dt)
  UpdateChoixMenu()
  heros.boostFuel = heros.boostFuelMax
end

--UpdateChoixMenu
--Fonction qui update le gamestate en fonction du choix du joueur
function UpdateChoixMenu()
  if menu.choixUtilisateur == 1 then
    heros.isInvinsible = false
    gamestate.currentState = 2
    musiqueMenu:stop()
    musiqueJeu:play()
  elseif menu.choixUtilisateur == 2 then
    gamestate.currentState = 4
    love.mouse.setVisible(false)
  elseif menu.choixUtilisateur == 3 then
    gamestate.currentState = 6
    love.mouse.setVisible(false)
  elseif menu.choixUtilisateur == 4 then
    gamestate.currentState = 7
  end
end

-- GestionVieChoixMenu
-- Gere la vie du et selectionne le choix menu si on le choisi
function GestionVieChoixMenu(dt)
  for n,choix in ipairs(menu.choix) do
    if choix.vie <= 0 then
      choix.vie = 0
      menu.choixUtilisateur = n
    elseif choix.vie > 0 then
      choix.vie = choix.vie + 60*dt
      if choix.vie > choix.vieMax then
        choix.vie = choix.vieMax
      end
    end
  end
end

-- UpdateTitreMenu
-- Update pour le blink du menu
function UpdateTitreMenu(dt)
  menu.titreTimer = menu.titreTimer + dt
  if menu.titreTimer > 5 then
    menu.titreTimer = 0
  end
end
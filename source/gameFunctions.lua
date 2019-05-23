-- DemarreJeu
-- Fonction d'initialisation des ressources au lancement du jeu
function DemarreJeu()
  math.randomseed(os.time())
  local width,height = love.window.getDesktopDimensions(1)
  love.window.setMode(width,height,{vsync=true})
  love.window.setFullscreen(true)
  love.window.setTitle("Star Survivor")
  largeur,hauteur = love.graphics.getDimensions()
  globalScale = largeur/1600
  icon = love.image.newImageData("images/Ships/playerShip2_blue.png")
  love.window.setIcon(icon)
  
  font = love.graphics.newFont("images/font.ttf")
  love.graphics.setFont(font)
  
  CreeLangue()
  CreeCursor()
  IniatialiseAudio()
  CreeBackground()
  CreeMenu()
  CreeImageVaisseau()
  CreeHeros()
  CreeOptionsJeu()
  CreeLevelOption()
  CreePowerUpOption()
  gameoverTimerAnimation = 0
  
end

--CreeLangue
--Creer les options/texte de langue
function CreeLangue()
  langage = {}
    langage.actuel = 1 --1=FR;2=EN
    langage.nom = {}
      langage.nom[1] = "Français"
      langage.nom[2] = "English"
    langage[1] = {}
      langage[1].texte= {}
        langage[1].texte[1] = "Jouer"
        langage[1].texte[2] = "Options"
        langage[1].texte[3] = "Aide"
        langage[1].texte[4] = "Quitter"
        langage[1].texte[5] = "Facile"
        langage[1].texte[6] = "Moyenne"
        langage[1].texte[7] = "Difficile"
        langage[1].texte[8] = "Générales"
        langage[1].texte[9] = "Touches"
        langage[1].texte[10] = "Difficulté"
        langage[1].texte[11] = "Change la difficulté:\n-Facile: Tir allié ON / Régen.vie-boost entre les vagues ON / Boost illimité ON\n-Moyenne: Tir allié OFF / Régen.vie-boost entre les vagues ON / Boost illimité OFF\n-Difficile: Tir allié OFF / Régen.vie-boost entre les vagues OFF / Boost illimité OFF"
        langage[1].texte[12] = "Vidéo/Résolution"
        langage[1].texte[13] = "Plein écran"
        langage[1].texte[14] = "OUI"
        langage[1].texte[15] = "NON"
        langage[1].texte[16] = "Son/Volume"
        langage[1].texte[17] = "Langue"
        langage[1].texte[18] = "Tir basique"
        langage[1].texte[19] = "Tir puissant"
        langage[1].texte[20] = "Déplacement haut"
        langage[1].texte[21] = "Déplacement bas"
        langage[1].texte[22] = "Déplacement droite"
        langage[1].texte[23] = "Déplacement gauche"
        langage[1].texte[24] = "Super Shot"
        langage[1].texte[25] = "Santé/Boost régen."
        langage[1].texte[26] = "Invinsibilité"
        langage[1].texte[27] = "Appuyez sur ENTRER pour revenir au menu"
        langage[1].texte[28] = "Ennemis tués / Ennemis cette vague : "
        langage[1].texte[29] = "Survie"
        langage[1].texte[30] = "Total ennemis tués : "
        langage[1].texte[31] = "Taux de précision : "
        langage[1].texte[32] = " activé"
        langage[1].texte[33] = " fini dans "
        langage[1].texte[34] = "Perdu !"
        langage[1].texte[35] = "Votre score : "
        langage[1].texte[36] = "Aide :\n\t- Flèches pour naviguer\n\t- Entrer pour sélectionner\n\t- Echap pour annuler/quitter"
        langage[1].texte[37] = "Bonjour à toi, aventurier de l'espace !\n\nTu es un pilote rebel rentrant d'une longue et éprouvante bataille spatiale.\nMalheureusement, tu es pris en filature... Les ennemis arrivent et ils sont de plus en plus nombreux !\nVas-tu être capable de survivre ?\nSi tu as besoin d'aide pour les touches ou pour configurer le jeu, vas dans le menu des options.\nBonne chance !\n\nRecommandation : Activé le plein écran"
        langage[1].texte[38] = " ou "
    langage[2] = {}
      langage[2].texte= {}
        langage[2].texte[1] = "Play"
        langage[2].texte[2] = "Settings"
        langage[2].texte[3] = "Help"
        langage[2].texte[4] = "Quit"
        langage[2].texte[5] = "Easy"
        langage[2].texte[6] = "Medium"
        langage[2].texte[7] = "Hard"
        langage[2].texte[8] = "General"
        langage[2].texte[9] = "Keys"
        langage[2].texte[10] = "Difficulty"
        langage[2].texte[11] = "Change the difficulty:\n-Easy: Friendly Fire ON / Health-boost regen between stages ON / Unlimited boost ON\n-Medium: Friendly Fire OFF / Health-boost regen between stages ON / Unlimited boost OFF\n-Hard: Friendly Fire OFF / Health-boost regen between stages OFF / Unlimited boost OFF"
        langage[2].texte[12] = "Video/Resolution"
        langage[2].texte[13] = "Fullscreen"
        langage[2].texte[14] = "ON"
        langage[2].texte[15] = "OFF"
        langage[2].texte[16] = "Sound/Volume"
        langage[2].texte[17] = "Language"
        langage[2].texte[18] = "Basic Shot"
        langage[2].texte[19] = "Strong Shot"
        langage[2].texte[20] = "Move up"
        langage[2].texte[21] = "Move down"
        langage[2].texte[22] = "Move right"
        langage[2].texte[23] = "Move left"
        langage[2].texte[24] = "Super Shot"
        langage[2].texte[25] = "Health/Boost regen."
        langage[2].texte[26] = "Invinsibility"
        langage[2].texte[27] = "Press ENTER to return to main menu"
        langage[2].texte[28] = "Ennemis killed / Ennemis this wave : "
        langage[2].texte[29] = "Survive"
        langage[2].texte[30] = "Total killed ennemis : "
        langage[2].texte[31] = "Precision rate : "
        langage[2].texte[32] = " activated"
        langage[2].texte[33] = " ends in "
        langage[2].texte[34] = "You lose !"
        langage[2].texte[35] = "Your score : "
        langage[2].texte[36] = "Help :\n\t- Arrow keys to navigate\n\t- Enter to select\n\t- Escape to cancel/quit"
        langage[2].texte[37] = "Welcome, space traveler!\n\nYou are a rebel pilot coming back from a long and intense galactic battle.\nSadly, you get followed by the ennemis... They are coming and they are even more as time's passing.\nWill you be able to survive?\nIf you need help for the keys and to configure the game, go to the settings menu.\nGood Luck!\n\nRecommandation: Activate fullscreen"
        langage[2].texte[38] = " or "
end

-- CreeCursor
-- Fonction de creation, initialisation des donnees pour le curseur
function CreeCursor()
  cursor = {}
  cursor[1] = love.mouse.newCursor("images/UI/cursorNonCharger1.png",11,11)
  cursor[2] = love.mouse.newCursor("images/UI/cursorNonCharger2.png",11,11)
  cursor[3] = love.mouse.newCursor("images/UI/cursorNonCharger3.png",11,11)
  cursor[4] = love.mouse.newCursor("images/UI/cursorNonCharger4.png",11,11)
  cursor[5] = love.mouse.newCursor("images/UI/cursorCharger.png",11,11)
  love.mouse.setCursor(cursor[1])
  local i for i=1,5 do
    img_explosions[i] = love.graphics.newImage("images/Effects/explode_"..i..".png")
  end
end

-- IniatialiseAudio
-- fonction d'initialisation de l'audio
function IniatialiseAudio()
  masterVolume = 5
  musiqueMenu = love.audio.newSource("sons/truc.mp3","stream")
  musiqueMenu:setVolume(0.05*masterVolume)
  musiqueMenu:setLooping(true)
  musiqueJeu = love.audio.newSource("sons/jpp.mp3","stream")
  musiqueJeu:setVolume(0.015*masterVolume)
  musiqueJeu:setLooping(true)
  love.audio.play(musiqueMenu)
  
  liste_sonTirs = {}
  liste_sonTirs.sonShoot1 = love.audio.newSource("sons/shoot.wav","static")
  liste_sonTirs.sonShoot1:setVolume(0.1*masterVolume)
  liste_sonTirs.sonShoot2 = love.audio.newSource("sons/piou.wav","static")
  liste_sonTirs.sonShoot2:setVolume(0.1*masterVolume)
  liste_sonTirs.sonShoot2:setPitch(0.3)
  liste_sonTirs.sonExplode = love.audio.newSource("sons/explode.wav","static")
  liste_sonTirs.sonExplode:setVolume(0.15*masterVolume)
  liste_sonTirs.sonBoum = love.audio.newSource("sons/explode.wav","static")
  liste_sonTirs.sonBoum:setVolume(0.3*masterVolume)
  
  sonMenuSwitch = love.audio.newSource("sons/selectionSwitch.wav","static")
  sonMenuSwitch:setVolume(0.05*masterVolume)
  sonMenuSelect = love.audio.newSource("sons/selectionConfirm.wav","static")
  sonMenuSelect:setVolume(0.05*masterVolume)
end

-- CreeBackground
-- Fonction de creation, initialisation des donnees pour le background
function CreeBackground()
  backgroundOption = {}
  backgroundOption.image = {}
    backgroundOption.image[1] = love.graphics.newImage("images/Backgrounds/background1.png")
    backgroundOption.image[2] = love.graphics.newImage("images/Backgrounds/background2.png")
    backgroundOption.image[3] = love.graphics.newImage("images/Backgrounds/background3.png")
    backgroundOption.image[4] = love.graphics.newImage("images/Backgrounds/background4.png")
    backgroundOption.image[5] = love.graphics.newImage("images/Backgrounds/background5.png")
    backgroundOption.image[6] = love.graphics.newImage("images/Backgrounds/background6.png")
    backgroundOption.image[7] = love.graphics.newImage("images/Backgrounds/background7.png")
  backgroundOption.currentColor = math.random(1,#backgroundOption.image)
  backgroundOption.previousColor = 0
  backgroundOption.scale = globalScale
  backgroundOption.l = backgroundOption.image[1]:getWidth() * backgroundOption.scale
  backgroundOption.h = backgroundOption.image[1]:getHeight() * backgroundOption.scale
  backgroundOption.offsetX = 0
  backgroundOption.offsetY = 0
  backgroundOption.timer = 0
  backgroundOption.dirX = math.random(-50*globalScale,50*globalScale)
  backgroundOption.dirY = math.random(-50*globalScale,50*globalScale)
  backgroundOption.decors = {}
    backgroundOption.decors[1] = "images/Meteors/meteorBrown_big1.png"
    backgroundOption.decors[2] = "images/Meteors/meteorBrown_big2.png"
    backgroundOption.decors[3] = "images/Meteors/meteorBrown_big3.png"
    backgroundOption.decors[4] = "images/Meteors/meteorBrown_big4.png"
    backgroundOption.decors[5] = "images/Meteors/meteorBrown_med1.png"
    backgroundOption.decors[6] = "images/Meteors/meteorBrown_med2.png"
    backgroundOption.decors[7] = "images/Meteors/meteorBrown_small1.png"
    backgroundOption.decors[8] = "images/Meteors/meteorBrown_small2.png"
    backgroundOption.decors[9] = "images/Meteors/meteorBrown_tiny1.png"
    backgroundOption.decors[10] = "images/Meteors/meteorBrown_tiny2.png"
    backgroundOption.decors[11] = "images/Meteors/meteorGrey_big1.png"
    backgroundOption.decors[12] = "images/Meteors/meteorGrey_big2.png"
    backgroundOption.decors[13] = "images/Meteors/meteorGrey_big3.png"
    backgroundOption.decors[14] = "images/Meteors/meteorGrey_big4.png"
    backgroundOption.decors[15] = "images/Meteors/meteorGrey_med1.png"
    backgroundOption.decors[16] = "images/Meteors/meteorGrey_med2.png"
    backgroundOption.decors[17] = "images/Meteors/meteorGrey_small1.png"
    backgroundOption.decors[18] = "images/Meteors/meteorGrey_small2.png"
    backgroundOption.decors[19] = "images/Meteors/meteorGrey_tiny1.png"
    backgroundOption.decors[20] = "images/Meteors/meteorGrey_tiny2.png"
  backgroundOption.nbDecorMax = 10
  backgroundOption.distDiagonal = GetDistance(0,0,largeur/2,hauteur/2)

  while #liste_decors < backgroundOption.nbDecorMax do
    local randX = math.random(1,largeur)
    local randY = math.random(1,hauteur)
    local nDecor = math.random(1,#backgroundOption.decors)
    CreeDecor(backgroundOption.decors[nDecor],randX,randY)
  end
end

-- CreeImageVaisseau
-- initialise les differentes images pour le vaisseau
function CreeImageVaisseau()
  vaisseauImage = {}
    vaisseauImage.current = 1
    vaisseauImage[1] = "images/Ships/playerShip2_blue.png"
    vaisseauImage[2] = "images/Ships/playerShip2_red.png"
    vaisseauImage[3] = "images/Ships/playerShip2_green.png"
    vaisseauImage[4] = "images/Ships/playerShip2_orange.png"
    vaisseauImage[5] = "images/Ships/playerShip1_blue.png"
    vaisseauImage[6] = "images/Ships/playerShip1_red.png"
    vaisseauImage[7] = "images/Ships/playerShip1_green.png"
    vaisseauImage[8] = "images/Ships/playerShip1_orange.png"
    vaisseauImage[9] = "images/Ships/playerShip3_blue.png"
    vaisseauImage[10] = "images/Ships/playerShip3_red.png"
    vaisseauImage[11] = "images/Ships/playerShip3_green.png"
    vaisseauImage[12] = "images/Ships/playerShip3_orange.png"
end

function CreeMenu()
  menu = {}
    menu.choix = {}
      menu.choix[1] = {}
        menu.choix[1].text = langage[langage.actuel].texte[1]
        menu.choix[1].x = 0.25*largeur
        menu.choix[1].y = 0.25*hauteur
        menu.choix[1].l = 0.20*largeur
        menu.choix[1].h = 0.10*hauteur
        menu.choix[1].scale = 1*globalScale
        menu.choix[1].vie = 200
        menu.choix[1].vieMax = 200
      menu.choix[2] = {}
        menu.choix[2].text = langage[langage.actuel].texte[2]
        menu.choix[2].x = 0.75*largeur
        menu.choix[2].y = 0.25*hauteur
        menu.choix[2].l = 0.20*largeur
        menu.choix[2].h = 0.10*hauteur
        menu.choix[2].scale = 1*globalScale
        menu.choix[2].vie = 200
        menu.choix[2].vieMax = 200
      menu.choix[3] = {}
        menu.choix[3].text = langage[langage.actuel].texte[3]
        menu.choix[3].x = 0.25*largeur
        menu.choix[3].y = 0.75*hauteur
        menu.choix[3].l = 0.20*largeur
        menu.choix[3].h = 0.10*hauteur
        menu.choix[3].scale = 1*globalScale
        menu.choix[3].vie = 200
        menu.choix[3].vieMax = 200
      menu.choix[4] = {}
        menu.choix[4].text = langage[langage.actuel].texte[4]
        menu.choix[4].x = 0.75*largeur
        menu.choix[4].y = 0.75*hauteur
        menu.choix[4].l = 0.20*largeur
        menu.choix[4].h = 0.10*hauteur
        menu.choix[4].scale = 1*globalScale
        menu.choix[4].vie = 200
        menu.choix[4].vieMax = 200
    menu.choixUtilisateur = 0
    menu.titreTimer = 0
end

-- CreePowerUpOption
-- Fonction de creation des options des powerups
function CreePowerUpOption()
  powerUpOption = {}
  powerUpOption.image = {}
    powerUpOption.image[1] = "images/Power-ups/bolt_gold.png"
    powerUpOption.image[2] = "images/Power-ups/pill_green.png"
    powerUpOption.image[3] = "images/Power-ups/star_silver.png"
  powerUpOption.globalTimer = 0
  powerUpOption.activeTimer = 0
  powerUpOption.maxActiveTime = 8
  powerUpOption.activated = false
  powerUpOption.timeToTake = 10
  powerUpOption.typeActive = 0
  powerUpOption.typeActiveName = ""
  powerUpOption.nextPowerUp = math.random(10,20)
end

-- CreeLevelOption
-- Fonction de creation des options des levels-vagues
function CreeLevelOption()
  levelOptions = {}
    levelOptions.currentLevel = 0
    levelOptions.totalEnnemis = 0
    levelOptions.aliveEnnemis = 0
    levelOptions.killedEnnemis = 0
    levelOptions.totalEnnemisKilled = 0
    levelOptions.nbEnnemisOnScreen = 0
    levelOptions.maxEnnemisOnScreen = 15
    levelOptions.difficulty = optionsJeu[1].options[1].valeur
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
    levelOptions.levels = {}
      levelOptions.levels[1] = {[1]=4,[2]=0,[3]=0}
      levelOptions.levels[2] = {[1]=0,[2]=6,[3]=0}
      levelOptions.levels[3] = {[1]=0,[2]=0,[3]=3}
      levelOptions.levels[4] = {[1]=3,[2]=4,[3]=2}
      levelOptions.levels[5] = {[1]=4,[2]=6,[3]=4}
      levelOptions.levels[6] = {[1]=6,[2]=8,[3]=5}
      levelOptions.levels[7] = {[1]=8,[2]=10,[3]=6}
      levelOptions.levels[8] = {[1]=15,[2]=20,[3]=8}
      levelOptions.levels[9] = {[1]=20,[2]=30,[3]=10}
      levelOptions.levels[10] = "Survive"
    levelOptions.transitionLevel = false
    levelOptions.transitionTimer = 0
    levelOptions.transitionText = ""
  showStats = false
    levelOptions.totalHeroShots = 0
    levelOptions.totalHeroShotsHit = 0
    levelOptions.score = 0
end

function CreeOptionsJeu()
  optionsJeu = {}
    optionsJeu.choixOption = 1
    optionsJeu.modification = false
    optionsJeu.numLastModify = nil
    optionsJeu[1] = {}
      optionsJeu[1].nom = langage[langage.actuel].texte[8]
      optionsJeu[1].options = {}
        optionsJeu[1].options.choixOption = 1
        optionsJeu[1].options[1] = {}
          optionsJeu[1].options[1].nom = langage[langage.actuel].texte[10]
          optionsJeu[1].options[1].valeur = langage[langage.actuel].texte[6]
          optionsJeu[1].options[1].numValeur = 2
          optionsJeu[1].options[1].valeurPossible = {langage[langage.actuel].texte[5],langage[langage.actuel].texte[6],langage[langage.actuel].texte[7]}
          optionsJeu[1].options[1].modifiable = true
          optionsJeu[1].options[1].description = langage[langage.actuel].texte[11]
        optionsJeu[1].options[2] = {}
          optionsJeu[1].options[2].nom = langage[langage.actuel].texte[12]
          optionsJeu[1].options[2].valeur = tostring(largeur).."x"..tostring(hauteur)
          optionsJeu[1].options[2].numValeur = 1
          optionsJeu[1].options[2].valeurPossible = {langage[langage.actuel].texte[13],"640x360","800x450","800x600","1200x675","1366x768","1400x900","1600x900","1920x1080"}
          optionsJeu[1].options[2].modifiable = true
        optionsJeu[1].options[3] = {}
          optionsJeu[1].options[3].nom = langage[langage.actuel].texte[13]
          optionsJeu[1].options[3].valeur = langage[langage.actuel].texte[14]
          optionsJeu[1].options[3].numValeur = 1
          optionsJeu[1].options[3].valeurPossible = {langage[langage.actuel].texte[14],langage[langage.actuel].texte[15]}
          optionsJeu[1].options[3].modifiable = true
        optionsJeu[1].options[4] = {}
          optionsJeu[1].options[4].nom = langage[langage.actuel].texte[16]
          optionsJeu[1].options[4].valeur = 5
          optionsJeu[1].options[4].numValeur = 6
          optionsJeu[1].options[4].valeurPossible = {0,1,2,3,4,5,6,7,8,9,10}
          optionsJeu[1].options[4].modifiable = true
        optionsJeu[1].options[5] = {}
          optionsJeu[1].options[5].nom = langage[langage.actuel].texte[17]
          optionsJeu[1].options[5].valeur = langage.nom[langage.actuel]
          optionsJeu[1].options[5].numValeur = 1
          optionsJeu[1].options[5].valeurPossible = {langage.nom[1],langage.nom[2]}
          optionsJeu[1].options[5].modifiable = true
    optionsJeu[2] = {}
      optionsJeu[2].nom = langage[langage.actuel].texte[9]
      optionsJeu[2].options = {}
        optionsJeu[2].options.choixOption = 1
        optionsJeu[2].options[1] = {}
          optionsJeu[2].options[1].nom = langage[langage.actuel].texte[18]
          optionsJeu[2].options[1].valeur = "space"
          optionsJeu[2].options[1].modifiable = false
        optionsJeu[2].options[2] = {}
          optionsJeu[2].options[2].nom = langage[langage.actuel].texte[19]
          optionsJeu[2].options[2].valeur = "lalt"
          optionsJeu[2].options[2].modifiable = false
        optionsJeu[2].options[3] = {}
          optionsJeu[2].options[3].nom = langage[langage.actuel].texte[20]
          optionsJeu[2].options[3].valeur = "z"
          optionsJeu[2].options[3].modifiable = true
        optionsJeu[2].options[4] = {}
          optionsJeu[2].options[4].nom = langage[langage.actuel].texte[21]
          optionsJeu[2].options[4].valeur = "s"
          optionsJeu[2].options[4].modifiable = true
        optionsJeu[2].options[5] = {}
          optionsJeu[2].options[5].nom = langage[langage.actuel].texte[23]
          optionsJeu[2].options[5].valeur = "q"
          optionsJeu[2].options[5].modifiable = true
        optionsJeu[2].options[6] = {}
          optionsJeu[2].options[6].nom = langage[langage.actuel].texte[22]
          optionsJeu[2].options[6].valeur = "d"
          optionsJeu[2].options[6].modifiable = true
        optionsJeu[2].options[7] = {}
          optionsJeu[2].options[7].nom = "Boost"
          optionsJeu[2].options[7].valeur = "lshift"
          optionsJeu[2].options[7].modifiable = true
        optionsJeu[2].options[8] = {}
          optionsJeu[2].options[8].nom = "Stats"
          optionsJeu[2].options[8].valeur = "t"
          optionsJeu[2].options[8].modifiable = true
    optionsJeu[3] = {}
      optionsJeu[3].nom = "Heros"
      optionsJeu[3].imageNumber = vaisseauImage.current
        
end

function ResetGame()
  love.mouse.setVisible(true)
  heros = {}
  levelOptions = {}
  liste_aliens = {}
  liste_tirs = {}
  powerUpOption = {}
  menu = {}
  CreeMenu()
  CreeHeros()
  CreePowerUpOption()
  CreeLevelOption()
  gameoverTimerAnimation = 0
end

-- CreeSprite
-- Fonction de creation global de sprite
-- Parametres : chemin de l'image, x, y 
-- Return : sprite
function CreeSprite(pCheminImage, pX, pY)
  sprite = {}
  sprite.x = pX
  sprite.y = pY
  sprite.image = love.graphics.newImage(pCheminImage)
  sprite.l = sprite.image:getWidth()
  sprite.h = sprite.image:getHeight()
  sprite.angle = 0
  sprite.scale = 1 * globalScale
  sprite.vie = 0
  return sprite
end

-- getDistance
-- Fonction de base collision
-- Parametres : entite 1, entite 2
-- Return : number
function GetDistance(xA,yA,xB,yB)
  return math.sqrt((xB-xA)^2+(yB-yA)^2)
end

-- Collide
-- Fonction de base collision
-- Parametres : entite 1, entite 2
-- Return : bool
function Collide(a1, a2)
 if (a1==a2) then return false end
 local dx = a1.x - a2.x
 local dy = a1.y - a2.y
 if (math.abs(dx) < a1.l/2*a1.scale+a2.l/2*a2.scale) then
  if (math.abs(dy) < a1.h/2*a1.scale+a2.h/2*a2.scale) then
   return true
  end
 end
 return false
end

-- Round
-- Fonction pour arrondir a une certaine precision
-- Parametres : quoi, precision apres virgule
function Round(pX,precision)
  return math.floor(pX*math.pow(10,precision)+0.5) / math.pow(10,precision)
end

-- Gradient
-- Creer un object gradient
-- Parametres : colors
function Gradient(colors)
  local direction = colors.direction or "horizontal"
  if direction == "horizontal" then
    direction = true
  elseif direction == "vertical" then
    direction = false
  else
    error("Invalid direction '" .. tostring(direction) "' for gradient.  Horizontal or vertical expected.")
  end
  local result = love.image.newImageData(direction and 1 or #colors, direction and #colors or 1)
  for i, color in ipairs(colors) do
    local x, y
    if direction then --horizontal
      x, y = 0, i - 1
    else -- vertical
      x, y = i - 1, 0
    end
    result:setPixel(x, y, color[1], color[2], color[3], color[4] or 255)
  end
  result = love.graphics.newImage(result)
  result:setFilter('linear', 'linear')
  return result
end

--Drawinrect
--Dessine dans un rectangle
function DrawInRect(img, x, y, w, h, r, ox, oy, kx, ky)
  return -- tail call for a little extra bit of efficiency
  love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end
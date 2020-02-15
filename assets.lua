---- Sprites ---------------------------------------------------------------------------------------
Sprites = {}

Sprites.player = {}
Sprites.player.default = lg.newImage('assets/player/player_default.png')
Sprites.player._1 	   = lg.newImage('assets/player/player_1.png')
Sprites.player._2 	   = lg.newImage('assets/player/player_2.png')
Sprites.player._3 	   = lg.newImage('assets/player/player_3.png')

Sprites.jazzer	  = lg.newImage('assets/enemies/jazzer.png')
Sprites.topHatter = lg.newImage('assets/enemies/top-hatter.png')
Sprites.drone	  = lg.newImage('assets/enemies/drone.png')
Sprites.kingpin	  = lg.newImage('assets/enemies/kingpin.png')

Sprites.jazzer_	   = lg.newImage('assets/enemies/corpses/jazzer.png')
Sprites.topHatter_ = lg.newImage('assets/enemies/corpses/top-hatter.png')
Sprites.drone_	   = lg.newImage('assets/enemies/corpses/drone.png')
Sprites.kingpin_   = lg.newImage('assets/enemies/corpses/kingpin.png')

Sprites.scythe	  	= lg.newImage('assets/spells/scythe.png')
Sprites.arrow 	  	= lg.newImage('assets/spells/arrow.png')
Sprites.cross	  	= lg.newImage('assets/spells/cross.png')
Sprites.cross_	    = lg.newImage('assets/spells/cross_.png')
Sprites.frostBall 	= lg.newImage('assets/spells/frostBall.png')
Sprites.sword 	  	= lg.newImage('assets/spells/sword.png')
Sprites.lightning_1 = lg.newImage('assets/spells/lightning_1.png')
Sprites.lightning_2 = lg.newImage('assets/spells/lightning_2.png')
Sprites.lightning_3 = lg.newImage('assets/spells/lightning_3.png')
Sprites.lightning_4 = lg.newImage('assets/spells/lightning_4.png')

Sprites.particles = {}
Sprites.particles.spellText = lg.newImage('assets/particle.jpg')
Sprites.particles.forBullet = lg.newImage('assets/smallParticle.jpg')
Sprites.particles.rain 		= lg.newImage('assets/rain.jpg')

Sprites.menu = {}
Sprites.menu.arrow = lg.newImage('assets/gui/menu/selectArrow.png')
Sprites.menu.spellbook = {}
Sprites.menu.spellbook[1]	 = lg.newImage('assets/gui/menu/bow.png')
Sprites.menu.spellbook[2]	 = lg.newImage('assets/gui/menu/scythe.png')
Sprites.menu.spellbook[3]	 = lg.newImage('assets/gui/menu/cross.png')
Sprites.menu.spellbook[4]	 = lg.newImage('assets/gui/menu/froster.png')
Sprites.menu.spellbook[5]	 = lg.newImage('assets/gui/menu/magicSword.png')
Sprites.menu.spellbook[6]	 = lg.newImage('assets/gui/menu/lightning.png')


---- GUI
Sprites.GUI = {}
Sprites.GUI.lives = lg.newImage('assets/gui/lives.png')
Sprites.GUI.score = lg.newImage('assets/gui/score.png')

Sprites.GUI.cooldown = {}
Sprites.GUI.cooldown[1] = lg.newImage('assets/gui/cooldown/bow.png')
Sprites.GUI.cooldown[2] = lg.newImage('assets/gui/cooldown/scythe.png')
Sprites.GUI.cooldown[3] = lg.newImage('assets/gui/cooldown/cross.png')
Sprites.GUI.cooldown[4] = lg.newImage('assets/gui/cooldown/froster.png')
Sprites.GUI.cooldown[5] = lg.newImage('assets/gui/cooldown/magicSword.png')
Sprites.GUI.cooldown[6] = lg.newImage('assets/gui/cooldown/lightning.png')

Sprites.GUI.pause = lg.newImage('assets/gui/pause.png')

---- Fonts -----------------------------------------------------------------------------------------
Fonts = {}

Fonts.spell = lg.newFont('assets/fonts/8bitOperatorPlus8-Regular.ttf', 40)
Fonts.arrows = {}
Fonts.arrows.up 	= lg.newImage('assets/fonts/arrows/up-arrow.png')
Fonts.arrows.down 	= lg.newImage('assets/fonts/arrows/down-arrow.png')
Fonts.arrows.left 	= lg.newImage('assets/fonts/arrows/left-arrow.png')
Fonts.arrows.right 	= lg.newImage('assets/fonts/arrows/right-arrow.png')

Fonts.GUI 		= lg.newFont('assets/fonts/8bitOperatorPlusSC-Regular.ttf', 20)
Fonts.smallGUI  = lg.newFont('assets/fonts/8bitOperatorPlusSC-Regular.ttf', 14)
Fonts.smallGUI_  = lg.newFont('assets/fonts/8bitOperatorPlusSC-Regular.ttf', 15)

Fonts.Menu_1	= lg.newFont('assets/fonts/PressStart2P.ttf', 40)
Fonts.Menu_2	= lg.newFont('assets/fonts/PressStart2P.ttf', 28)
Fonts.Menu_3	= lg.newFont('assets/fonts/PressStart2P.ttf', 13)
Fonts.Menu_4	= lg.newFont('assets/fonts/PressStart2P.ttf', 18)
Fonts.Menu_5	= lg.newFont('assets/fonts/PressStart2P.ttf', 20)

---- Particles -------------------------------------------------------------------------------------
Particles = {}

Particles.menu = lg.newParticleSystem(Sprites.particles.rain)
	Particles.menu:setParticleLifetime(6, 8)
	Particles.menu:setEmissionRate(14)
	Particles.menu:setSpeed(120, 180)
	Particles.menu:setLinearAcceleration(0, 20, 0, 20)
	Particles.menu:setDirection(math.pi/2 - math.pi/16)
	Particles.menu:setEmissionArea('uniform', 0, 900, math.pi/2)
	Particles.menu:setPosition(lg.getWidth()/2 - 60, -100)
	Particles.menu:stop()

Particles.spellText = lg.newParticleSystem(Sprites.particles.spellText)
	Particles.spellText:setParticleLifetime(0.6, 1)
	Particles.spellText:setSizeVariation(1)
	Particles.spellText:setLinearAcceleration(0, 200, 0, 200)
	Particles.spellText:setSpeed(70, 80)
	Particles.spellText:setSpread(math.pi)
	Particles.spellText:setEmissionArea('normal', 2, 2, math.pi*2)
	Particles.spellText:setDirection(-math.pi/2)
	Particles.spellText:setColors(1, 1, 1, 1, 1, 1, 1, 0)
	
Particles.player = lg.newParticleSystem(Sprites.particles.spellText)
	Particles.player:setPosition(270, 536)
	Particles.player:setParticleLifetime(0.9, 1.2)
	Particles.player:setSizeVariation(0.6)
	Particles.player:setLinearAcceleration(40, 40, 40, 40)
	Particles.player:setSpeed(75, 110)
	Particles.player:setSpread(math.pi*2)
	Particles.player:setEmissionArea('normal', 5, 5, math.pi*2)
	Particles.player:setColors(1, 1, 1, 0.8, 1, 1, 1, 0)

Particles.bow = lg.newParticleSystem(Sprites.particles.forBullet)
	Particles.bow:setParticleLifetime(0.3, 0.5)
	Particles.bow:setSizeVariation(0.6)
	Particles.bow:setLinearAcceleration(70, 70, 70, 70)
	Particles.bow:setSpeed(170, 200)
	Particles.bow:setSpread(math.pi*2)
	Particles.bow:setColors(1, 1, 1, 0.6, 1, 1, 1, 0)
	
Particles.scythe = lg.newParticleSystem(Sprites.particles.forBullet)
	Particles.scythe:setParticleLifetime(0.3, 0.5)
	Particles.scythe:setSizeVariation(0.5)
	Particles.scythe:setSpeed(120, 270)
	Particles.scythe:setSpread(math.pi/8)
	Particles.scythe:setColors(1, 1, 1, 0.6, 1, 1, 1, 0)

Particles.sword = lg.newParticleSystem(Sprites.particles.spellText)
	Particles.sword:setParticleLifetime(0.8, 1)
	Particles.sword:setSizeVariation(0.9)
	Particles.sword:setLinearAcceleration(0, 30, 0, 10)
	Particles.sword:setSpeed(160, 240)
	Particles.sword:setDirection(math.pi/2)
	Particles.sword:setSpread(math.pi/5)
	Particles.sword:setColors(1, 1, 1, 1, 1, 1, 1, 0.2)

Particles.rain = lg.newParticleSystem(Sprites.particles.rain)
	Particles.rain:setParticleLifetime(4, 6)
	Particles.rain:setSpeed(440, 520)
	Particles.rain:setDirection(math.pi/2 + math.pi/12)
	Particles.rain:setEmissionArea('uniform', 0, 360, math.pi/2)
	Particles.rain:setPosition(340, -40)
	
	
Particles_ = {}
	
Particles_.froster_left = lg.newParticleSystem(Sprites.particles.spellText)
	Particles_.froster_left:setEmissionRate(40)
	Particles_.froster_left:setParticleLifetime(0.3, 0.4)
	Particles_.froster_left:setSizeVariation(0.8)
	Particles_.froster_left:setLinearAcceleration(100, 0, 100, 0)
	Particles_.froster_left:setSpeed(200, 240)
	Particles_.froster_left:setDirection(0)
	Particles_.froster_left:setSpread(math.pi/24)
	Particles_.froster_left:setColors(1, 1, 1, 0.9, 1, 1, 1, 0.2)
	Particles_.froster_left:setEmissionArea('uniform', 0, 40, math.pi)

Particles_.froster_right = lg.newParticleSystem(Sprites.particles.spellText)
	Particles_.froster_right:setEmissionRate(40)
	Particles_.froster_right:setParticleLifetime(0.3, 0.4)
	Particles_.froster_right:setSizeVariation(0.8)
	Particles_.froster_right:setLinearAcceleration(-100, 0, -100, 0)
	Particles_.froster_right:setSpeed(200,240)
	Particles_.froster_right:setSpread(math.pi/24)
	Particles_.froster_right:setDirection(math.pi)
	Particles_.froster_right:setColors(1, 1, 1, 0.9, 1, 1, 1, 0.2)
	Particles_.froster_right:setEmissionArea('uniform', 0, 40, math.pi)


---- Audio -----------------------------------------------------------------------------------------
Audio = {}

-- Music
Audio.Musics = {}

Audio.Musics.menu = {}
Audio.Musics.menu.audio = la.newSource('assets/audio/music/Chippy music 1_.wav', 'stream')
Audio.Musics.menu.volume = 0.72

Audio.Musics.mainTheme = {}
Audio.Musics.mainTheme.audio = la.newSource('assets/audio/music/Chippy Music 16_.wav', 'stream')
Audio.Musics.mainTheme.volume = 0.8

-- SFX
Audio.SFXs = {}

Audio.SFXs.character = {}
Audio.SFXs.character.audio = la.newSource('assets/audio/sfx/Swing 1.mp3', 'static')
Audio.SFXs.character.volume = 0.8

Audio.SFXs.arrow = {}
Audio.SFXs.arrow.audio = la.newSource('assets/audio/sfx/Swing 2.mp3', 'static')
Audio.SFXs.arrow.volume = 0.8

Audio.SFXs.lightning = {}
Audio.SFXs.lightning.audio = la.newSource('assets/audio/sfx/Buff Up.wav', 'static')
Audio.SFXs.lightning.volume = 0.8

Audio.SFXs.castSpell = {}
Audio.SFXs.castSpell.audio = la.newSource('assets/audio/sfx/Swing Hollow.mp3', 'static')
Audio.SFXs.castSpell.volume = 0.8

Audio.SFXs.error = {}
Audio.SFXs.error.audio = la.newSource('assets/audio/sfx/Error 1.mp3', 'static')
Audio.SFXs.error.volume = 0.8

Audio.SFXs.hit_1 = {}
Audio.SFXs.hit_1.audio = la.newSource('assets/audio/sfx/Hitsound 1.mp3', 'static')
Audio.SFXs.hit_1.volume = 0.8

Audio.SFXs.hit_2 = {}
Audio.SFXs.hit_2.audio = la.newSource('assets/audio/sfx/Hitsound 2.mp3', 'static')
Audio.SFXs.hit_2.volume = 0.8

Audio.SFXs.hit_3 = {}
Audio.SFXs.hit_3.audio = la.newSource('assets/audio/sfx/Hitsound 3.mp3', 'static')
Audio.SFXs.hit_3.volume = 0.8

Audio.SFXs.hit_4 = {}
Audio.SFXs.hit_4.audio = la.newSource('assets/audio/sfx/Power Hit.mp3', 'static')
Audio.SFXs.hit_4.volume = 0.8

Audio.SFXs.death_1 = {}
Audio.SFXs.death_1.audio = la.newSource('assets/audio/sfx/Death Sound 1.mp3', 'static')
Audio.SFXs.death_1.volume = 0.8

Audio.SFXs.death_2 = {}
Audio.SFXs.death_2.audio = la.newSource('assets/audio/sfx/Death Sound 2.mp3', 'static')
Audio.SFXs.death_2.volume = 0.8

Audio.SFXs.death_3 = {}
Audio.SFXs.death_3.audio = la.newSource('assets/audio/sfx/Death Sound 3.mp3', 'static')
Audio.SFXs.death_3.volume = 0.8

Audio.SFXs.death_4 = {}
Audio.SFXs.death_4.audio = la.newSource('assets/audio/sfx/Death Sound 4.mp3', 'static')
Audio.SFXs.death_4.volume = 0.8

Audio.SFXs.unlock = {}
Audio.SFXs.unlock.audio = la.newSource('assets/audio/sfx/Unlock.mp3', 'static')
Audio.SFXs.unlock.volume = 0.8

Audio.SFXs.menu_1 = {}
Audio.SFXs.menu_1.audio = la.newSource('assets/audio/sfx/Menu Back.mp3', 'static')
Audio.SFXs.menu_1.volume = 0.6

Audio.SFXs.menu_2 = {}
Audio.SFXs.menu_2.audio = la.newSource('assets/audio/sfx/Menu Select.mp3', 'static')
Audio.SFXs.menu_2.volume = 0.6

Audio.SFXs.menu_3 = {}
Audio.SFXs.menu_3.audio = la.newSource('assets/audio/sfx/Menu Select 2.mp3', 'static')
Audio.SFXs.menu_3.volume = 0.35

Audio.SFXs.loseLives = {}
Audio.SFXs.loseLives.audio = la.newSource('assets/audio/sfx/Charge 2.mp3', 'static')
Audio.SFXs.loseLives.volume = 0.5

Audio.SFXs.lost = {}
Audio.SFXs.lost.audio = la.newSource('assets/audio/sfx/Denied.mp3', 'static')
Audio.SFXs.lost.volume = 0.6

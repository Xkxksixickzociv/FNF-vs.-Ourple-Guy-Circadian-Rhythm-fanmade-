local goldInitX = 400;
local goldInitY = 0;
local goldFloatY = 0.0;
local goldShakeForce = 5.0;
local goldShakeTimer = 0.0;
local goldShakeTime = 8.0;

local nikkuInitY = -125;
local nikkuFloatY = 0.0;

local oldCamZoom = 1;
local camZoomBI = 1; -- BI = beat intensity
local camAngleBI = 0; 
local isZooming = false;

local bgphase = 0; --0: fnaf world, 1: fnaf pizza sim, 2: ucn
local everybody = false;

local splashName; -- splash offsets help by ImaginationSuperHero52806

local worldelements = {
	'sky',
	'back',
	'midback',
	'midfront',
	'front',
	'objben',
	'objdod',
	'objgold',
	'objragtime',
	'objsherri',
	'objviba'
}

local pizzaelements = {
	
	'pizzasimbg',
	'pizzasimfloor',
	'pizzasimpaperpals',
	'objjaylung',
	'objbroken',
	'objpuro',
	'objtheft',
	'speakerright',
	'speakerleft',
	'lolbit',
	'pizzasimstage',
	'objsheepman',
	'objmetalgeneral',
	'objmettatonex',
	'balloonsleft',
	'balloonsright'

}

local ucnelements = {

	'ucnoffice',
	'ucntable',
	'objcandycadet',
	'objcoffee',
	'objcutmandy',
	'objdguy',
	'objfan',
	'objgamma',
	'objironvaliant',
	'objjergeaul',
	'objkerfluffle',
	'objkoi',
	'objnikku',
	'objpink',
	'objrory',
	'objsandwoman',
	'objsenpai',
	'objtoychica',
	'objtronbonne',
	'objuhyeah',
	'objvideoman',
	'objzero'

}

local font = 'silkscreen.ttf';

local function lerp(a, b, ratio)
    return a + ratio * (b - a)
end

function onCreate()

	-- game over

	setPropertyFromClass('GameOverSubstate', 'characterName', 'ourplej8-dead'); -- your character's json file name
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'ourple-j8-loss'); -- sound to play when the death screen is triggered
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver-ourplej8'); -- song that will play during the death screen
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd-ourplej8'); --sound to play when you press the confirm button to retry
	
	-- fnaf world bg setup
	
	makeLuaSprite('sky', 'ourplej8backgrounds/sky', -300, -200);
	setScrollFactor('sky', 0.15, 0.15);
	setProperty('sky.antialiasing', false);
	
	makeLuaSprite('back', 'ourplej8backgrounds/back bg', -400, -100);
	setScrollFactor('back', 0.25, 0.25);
	setProperty('back.antialiasing', false);
	
	makeLuaSprite('midback', 'ourplej8backgrounds/mid back bg', -350, -50);
	setScrollFactor('midback', 0.425, 0.425);
	scaleObject('midfront', 1.1, 1);
	setProperty('midfront.antialiasing', false);
	
	makeLuaSprite('midfront', 'ourplej8backgrounds/mid front bg', -425, 250);
	setScrollFactor('midfront', 0.675, 0.675);
	scaleObject('midfront', 1.1, 1);
	setProperty('midfront.antialiasing', false);
	
	makeLuaSprite('front', 'ourplej8backgrounds/front bg', -600, 500);
	setScrollFactor('front', 0.9, 0.9);
	scaleObject('front', 1.5, 1.1);
	setProperty('front.antialiasing', false);

	makeAnimatedLuaSprite('objben', 'spr_ben', -100, 210);
	setScrollFactor('objben', 0.9, 0.9);
	addAnimationByPrefix('objben','bounce', 'ben',24,false);
	setProperty('objben.antialiasing', false);

	makeAnimatedLuaSprite('objdod', 'spr_dod', 200, 250);
	setScrollFactor('objdod', 0.9, 0.9);
	addAnimationByPrefix('objdod','bounce', 'dod',24,false);
	setProperty('objdod.antialiasing', false);

	makeAnimatedLuaSprite('objgold', 'spr_gold', goldInitX, goldInitY);
	setScrollFactor('objgold', 0.9, 0.9);
	setGraphicSize('objgold', 0.8, 0.8);
	addAnimationByPrefix('objgold','bounce', 'gold',24,false);
	setProperty('objgold.antialiasing', false);

	makeAnimatedLuaSprite('objragtime', 'spr_ragtime', 700, 380);
	setScrollFactor('objragtime', 0.9, 0.9);
	addAnimationByPrefix('objragtime','bounce', 'ragtime',24,false);
	setProperty('objragtime.antialiasing', false);

	makeAnimatedLuaSprite('objsherri', 'spr_sherri', 1000, 250);
	setScrollFactor('objsherri', 0.9, 0.9);
	addAnimationByPrefix('objsherri','bounce', 'sherri',24,false);
	setProperty('objsherri.antialiasing', false);

	makeAnimatedLuaSprite('objviba', 'spr_viba', 1400, 10);
	setScrollFactor('objviba', 0.9, 0.9);
	addAnimationByPrefix('objviba','bounce', 'viba',24,false);
	setProperty('objviba.antialiasing', false);
	
	-- fnaf world bg adds
	
	addLuaSprite('sky', false);
	addLuaSprite('back', false);
	addLuaSprite('midback', false);
	addLuaSprite('midfront', false);
	addLuaSprite('front', false);

	addLuaSprite('objben', false);
	addLuaSprite('objdod', false);
	addLuaSprite('objgold', false);
	addLuaSprite('objragtime', false);
	addLuaSprite('objsherri', false);
	addLuaSprite('objviba', false);
	
	-- fnaf pizza sim setup
	
	makeLuaSprite('pizzasimbg', 'ourplej8backgrounds/sim_bg', -550, -200);
	setScrollFactor('pizzasimbg', 0.85, 0.85);
	setProperty('pizzasimbg.antialiasing', false);
	scaleObject('pizzasimbg', 1.15, 1.15);
	
	makeLuaSprite('pizzasimfloor', 'ourplej8backgrounds/sim_floor', -2700, 650);
	setScrollFactor('pizzasimfloor', 0.9, 0.9);
	setProperty('pizzasimfloor.antialiasing', false);
	
	makeAnimatedLuaSprite('pizzasimpaperpals', 'ourplej8backgrounds/simpaperpals', -200, 100);
	setScrollFactor('pizzasimpaperpals', 0.85, 0.85);
	addAnimationByPrefix('pizzasimpaperpals','bounce', 'paperpals',24,false);
	setProperty('pizzasimpaperpals.antialiasing', false);
	
	makeAnimatedLuaSprite('lolbit', 'ourplej8backgrounds/tvlolbit', 1200, -300);
	setScrollFactor('lolbit', 0.875, 0.875);
	addAnimationByPrefix('lolbit','bounce', 'lolbit',24,false);
	setProperty('lolbit.antialiasing', false);
	
	makeAnimatedLuaSprite('balloonsleft', 'ourplej8backgrounds/balloons', -600, -200);
	setScrollFactor('balloonsleft', 0.9125, 0.9125);
	addAnimationByPrefix('balloonsleft','bounce', 'balloons',24,false);
	setProperty('balloonsleft.antialiasing', false);
	
	makeAnimatedLuaSprite('balloonsright', 'ourplej8backgrounds/balloons', 1700, -200);
	setScrollFactor('balloonsright', 0.9125, 0.9125);
	addAnimationByPrefix('balloonsright','bounce', 'balloons',24,false);
	setProperty('balloonsright.antialiasing', false);
	
	makeLuaSprite('pizzasimstage', 'ourplej8backgrounds/sim_stage', 180, 300);
	setScrollFactor('pizzasimstage', 0.925, 0.925);
	setProperty('pizzasimstage.antialiasing', false);
	
	makeAnimatedLuaSprite('speakerleft', 'ourplej8backgrounds/sim_speaker', -200, 300);
	setScrollFactor('speakerleft', 0.95, 0.95);
	addAnimationByPrefix('speakerleft','bounce', 'speakers',24,false);
	setProperty('speakerleft.antialiasing', false);
	
	makeAnimatedLuaSprite('speakerright', 'ourplej8backgrounds/sim_speaker', 1400, 300);
	setScrollFactor('speakerright', 0.95, 0.95);
	addAnimationByPrefix('speakerright','bounce', 'speakers',24,false);
	setProperty('speakerright.antialiasing', false);
	scaleObject('speakerright', -1, 1);
	
	makeAnimatedLuaSprite('objmetalgeneral', 'spr_metalgeneral', 880, -90);
	setScrollFactor('objmetalgeneral', 0.9125, 0.9125);
	addAnimationByPrefix('objmetalgeneral','bounce', 'metalgeneral',24,false);
	setProperty('objmetalgeneral.antialiasing', false);

	makeAnimatedLuaSprite('objsheepman', 'spr_sheepman', 380, -150);
	setScrollFactor('objsheepman', 0.9125, 0.925);
	addAnimationByPrefix('objsheepman','bounce', 'sheepman',24,false);
	setProperty('objsheepman.antialiasing', false);

	makeAnimatedLuaSprite('objmettatonex', 'spr_mettatonex', 580, -90);
	setScrollFactor('objmettatonex', 0.92, 0.92);
	addAnimationByPrefix('objmettatonex','bounce', 'mettatonex',24,false);
	setProperty('objmettatonex.antialiasing', false);

	makeAnimatedLuaSprite('objjaylung', 'spr_jaylung', 1750, 125);
	setScrollFactor('objjaylung', 0.92, 0.92);
	addAnimationByPrefix('objjaylung','bounce', 'jaylung',24,false);
	setProperty('objjaylung.antialiasing', false);

	makeAnimatedLuaSprite('objbroken', 'spr_broken', 1625, 400);
	setScrollFactor('objbroken', 0.92, 0.92);
	addAnimationByPrefix('objbroken','bounce', 'broken',24,false);
	setProperty('objbroken.antialiasing', false);

	makeAnimatedLuaSprite('objpuro', 'spr_puro', -625, 50);
	setScrollFactor('objpuro', 0.92, 0.92);
	addAnimationByPrefix('objpuro','bounce', 'puro', 24, false);
	setProperty('objpuro.antialiasing', false);

	makeAnimatedLuaSprite('objtheft', 'spr_theft', -400, 450);
	setScrollFactor('objtheft', 0.92, 0.92);
	addAnimationByPrefix('objtheft','bounce', 'theft',24,false);
	setProperty('objtheft.antialiasing', false);
	
	-- fnaf pizza sim adds
	
	addLuaSprite('pizzasimbg', false);
	addLuaSprite('pizzasimfloor', false);
	addLuaSprite('pizzasimpaperpals', false);
	addLuaSprite('lolbit', false);
	addLuaSprite('balloonsleft', false);
	addLuaSprite('balloonsright', false);
	addLuaSprite('objpuro', false);
	addLuaSprite('objtheft', false);
	addLuaSprite('objjaylung', false);
	addLuaSprite('pizzasimstage', false);
	addLuaSprite('speakerleft', false);
	addLuaSprite('speakerright', false);
	addLuaSprite('objbroken', false);
	addLuaSprite('objmetalgeneral', false);
	addLuaSprite('objsheepman', false);
	addLuaSprite('objmettatonex', false);
	
	-- ucn setup
	
	makeLuaSprite('ucnoffice', 'ourplej8backgrounds/ucn_office', -650, -250);
	setScrollFactor('ucnoffice', 0.925, 0.925);
	setProperty('ucnoffice.antialiasing', false);
	scaleObject('ucnoffice', 1.125, 1.125);
	
	makeLuaSprite('ucntable', 'ourplej8backgrounds/ucn_table', 300, 350);
	setScrollFactor('ucntable', 0.9325, 0.9325);
	setProperty('ucntable.antialiasing', false);
	scaleObject('ucntable', 1.125, 1.125);

	makeAnimatedLuaSprite('objcandycadet', 'spr_candycadet', 367, 215);
	setScrollFactor('objcandycadet', 0.92, 0.92);
	addAnimationByPrefix('objcandycadet','bounce', 'candycadet',24,false);
	setProperty('objcandycadet.antialiasing', false);

	makeAnimatedLuaSprite('objcoffee', 'spr_coffee', 700, 500);
	setScrollFactor('objcoffee', 0.92, 0.92);
	addAnimationByPrefix('objcoffee','bounce', 'coffee',24,false);
	setProperty('objcoffee.antialiasing', false);

	makeAnimatedLuaSprite('objcutmandy', 'spr_cutmandy', 900, 357);
	setScrollFactor('objcutmandy', 0.92, 0.92);
	addAnimationByPrefix('objcutmandy','bounce', 'cutmandy',24,false);
	setProperty('objcutmandy.antialiasing', false);

	makeAnimatedLuaSprite('objdguy', 'spr_dguy', -50, 275);
	setScrollFactor('objdguy', 0.92, 0.92);
	addAnimationByPrefix('objdguy','bounce', 'dguy',24,false);
	setProperty('objdguy.antialiasing', false);

	makeAnimatedLuaSprite('objfan', 'spr_fan', 853, 273);
	setScrollFactor('objfan', 0.92, 0.92);
	addAnimationByPrefix('objfan','bounce', 'fan',24,false);
	setProperty('objfan.antialiasing', false);

	makeAnimatedLuaSprite('objgamma', 'spr_gamma', 950, 175);
	setScrollFactor('objgamma', 0.92, 0.92);
	addAnimationByPrefix('objgamma','bounce', 'gamma',24,false);
	setProperty('objgamma.antialiasing', false);

	makeAnimatedLuaSprite('objironvaliant', 'spr_ironvaliant', 1250, 100);
	setScrollFactor('objironvaliant', 0.92, 0.92);
	addAnimationByPrefix('objironvaliant','bounce', 'ironvaliant',24,false);
	setProperty('objironvaliant.antialiasing', false);

	makeAnimatedLuaSprite('objjergeaul', 'spr_jergeaul', -100, 112);
	setScrollFactor('objjergeaul', 0.92, 0.92);
	addAnimationByPrefix('objjergeaul','bounce', 'jergeaul',24,false);
	setProperty('objjergeaul.antialiasing', false);

	makeAnimatedLuaSprite('objkerfluffle', 'spr_kerfluffle', 150, 195);
	setScrollFactor('objkerfluffle', 0.92, 0.92);
	addAnimationByPrefix('objkerfluffle','bounce', 'kerfluffle',24,false);
	setProperty('objkerfluffle.antialiasing', false);

	makeAnimatedLuaSprite('objkoi', 'spr_koi', 1375, 500);
	setScrollFactor('objkoi', 0.92, 0.92);
	addAnimationByPrefix('objkoi','bounce', 'koi',24,false);
	setProperty('objkoi.antialiasing', false);

	makeAnimatedLuaSprite('objnikku', 'spr_nikku', 575, -125);
	setScrollFactor('objnikku', 0.92, 0.92);
	addAnimationByPrefix('objnikku','bounce', 'nikku',24,false);
	setProperty('objnikku.antialiasing', false);

	makeAnimatedLuaSprite('objpink', 'spr_pink', -150, 525);
	setScrollFactor('objpink', 0.92, 0.92);
	addAnimationByPrefix('objpink','bounce', 'pink',24,false);
	setProperty('objpink.antialiasing', false);

	makeAnimatedLuaSprite('objrory', 'spr_rory', 300, 310);
	setScrollFactor('objrory', 0.92, 0.92);
	addAnimationByPrefix('objrory','bounce', 'rory',24,false);
	setProperty('objrory.antialiasing', false);

	makeAnimatedLuaSprite('objsandwoman', 'spr_sandwoman', 0, 275);
	setScrollFactor('objsandwoman', 0.92, 0.92);
	addAnimationByPrefix('objsandwoman','bounce', 'sandwoman',24,false);
	setProperty('objsandwoman.antialiasing', false);

	makeAnimatedLuaSprite('objsenpai', 'spr_senpai', 850, 275);
	setScrollFactor('objsenpai', 0.92, 0.92);
	addAnimationByPrefix('objsenpai','bounce', 'senpai',24,false);
	setProperty('objsenpai.antialiasing', false);

	makeAnimatedLuaSprite('objtoychica', 'spr_toychica', -300, 425);
	setScrollFactor('objtoychica', 0.92, 0.92);
	addAnimationByPrefix('objtoychica','bounce', 'toychica',24,false);
	setProperty('objtoychica.antialiasing', false);

	makeAnimatedLuaSprite('objtronbonne', 'spr_tronbonne', 1525, 375);
	setScrollFactor('objtronbonne', 0.92, 0.92);
	addAnimationByPrefix('objtronbonne','bounce', 'tronbonne',24,false);
	setProperty('objtronbonne.antialiasing', false);

	makeAnimatedLuaSprite('objuhyeah', 'spr_uhyeah', 550, 412);
	setScrollFactor('objuhyeah', 0.92, 0.92);
	addAnimationByPrefix('objuhyeah','bounce', 'uhyeah',24,false);
	setProperty('objuhyeah.antialiasing', false);

	makeAnimatedLuaSprite('objvideoman', 'spr_videoman', 650, 300);
	setScrollFactor('objvideoman', 0.92, 0.92);
	addAnimationByPrefix('objvideoman','bounce', 'videoman',24,false);
	setProperty('objvideoman.antialiasing', false);

	makeAnimatedLuaSprite('objzero', 'spr_zero', 1250, 500);
	setScrollFactor('objzero', 0.92, 0.92);
	addAnimationByPrefix('objzero','bounce', 'zero',24,false);
	setProperty('objzero.antialiasing', false);

	-- ucn adds

	addLuaSprite('ucnoffice', false);
	addLuaSprite('objironvaliant', false);
	addLuaSprite('ucntable', false);
	addLuaSprite('objjergeaul', false);
	addLuaSprite('objfan', false);
	addLuaSprite('objnikku', false);
	addLuaSprite('objgamma', false);
	addLuaSprite('objzero', false);
	addLuaSprite('objdguy', false);
	addLuaSprite('objcandycadet', false);
	addLuaSprite('objsenpai', false);
	addLuaSprite('objkerfluffle', false);
	addLuaSprite('objvideoman', false);
	addLuaSprite('objrory', false);
	addLuaSprite('objsandwoman', false);
	addLuaSprite('objcutmandy', false);
	addLuaSprite('objcoffee', false);
	addLuaSprite('objuhyeah', false);
	addLuaSprite('objpink', false);
	addLuaSprite('objtronbonne', false);
	addLuaSprite('objkoi', false);
	addLuaSprite('objtoychica', false);

	math.randomseed(os.time());
	if (everybody == false) then
		local num = 2;
		while num < (#ucnelements)/2 do

			local rand = math.random(3, #ucnelements);
			if (getProperty(ucnelements[rand]..'.alpha') ~= 0) then
				setProperty(ucnelements[rand]..'.alpha', 0);
				num = num + 1;
			end;

		end;
	end;
	
	-- other stuff
	
	makeLuaSprite('flash', 'ourplej8backgrounds/flash', -1000, -1000);
	setScrollFactor('flash', 0.01, 0.01);
	scaleObject('flash', 2, 2);
	setProperty('flash.alpha', 0);
	
	makeLuaSprite('dark', 'ourplej8backgrounds/dark', -1000, -1000);
	setScrollFactor('dark', 0.01, 0.01);
	scaleObject('dark', 2, 2);
	setProperty('dark.alpha', 0);
	
	addLuaSprite('flash', false);
	addLuaSprite('dark', false);
	
end

function onCreatePost()

	for i=0, 7 do
		setPropertyFromGroup('unspawnNotes', i, 'alpha', 1);
		setPropertyFromGroup('strumLineNotes', i, 'alpha', 1);
		setPropertyFromGroup('unspawnNotes', i, 'antialiasing', false);
		setPropertyFromGroup('strumLineNotes', i, 'antialiasing', false);
	end;
	
	setProperty('gf.visible', false);

	setProperty('iconP1.antialiasing', false);
	setProperty('iconP2.antialiasing', false);
	
    -- code help by Aizakku

    setTextFont('scoreTxt', font);
    setTextFont('botplayTxt', font);
    setTextFont('timeTxt', font);
    
    setTextSize('scoreTxt', 24);
    setTextSize('botplayTxt',32);
    setTextSize('timeTxt', 24);
    
    setProperty('timeTxt.y', getProperty('timeBar.y') - 14);     
	setProperty('scoreTxt.y', getProperty('scoreTxt.y') + 14);

	-- code help by gavman
    makeLuaSprite('countdownThree', 'ourple_onyourmarks', 0, 0)
    setObjectCamera('countdownThree', 'hud')
    setProperty('countdownThree.antialiasing', false)
    screenCenter('countdownThree')
    addLuaSprite('countdownThree', true)
    setProperty('countdownThree.visible', false)

    setProperty('countdownReady.antialiasing', false)
    setProperty('countdownSet.antialiasing', false)
    setProperty('countdownGo.antialiasing', false)
	
	setProperty('introSoundsSuffix', '-ourple')

	setProperty('ratingsData[0].image', 'ourple_sick');
	setProperty('ratingsData[1].image', 'ourple_good');
	setProperty('ratingsData[2].image', 'ourple_bad');
	setProperty('ratingsData[3].image', 'ourple_shit');

	-- thanks betty on discord
	setProperty('showComboNum', false)

	
end

function onCountdownTick(tick)

	-- code help by gavman
    if tick == 0 then
        setProperty('countdownThree.visible', true)
        doTweenAlpha('countdownThreeAlpha', 'countdownThree', 0, crochet / 1000, 'cubeInOut')
    elseif tick == 1 then
        loadGraphic('countdownReady', 'ourple_ready')
		screenCenter('countdownReady')
    elseif tick == 2 then
        loadGraphic('countdownSet', 'ourple_set')
		screenCenter('countdownSet')
    elseif tick == 3 then
        loadGraphic('countdownGo', 'ourple_go')
		screenCenter('countdownGo')
    end

end

function onBeatHit()

	if curBeat % 1 == 0 then
	
		if isZooming == false then
	
			if curBeat % 4 == 0  then
			
				oldCamZoom = getProperty("camGame.zoom");
				setProperty("camGame.zoom", getProperty("camGame.zoom") * camZoomBI * 1.05);
				doTweenZoom("beatzoom", "camGame", oldCamZoom, 0.325, 'quartOut');
			
			else
			
				oldCamZoom = getProperty("camGame.zoom");
				setProperty("camGame.zoom", getProperty("camGame.zoom") * camZoomBI);
				doTweenZoom("beatzoom", "camGame", oldCamZoom, 0.325, 'quartOut');
			
			end
		
		end
		
		local cameraAngle = camAngleBI * (1 - 2*(curBeat % 2));
		setProperty("camGame.angle", cameraAngle);
		doTweenAngle("beatangle", "camGame", 0, 0.325, 'quartOut');
	
		objectPlayAnimation('objben', 'bounce', true);
		objectPlayAnimation('objdod', 'bounce', true);
		--objectPlayAnimation('objgold', 'bounce', true);
		objectPlayAnimation('objragtime', 'bounce', true);
		objectPlayAnimation('objsherri', 'bounce', true);
		objectPlayAnimation('objviba', 'bounce', true);
		
		objectPlayAnimation('speakerleft', 'bounce', true);
		objectPlayAnimation('speakerright', 'bounce', true);
		objectPlayAnimation('balloonsleft', 'bounce', true);
		objectPlayAnimation('balloonsright', 'bounce', true);
		objectPlayAnimation('pizzasimpaperpals', 'bounce', true);
		objectPlayAnimation('lolbit', 'bounce', true);
		objectPlayAnimation('objmetalgeneral', 'bounce', true);
		objectPlayAnimation('objsheepman', 'bounce', true);
		objectPlayAnimation('objmettatonex', 'bounce', true);

		objectPlayAnimation('speakerleft', 'bounce', true);
		objectPlayAnimation('speakerright', 'bounce', true);
		objectPlayAnimation('balloonsleft', 'bounce', true);
		objectPlayAnimation('balloonsright', 'bounce', true);
		objectPlayAnimation('pizzasimpaperpals', 'bounce', true);
		objectPlayAnimation('lolbit', 'bounce', true);
		objectPlayAnimation('objmetalgeneral', 'bounce', true);
		objectPlayAnimation('objsheepman', 'bounce', true);
		objectPlayAnimation('objmettatonex', 'bounce', true);

		objectPlayAnimation('objbroken','bounce', true);
		objectPlayAnimation('objcandycadet','bounce', true);
		objectPlayAnimation('objcoffee','bounce', true);
		objectPlayAnimation('objcutmandy','bounce', true);
		objectPlayAnimation('objdguy','bounce', true);
		objectPlayAnimation('objfan','bounce', true);
		objectPlayAnimation('objgamma','bounce', true);
		objectPlayAnimation('objironvaliant','bounce', true);
		objectPlayAnimation('objjaylung','bounce', true);
		objectPlayAnimation('objjergeaul','bounce', true);
		objectPlayAnimation('objkerfluffle','bounce', true);
		objectPlayAnimation('objkoi','bounce', true);
		objectPlayAnimation('objnikku','bounce', true);
		objectPlayAnimation('objpink','bounce', true);
		objectPlayAnimation('objpuro','bounce', true);
		objectPlayAnimation('objragtime','bounce', true);
		objectPlayAnimation('objrory','bounce', true);
		objectPlayAnimation('objsandwoman','bounce', true);
		objectPlayAnimation('objsenpai','bounce', true);
		objectPlayAnimation('objsherri','bounce', true);
		objectPlayAnimation('objtheft','bounce', true);
		objectPlayAnimation('objtoychica','bounce', true);
		objectPlayAnimation('objtronbonne','bounce', true);
		objectPlayAnimation('objuhyeah','bounce', true);
		objectPlayAnimation('objvideoman','bounce', true);
		objectPlayAnimation('objzero', 'bounce', true);
	end

	if curBeat % 2 == 1 then

	    goldShakeTimer = goldShakeTime;

	end

end

function onUpdate()

	-- misc

	if goldShakeTimer > 0 then
		goldShakeTimer = goldShakeTimer - 1;
	else
		goldShakeTimer = 0;
	end;

	goldFloatY = math.sin(getSongPosition()/1000) * 10.0;
	setProperty("objgold.x", goldInitX + math.cos(math.rad(math.random(0, 360)) )*lerp(0, goldShakeForce, (goldShakeTimer/goldShakeTime)));
	setProperty("objgold.y", goldInitY - math.sin(math.rad(math.random(0, 360)) )*lerp(0, goldShakeForce, (goldShakeTimer/goldShakeTime)) + goldFloatY );

	nikkuFloatY = math.sin(getSongPosition()/750 + 100) * 20.0;
	setProperty("objnikku.y", nikkuInitY + nikkuFloatY );

	for i = 0, getProperty('unspawnNotes.length')-1 do
        splashName = getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture')
    end
    -- Prints offsets cause I was gonna not do it like this before but then I realized the for statement was not in onUpdate so...
    --printOffsets('noteSplashes')

    -- Offsets obv :rolling_eyes:
    splashesOffset('ourple_guy_splashes', -64, -64)
    -- Array support cause why not... sets offsets to multiple

end

function onUpdatePost()
	-- code help by Aizakku    

    scoreText = 'how ourple you are: ' .. score .. ' | Misses: ' .. misses .. ' | Rating: ' .. ratingName;
    ratingPercentText = ' (' .. math.floor(getProperty('ratingPercent') * 10000) * 0.01 .. '%)' .. ' - ' .. ratingFC;
    
    if ratingName == '?' then
        setTextString('scoreTxt', scoreText);
    else
        setTextString('scoreTxt', scoreText.. ratingPercentText);
    end
	
	setProperty("camZooming",false);
	
	-- set visibles
	
	if bgphase == 0 then
	
		-- only fnaf world stuff visible
		for i, v in ipairs(worldelements) do
			setProperty(v .. '.visible', true);
			setProperty(v .. '.alpha', 1);
		end
		for i, v in ipairs(pizzaelements) do
			setProperty(v .. '.visible', false);
		end
		for i, v in ipairs(ucnelements) do
			setProperty(v .. '.visible', false);
		end
		--setProperty('sky.visible', false);
	
	elseif bgphase == 1 then
	
		for i, v in ipairs(worldelements) do
			setProperty(v .. '.visible', false);
		end
	
		for i, v in ipairs(pizzaelements) do
			setProperty(v .. '.visible', true);
			setProperty(v .. '.alpha', 1);
		end
		for i, v in ipairs(ucnelements) do
			setProperty(v .. '.visible', false);
		end
		-- only pizza sim stuff visible
	
	elseif bgphase == 2 then
	
		for i, v in ipairs(worldelements) do
			setProperty(v .. '.visible', false);
		end
		for i, v in ipairs(pizzaelements) do
			setProperty(v .. '.visible', false);
		end
		for i, v in ipairs(ucnelements) do
			setProperty(v .. '.visible', true);
		end
		-- only :p stuff visible
		
	else
	
		for i, v in ipairs(worldelements) do
			setProperty(v .. '.visible', false);
		end
		for i, v in ipairs(pizzaelements) do
			setProperty(v .. '.visible', false);
		end
		for i, v in ipairs(ucnelements) do
			setProperty(v .. '.visible', false);
		end
		-- black bg
	
	end;
	
end

function onEvent(name, value1, value2)

	if name == "SceneChangeEvent" then
	
		bgphase = tonumber(value1);
		
	elseif name == "CameraTweenZoom" then
	
		doTweenZoom("eventzoom", "camGame", value1, value2, 'quartOut');
		isZooming = true;
		
	elseif name == "CameraMotionIntensity" then
	
		camZoomBI = value1;
		camAngleBI = value2;
		
	elseif name == "FadeToBlack" then
	
		if (tonumber(value1) > 0) then
	
			doTweenAlpha('darktween', 'dark', 1, value1, 'linear');
				
		else
		
			setProperty('dark.alpha', 0);
		
		end
		
	elseif name == "FlashWhite" then
		
		setProperty('flash.alpha', 1);
		doTweenAlpha('flashtween', 'flash', 0, value1, 'linear');
	
	end

end

function onTweenCompleted(name)

	if (name == "eventzoom") then
	
		isZooming = false;
		
	end
	
end

-- thanks betty for custom combo numbers

local theuhhthing = 2
local fuck = 0
function goodNoteHit(id, direction, noteType, isSustainNote)
	if not isSustainNote and not hideHud then
		fuck = fuck + 1
	    if getProperty('combo') > 999 then
	    	theuhhthing = #tostring(getProperty('combo')) - 1
	    end
		makeComboNumSprites('comboDigit', getProperty('combo'), getPropertyFromClass('ClientPrefs', 'comboOffset[2]'), getPropertyFromClass('ClientPrefs', 'comboOffset[3]'))
	end
end
function makeComboNumSprites(spriteTag, value, xAdd, yAdd)
	theuhhthing = #tostring(value) - 1
	if theuhhthing < 2 then
		theuhhthing = 2
	end
	local numsToDisplay = theuhhthing
	for i = numsToDisplay, 0, -1 do
		local tag = spriteTag..i
		if getPropertyFromClass('ClientPrefs', 'comboStacking') then
			tag = spriteTag..i..'-'..fuck -- dont know if that works but whatever
		end
		local aeaeae = numsToDisplay - 2
		if aeaeae < 0 then
			aeaeae = 0
		end
		-- general sprite
		local coolTextX = screenWidth * 0.35
		makeLuaSprite(tag, 'ourple_num'..math.floor(value / 10 ^ i % 10), 0, 0)
		setObjectCamera(tag,'hud')
		screenCenter(tag)
		setProperty(tag..'.x', coolTextX + (43 * (-i + aeaeae)))
		setProperty(tag..'.y', getProperty(tag..'.y') + 80)
		setProperty(tag..'.x', getProperty(tag..'.x') + xAdd)
		setProperty(tag..'.y', getProperty(tag..'.y') - yAdd)
		runTimer(tag..',timer', (crochet * 0.002) / playbackRate)
		setScrollFactor(tag, 1, 1)
		scaleObject(tag, 0.5, 0.5)
		updateHitbox(tag)
		addLuaSprite(tag, true)
		setObjectOrder(tag, getObjectOrder('strumLineNotes') - 1)
		setProperty(tag..'.acceleration.y', 200 * playbackRate * playbackRate)
		setProperty(tag..'.velocity.y', -100 * playbackRate)
		setProperty(tag..'.velocity.x', 0.0 * playbackRate)
	end
end
function onTimerCompleted(tag) -- script by: Stilic#5989
	for i = 0, theuhhthing do
		if stringStartsWith(tag, 'comboDigit'..i) then
    	    -- funni split moment
    	    local leObj = stringSplit(tag, ',')[1]
			doTweenAlpha(leObj .. ',tween', leObj, 0, 0.2 / playbackRate, 'linear')
    	end
	end
end


-- once again by by me ImaginationSuperHero52806
function splashesOffset(textureName, x, y)
    -- Null Check
    x, y = ((x == '' or x == nil) and 10 or x), ((y == '' or y == nil) and 10 or y)
    
    -- :)
    for i = 0, getProperty('grpNoteSplashes.length')-1 do
        for ii = 1, #textureName do
            if splashName == (type(textureName) == 'string' and textureName or type(textureName) == 'table' and textureName[ii]) then
                setPropertyFromGroup('grpNoteSplashes', i, 'offset.x', x)
                setPropertyFromGroup('grpNoteSplashes', i, 'offset.y', y)
            end
        end
    end
end
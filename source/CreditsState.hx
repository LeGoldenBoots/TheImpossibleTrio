package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		//trace("finding mod shit");
		for (folder in Paths.getModDirectories())
		{
			var creditsFile:String = Paths.mods(folder + '/data/credits.txt');
			if (FileSystem.exists(creditsFile))
			{
				var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
				for(i in firstarray)
				{
					var arr:Array<String> = i.replace('\\n', '\n').split("::");
					if(arr.length >= 5) arr.push(folder);
					creditsStuff.push(arr);
				}
				creditsStuff.push(['']);
			}
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['The Impossible Trio Team'],
			['LeGoldenBoots',		'legoldenboots',	'Main Programmer',					'https://www.youtube.com/channel/UCysojweWJ_X3iaTAMAvNFCQ',	'E53778'],
			['fidget boii',			'fidget',			'Assistant Programmer',				'https://www.youtube.com/channel/UCknRWVWQvDHf8RXXiuzAN3A',	'0BFF00'],
			['kyso',				'kyso',			'Main Charter',						'https://www.youtube.com/channel/UCPfz7f4ecd_gLhfx7Uy2Sew/featured',		'FF0BFF00'],
			['WizardMantis',		'mantis',			'AGONY & Survival (TPTF) Charter',	'https://www.youtube.com/c/WizardMantis441',		'0BFF00'],
			[''],
			['Mashup Creators and Musicians'],
			['rapparep lol',	'rap',				'The Impossible Trio Mashup Creator',			'https://www.youtube.com/c/rappareplol',		'0BFF00'],
			['ZellersGord',		'zellers',			'Survival Mashup Creator',						'https://www.youtube.com/channel/UCBt17RPvXOBQTn7u82Ip1Hw',		'0BFF00'],
			['Aussie Axe',		'aussieaxe',		'AGONY Mashup Creator',							'https://www.youtube.com/channel/UCBt17RPvXOBQTn7u82Ip1Hw',		'0BFF00'],
			['That Pizza Tower Fan',	'tptf',		'Survival TPTF Composer',				'https://www.youtube.com/channel/UC7-0Iemmc842O6HYtVYl7MQ',		'0BFF00'],
			['Gilbert de Guzman',	'gdg',			'Not Impossible Mashup Creator',			'https://www.youtube.com/channel/UC9IzRYupvv6K-XOl24G9uXA',		'0BFF00'],
			['Pap7Swag45',	'pap',					'The Swapped Trio Mashup Creator',			'https://www.youtube.com/channel/UCMuLDoH6hRY5orCLvFUCpag',		'0BFF00'],
			['Mods Featured'],
			['Vs. Bob',					'bob',					'Press Enter to Go to the Mods page!',			'https://gamebanana.com/mods/285296',		'0BFF00'],
			['Vs. Spong',				'spong',				'Press Enter to Go to the Mods page!',			'https://twitter.com/bmv277/status/1461877047169626118',		'0BFF00'],
			['Vs. Dave and Bambi',		'daveandbambers',		'Press Enter to Go to the Mods page!',			'https://gamebanana.com/mods/43201',		'0BFF00'],
			['Vs. Ron',					'ron',					'Press Enter to Go to the Mods page!',			'https://gamebanana.com/mods/309980',		'0BFF00'],
			['Vs. Hex',					'hex',					'Press Enter to Go to the Mods page!',			'https://gamebanana.com/mods/44225',		'0BFF00'],
			['Bikini Bottom Funkin',	'spongebob',			'Press Enter to Go to the Mods page!',			'https://gamebanana.com/mods/314145',		'0BFF00'],
			['Vs. Garcello',			'garcello',				'Press Enter to Go to the Mods page!',			'https://gamebanana.com/mods/166531',		'0BFF00'],
			['Vs. Bob and Bosip',		'bobbosip',				'Press Enter to Go to the Mods page!',			'https://drive.google.com/file/d/1zKeHKtsVx1pdG4UDK3RSnTNRIVyP9WSm/view',		'FF0BFF00'],
			[''],
			['Psych Engine Team'],
			['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',						'https://twitter.com/Shadow_Mario_',	'FFDD33'],
			['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',					'https://twitter.com/river_oaken',		'C30085'],
			['bb-panzu',			'bb-panzu',			'Additional Programmer of Psych Engine',				'https://twitter.com/bbsub3',			'389A58'],
			[''],
			['Engine Contributors'],
			['shubs',				'shubs',			'New Input System Programmer',							'https://twitter.com/yoshubs',			'4494E6'],
			['SqirraRNG',			'gedehari',			'Chart Editor\'s Sound Waveform base',					'https://twitter.com/gedehari',			'FF9300'],
			['iFlicky',				'iflicky',			'Delay/Combo Menu Song Composer\nand Dialogue Sounds',	'https://twitter.com/flicky_i',			'C549DB'],
			['PolybiusProxy',		'polybiusproxy',	'.MP4 Video Loader Extension',							'https://twitter.com/polybiusproxy',	'FFEAA6'],
			['Keoiki',				'keoiki',			'Note Splash Animations',								'https://twitter.com/Keoiki_',			'FFFFFF'],
			[''],
			["Funkin' Crew"],
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",					'https://twitter.com/ninja_muffin99',	'F73838'],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",						'https://twitter.com/PhantomArcade3K',	'FFBB1B'],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",						'https://twitter.com/evilsk8r',			'53E52C'],
			['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",						'https://twitter.com/kawaisprite',		'6475F3']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
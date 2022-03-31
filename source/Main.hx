package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
#if android //only android will use those
import sys.FileSystem;
import lime.app.Application;
import lime.system.System;
import android.*;
#end

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;

	#if android//the things android uses  
        private static var androidDir:String = null;
        private static var storagePath:String = AndroidTools.getExternalStorageDirectory();  
        #end

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

        static public function getDataPath():String
        {
        	#if android
                if (androidDir != null && androidDir.length > 0) 
                {
                        return androidDir;
                } 
                else 
                { 
                        androidDir = storagePath + "/" + Application.current.meta.get("packageName") + "/files/";
                }
                return androidDir;
                #else
                return "";
	        #end
        }

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

                #if android
                if (AndroidTools.getSDKversion() > 23 || AndroidTools.getSDKversion() == 23) {
		    AndroidTools.requestPermissions([Permissions.READ_EXTERNAL_STORAGE, Permissions.WRITE_EXTERNAL_STORAGE]);
		}  

                var grantedPermsList:Array<Permissions> = AndroidTools.getGrantedPermissions();    

                if (!grantedPermsList.contains(Permissions.READ_EXTERNAL_STORAGE) || !grantedPermsList.contains(Permissions.WRITE_EXTERNAL_STORAGE)) {
                	if (AndroidTools.getSDKversion() > 23 || AndroidTools.getSDKversion() == 23) {
                        	Application.current.window.alert("If you accepted the permisions for storage good, you can continue, if you not the game can't run without storage permissions please grant them in app settings" + "\n" + "Press Ok To Close The App","Permissions");
                                System.exit(0);//Will close the game
		        } else {
                        	Application.current.window.alert("game can't run without storage permissions please grant them in app settings" + "\n" + "Press Ok To Close The App","Permissions");
                                System.exit(0);//Will close the game
		        }
                }
                else
                {
                        if (!FileSystem.exists(storagePath + "/" + Application.current.meta.get("packageName"))) {
                                FileSystem.createDirectory(storagePath + "/" + Application.current.meta.get("packageName"));
                        } 
                        if (!FileSystem.exists(storagePath + "/" + Application.current.meta.get("packageName") + '/files')) {
                                FileSystem.createDirectory(storagePath + "/" + Application.current.meta.get("packageName") + '/files');
                        }
                        if (!FileSystem.exists(Main.getDataPath() + "assets")) {
                                Application.current.window.alert("Try copying assets/assets from apk to" + Application.current.meta.get("packageName") + " In your internal storage" + "\n" + "Press Ok To Close The App", "Instructions");
                                System.exit(0);//Will close the game
                        }
                        if (!FileSystem.exists(Main.getDataPath() + "mods")) {
                                Application.current.window.alert("Try copying assets/mods from apk to " + Application.current.meta.get("packageName") + " In your internal storage" + "\n" + "Press Ok To Close The App", "Instructions");
                                System.exit(0);//Will close the game
                        }
                }
                #end

		ClientPrefs.loadDefaultKeys();
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}
}

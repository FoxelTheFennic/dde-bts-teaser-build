package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxSound;

class Titlescreen extends FlxState
{
	var button:FlxSprite = new FlxSprite(0, 200);

	override public function create()
	{
		super.create();

		FlxG.sound.playMusic("assets/music/216.ogg", 1, true);

		FlxG.autoPause = false;

		var bg:FlxSprite = new FlxSprite(0, 0);
		bg.loadGraphic("assets/images/farmland.png");
		bg.updateHitbox();
		bg.antialiasing = true;
		add(bg);

		button.frames = FlxAtlasFrames.fromSparrow("assets/images/Main Menu.png", 'assets/images/Main Menu.xml');
		button.animation.addByPrefix('Play', "Play" + '0', 30);
		button.animation.addByPrefix('Play Press', "Play Press" + '0', 30);
		button.animation.play('Play');
		// button.setGraphicSize(Std.int(button.width * 0.25));
		button.updateHitbox();
		button.antialiasing = true;
		button.screenCenter(X);
		add(button);

		var text:FlxSprite = new FlxSprite(-25, 1);
		text.frames = FlxAtlasFrames.fromSparrow("assets/images/Main Menu.png", 'assets/images/Main Menu.xml');
		text.animation.addByPrefix('Text', "Text", 30);
		text.animation.addByPrefix('Text', "Text", 30);
		text.animation.play('Text');
		// button.setGraphicSize(Std.int(button.width * 0.25));
		text.updateHitbox();
		text.antialiasing = true;
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if ((FlxG.mouse.justPressed) && FlxG.mouse.overlaps(button))
		{
			// FlxG.sound.music.stop();
			FlxG.switchState(new PlayState());
		}

		if (FlxG.mouse.overlaps(button))
			button.animation.play('Play Press');
		else
			button.animation.play('Play');
	}
}

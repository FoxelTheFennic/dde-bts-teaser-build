package;

import PlayState;
import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Lose extends FlxState
{
	var scoreText:FlxText;

	override public function create()
	{
		super.create();

		FlxG.autoPause = false;
		FlxG.mouse.visible = false;

		scoreText = new FlxText(1, 1, 0, "Your final score is: " + PlayState.score + "!", 34);
		scoreText.screenCenter(X);
		scoreText.y = 480 + 40;
		add(scoreText);

		var timer = new haxe.Timer(50);
		timer.run = function()
		{
			FlxTween.tween(scoreText, {y: 480 / 2 - 20}, 1, {ease: FlxEase.backOut});
		}

		var bg:FlxSprite = new FlxSprite(0, 0);
		bg.loadGraphic("assets/images/fuck you.png");
		bg.updateHitbox();
		bg.screenCenter(XY);
		bg.visible = false;
		add(bg);

		var timer = new haxe.Timer(1500); // 10ms delay
		timer.run = function()
		{
			bg.visible = true;
			FlxG.sound.play("assets/sounds/YOU SUCK.ogg");
			getReadyToDIE();
		}
		timer.stop;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function getReadyToDIE()
	{
		var timer = new haxe.Timer(1598); // 10ms delay
		timer.run = function()
		{
			System.exit(0);
		}
		timer.stop;
	}
}

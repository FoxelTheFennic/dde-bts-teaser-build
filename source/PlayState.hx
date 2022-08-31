package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import openfl.display.Sprite;

class PlayState extends FlxState
{
	var elapsedtime:Float = 0;
	var bambi:FlxSprite = new FlxSprite(0, FlxG.height);
	var corn:FlxTypedGroup<FlxSprite>;
	var lives:Int = 3;
	var livesCount:FlxText;
	var scoreCount:FlxText;
	var timerCounter:Float = 0;
	var miliseconds:Float = 800;
	var purpleOverlay:FlxSprite;

	public static var score:Int = 0;

	// window shit
	var windowshell:FlxSprite;
	var xVal = 0;
	var yVal = 0;
	var ogXVal:Float = 0;
	var ogYVal:Float = 0;
	var shmooveamount:Float = 0;

	override public function create()
	{
		super.create();
		windowshell = new FlxSprite(Lib.application.window.x, Lib.application.window.y);
		ogXVal = Lib.application.window.x;
		ogYVal = Lib.application.window.y;
		if (FlxG.sound.music == null) // don't restart the music if it's already playing
		{
			FlxG.sound.playMusic("assets/music/im_gonna_Sc.ogg", 1, true);

			var bg:FlxSprite = new FlxSprite(0, 0);
			bg.loadGraphic("assets/images/farmland.png");
			bg.updateHitbox();
			bg.antialiasing = true;
			add(bg);

			bambi.frames = FlxAtlasFrames.fromSparrow("assets/images/bambi.png", 'assets/images/bambi.xml');
			bambi.animation.addByPrefix('idle', "idle", 24);
			bambi.animation.play('idle');
			bambi.setGraphicSize(Std.int(bambi.width * 0.25));
			bambi.updateHitbox();
			bambi.antialiasing = true;
			add(bambi);

			FlxG.autoPause = false;
			FlxG.mouse.visible = false;

			livesCount = new FlxText(1, 1, 0, "Lives: 0", 24);
			add(livesCount);

			scoreCount = new FlxText(400, 1, 0, "Score: 0", 24);
			scoreCount.alignment = FlxTextAlign.RIGHT;
			scoreCount.screenCenter(X);
			add(scoreCount);

			corn = new FlxTypedGroup<FlxSprite>();
			add(corn);

			purpleOverlay = new FlxSprite().makeGraphic(640, 480, 0xFF981E9C);
			purpleOverlay.alpha = 0;
			add(purpleOverlay);

			makeCorn();
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		elapsedtime += elapsed;
		timerCounter += elapsedtime;

		if (lives == 0 || lives < 0)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new Lose());
		}

		if (purpleOverlay != null)
			purpleOverlay.alpha -= 0.005;

		if (timerCounter > miliseconds)
		{
			makeCorn();
			miliseconds -= 0.0001;
			timerCounter = 0;
		}

		scoreCount.x += (Math.sin(elapsedtime));

		bambi.x = FlxG.mouse.x - bambi.width / 2;
		bambi.y = FlxG.mouse.y - bambi.height / 2;

		score++;

		livesCount.text = "Lives: " + lives;
		scoreCount.text = "Score: " + score;
		corn.forEach(function(spr:FlxSprite)
		{
			if (spr.active)
			{
				spr.y += 5;
				if (FlxG.overlap(bambi, spr))
				{
					switch spr.animation.curAnim.name
					{
						case "corn":
							score += 469;
							FlxG.sound.play("assets/sounds/corn.ogg");
							spr.active = false;
							spr.destroy();
						case "distortcorn":
							shmooveamount += 0.1;
							purpleOverlay.alpha = 1;
							score -= 50;
							FlxG.sound.play("assets/sounds/splooge.ogg");
							spr.active = false;
							spr.destroy();
						case "heart":
							lives++;
							score += 2269;
							FlxG.sound.play("assets/sounds/heal.ogg");
							spr.active = false;
							spr.destroy();
						case "reset":
							score += 4269;
							purpleOverlay.alpha = 0;
							shmooveamount = 0;
							FlxG.sound.play("assets/sounds/rewind.ogg");
							FlxTween.tween(windowshell, {x: ogXVal, y: ogYVal}, 0.5, {ease: FlxEase.backOut});
							spr.active = false;
							spr.destroy();
						case "mine":
							lives--;
							score -= 1269;
							FlxG.sound.play("assets/sounds/mine.ogg");
							spr.active = false;
							spr.destroy();
					}
				}
				if (spr.y > 480)
				{
					switch spr.animation.curAnim.name
					{
						case "corn":
							lives -= 1;
					}

					spr.y = 0;
					spr.destroy();
					spr.active = false;
				}
			}
		});

		// windows shitistit
		yVal = Std.int(windowshell.y);
		xVal = Std.int(windowshell.x);
		Lib.application.window.move(xVal, yVal);
		windowshell.x += Math.sin(elapsedtime) * shmooveamount;
		windowshell.y += Math.sin(elapsedtime * shmooveamount) * shmooveamount;
	}

	function makeCorn()
	{
		var tex = FlxAtlasFrames.fromSparrow("assets/images/cornshit.png", 'assets/images/cornshit.xml');
		var projectile:FlxSprite = new FlxSprite(0, 0);
		projectile.frames = tex;
		projectile.animation.addByPrefix('corn', 'corn', 30);
		projectile.animation.addByPrefix('distortcorn', 'distortcorn', 30);
		projectile.animation.addByPrefix('heart', 'heart', 30);
		projectile.animation.addByPrefix('reset', 'reset', 30);
		projectile.animation.addByPrefix('mine', 'mine', 30);

		if (Std.random(4) == 1)
			projectile.animation.play('distortcorn');
		else if (Std.random(25) == 1)
			projectile.animation.play('mine');
		else if (Std.random(40) == 1)
			projectile.animation.play('heart');
		else if (Std.random(60) == 1)
			projectile.animation.play('reset');
		else
			projectile.animation.play('corn');

		corn.add(projectile);
		projectile.scrollFactor.set();
		projectile.antialiasing = true;
		projectile.setGraphicSize(Std.int(projectile.width * 0.2));
		projectile.updateHitbox();
		projectile.x = (Std.random(Std.int(640 - projectile.width)));
		projectile.y -= projectile.height;
	}
}

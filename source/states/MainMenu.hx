package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

class MainMenu extends FlxState
{
	var clouds:FlxGroup;
	var titleText:FlxText;
	var playOption:FlxText;
	var editorOption:FlxText;
	var optionsOption:FlxText;
	var selectedOption:Int = 0;

	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF87CEEB;

		clouds = new FlxGroup();

		for (i in 0...100)
		{
			var cloudX:Float = FlxG.random.float(0, FlxG.width);
			var cloudY:Float = FlxG.random.float(0, FlxG.height);
			var cloud = new FlxSprite(cloudX, cloudY, 'assets/images/chmura.png');
			cloud.velocity.x = FlxG.random.float(2, 5);
			cloud.scale.set(2, 2);
			cloud.active = true;
			clouds.add(cloud);
		}

		add(clouds);

		titleText = new FlxText(0, FlxG.height * 0.2, FlxG.width, "Main Menu");
		titleText.setFormat(null, 48, 0xFFFFFF, "center");
		add(titleText);

		playOption = new FlxText(0, FlxG.height * 0.4, FlxG.width, "Play");
		playOption.setFormat(null, 32, 0xFFFFFF, "center");
		add(playOption);

		editorOption = new FlxText(0, FlxG.height * 0.5, FlxG.width, "Editor");
		editorOption.setFormat(null, 32, 0xFFFFFF, "center");
		add(editorOption);

		optionsOption = new FlxText(0, FlxG.height * 0.6, FlxG.width, "Options");
		optionsOption.setFormat(null, 32, 0xFFFFFF, "center");
		add(optionsOption);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.DOWN)
		{
			selectedOption = (selectedOption + 1) % 3;
		}
		else if (FlxG.keys.justPressed.UP)
		{
			selectedOption = (selectedOption - 1 + 3) % 3;
		}

		playOption.color = (selectedOption == 0) ? 0xFFFF00 : 0xFFFFFF;
		editorOption.color = (selectedOption == 1) ? 0xFFFF00 : 0xFFFFFF;
		optionsOption.color = (selectedOption == 2) ? 0xFFFF00 : 0xFFFFFF;

		if (FlxG.keys.justPressed.ENTER)
		{
			if (selectedOption == 0)
			{
				FlxG.switchState(new states.PlayState());
			}
			else if (selectedOption == 1)
			{
				FlxG.switchState(new states.EditorState());
			}
			else if (selectedOption == 2) {}
		}

		super.update(elapsed);
	}
}

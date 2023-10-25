package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class MainMenu extends FlxState
{
	private var title:FlxText;
	private var menuItems:Array<FlxText>;
	private var selectedItemIndex:Int = 0;

	override public function create():Void
	{
		super.create();

		title = new FlxText(100, 50, 400, "Pixel Rush");
		title.size = 40;
		title.color = 0xff0000;
		add(title);

		menuItems = [];

		var playText:FlxText = new FlxText(100, 150, 200, "Play");
		var editorText:FlxText = new FlxText(100, 200, 200, "Editor");
		var optionsText:FlxText = new FlxText(100, 250, 200, "Options");
		var exitText:FlxText = new FlxText(100, 300, 200, "Exit");

		menuItems.push(playText);
		menuItems.push(editorText);
		menuItems.push(optionsText);
		menuItems.push(exitText);

		for (menuItem in menuItems)
		{
			menuItem.size = 20;
			add(menuItem);
		}

		menuItems[selectedItemIndex].color = 0xff0000;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP)
		{
			menuItems[selectedItemIndex].color = 0xffffff;
			selectedItemIndex = (selectedItemIndex - 1 + menuItems.length) % menuItems.length;
			menuItems[selectedItemIndex].color = 0xff0000;
		}
		else if (FlxG.keys.justPressed.DOWN)
		{
			menuItems[selectedItemIndex].color = 0xffffff;
			selectedItemIndex = (selectedItemIndex + 1) % menuItems.length;
			menuItems[selectedItemIndex].color = 0xff0000;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			selectMenuItem();
		}
	}

	private function selectMenuItem():Void
	{
		switch (selectedItemIndex)
		{
			case 0:
				FlxG.switchState(new states.PlayState());
			case 1:
				FlxG.switchState(new states.EditorState());
			case 2:
			case 3:
		}
	}
}

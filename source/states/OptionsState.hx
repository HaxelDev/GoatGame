package states;

import flixel.FlxG;
import flixel.FlxState;

class OptionsState extends FlxState
{
	override public function create():Void {}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new states.MainMenu());
		}

		super.update(elapsed);
	}
}

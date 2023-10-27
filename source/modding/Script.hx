package modding;

import hscript.Interp;
import hscript.Parser;

class Script
{
	public static var program:hscript.Expr;
	public static var interp = new Interp();
	public static var parser = new Parser();

	public static function run(script:String):String
	{
		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;

		program = parser.parseString(script);

		#if sys
		interp.variables.set("console", {
			log: function(message:Dynamic)
			{
				Sys.println(message);
			}
		});
		#end

		return interp.execute(program);
	}

	public static function call(funcName:String, ?args:Array<Dynamic>):Dynamic
	{
		if (args == null)
			args = [];
		try
		{
			var func:Dynamic = interp.variables.get(funcName);
			if (func != null && Reflect.isFunction(func))
				return Reflect.callMethod(null, func, args);
		}
		catch (error:Dynamic)
		{
			flixel.FlxG.log.add(error.details());
			trace(error);
		}
		return true;
	}
}

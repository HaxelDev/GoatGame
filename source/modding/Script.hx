package modding;

import hscript.Interp;
import hscript.Parser;

class Script
{
	public var program:hscript.Expr;
	public var interp = new Interp();
	public var parser = new Parser();

	public function run(script:String):String
	{
		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;

		#if sys
		var scriptFile:String = sys.io.File.getContent("assets/data/scripts/script.hx");
		#else
		var scriptFile:String = openfl.utils.Assets.getText("assets/data/scripts/script.hx");
		#end

		program = parser.parseString(script);

		var require = (file:String, ?vars:String) ->
		{
			var fileScript = "assets/data/scripts/" + file + ".hx";
			#if sys
			var code = sys.io.File.getContent(fileScript);
			#else
			var code = openfl.utils.Assets.getText(fileScript);
			#end
			var lines = code.split("\n");
			// https://github.com/HaxeFoundation/hscript/issues/100
			// for( x in 0...lines.length ){
			//	lines[x] = lines[x]+";";
			//	lines[x] = ~/;;/;/g;
			// }
			return run(lines.join("\n"));
		}
		interp.variables.set("console", {
			log: haxe.Log.trace
		});
		interp.variables.set("call", call);
		interp.variables.set("require", require);
		return interp.execute(program);
	}

	public function call(funcName:String, ?args:Array<Dynamic>):Dynamic
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

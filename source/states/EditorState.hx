package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

typedef MapJson =
{
	var player:Array<Int>;
	var blocks:Array<Blocks>;
}

typedef Blocks =
{
	var x:Int;
	var y:Int;
	var type:Int;
}

class EditorState extends FlxState
{
	private var levelData:Array<Array<Int>>;
	private var tileWidth:Int = 32;
	private var tileHeight:Int = 32;
	private var currentTileType:Int = 1;
	private var instructionsText:FlxText;
	private var blocks:Array<FlxSprite>;
	private var player:FlxSprite;

	override public function create():Void
	{
		super.create();

		instructionsText = new FlxText(10, 10, FlxG.width
			- 20,
			"Welcome to the Editor!\n\n"
			+ "Left-click to place blocks\n"
			+ "Right-click to remove blocks\n"
			+ "Use the number keys (1, 2, 3, etc.) to change block types\n"
			+ "Use arrow keys to move the camera\n"
			+ "Use W, A, S, D to move the player\n"
			+ "Press Enter to save the map as JSON\n"
			+ "Press Space to load a JSON map\n"
			+ "Press R to reset all blocks\n");
		instructionsText.size = 13;
		add(instructionsText);

		levelData = new Array<Array<Int>>();

		for (x in 0...Math.floor(FlxG.width / tileWidth))
		{
			levelData[x] = new Array<Int>();
			for (y in 0...Math.floor(FlxG.height / tileHeight))
			{
				levelData[x][y] = 0;
			}
		}

		blocks = new Array<FlxSprite>();

		for (x in 0...levelData.length)
		{
			for (y in 0...levelData[x].length)
			{
				var tileType = levelData[x][y];
				if (tileType != 0)
				{
					addBlock(x, y, tileType);
				}
			}
		}

		addPlayer(5, 9);

		setTile(4, 10, 1);
		setTile(5, 10, 1);
		setTile(6, 10, 1);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.LEFT)
		{
			FlxG.camera.scroll.x -= 4;
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			FlxG.camera.scroll.x += 4;
		}

		if (FlxG.keys.pressed.UP)
		{
			FlxG.camera.scroll.y -= 4;
		}
		else if (FlxG.keys.pressed.DOWN)
		{
			FlxG.camera.scroll.y += 4;
		}

		if (FlxG.keys.justPressed.A)
		{
			player.x -= 4;
		}
		else if (FlxG.keys.justPressed.D)
		{
			player.x += 4;
		}

		if (FlxG.keys.justPressed.W)
		{
			player.y -= 4;
		}
		else if (FlxG.keys.justPressed.S)
		{
			player.y += 4;
		}

		if (FlxG.keys.pressed.ONE)
		{
			currentTileType = 1;
		}
		else if (FlxG.keys.pressed.TWO)
		{
			currentTileType = 2;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			onSaveMap();
		}
		else if (FlxG.keys.justPressed.SPACE)
		{
			onLoadMap();
		}
		else if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new states.MainMenu());
		}
		else if (FlxG.keys.justPressed.R)
		{
			clearAllBlocks();
		}

		var mouseX:Int = Math.floor((FlxG.mouse.x + FlxG.camera.scroll.x) / tileWidth);
		var mouseY:Int = Math.floor((FlxG.mouse.y + FlxG.camera.scroll.y) / tileHeight);

		if (FlxG.mouse.justPressed)
		{
			setTile(mouseX, mouseY, currentTileType);
		}
		else if (FlxG.mouse.justPressedRight)
		{
			setTile(mouseX, mouseY, 0);
		}
	}

	private function clearAllBlocks():Void
	{
		for (block in blocks)
		{
			remove(block);
		}

		blocks = new Array<FlxSprite>();

		for (x in 0...levelData.length)
		{
			for (y in 0...levelData[x].length)
			{
				levelData[x][y] = 0;
			}
		}
	}

	private function setTile(x:Int, y:Int, type:Int):Void
	{
		levelData[x][y] = type;
		removeBlock(x, y);

		if (type != 0)
		{
			addBlock(x, y, type);
		}
	}

	private function addPlayer(x:Int, y:Int):Void
	{
		player = new FlxSprite(x * tileWidth, y * tileHeight);
		player.loadGraphic('assets/images/koza.png', true, tileWidth, tileHeight);
		player.animation.add('idle', [0], 12);
		player.scale.set(1.3, 1.3);
		add(player);
	}

	private function addBlock(x:Int, y:Int, type:Int):Void
	{
		var block = new FlxSprite(x * tileWidth, y * tileHeight);
		if (type == 1)
		{
			block.loadGraphic('assets/images/ziemia.png', false, tileWidth, tileHeight);
		}
		else if (type == 2)
		{
			block.loadGraphic('assets/images/ziemia2.png', false, tileWidth, tileHeight);
		}
		block.scale.set(2, 2);
		blocks.push(block);
		add(block);
	}

	private function removeBlock(x:Int, y:Int):Void
	{
		var indexToRemove:Int = -1;
		for (i in 0...blocks.length)
		{
			if (blocks[i].x == x * tileWidth && blocks[i].y == y * tileHeight)
			{
				remove(blocks[i]);
				indexToRemove = i;
				break;
			}
		}
		if (indexToRemove != -1)
		{
			blocks.splice(indexToRemove, 1);
		}
	}

	private var _file:openfl.net.FileReference;

	private function onSaveMap():Void
	{
		var mapData:MapJson = {player: [Std.int(player.x), Std.int(player.y)], blocks: []};

		for (x in 0...levelData.length)
		{
			for (y in 0...levelData[x].length)
			{
				var tileType = levelData[x][y];
				if (tileType != 0)
				{
					var blockData:Blocks = {x: x, y: y, type: tileType};
					mapData.blocks.push(blockData);
				}
			}
		}

		var data:String = haxe.Json.stringify(mapData, "\t");

		if (data.length > 0)
		{
			_file = new openfl.net.FileReference();
			_file.addEventListener(openfl.events.Event.COMPLETE, onSaveComplete);
			_file.addEventListener(openfl.events.Event.CANCEL, onSaveCancel);
			_file.addEventListener(openfl.events.IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data, "map.json");
		}
	}

	private function onSaveComplete(_):Void
	{
		_file.removeEventListener(openfl.events.Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(openfl.events.Event.CANCEL, onSaveCancel);
		_file.removeEventListener(openfl.events.IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved file.");
	}

	private function onSaveCancel(_):Void
	{
		_file.removeEventListener(openfl.events.Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(openfl.events.Event.CANCEL, onSaveCancel);
		_file.removeEventListener(openfl.events.IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	private function onSaveError(_):Void
	{
		_file.removeEventListener(openfl.events.Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(openfl.events.Event.CANCEL, onSaveCancel);
		_file.removeEventListener(openfl.events.IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving file");
	}

	private function onLoadMap():Void
	{
		_file = new openfl.net.FileReference();
		_file.addEventListener(openfl.events.Event.SELECT, onFileSelect);
		_file.browse();
	}

	private function onFileSelect(event:openfl.events.Event):Void
	{
		_file.removeEventListener(openfl.events.Event.SELECT, onFileSelect);
		_file.addEventListener(openfl.events.Event.COMPLETE, onFileLoadComplete);
		_file.addEventListener(openfl.events.IOErrorEvent.IO_ERROR, onFileLoadError);
		_file.load();
	}

	private function onFileLoadComplete(event:openfl.events.Event):Void
	{
		_file.removeEventListener(openfl.events.Event.COMPLETE, onFileLoadComplete);
		_file.removeEventListener(openfl.events.IOErrorEvent.IO_ERROR, onFileLoadError);

		var jsonMapData:String = _file.data.toString();

		try
		{
			var mapData:MapJson = haxe.Json.parse(jsonMapData);
			var playerPosition:Array<Int> = mapData.player;
			var blocks:Array<Blocks> = mapData.blocks;

			player.x = playerPosition[0];
			player.y = playerPosition[1];

			for (blockData in blocks)
			{
				setTile(blockData.x, blockData.y, blockData.type);
			}

			FlxG.log.notice("Successfully loaded map from file.");
		}
		catch (error:Dynamic)
		{
			FlxG.log.error("Error loading map from file: " + error);
		}
	}

	private function onFileLoadError(event:openfl.events.IOErrorEvent):Void
	{
		_file.removeEventListener(openfl.events.Event.COMPLETE, onFileLoadComplete);
		_file.removeEventListener(openfl.events.IOErrorEvent.IO_ERROR, onFileLoadError);
		FlxG.log.error("Error loading map file: " + event.text);
	}
}

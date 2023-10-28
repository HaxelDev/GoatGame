package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import states.EditorState;

class PlayState extends FlxState
{
	private var levelData:Array<Array<Int>>;
	private var tileWidth:Int = 32;
	private var tileHeight:Int = 32;
	private var currentTileType:Int = 1;
	private var blocks:Array<FlxSprite>;
	private var player:FlxSprite;
	private var speed:Int = 120;
	private var deceleration:Int = 15;

	override public function create():Void
	{
		levelData = new Array<Array<Int>>();
		blocks = new Array<FlxSprite>();

		var jsonMapData:String = sys.io.File.getContent("assets/data/map.json");

		try
		{
			var mapData:MapJson = haxe.Json.parse(jsonMapData);
			var playerPosition:Array<Int> = mapData.player;
			var mapBlocks:Array<Blocks> = mapData.blocks;

			for (x in 0...Math.floor(FlxG.width / tileWidth))
			{
				levelData[x] = new Array<Int>();
				for (y in 0...Math.floor(FlxG.height / tileHeight))
				{
					levelData[x][y] = 0;
				}
			}

			FlxG.worldBounds.set(0, 0, levelData.length * tileWidth, levelData[0].length * tileHeight);

			FlxG.worldBounds.y = 0;
			FlxG.camera.follow(player);

			addPlayer(0, 0);

			player.x = playerPosition[0];
			player.y = playerPosition[1];

			for (blockData in mapBlocks)
			{
				setTile(blockData.x, blockData.y, blockData.type);
			}
		}
		catch (error:Dynamic)
		{
			FlxG.log.error("Error loading map from file: " + error);
		}

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

		FlxG.camera.follow(player, PLATFORMER, 0.65);
		FlxG.worldBounds.set(0, 0, 9999999, 9999999);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (player != null)
		{
			if (FlxG.keys.pressed.LEFT)
			{
				player.velocity.x = -speed;
				player.animation.play('left');
			}
			else if (FlxG.keys.pressed.RIGHT)
			{
				player.velocity.x = speed;
				player.animation.play('idle');
			}
			else
			{
				if (player.velocity.x > 0)
				{
					player.velocity.x -= deceleration;
				}
				else if (player.velocity.x < 0)
				{
					player.velocity.x += deceleration;
				}
				else
				{
					player.velocity.x = 0;
				}
			}

			var isOnBlock:Bool = false;

			for (block in blocks)
			{
				if (player.overlaps(block))
				{
					if (player.velocity.y > 0)
					{
						player.y = block.y - player.height;
						isOnBlock = true;
					}
					else if (player.velocity.y < 0)
					{
						player.y = block.y + block.height;
					}
				}
			}

			if (!isOnBlock)
			{
				player.velocity.y += 500;
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new states.MainMenu());
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
		player.animation.add('left', [2], 12);
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
}

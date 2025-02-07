/*
	BactaTankCharacter
	-------------------------------------------------------------------------
	Script:			BactaTankCharacter
	Version:		v1.00
	Created:		20/11/2024 by Alun Jones
	Description:	BactaTank Character Constructor
	-------------------------------------------------------------------------
	History:
	 - Created 20/11/2024 by Alun Jones
	
	To Do:
	 - Change the save function to format it nicely
*/

enum BTTextTypes
{
	Attribute,
	String,
	Integer,
	Float,
	Text,
}
global.__textTypes = ["Attribute", "String", "Integer", "Float", "Text"];
#macro BT_TEXT_TYPES global.__textTypes

enum BTCharacterVarients_TCS
{
	None,
	Padme,
	Anakin,
	Pod,
	Walker4Legs,
	Walker2Legs,
	Criter,
	BattleDroid,
	ObiwanKenobi,
	Fett,
	Wookie,
	Clone,
	HanSolo,
	Stormtooper,
	JediStarfighterEp3,
	HoverDroid,
	Lando,
	Luke,
	MaceWindu,
	Tie,
	NabooStarfighter,
	Leia,
	Rebel,
	RepublicGunship,
	Weirdo,
}
global.__characterVarientsTCS = ["None", "Padme", "Anakin", "Pod", "Walker4Legs", "Walker2Legs", "Criter", "BattleDroid", "ObiwanKenobi", "Fett", "Wookie", "Clone", "HanSolo",
								 "Stormtooper", "JediStarfighterEp3", "HoverDroid", "Lando", "Luke", "MaceWindu", "Tie", "NabooStarfighter", "Leia", "Rebel", "RepublicGunship", "Weirdo"];
#macro BT_CHARACTER_VARIENTS_TCS global.__characterVarientsTCS

enum BTCharacterType
{
	TCS,
	LIJ1,
	LB1,
}
global.__characterType = ["TCS", "LIJ1", "LB1"];
#macro BT_CHARACTER_TYPE global.__characterType

global.__characterDefaults = {
	// General Attributes
	name_id: 0,
	icon: "FLOM_ICON",
	varient: BTCharacterVarients_TCS.None,
	weapon: NULL,
	hit_points: 4,
	attributes: [  ],
	
	// Collider
	radius: 0.1,
	miny: 0,
	maxy: 0.42,
	scale: 1,
	
	// Physics
	// General Physics
	acceleration: 10,
	move_delay: 0.2,
	hover_height: NULL,
	friction: NULL,
	
	// Speeds
	tiptoe_speed: 0.3,
	walk_speed: 0.6,
	run_speed: 1.1793,
	jump_speed: 2.3,
	jump_2_speed: NULL,
	slam_jumpspeed: 3,
	lunge_jumpspeed: NULL,
	
	// Gravity
	air_gravity: -6.0,
	water_gravity: 0,
	slam_gravity: -15,
}
#macro BT_CHARACTER_DEFAULTS global.__characterDefaults

global.__characterTypes = {
	// General Attributes
	name_id: BTTextTypes.Integer,
	icon: BTTextTypes.String,
	varient: BTTextTypes.Text,
	weapon: BTTextTypes.Text,
	hit_points: BTTextTypes.Integer,
	
	// Collider
	radius: BTTextTypes.Float,
	miny: BTTextTypes.Float,
	maxy: BTTextTypes.Float,
	scale: BTTextTypes.Float,
	
	// Physics
	// General Physics
	acceleration: BTTextTypes.Float,
	move_delay: BTTextTypes.Float,
	hover_height: BTTextTypes.Float,
	friction: BTTextTypes.Float,
	
	// Speeds
	tiptoe_speed: BTTextTypes.Float,
	walk_speed: BTTextTypes.Float,
	run_speed: BTTextTypes.Float,
	jump_speed: BTTextTypes.Float,
	jump_2_speed: BTTextTypes.Float,
	slam_jumpspeed: BTTextTypes.Float,
	lunge_jumpspeed: BTTextTypes.Float,
	
	// Gravity
	air_gravity: BTTextTypes.Float,
	water_gravity: BTTextTypes.Float,
	slam_gravity: BTTextTypes.Float,
}
#macro BT_CHARACTER_TYPES global.__characterTypes

function BactaTankCharacter() constructor
{
	// BactaTank Settings
	name = "BTName";
	type = BTCharacterType.TCS;
	
	// General Attributes
	name_id = 0;
	icon = "FLOM_ICON";
	varient = BTCharacterVarients_TCS.None;
	weapon = NULL;
	hit_points = 4;
	attributes = [  ];
	
	// Collider
	radius = 0.1;
	miny = 0;
	maxy = 0.42;
	scale = 1;
	
	// Physics
	// General Physics
	acceleration = 10;
	move_delay = 0.2;
	hover_height = NULL;
	friction = NULL;
	
	// Speeds
	tiptoe_speed = 0.3;
	walk_speed = 0.6;
	run_speed = 1.1793;
	jump_speed = 2.3;
	jump_2_speed = NULL;
	slam_jumpspeed = 3;
	lunge_jumpspeed = NULL;
	
	// Gravity
	air_gravity = -6.0;
	water_gravity = 0;
	slam_gravity = -15;
	
	#region Methods
	
	#region Load / Save Text
	
	static load = function(file)
	{
		// Load File Into Lines
		var lines = file_read_lines(file);
		
		// Loop Through Lines
		for (var i = 0; i < array_length(lines); i++)
		{
			// Line
			var line = string_trim(lines[i]);
			
			// Comment Check
			if (string_char_at(line, 1) == "/" || string_char_at(line, 1) == "\\" || string_char_at(line, 1) == ";") continue;
			
			// Split line
			var split = string_split(string_split_ext(line, ["//", @"\\", ";"], true)[0], "=", true);
			
			// Check if Split[0] Contains a Comment
			if (string_contains_ext(split[0], ["//", @"\\", ";"])) continue;
			
			// Check if Tag Exists
			
			// Switch
			switch(split[0])
			{
				// Each Text Element
				default:
					// Setter Check
					if (variable_struct_exists(self, split[0]))
					{
						var type = variable_struct_get(BT_CHARACTER_TYPES, split[0]);
						if (type == BTTextTypes.Integer || type == BTTextTypes.Float) variable_struct_set(self, split[0], real(split[1]));
						else if (type == BTTextTypes.String) variable_struct_set(self, split[0], string_trim(split[1], ["\""]));
					}
					break;
			}
		}
	}
	
	static save = function(file)
	{
		// Final String
		var str = "// Generated with BactaTank\n\n";
		
		// Get Variable Names
		var names = variable_struct_get_names(self);
		
		// Loop Over Names
		for (var i = 0; i < array_length(names); i++)
		{
			// Attribute Name
			var name = names[i];
			
			// Error Checking
			if (!variable_struct_exists(BT_CHARACTER_TYPES, name)) continue;
			if (variable_struct_get(self, name) == NULL) continue;
			
			// Write
			switch (variable_struct_get(BT_CHARACTER_TYPES, name))
			{
				case BTTextTypes.Integer:
					str += $"{name}={variable_struct_get(self, name)}\n";
					break;
				case BTTextTypes.Float:
					str += $"{name}={string_format(variable_struct_get(self, name), 1, 4)}\n";
					break;
				case BTTextTypes.String:
					str += $"{name}=\"{variable_struct_get(self, name)}\"\n";
					break;
				case BTTextTypes.Text:
					str += $"{name}={variable_struct_get(self, name)}\n";
					break;
			}
		}
		
		// Save File
		file_text_write(file, str);
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	static serialize = function(buffer)
	{
		// Write BactaTank Properties
		buffer_write(buffer, buffer_string, name);
		buffer_write(buffer, buffer_string, BT_CHARACTER_TYPE[type]);
		
		// Get Variable Names
		var names = variable_struct_get_names(self);
		
		// Write Properties
		buffer_write(buffer, buffer_string, "CharacterProperties");
		buffer_write(buffer, buffer_u32, array_length(names));
		
		// Loop Over Names
		for (var i = 0; i < array_length(names); i++)
		{
			// Property Name
			var propertyName = names[i];
			
			// Error Checking
			if (!variable_struct_exists(BT_CHARACTER_TYPES, propertyName)) continue;
			if (variable_struct_get(self, propertyName) == NULL) continue;
			
			// Write Name
			buffer_write(buffer, buffer_string, propertyName);
			
			// Write
			switch (variable_struct_get(BT_CHARACTER_TYPES, propertyName))
			{
				case BTTextTypes.Integer:
					buffer_write(buffer, buffer_s32, variable_struct_get(self, propertyName));
					break;
				case BTTextTypes.Float:
					buffer_write(buffer, buffer_f32, variable_struct_get(self, propertyName));
					break;
				case BTTextTypes.String:
					buffer_write(buffer, buffer_string, variable_struct_get(self, propertyName));
					break;
				case BTTextTypes.Text:
					buffer_write(buffer, buffer_string, variable_struct_get(self, propertyName));
					break;
			}
		}
		
		// Write Attributes
		buffer_write(buffer, buffer_string, "CharacterAttributes");
		buffer_write(buffer, buffer_u32, array_length(attributes));
		
		// Loop Over Names
		for (var i = 0; i < array_length(attributes); i++)
		{
			// Attribute Name
			buffer_write(buffer, buffer_string, attributes[i]);
		}
	}
	
	#endregion
	
	#endregion
}
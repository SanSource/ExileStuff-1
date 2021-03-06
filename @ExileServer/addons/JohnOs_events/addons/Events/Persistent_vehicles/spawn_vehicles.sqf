/*

	_vehicleArray = ["Vehicle Class Name",amount to spawn,[array of potential spawn locations]]

*/

uiSleep 30;

"ExileServer - Spawning world persistent vehicles" call ExileServer_util_log;

private ["_count","_uid","_debugForSP","_vehicle","_vehicleArray","_count","_vehicleClass","_position","_positionCount","_pinCode","_vehicleObject","_nearVehicles","_nearVechicleCount","_marker","_cancelSpawn","_isRandomRoadPos","_road","_scriptComplete"];

_scriptComplete = false;
_debugForSP = false;

LastPosition = [];

_uid = Persistent_UID;

_vehicleArray = 
[
	// Quads
	["Exile_Bike_QuadBike_Black",3,[],true],
	["Exile_Bike_QuadBike_Csat",3,[],true],
	// Vans
	["Exile_Car_Van_Box_Black",2,[],true],
	// Offroads
	["Exile_Car_Offroad_White",2,[],true], 
	["Exile_Car_Offroad_Rusty1",2,[],true], 
	["Exile_Car_Offroad_Armed_Guerilla01",1,[],true],
	// Hatchbacks
	["Exile_Car_Hatchback_Green",2,[],true],
	["Exile_Car_Hatchback_Grey",2,[],true],
	// Hatchback sports
	["Exile_Car_Hatchback_Sport_Red",1,[],true],
	["Exile_Car_Hatchback_Sport_Blue",1,[],true],
	["Exile_Car_Hatchback_Sport_Orange",1,[],true],
	// SUV
	["Exile_Car_SUV_Red",1,[],true],
	["Exile_Car_SUV_Black",1,[],true],
	["Exile_Car_SUV_Grey",1,[],true],
	["Exile_Car_SUV_Orange",1,[],true],
	// Volha
	//["Exile_Car_Volha_Blue",1,[],true],
	//["Exile_Car_Volha_White",1,[],true],
	//["Exile_Car_Volha_Black",1,[],true],
	// Bus
	["Exile_Car_Ikarus_Blue",1,[],true],
	// Zamak
	//["Exile_Car_Zamak",1,[],true],
	// Urals
	//["Exile_Car_Ural_Covered_Blue",1,[],true],
	//["Exile_Car_Ural_Covered_Yellow",1,[],true],
	//["Exile_Car_Ural_Covered_Worker",1,[],true],
	//["Exile_Car_Ural_Covered_Military",1,[],true],
	// Land rovers
	//["Exile_Car_LandRover_Red",1,[],true],
	//["Exile_Car_LandRover_Urban",1,[],true],
	//["Exile_Car_LandRover_Green",1,[],true],
	//["Exile_Car_LandRover_Sand",1,[],true],
	//["Exile_Car_LandRover_Desert",1,[],true],
	
	//RHS - USAF
	
	["rhsusf_mrzr4_d",1,[],true],
	["rhsusf_m1025_d",1,[],true],
	["rhsusf_m998_d_4dr",1,[],true],
	["rhsusf_m998_w_s_4dr",1,[],true],
	["rhsusf_M1083A1P2_d_fmtv_usarmy",1,[],true],
	["rhsusf_M1078A1P2_d_open_fmtv_usarmy",1,[],true],
	["rhsusf_m113d_usarmy_unarmed",1,[[20078.2,6735.33,0],[14221.6,21232.7,0]],false],
	["rhsusf_m113_usarmy_unarmed",1,[[14268.7,16211,0],[17396.6,13152.5,0],[25304.1,21792.1,0]],false],
	//["rhsusf_M1232_usarmy_d",1,[],true],	//RG-33l MRAP  	//Use custom pos
	["rhsusf_M1232_usarmy_wd",1,[[10195.8,15905.9,0],[6250.05,16862,0]],false],	//RG-33l MRAP 	//Use custom pos
	
	
	
	//RHS - AFRF
	
	["rhs_uaz_vdv",1,[],true],
	["rhs_uaz_open_MSV_01",1,[],true],
	["rhs_tigr_3camo_msv",1,[],true],
	["rhs_tigr_m_vdv",1,[[18509.7,10899.6,0],[13835,19878.4,0],[3906.45,17444.5,0]],false],
	["rhs_kamaz5350_open_vdv",1,[],true],
	["rhs_kamaz5350_vdv",1,[],true],
	["RHS_Ural_Open_VDV_01",1,[],true],
	["rhs_gaz66_vv",1,[],true],

	
	//Armed
	["rhs_btr60_msv",1,[[12282.4,8930.5,0],[18080.2,19178.9,0]],false], 	//Use custom pos
	["rhs_btr70_msv",1,[[20911,19314.1,0],[23031.3,7258.71,0]],false], 	//Use custom pos

	
	// Apex stuff
	//["Exile_Car_ProwlerUnarmed",1,[],true],
	//["Exile_Car_QilinUnarmed",1,[],true],
	["Exile_Car_MB4WD",1,[],true],
	["Exile_Car_MB4WDOpen",1,[],true],
	
	// Choppers	
	["RHS_Mi8AMT_vvs",1,[[23483.9,21144.8,0],[25240.1,21828.6,0]],false],		
	["RHS_MELB_H6M",1,[[12834.2,16735.8,0],[23079.8,7299.1,0]],false],
	["RHS_CH_47F_10",1,[[17550.5,13240.5,0],[26783.6,24673,0]],false],						
	["rhs_ka60_grey",1,[[3732.07,12976.3,20]],false],											// Kavala hospital
	
	

	["RHS_Mi8mt_Cargo_vvs",1,[[23014.4,18864.9,0]],false],	//salt flats
	["RHS_Mi24Vt_vvs",1,[[20798.2,7227.74,0]],false], //Selekano
	["RHS_UH60M_d",1,[[11578.3,11908,0], [9187.2,21622.8,0]],false], //AAC, North Abdera
	["rhsusf_CH53E_USMC",1,[[23815,16009.6,0]],false]//sea king @ Ochrolimni
	//["RHS_UH1Y_UNARMED",1,[],false],
	
	
];

{
	for "_i" from 0 to (_x select 1) do
	{	
		_cancelSpawn = false;
		_obj = _x select 0;
		_count = count allMissionObjects _obj;
		_positionCount = (count (_x select 2));
		_isRandomRoadPos = _x select 3;

		if !(_count >= _x select 1) then
		{
			_vehicleClass = _x select 0;
			_position = selectRandom (_x select 2);

			if !(_isRandomRoadPos) then
			{
				_foundSafePos = false;
				_failSafe = 15;
				_checks = 0;
				waitUntil 
				{ 
					_position = selectRandom (_x select 2);
					_nearVehicles = nearestObjects [_position, ["car","air"], 10];
					_nearVechicleCount = count _nearVehicles;
					if (!(_position isEqualTo LastPosition) && (_nearVechicleCount == 0)) then
					{
						_foundSafePos = true;
					};
					_checks = _checks + 1;
					if (_checks >= _failSafe) then {_cancelSpawn = true; _foundSafePos = true;};
					_foundSafePos
				};		
			}
			else
			{
				_foundSafePos = false;
				waitUntil //Loop the script until _foundRoad = true;
				{
					_spawnCenter = Event_world_centerPosition; 
					_min = 15; // minimum distance from the center position (Number) in meters
					_max = 30000; // maximum distance from the center position (Number) in meters
					_mindist = 5; // minimum distance from the nearest object (Number) in meters, ie. spawn at least this distance away from anything within x meters..
					_water = 0; // water mode 0: cannot be in water , 1: can either be in water or not , 2: must be in water
					_shoremode = 0; // 0: does not have to be at a shore , 1: must be at a shore
					_blackList = [[[0, 0],[0,0]]]; 

					_startPosRoad = [_spawnCenter,_min,_max,_mindist,_water,10,_shoremode,_blackList] call BIS_fnc_findSafePos; //Find random spot on the map
					_onRoadCheck = _startPosRoad nearRoads 100; //Find road objects 100m from spot
					_countPossibleRoads = count _onRoadCheck; // count road objects

					if (_countPossibleRoads == 0) then 
					{
					}
					else
					{
						_road = _onRoadCheck select 0;
						_position = getPos _road;
						_foundSafePos = true;
					};
					uiSleep 0.1;
					_foundSafePos
				};
			};	
			if !(_cancelSpawn) then
			{	
				if !(_debugForSP) then
				{
					_pinCode = format ["%1%2%3%4",round (random 8 +1),round (random 8 +1),round (random 8 +1),round (random 8 +1)];
					_vehicleObject = [_vehicleClass, _position, (random 360), true,_pinCode] call ExileServer_object_vehicle_createPersistentVehicle;
					_vehicleObject setDamage 0.8;
					_vehicleObject setFuel 0;

					if !((_x select 0) isKindOf "AIR") then
					{
						_wheels = ["HitLF2Wheel","HitLFWheel","HitRFWheel","HitRF2Wheel"];
						{
							if (random 1 > 0.5) then
							{	
								_vehicleObject setHitPointDamage [_x,1];
							};	
						} forEach _wheels;
					};	
					_vehicleObject setVariable ["ExileOwnerUID", _uid];
					_vehicleObject setVariable ["ExileIsLocked",0];
					_vehicleObject lock 0;
					_vehicleObject call ExileServer_object_vehicle_database_insert;
					_vehicleObject call ExileServer_object_vehicle_database_update;

					if (random 1 > 0.5) then
					{
						for "_i" from 0 to 2 + floor (random 5) do
						{	
							_item = [6] call JohnO_fnc_getRandomItems_new;
					
							[_vehicleObject, _item] call ExileClient_util_containerCargo_add;
						};
					};	

					format ["[Event: Persistent Spawns] -- Spawned a %1 at location: %2 -- Max allowed: %3",_x select 0,_position, _x select 1] call ExileServer_util_log;
				}
				else
				{
					_vehicleObject = createVehicle [_vehicleClass,_position,[], 0, "NONE"];

					if !((_x select 0) isKindOf "AIR") then
					{
						_wheels = ["HitLF2Wheel","HitLFWheel","HitRFWheel","HitRF2Wheel"];
						{
							_vehicleObject setHitPointDamage [_x,1];
						} forEach _wheels;
					};

					_marker = createMarker [format["HeliCrash%1", diag_tickTime], _position];
					_marker setMarkerType "mil_dot";
					_marker setMarkerText "Vehicle";
				};
			}
			else
			{
				if !(_debugForSP) then
				{			
					format ["[Event: Persistent Spawns] -- Could not find valid spawn position for %1 at position %2 -- exiting try for this vehicle",_x select 0,_position] call ExileServer_util_log;
				}
				else
				{
					hint format["[Event: Persistent Spawns] -- Could not find valid spawn position for %1 at position %2 -- exiting try for this vehicle",_x select 0,_position];
				};	
			};		
		};
	};		
	
} forEach _vehicleArray;

_scriptComplete = true;

waitUntil 
{
	"ExileServer - Finished spawning world vehicles" call ExileServer_util_log;
	_scriptComplete
};

{
	private ["_vehicle","_magazines"];

	_vehicle = _x;
	_magazines = [];

	{
		_magazines pushBack [(_x select 0),(_x select 1)];
	} forEach magazinesAllTurrets _vehicle;

	{
		_vehicle removeMagazinesTurret [(_x select 0),(_x select 1)];
	} forEach _magazines;	

} forEach vehicles;

"Cleared ammo from all spawned vehicles" call ExileServer_util_log;
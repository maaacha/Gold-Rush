
/datum/hud
	/// Whether we are wielding something or not right now, makes for faster icon updates
	var/wield_active = FALSE

/datum/hud/human/proc/set_loadout()
	world << "we're setting our loadout"
	var/atom/movable/screen/using
	using = new /atom/movable/screen/loadout_setup()
	using.screen_loc = ui_loadout_setup
	using.hud = src
	static_inventory += using

/datum/hud/human/New(mob/living/carbon/human/owner)
	..()

	world << "so did our override"
	
	var/atom/movable/screen/using

	using = new /atom/movable/screen/loadout_setup()
	using.screen_loc = ui_loadout_setup
	using.hud = src
	static_inventory += using
	
	for(var/i in GLOB.loadout_datum_instances)
		world << "list is [i]"


	update_locked_slots()

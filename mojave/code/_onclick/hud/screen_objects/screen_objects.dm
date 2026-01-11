/atom/movable/screen/resist
	name = "resist"
	icon = 'mojave/icons/hud/ms_ui_combat.dmi'
	icon_state = "resist"
	base_icon_state = "resist"
	plane = HUD_PLANE

/atom/movable/screen/resist/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		L.resist()

/atom/movable/screen/wield
	name = "wield"
	icon = 'mojave/icons/hud/ms_ui_combat.dmi'
	icon_state = "wield"
	base_icon_state = "wield"
	plane = HUD_PLANE

/atom/movable/screen/wield/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		L.wield_active_hand()

/atom/movable/screen/wield/update_icon_state()
	. = ..()
	if(hud?.wield_active)
		icon_state = "[base_icon_state]_active"
	else
		icon_state = base_icon_state

/atom/movable/screen/loadout_setup
	name = "Loadout Setup"
	icon = null
	icon_state = ""
	screen_loc = ui_loadout_setup

INITIALIZE_IMMEDIATE(/atom/movable/screen/loadout_setup)

/atom/movable/screen/loadout_setup/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_mob)), 3 TICKS)

/atom/movable/screen/loadout_setup/Destroy()
	hud.static_inventory -= src
	return ..()

/atom/movable/screen/loadout_setup/proc/check_mob()
	world << "checking log"
	if(QDELETED(src))
		world << "qdelled"
		return
	if(!hud)
		world << "no hud :()"
		qdel(src)
		return
	if(!ishuman(hud.mymob))
		world << "not human?"
		qdel(src)
		return
	var/mob/living/carbon/human/H = hud.mymob
	if(H.loadout_setup)
		world << "we should be loading an icon right meow"
		alpha = 0
		icon = 'mojave/icons/hud/loadout.dmi'
		icon_state = "loadout"
		animate(src, alpha = 255, time = 2 SECONDS)
		update_appearance()

/atom/movable/screen/loadout_setup/Click(location,control,params)
	if(!hud)
		qdel(src)
		return
	if(!ishuman(hud.mymob))
		qdel(src)
		return
	var/mob/living/carbon/human/target = hud.mymob
	if(!target.loadout_setup)
		qdel(src)
		return
	else
		var/datum/select_equipment/loadout/ui = new(target, target)
		ui.ui_interact(target)

/atom/movable/screen/fullscreen/loadout_blind
	icon = 'mojave/icons/hud/blind.dmi'
	icon_state = "blind"
	layer = BLIND_LAYER
	plane = FULLSCREEN_PLANE

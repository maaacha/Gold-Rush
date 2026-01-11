/*
Mojave Sun Job Base Class
*/
/datum/job/ms13
	title = "Default - please implement the title in your dataum/job/ms13/yourjob file"
	supervisors = "N/A - please implement the supervisors in your dataum/job/ms13/yourjob file"
	description = "N/A - please give a description of the role in your dataum/job/ms13/yourjob file"
	forbid = "N/A - please note down what the role shout NOT be doing in your dataum/job/ms13/yourjob file"
	enforce = "N/A - please note down what the role should be doing in dataum/job/ms13/yourjob file"
	faction = FACTION_STATION // this has to be faction station for it to work properly with the prefs menu.
	paycheck = null
	paycheck_department = null
	job_flags = JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS
	var/loadout_tag = NONE // var to determine our jobs loadouts. do not change this if there are no loadouts for the job

/datum/outfit/job/ms13
	name = "Default"
	jobtype = /datum/job/ms13

	//This is all nulled to override /datum/outfit/job giving everyone assistant gear.

	uniform = null
	id = null
	ears = null
	belt = null
	shoes = null
	box = null

	backpack = null
	satchel  = null
	duffelbag = null

	pda_slot = null

//These are base jobs, we don't want them appearing at all
/datum/job/ms13/config_check()
	if(type == /datum/job/ms13)
		return FALSE
	return ..()

/datum/job/ms13/map_check()
	if(type == /datum/job/ms13)
		return FALSE
	return ..()

/datum/outfit/job/ms13/proc/try_add_ammo_for_suit_store_gun(mob/living/carbon/human/human)
	var/obj/item/gun/ballistic/equipped_gun = human.get_item_by_slot(ITEM_SLOT_SUITSTORE)
	if(!istype(equipped_gun))
		return
	var/obj/item/ammo_casing/loaded_casing = equipped_gun.chambered || equipped_gun.magazine?.get_round(TRUE)
	//bullshit!
	if(!loaded_casing?.stack_type)
		return
	var/obj/item/ammo_casing/stacker_casing = new loaded_casing.type(human.loc)
	var/obj/item/ammo_box/magazine/ammo_stack/ammo_stack = stacker_casing.stack_with(new loaded_casing.type(human.loc))
	ammo_stack.top_off(loaded_casing.type, starting = TRUE)
	//this is fucking dumb but top_off has weird behavior
	if(length(ammo_stack.stored_ammo) > ammo_stack.max_ammo)
		stacker_casing = ammo_stack.get_round(keep = FALSE)
		qdel(stacker_casing)
	human.put_in_hands(ammo_stack)
	var/obj/item/backpack = human.get_item_by_slot(ITEM_SLOT_BACK)
	if(!backpack)
		return
	SEND_SIGNAL(backpack, COMSIG_TRY_STORAGE_INSERT, ammo_stack, null, TRUE, TRUE, FALSE)

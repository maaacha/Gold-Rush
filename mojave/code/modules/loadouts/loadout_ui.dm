


/datum/select_equipment/loadout/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SelectEquipment", "Select Loadout")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/select_equipment/loadout/ui_static_data(mob/user)
	var/list/data = list()
	var/datum/job/ms13/user_job = SSjob.GetJob(user.job)


	if(!cached_outfits)
		cached_outfits = list()
		cached_outfits += list(outfit_entry("General", /datum/outfit, "Naked", priority=TRUE))
		if(!isnull(user_job))
			cached_outfits += make_outfit_entries("Loadouts", typesof(/datum/outfit/loadout))
			/*var/list/job_loadouts = GLOB.loadout_datum_instances[user_job.loadout_tag]
			cached_outfits += make_outfit_entries("General", job_loadouts)*/

	data["outfits"] = cached_outfits
	return data
/*
/datum/select_equipment/loadout/ui_act(action, params)
	if(..())
		return
	. = TRUE
	switch(action)
		if("preview")
			var/datum/outfit/new_outfit = resolve_outfit(params["path"])

			if(ispath(new_outfit)) //got a typepath - that means we're dealing with a normal outfit
				selected_identifier = new_outfit //these are keyed by type
				//by the way, no, they can't be keyed by name because many of them have duplicate names

			else if(istype(new_outfit)) //got an initialized object - means it's a custom outfit
				selected_identifier = REF(new_outfit) //and the outfit will be keyed by its ref (cause its type will always be /datum/outfit)

			else //we got nothing and should bail
				return

			selected_outfit = new_outfit

		if("applyoutfit")
			var/datum/outfit/new_outfit = resolve_outfit(params["path"])
			if(new_outfit && ispath(new_outfit)) //initialize it
				new_outfit = new new_outfit
			if(!istype(new_outfit))
				return
			user.apply_loadout(target_mob, new_outfit)

		if("customoutfit")
			user.outfit_manager()

		if("togglefavorite")
			var/datum/outfit/outfit_path = resolve_outfit(params["path"])
			if(!ispath(outfit_path)) //we do *not* want custom outfits (i.e objects) here, they're not even persistent
				return

			if(user.prefs.favorite_outfits.Find(outfit_path)) //already there, remove it
				user.prefs.favorite_outfits -= outfit_path
			else //not there, add it
				user.prefs.favorite_outfits += outfit_path
			user.prefs.save_preferences()
*/

/client/proc/apply_loadout(mob/target, dresscode)

	if(!ishuman(target) && !isobserver(target))
		tgui_alert(usr,"Invalid mob")
		return

	if(!dresscode)
		return

	SSblackbox.record_feedback("tally", "select_loadout", 1, "Select Loadout")

	var/mob/living/carbon/human/human_target = target

	if(dresscode != "Naked")
		human_target.equipOutfit(dresscode)

	human_target.regenerate_icons()

	log_admin("[key_name(usr)] selected the loadout [dresscode].")

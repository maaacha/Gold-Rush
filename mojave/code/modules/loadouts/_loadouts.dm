

GLOBAL_DATUM_INIT(loadout_handler, /datum/loadout_handler, new)

/datum/loadout_handler/New()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(handle_new_loadout))
	world << "we're creating our handler"
	

/datum/loadout_handler/proc/handle_new_loadout(datum/source, mob/living/carbon/human/new_crewmember, rank)
	SIGNAL_HANDLER
	world << "we're handling our loadout"

	if(!istype(new_crewmember))
		world << "we're not a type :L"
		return
	if(isnull(new_crewmember.mind))
		world << "we're stupid :L"
		return

	var/datum/preferences/prefs = new_crewmember.client?.prefs

	var/datum/job/ms13/player_job = SSjob.GetJob(new_crewmember.job)

	if(isnull(player_job.loadout_tag))
		world << "our job has no loadouts"
		return

	if(isnull(prefs))
		world << "we have no prefs?"
		return

	apply_loadout(new_crewmember)

/datum/loadout_handler/proc/apply_loadout(mob/living/carbon/human/target)
	world << "we're applying our loadout" 
	target.loadout_setup = TRUE
	target.invisibility = INVISIBILITY_MAXIMUM
	target.loadout_blindness(TRUE)
	target.Stun(10 MINUTES)
	target.loadout_setup = TRUE

	var/datum/hud/human/player_hud = target.hud_used
	if(player_hud)
		world << "we have a hud !"
		player_hud.set_loadout()

/datum/loadout_handler/Destroy()
	..()
	UnregisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED)

/datum/outfit/loadout
	var/job_tag

/mob/proc/loadout_blindness(is_blind)
	if(is_blind)
		overlay_fullscreen("blind", /atom/movable/screen/fullscreen/loadout_blind)
		// You are blind why should you be able to make out details like color, only shapes near you
		add_client_colour(/datum/client_colour/monochrome/blind)
	else
		clear_fullscreen("blind")
		remove_client_colour(/datum/client_colour/monochrome/blind)

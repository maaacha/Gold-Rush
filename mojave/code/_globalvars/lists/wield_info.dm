GLOBAL_LIST_INIT(path_to_wield_info, setup_wield_infos())

/proc/setup_wield_infos()
	. = list()
	for(var/datum/wield_info/wield_info as anything in init_subtypes(/datum/wield_info))
		.[wield_info.type] = wield_info

GLOBAL_LIST_INIT(loadout_datum_instances, init_loadout_prototypes())

/proc/init_loadout_prototypes()
	testing("intializing loadouts?")

	var/list/loadouts_list

	LAZYINITLIST(loadouts_list)

	for(var/datum/outfit/loadout/loadout_type as anything in typesof(/datum/outfit/loadout))
		testing("loadout is loadout_type")
		if(!initial(loadout_type.name))
			testing("looadout is not initial")
			continue
		if(isnull(loadout_type))
			testing("loadout is null")
			continue

		LAZYADD(loadouts_list[loadout_type.job_tag], loadout_type)

	return loadouts_list

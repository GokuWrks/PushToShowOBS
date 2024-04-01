-- OBS Studio 30.1.1 by Goku Works

obslua = obslua
hotkey_id = obslua.OBS_INVALID_HOTKEY_ID
hotkey_saved_key = nil
obs_data = nil
callback = nil
_id = nil
text_MapImage = ""
text_Scene = ""
float_delay = 0.11
active = false

function toggle()
    local current_scene_source = obslua.obs_frontend_get_current_scene()
    local current_scene = obslua.obs_scene_from_source(current_scene_source)
    local scene_item = obslua.obs_scene_find_source(current_scene, text_MapImage)
    local boolean = not obslua.obs_sceneitem_visible(scene_item)
    obslua.obs_sceneitem_set_visible(scene_item, boolean)
    obslua.obs_source_release(current_scene_source)
end

function mapkey_callback(pressed)
    if pressed then
        toggle()
        active = true
    else
        if active then
            toggle()
            active = false
        end
    end
end

function register_hotkey()
    hotkey_id = obslua.obs_hotkey_register_frontend(tostring(_id), tostring(_id), callback)
    obslua.obs_hotkey_load(hotkey_id, hotkey_saved_key)
end

function load_hotkey()
    hotkey_saved_key = obslua.obs_data_get_array(obs_data, tostring(_id))
    obslua.obs_data_array_release(hotkey_saved_key)
end

function save_hotkey()
    hotkey_saved_key = obslua.obs_hotkey_save(hotkey_id)
    obslua.obs_data_set_array(obs_data, tostring(_id), hotkey_saved_key)
    obslua.obs_data_array_release(hotkey_saved_key)
end

function script_properties()
    local props = obslua.obs_properties_create()
    obslua.obs_properties_add_text(props, "source_name", "source_name", obslua.OBS_TEXT_DEFAULT)
    obslua.obs_properties_add_text(props, "scene_name", "scene_name", obslua.OBS_TEXT_DEFAULT)
    obslua.obs_properties_add_float_slider(props, "delay", "reveal delay (.11 std)", 0, 1, 0.01)
    return props
end

function script_description()
    return "Adds a hotkey for 'push to show'.\n\n\nTutorial: \n\nsource_name : is the name of the image you have in your scene. \n\nscene_name : is the scene that you want the hotkey to affect. leave blank if irrelevant\n\nreveal delay : the amount of time before the source disapeears before revealing (seconds).\n\nThen go into hotkeys and setup ur key in 'Push to show'.\n\n\n  OBS Studio 30.1.1 update by Goku Works Support me on IG: Goku.wrks  Twitch: DampfyTV <3"
end

function script_update(settings)
    text_MapImage = obslua.obs_data_get_string(settings, "source_name")
    text_Scene = obslua.obs_data_get_string(settings, "scene_name")
    float_delay = obslua.obs_data_get_double(settings, "delay")
end

function script_load(settings)
    obs_data = settings
    callback = mapkey_callback
    _id = "Push to show"
    load_hotkey()
    register_hotkey()
end

function script_save(settings)
    save_hotkey()
end

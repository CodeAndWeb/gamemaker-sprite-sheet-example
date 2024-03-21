
function tp_load_texture_atlas(_data_file)
{
	var _json = tp_read_file_as_json(_data_file);
	if (!ds_map_exists(_json, "meta") ||
	    _json[? "meta"][? "exporter"] != "gamemaker" ||
	    _json[? "meta"][? "version"] != "1.0")
	{
		show_error("Invalid JSON file format: " + _data_file, true);
	}
	// multi-pack not yet supported, load first texture
	var _tex_file = filename_path(_data_file) +  _json[? "textures"][| 0][? "texture"];

    var _texture = sprite_add(_tex_file, 1, false, false, 0, 0);
	if (_texture == -1)
	{
		show_error("Failed to load texture file: " + _tex_file, true);
	}
	_json[? "textures"][| 0][? "texture_image"] = _texture;
	return _json;
}
	

function tp_read_file_as_json(_file_name)  // returns ds_map
{
    var _file_handle;
    var _json_content = undefined;

    _file_handle = file_text_open_read(_file_name);
    if (_file_handle != -1) 
    {
        var _file_content = "";
        while (!file_text_eof(_file_handle)) 
        {
            _file_content += file_text_readln(_file_handle) + "\n";
        }
        file_text_close(_file_handle);
        
        _json_content = json_decode(_file_content);
        if (_json_content == undefined) 
        {
            show_error("Failed to parse JSON in file: " + _file_name, true);
        }
    } 
    else 
    {
        show_error("Failed to open file: " + _file_name, true);
    }

    return _json_content;
}


function tp_draw_sprite_from_atlas(_atlas, _sprite_name, _x, _y, _scale_x, _scale_y, _angle)
{
	_scale_x ??= 1;
	_scale_y ??= 1;
	_angle ??= 0;
	
	var _tex = _atlas[? "textures"][| 0];
	var _img = _tex[? "texture_image"];
	
	var _data = _tex[? "frames"][? _sprite_name];
	if (_data == undefined)
	{
		show_message("Sprite '" + _sprite_name + "' not found in atlas");
		game_end();
		return;
	}
	var _frame_x = _data[? "frame"][? "x"];
	var _frame_y = _data[? "frame"][? "y"];
	var _frame_w = _data[? "frame"][? "w"];
	var _frame_h = _data[? "frame"][? "h"];
	
	// add trimmed margin
	_x += _data[? "offset"][? "x"];
	_y += _data[? "offset"][? "y"];
	
	// sprite rotated on sheet?
	var _rotated = _data[? "rotated"];
	_angle += _rotated ? 90 : 0;
	_y += _rotated ? _frame_h : 0;
	
	draw_sprite_general(_img, 0, _frame_x,_frame_y,_frame_w,_frame_h, _x,_y, _scale_x, _scale_y, _angle, c_white,c_white,c_white,c_white,1);
}

// TODO: pass scalex/y, rotation; release memory; build animation sprites (?)

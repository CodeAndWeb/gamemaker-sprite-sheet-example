x = (x + vx*delta_time/1000000) % room_width;

animation_position = (animation_position + delta_time) % (frame_duration * num_frames);
var _current_frame = floor(animation_position / frame_duration) % num_frames;

// create frame index with leading zeros, e.g "0005"
var _index_str = string_replace_all(string_format(_current_frame+1, 4, 0), " ", "0");
var _sprite_name = "capguy/walk/" + _index_str + ".png";

tp_draw_sprite_from_atlas(global.atlas_cityscene, _sprite_name, x, y);


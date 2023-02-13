def convert_coord_sys(coord, old_sys_min, old_sys_max, new_sys_min, new_sys_max) -> float:
    """Convert a coordinate from one scale (e.g. [0, 100]) to another (e.g. [-100, 100])"""
    new_sys_range = new_sys_max - new_sys_min + 1
    old_sys_range = old_sys_max - old_sys_min + 1

    dist_from_old_lower_bound = coord - old_sys_min
    range_scale = dist_from_old_lower_bound / old_sys_range
    new_coord = new_sys_min + range_scale * new_sys_range

    return new_coord
//Remap functions.
inline half Remap(half original_value, half original_min, half original_max, half new_min, half new_max)
{
	return new_min + (((original_value - original_min) / (original_max - original_min)) * (new_max - new_min));
}
//Remap functions.
inline half4 Remap(half4 original_value, half4 original_min, half4 original_max, half4 new_min, half4 new_max)
{
	return new_min + (((original_value - original_min) / (original_max - original_min)) * (new_max - new_min));
}
inline half Remap01(half original_value, half original_min)
{
	return ((original_value - original_min) / (1 - original_min));
}
inline half RemapClamped(half original_value, half original_min, half original_max, half new_min, half new_max)
{
	return new_min + (saturate((original_value - original_min) / (original_max - original_min)) * (new_max - new_min));
}

inline half RemapClamped01(half original_value, half original_min)
{
	return saturate((original_value - original_min) / (1 - original_min));
}
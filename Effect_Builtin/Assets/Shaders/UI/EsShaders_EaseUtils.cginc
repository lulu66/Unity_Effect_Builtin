#define PI 3.1415926
inline float clerp(float start, float end, float value)
{
	float min = 0.0;
	float max = 360.0;
	float halfnumber = abs((max - min) / 2.0);
	float retval = 0.0;
	float diff = 0.0;
    if ((end - start) < -halfnumber)
	{
		diff = ((max - start) + end) * value;
		retval = start + diff;
	}
    else if ((end - start) > halfnumber)
	{
		diff = -((max - end) + start) * value;
		retval = start + diff;
	}
	else retval = start + (end - start) * value;
	return retval;
}

inline float invLerp(float from, float to, float value)
{
	return (value - from) / (to - from);
}

// return value falls in [0, 1] section //
inline float pingpong(float value)
{
	int remainder = fmod(floor(value), 2);
	return remainder == 1 ? 1 - frac(value) : frac(value);
}

inline float spring(float start, float end, float value)
{
	value = saturate(value);
	value = (sin(value * PI * (0.2 + 2.5 * value * value * value)) * pow(1 - value, 2.2) + value) * (1 + (1.2 * (1 - value)));
	return start + (end - start) * value;
}

inline float easeInQuad(float start, float end, float value)
{
	end -= start;
	return end * value * value + start;
}

inline float easeOutQuad(float start, float end, float value)
{
	end -= start;
	return -end * value * (value - 2) + start;
}

inline float easeInOutQuad(float start, float end, float value)
{
	value /= .5;
	end -= start;
	if (value < 1) return end / 2 * value * value + start;
	value--;
	return -end / 2 * (value * (value - 2) - 1) + start;
}

inline float easeInCubic(float start, float end, float value)
{
	end -= start;
	return end * value * value * value + start;
}

inline float easeOutCubic(float start, float end, float value)
{
	value--;
	end -= start;
	return end * (value * value * value + 1) + start;
}

inline float easeInOutCubic(float start, float end, float value)
{
	value /= .5;
	end -= start;
	if (value < 1) return end / 2 * value * value * value + start;
	value -= 2;
	return end / 2 * (value * value * value + 2) + start;
}

inline float easeInQuart(float start, float end, float value)
{
	end -= start;
	return end * value * value * value * value + start;
}

inline float easeOutQuart(float start, float end, float value)
{
	value--;
	end -= start;
	return -end * (value * value * value * value - 1) + start;
}

inline float easeInOutQuart(float start, float end, float value)
{
	value /= .5;
	end -= start;
	if (value < 1) return end / 2 * value * value * value * value + start;
	value -= 2;
	return -end / 2 * (value * value * value * value - 2) + start;
}

inline float easeInQuint(float start, float end, float value)
{
	end -= start;
	return end * value * value * value * value * value + start;
}

inline float easeOutQuint(float start, float end, float value)
{
	value--;
	end -= start;
	return end * (value * value * value * value * value + 1) + start;
}

inline float easeInOutQuint(float start, float end, float value)
{
	value /= .5;
	end -= start;
	if (value < 1) return end / 2 * value * value * value * value * value + start;
	value -= 2;
	return end / 2 * (value * value * value * value * value + 2) + start;
}

inline float easeInSine(float start, float end, float value)
{
	end -= start;
	return -end * cos(value / 1 * (PI / 2)) + end + start;
}

inline float easeOutSine(float start, float end, float value)
{
	end -= start;
	return end * sin(value / 1 * (PI / 2)) + start;
}

inline float easeInOutSine(float start, float end, float value)
{
	end -= start;
	return -end / 2 * (cos(PI * value / 1) - 1) + start;
}

inline float easeInExpo(float start, float end, float value)
{
	end -= start;
	return end * pow(2, 10 * (value / 1 - 1)) + start;
}

inline float easeOutExpo(float start, float end, float value)
{
	end -= start;
	return end * (-pow(2, -10 * value / 1) + 1) + start;
}

inline float easeInOutExpo(float start, float end, float value)
{
	value /= .5;
	end -= start;
	if (value < 1) return end / 2 * pow(2, 10 * (value - 1)) + start;
	value--;
	return end / 2 * (-pow(2, -10 * value) + 2) + start;
}

inline float easeInCirc(float start, float end, float value)
{
	end -= start;
	return -end * (sqrt(1 - value * value) - 1) + start;
}

inline float easeOutCirc(float start, float end, float value)
{
	value--;
	end -= start;
	return end * sqrt(1 - value * value) + start;
}

inline float easeInOutCirc(float start, float end, float value)
{
	value /= .5;
	end -= start;
	if (value < 1) return -end / 2 * (sqrt(1 - value * value) - 1) + start;
	value -= 2;
	return end / 2 * (sqrt(1 - value * value) + 1) + start;
}

/* GFX47 MOD END */

/* GFX47 MOD START */
//inline float bounce(float start, float end, float value){
inline float easeOutBounce(float start, float end, float value)
{
	value /= 1;
	end -= start;
	if (value < (1 / 2.75))
	{
		return end * (7.5625 * value * value) + start;
	}
	else if (value < (2 / 2.75))
	{
		value -= (1.5 / 2.75);
		return end * (7.5625 * (value) * value + .75) + start;
	}
	else if (value < (2.5 / 2.75))
	{
		value -= (2.25 / 2.75);
		return end * (7.5625 * (value) * value + .9375) + start;
	}
	else
	{
		value -= (2.625 / 2.75);
		return end * (7.5625 * (value) * value + .984375) + start;
	}
}

/* GFX47 MOD START */
inline float easeInBounce(float start, float end, float value)
{
	end -= start;
	float d = 1;
	return end - easeOutBounce(0, end, d - value) + start;
}

/* GFX47 MOD END */

/* GFX47 MOD START */
inline float easeInOutBounce(float start, float end, float value)
{
	end -= start;
	float d = 1;
	if (value < d / 2) return easeInBounce(0, end, value * 2) * 0.5 + start;
	else return easeOutBounce(0, end, value * 2 - d) * 0.5 + end * 0.5 + start;
}
/* GFX47 MOD END */

inline float easeInBack(float start, float end, float value)
{
	end -= start;
	value /= 1;
	float s = 1.70158f;
	return end * (value) * value * ((s + 1) * value - s) + start;
}

inline float easeOutBack(float start, float end, float value)
{
	float s = 1.70158f;
	end -= start;
	value = (value / 1) - 1;
	return end * ((value) * value * ((s + 1) * value + s) + 1) + start;
}

inline float easeInOutBack(float start, float end, float value)
{
	float s = 1.70158f;
	end -= start;
	value /= .5;
	if ((value) < 1)
	{
		s *= (1.525);
		return end / 2 * (value * value * (((s) + 1) * value - s)) + start;
	}
	value -= 2;
	s *= (1.525);
	return end / 2 * ((value) * value * (((s) + 1) * value + s) + 2) + start;
}

inline float punch(float amplitude, float value)
{
	float s = 9;
	if (value == 0)
	{
		return 0;
	}
	if (value == 1)
	{
		return 0;
	}
	float period = 1 * 0.3;
	s = period / (2 * PI) * asin(0);
	return (amplitude * pow(2, -10 * value) * sin((value * 1 - s) * (2 * PI) / period));
}

/* GFX47 MOD START */
inline float easeInElastic(float start, float end, float value)
{
	end -= start;

	float d = 1;
	float p = d * .3;
	float s = 0;
	float a = 0;

	if (value == 0) return start;

	if ((value /= d) == 1) return start + end;

	if (a == 0 || a < abs(end))
	{
		a = end;
		s = p / 4;
	}
	else
	{
		s = p / (2 * PI) * asin(end / a);
	}

	return -(a * pow(2, 10 * (value -= 1)) * sin((value * d - s) * (2 * PI) / p)) + start;
}
/* GFX47 MOD END */

/* GFX47 MOD START */
//inline float elastic(float start, float end, float value){
inline float easeOutElastic(float start, float end, float value)
{
	/* GFX47 MOD END */
	//Thank you to rafael.marteleto for fixing this as a port over from Pedro's UnityTween
	end -= start;

	float d = 1;
	float p = d * .3;
	float s = 0;
	float a = 0;

	if (value == 0) return start;

	if ((value /= d) == 1) return start + end;

	if (a == 0 || a < abs(end))
	{
		a = end;
		s = p / 4;
	}
	else
	{
		s = p / (2 * PI) * asin(end / a);
	}

	return (a * pow(2, -10 * value) * sin((value * d - s) * (2 * PI) / p) + end + start);
}

/* GFX47 MOD START */
inline float easeInOutElastic(float start, float end, float value)
{
	end -= start;

	float d = 1;
	float p = d * .3;
	float s = 0;
	float a = 0;

	if (value == 0) return start;

	if ((value /= d / 2) == 2) return start + end;

	if (a == 0 || a < abs(end))
	{
		a = end;
		s = p / 4;
	}
	else
	{
		s = p / (2 * PI) * asin(end / a);
	}

	if (value < 1) return -0.5 * (a * pow(2, 10 * (value -= 1)) * sin((value * d - s) * (2 * PI) / p)) + start;
	return a * pow(2, -10 * (value -= 1)) * sin((value * d - s) * (2 * PI) / p) * 0.5 + end + start;
}

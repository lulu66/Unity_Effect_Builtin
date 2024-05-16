#ifndef MARBLEBG
#define MARBLEBG
#include "RemapFunctions.cginc"

half _MarbleMoveVelocity;
half _MarbleRotateVelocity;
half _MarbleMoveDirX;
half _MarbleMoveDirY;
half _MarbleAngle;
half _FullMarbleAngle;
half4 _MarbleColor;
sampler2D _MainTex;
float4 _MainTex_TexelSize;
sampler2D _BgTex;
// sampler2D _ValueNoise;

float _FlipScale;

//half _BlurStrength;
half _GapOffsetX;
half _GapOffsetY;
half _RandomInfo;

// float _NoiseScale;


half _RowCount;
half _ColumnCount;
half _MarbleScale;
fixed _MarbleScaleDiff;


//x : AxisOffset  y : timeSinceLevelLoad
float2 _AnimaControl;


//sky background
half4 _BackgroundColor;
half4 _OriginalStarColor;
half4 _CloudColor;
half4 _SecondCloudColor;

sampler2D _CloudNoiseTexture;
sampler2D _SecondCloudNoiseTexture;

half _StarUVTilling;
half _FirstCloudTilling;
half _SecondCloudTilling;
half _StarFlowSpeed;
half _CloudSpeedX;
half _CloudSpeedY;
half _SecondCloudSpeedX;
half _SecondCloudSpeedY;
half _MaxBrightness;
half _MinBrightness;

//sky 2
sampler2D _StarNoiseMap;
half _FlySpeed;
half4 _StarColor;
float _GlobalTime;
float _Duration;
half _StarShape2;
half _StarShape1;
half _StarSpeed;
half _Opacity;
half _StarBrightness;

//end sky background

#include "EsShaders_EaseUtils.cginc"


half2 rotateUV(half2 uv, float rotation, half2 scaledCenter)
{
	uv -= scaledCenter;
	half startRot = atan2(uv.y, uv.x);
	half dis = length(uv);
	startRot += rotation;
	return half2(
		cos(startRot)*dis,
		sin(startRot) * dis
		) + scaledCenter;
}

half2 rotate2d(half2 uv ,float angle,half2 center)
{
    uv -= center;
    return half2(dot(uv, half2(cos(angle), sin(angle))), dot(uv, half2(-sin(angle), cos(angle)))) + center;
}

float2 rotateDir(float2 dir, float angle)
{
	float radian = radians(angle);
	return rotate2d(dir, radian, float2(0, 0));
}

inline float hash11(float p)
{
	return -1.0 + 2.0 * frac(sin(p) * 43758.5453123);
}

float random(float2 uv)
{
	return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453123);
}

// float2 voronoi( in float2 p)
// {
//     //Floor our float2 and add an offset to create our point
//     float2 tp = floor(p.xy);// + float2(xo, yo);
//     //Calculate the minimum distance for this grid point
//     //Mix in the noise value too!
//     float2 sphereCenterOffset = random(tp);
  
//     return sphereCenterOffset;
// }

// #ifdef ENABLE_FLIP
float Pulse(float t, float Scale)
{
	float tt = saturate(t/1.5);
    float ss = pow(tt,.2)*0.5 + 0.5;
    ss = 1.0 + ss * Scale * sin(tt * 6.2831 * 3.0  - 0.25 * 0.5)*exp(-tt * 4.0);
	return 0.5 + ss * 0.5;
}
// #endif

float4 WithOutMarbleColor(half2 uv)
{
	half4 bgcolor = _MarbleColor * tex2D(_BgTex, uv);
	return bgcolor;
}

half4 WithOutBgColor(half2 uv, half4 bgcolor)
{
    half2 scale = half2(_RowCount, _ColumnCount);
    half2 scaledCenter = 0.5;
    float2 uvPattern = uv * scale;
    uvPattern.x *= _ScreenParams.x / _ScreenParams.y;

    half lengthToCenter = length(uv - half2(0.5, 0.5));

	//四组一循环，防止手机上出现精度问题，同时提供一点随机性
    uvPattern.x += fmod(_MarbleMoveVelocity * _MarbleMoveDirX * _Time.x,2e4);
    uvPattern.y += fmod(_MarbleMoveVelocity * _MarbleMoveDirY * _Time.x,2e4);

    float idY = fmod(floor(uvPattern.y), 4);
    float randomValY = hash11(idY);
    float idX = fmod(floor(uvPattern.x), 4);
    float randomValX = hash11(idX); //[-1,1]


    uvPattern = frac(uvPattern);

	//计算不同方格id中图案的uv的随机偏移
	uvPattern.x += randomValY * _GapOffsetX;
    uvPattern.y += randomValX * _GapOffsetY;

	//随机旋转角度
    half roateRandom = _RandomInfo * randomValX;
	//图案还有个随时间的自旋转
    uvPattern = rotateUV(uvPattern, roateRandom + _MarbleRotateVelocity * _Time.x + _MarbleAngle, 0.5);

	//图案缩放
	//方格Id拆分为奇偶两种id(0或者1)
    int lowerBit = idX + idY - (((int) (idX + idY) >> 1) << 1);

	//跳变缩放图案
	float p = Pulse(fmod(_Time.y, 2.5) * lowerBit, _FlipScale);

	half scaleRandom = p + lerp(0.1, 1.5, lowerBit) * _MarbleScaleDiff;//sin((lowerBit + 0.5) * UNITY_PI);

	half marbleScale = _MarbleScale + scaleRandom ;

    half scaleMarble = marbleScale;
    uvPattern = scaleMarble * (uvPattern - scaledCenter) + scaledCenter;

	//根据奇偶性采样两种图案
	half2 patternMaskRG = tex2D(_MainTex, uvPattern).rg;
	half patternMask = lerp(patternMaskRG.r, patternMaskRG.g, lowerBit);
    half4 partternColor = _MarbleColor * patternMask;
	
	bgcolor.rgb = lerp(bgcolor.rgb, partternColor.rgb, lengthToCenter * _MarbleColor.a * partternColor.a);
    return bgcolor;
}

float LinearGradual(float2 uv, float angle, float centerPosX, float centerPosY)
{
	float2 dir = rotateDir(float2(1, 0), angle);
	float2 uvLinear = uv;
	float2 vertexPos1 = float2(0, 0);
	float2 vertexPos2 = float2(0, 1);
	float2 vertexPos3 = float2(1, 0);
	float2 vertexPos4 = float2(1, 1);
	float maxLen = 0;
	float2 beginPos = float2(centerPosX, centerPosY);
	maxLen = max(maxLen, dot(dir, vertexPos1 - beginPos));
	maxLen = max(maxLen, dot(dir, vertexPos2 - beginPos));
	maxLen = max(maxLen, dot(dir, vertexPos3 - beginPos));
	maxLen = max(maxLen, dot(dir, vertexPos4 - beginPos));
	float f;
	f = clamp(dot(dir, uvLinear - beginPos), 0, maxLen);
	return Remap(f, 0, maxLen, 0, 1);
}

float RadialGradual(float2 uv, float angle, float centerPosX, float centerPosY)
{
	//radial direction
	float aspect = _ScreenParams.y / _ScreenParams.x;
	float2 uvRad = uv - 0.5;
	uvRad.x /= aspect;
	//return half4(uvRad, 0, 1);
	centerPosX -= 0.5;
	centerPosY -= 0.5;
	centerPosX /= aspect;
	float2 center = float2(centerPosX, centerPosY);
	float lenX = 0.5/aspect;
	float lenY = 0.5;

	float maxLen = length(float2(-lenX, -lenY) - center);
	maxLen = max(maxLen, length(float2(-lenX, lenY) - center));
	maxLen = max(maxLen, length(float2(lenX, lenY) - center));
	maxLen = max(maxLen, length(float2(lenX, -lenY) - center));
	
	float f;
	f = (length(uvRad - center));
	return Remap(f, 0, maxLen, 0, 1);
}


float CircleGradual(float2 uv, float radius, float gradual, float centerPosX, float centerPosY)
{
    float aspect = _ScreenParams.y / _ScreenParams.x;
    float2 uvRad = uv - 0.5;
    uvRad.x /= aspect;
	//return half4(uvRad, 0, 1);
    centerPosX -= 0.5;
    centerPosY -= 0.5;
    centerPosX /= aspect;
    float2 dist = uvRad - float2(centerPosX, centerPosY);
    return 1. - smoothstep(radius - (radius * gradual),
                         radius,
                         dot(dist, dist) * 4.0);
}


float4 BackgroundColorBlend(float4 colorBegin, float4 colorEnd, float f)
{
	float4 bgcolor = 0;
	//f : Linear, Color : sRGB
	colorBegin.rgb = LinearToGammaSpace(colorBegin.rgb);
	colorEnd.rgb = LinearToGammaSpace(colorEnd.rgb);
	bgcolor = lerp(colorBegin, colorEnd, f);
	bgcolor.rgb = GammaToLinearSpace(bgcolor.rgb);
	return bgcolor;
}


#endif
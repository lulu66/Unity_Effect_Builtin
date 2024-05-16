// Upgrade NOTE: replaced 'defined LINEAR_GRADUAL' with 'defined (LINEAR_GRADUAL)'

Shader "EsShaders/UI/GradualWithMarbleBgTransparency"
{
	Properties
	{
		[Header(Background Settings)]
		[Space(10)]
		[KeywordEnum(LINEAR,RADIAL)] _GradualMode("背景渐变模式", int) = 0
		_Angle("背景旋转角度", Range(0,360)) = 0
		_CenterPosX("X轴中心位置", Range(0, 1)) = 0.5
		_CenterPosY("Y轴中心位置", Range(0, 1)) = 0.5
		[HDR]_ColorBegin("渐变颜色1", Color) = (0, 0, 0, 1)
		[HDR]_ColorEnd("渐变颜色2", Color) = (1, 1, 1, 1)

		[Header(Pattern Base Settings)]
		[Space(10)]
		_MainTex("图案贴图(支持RG两个通道放不同图案)", 2D) = "white" {}
		_MarbleColor("图案颜色", Color) = (0,0,0,1)
		_RowCount("图案行数", Int) = 1
		_ColumnCount("图案列数", Int) = 1

		[Header(Pattern Move Settings)]
		[Space(10)]
		_MarbleMoveVelocity("图案运动速度", Range(0,10)) = 1
		_MarbleMoveDirX("图案X轴运动方向", Range(-1,1)) = 1
		_MarbleMoveDirY("图案Y轴运动方向", Range(-1,1)) = 1
		_GapOffsetX("X轴方向图案UV偏移", Range(-0.5, 0.5)) = 0
		_GapOffsetY("Y轴方向图案UV偏移", Range(-0.5, 0.5)) = 0

		[Header(Pattern Rotate Settings)]
		[Space(10)]
		_RandomInfo("图案随机旋转角度", Range(-4,4)) = 0
		_MarbleAngle("图案旋转角度", Range(-4,4)) = 0
		_MarbleRotateVelocity("图案随时间的自旋转速度", Range(-10,10)) = 1

		[Header(Pattern Scale Settings)]
		[Space(10)]
		_MarbleScale("图案整体缩放", Range(0,4)) = 1
		_MarbleScaleDiff("图案缩放差异", Range(-5,5)) = 1
		_FlipScale("图案跳变缩放程度", Range(0,5)) = 0.5
		
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15
	}

	SubShader
	{
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

		Pass
		{
			CGPROGRAM
			#pragma shader_feature_local LINEAR_GRADUAL RADIAL_GRADUAL
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "EsShaders_MarbleBg.cginc"
			
			half _Angle;
			half _CenterPosX;
			half _CenterPosY;
			//float _Range;
			half4 _ColorBegin;
			half4 _ColorEnd;
	
			struct appdata
			{
				float4 vertex : POSITION;
				half2 uv     : TEXCOORD0;
				half4 color : COLOR;
			};
	
			struct v2f
			{
				half2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				half4 color : TEXCOORD1;
			};
	
	
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = v.vertex;
				o.vertex.xy = o.vertex.xy * 2;
				o.vertex.z = 0.9999;
			#if defined(UNITY_REVERSED_Z)
				o.vertex.z = 1 - o.vertex.z;
			#endif
				o.uv = o.vertex.xy * 0.5 + 0.5;
				#if UNITY_UV_STARTS_AT_TOP
				if (_MainTex_TexelSize.y < 0)
					o.uv.y = 1 - o.uv.y;
				#endif
				o.color = v.color;
				return o;
			}
	
			fixed4 frag(v2f i) : SV_Target
			{
				if (_ProjectionParams.x < 0)
				{
					i.uv.y = 1 - i.uv.y;
				}
				half4 bgcolor;
				half f = 0;

				//linear direction
			#if defined (LINEAR_GRADUAL)
				f = LinearGradual(i.uv, _Angle, _CenterPosX, _CenterPosY);
				
			#elif defined (RADIAL_GRADUAL)
				f = RadialGradual(i.uv, _Angle, _CenterPosX, _CenterPosY);

			#else
				f = 0;
			#endif
				
				bgcolor = BackgroundColorBlend(_ColorBegin, _ColorEnd, f);

				bgcolor = WithOutBgColor(i.uv, bgcolor);

				bgcolor *= i.color;
				return bgcolor;
			}
			ENDCG
		}
	}
}

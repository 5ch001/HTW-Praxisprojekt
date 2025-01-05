// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UModeler/WC/CandleLight"
{
	Properties
	{
		_MaskTex("MaskTex", 2D) = "white" {}
		_ColorTex("ColorTex", 2D) = "white" {}
		_NormalTex("NormalTex", 2D) = "bump" {}
		[HDR]_Color("Color", Color) = (1,0,0,0)
		_Intensity("Intensity", Float) = 5
		_Range("Range", Range( 0 , 1)) = 0.51
		_Contrast("Contrast", Float) = 0
		_Speed("Speed", Float) = 0
		_NoiseTexture("NoiseTexture", 2D) = "white" {}
		_CandleHeight("CandleHeight", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform sampler2D _ColorTex;
		uniform float4 _ColorTex_ST;
		uniform sampler2D _MaskTex;
		SamplerState sampler_MaskTex;
		uniform float4 _MaskTex_ST;
		uniform sampler2D _CandleHeight;
		uniform float _Range;
		uniform float _Contrast;
		uniform sampler2D _NoiseTexture;
		uniform float _Speed;
		uniform float4 _Color;
		uniform float _Intensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalTex, uv_NormalTex ) );
			float2 uv_ColorTex = i.uv_texcoord * _ColorTex_ST.xy + _ColorTex_ST.zw;
			o.Albedo = tex2D( _ColorTex, uv_ColorTex ).rgb;
			float2 uv_MaskTex = i.uv_texcoord * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float4 tex2DNode11 = tex2D( _MaskTex, uv_MaskTex );
			float3 ase_worldPos = i.worldPos;
			float3 objToWorld17 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 appendResult41 = (float2(saturate( pow( ( distance( ase_worldPos , objToWorld17 ) + _Range ) , _Contrast ) ) , 0.0));
			float2 temp_cast_1 = (( frac( ( ( objToWorld17.x + objToWorld17.y ) + objToWorld17.z ) ) + ( _Time.y * _Speed ) )).xx;
			o.Emission = ( tex2DNode11.g * ( ( tex2D( _CandleHeight, appendResult41 ) * tex2D( _NoiseTexture, temp_cast_1 ) ) * ( _Color * _Intensity ) ) ).rgb;
			o.Smoothness = tex2DNode11.a;
			o.Occlusion = tex2DNode11.g;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18701
1096;152;2253;1141;993.8696;262.4531;1;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-2923.787,431.6776;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;17;-3067.787,691.6776;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-2678.422,601.6721;Inherit;False;Property;_Range;Range;5;0;Create;True;0;0;False;0;False;0.51;0.68;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;18;-2690.787,422.6776;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2334.534,629.2946;Inherit;False;Property;_Contrast;Contrast;6;0;Create;True;0;0;False;0;False;0;7.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-2319.339,530.1022;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-2313.166,733.0834;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-2113.383,742.6315;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;29;-2178.339,539.1023;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2215.51,973.9692;Inherit;False;Property;_Speed;Speed;7;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;-2184.251,858.991;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;23;-2006.002,537.95;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;53;-1963.383,755.6313;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1985.251,865.991;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-1835.25,540.8522;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-1821.244,755.149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-1663.696,727.1923;Inherit;True;Property;_NoiseTexture;NoiseTexture;8;0;Create;True;0;0;False;0;False;-1;db9e86714a9eda04dbb070b089662f41;db9e86714a9eda04dbb070b089662f41;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-1128.189,1003.342;Inherit;False;Property;_Intensity;Intensity;4;0;Create;True;0;0;False;0;False;5;13.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-1676.491,511.2057;Inherit;True;Property;_CandleHeight;CandleHeight;9;0;Create;True;0;0;False;0;False;-1;510453eefe9e30542bb5c8666668c729;510453eefe9e30542bb5c8666668c729;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-1121.162,813.8401;Inherit;False;Property;_Color;Color;3;1;[HDR];Create;True;0;0;False;0;False;1,0,0,0;0.7490196,0.2078431,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-893.3768,843.6476;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1237.115,657.3845;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.01,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-729.8106,666.4728;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.01,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;-744,21;Inherit;True;Property;_MaskTex;MaskTex;0;0;Create;True;0;0;False;0;False;11;866d0c7b4ee920d45926c3ae7977cfe0;866d0c7b4ee920d45926c3ae7977cfe0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-738,252;Inherit;True;Property;_NormalTex;NormalTex;2;0;Create;True;0;0;False;0;False;13;fbd14f0c24e9f664392d7a0d1c1464e6;fbd14f0c24e9f664392d7a0d1c1464e6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-741,-195;Inherit;True;Property;_ColorTex;ColorTex;1;0;Create;True;0;0;False;0;False;12;756104ccb135f4146b689262aaac6ba5;756104ccb135f4146b689262aaac6ba5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-242.4838,314.5471;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;57;138,-22;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UModeler/WC/CandleLight;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;27;0;18;0
WireConnection;27;1;28;0
WireConnection;51;0;17;1
WireConnection;51;1;17;2
WireConnection;52;0;51;0
WireConnection;52;1;17;3
WireConnection;29;0;27;0
WireConnection;29;1;30;0
WireConnection;23;0;29;0
WireConnection;53;0;52;0
WireConnection;44;0;43;0
WireConnection;44;1;46;0
WireConnection;41;0;23;0
WireConnection;54;0;53;0
WireConnection;54;1;44;0
WireConnection;39;1;54;0
WireConnection;40;1;41;0
WireConnection;21;0;15;0
WireConnection;21;1;25;0
WireConnection;45;0;40;0
WireConnection;45;1;39;0
WireConnection;20;0;45;0
WireConnection;20;1;21;0
WireConnection;55;0;11;2
WireConnection;55;1;20;0
WireConnection;57;0;12;0
WireConnection;57;1;13;0
WireConnection;57;2;55;0
WireConnection;57;4;11;4
WireConnection;57;5;11;2
ASEEND*/
//CHKSM=8A38702BB2D46DC46A47CED3FC8008F76BD19526
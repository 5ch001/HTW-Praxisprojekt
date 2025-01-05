// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UModeler/WC/RotateSoup"
{
	Properties
	{
		_ColorB("ColorB", Color) = (0.3834626,0.5188679,0,0)
		_ColorA("ColorA", Color) = (0,0.2324269,0.5176471,0)
		_Intensity("Intensity", Float) = 0
		_Range("Range", Float) = 0.8
		_Contrast("Contrast", Float) = 16.2
		_RotateBlur_Speed("RotateBlur_Speed", Float) = -0.82
		_RotateNoise_Speed("RotateNoise_Speed", Float) = 0
		_RotateBlur_Tex("RotateBlur_Tex", 2D) = "white" {}
		_RotateNoise_Tex("RotateNoise_Tex", 2D) = "white" {}
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
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _ColorA;
		uniform float4 _ColorB;
		uniform sampler2D _RotateBlur_Tex;
		SamplerState sampler_RotateBlur_Tex;
		uniform float _RotateBlur_Speed;
		uniform sampler2D _RotateNoise_Tex;
		SamplerState sampler_RotateNoise_Tex;
		uniform float _RotateNoise_Speed;
		uniform float _Range;
		uniform float _Contrast;
		uniform float _Intensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float cos21 = cos( ( _Time.y * _RotateBlur_Speed ) );
			float sin21 = sin( ( _Time.y * _RotateBlur_Speed ) );
			float2 rotator21 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos21 , -sin21 , sin21 , cos21 )) + float2( 0.5,0.5 );
			float4 tex2DNode15 = tex2D( _RotateBlur_Tex, rotator21 );
			float4 lerpResult47 = lerp( _ColorA , _ColorB , tex2DNode15.r);
			float cos29 = cos( ( _Time.y * _RotateNoise_Speed ) );
			float sin29 = sin( ( _Time.y * _RotateNoise_Speed ) );
			float2 rotator29 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos29 , -sin29 , sin29 , cos29 )) + float2( 0.5,0.5 );
			o.Emission = ( lerpResult47 + ( lerpResult47 * ( saturate( ( pow( ( ( tex2DNode15.r * tex2D( _RotateNoise_Tex, rotator29 ).r ) + _Range ) , _Contrast ) * ( 1.0 - distance( i.uv_texcoord , float2( 0.5,0.5 ) ) ) ) ) * _Intensity ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
}
/*ASEBEGIN
Version=18701
1096;152;2253;1141;4312.494;1358.117;6.143441;True;False
Node;AmplifyShaderEditor.RangedFloatNode;26;-3509.122,476.3286;Inherit;False;Property;_RotateBlur_Speed;RotateBlur_Speed;5;0;Create;True;0;0;False;0;False;-0.82;-0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-3666.122,278.3287;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-3513.767,757.4957;Inherit;False;Property;_RotateNoise_Speed;RotateNoise_Speed;6;0;Create;True;0;0;False;0;False;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-3208.122,75.32867;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-3330.122,382.3287;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-3364.767,648.4958;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;29;-3015.267,536.9958;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;21;-2979.122,78.32867;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;28;-2740.267,511.9958;Inherit;True;Property;_RotateNoise_Tex;RotateNoise_Tex;8;0;Create;True;0;0;False;0;False;-1;82ab9b1ecd0b2be499af304bb1be2488;82ab9b1ecd0b2be499af304bb1be2488;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-2773.122,59.32867;Inherit;True;Property;_RotateBlur_Tex;RotateBlur_Tex;7;0;Create;True;0;0;False;0;False;-1;6c8b3a93b9f3e9f4fbee9df27b30992d;6c8b3a93b9f3e9f4fbee9df27b30992d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;41;-2527.886,1086.004;Inherit;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-2348.268,368.9959;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-2508.885,924.0036;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-2233.237,576.2842;Inherit;False;Property;_Range;Range;3;0;Create;True;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1926.237,567.2842;Inherit;False;Property;_Contrast;Contrast;4;0;Create;True;0;0;False;0;False;16.2;16.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;39;-2206.886,1011.004;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-1938.237,415.2844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;33;-1742.428,428.9959;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-2007.886,1001.004;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1509.162,595.1149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1207.283,959.3284;Inherit;False;Property;_Intensity;Intensity;2;0;Create;True;0;0;False;0;False;0;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;34;-1416.428,442.9959;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-1311.748,109.2083;Inherit;False;Property;_ColorB;ColorB;0;0;Create;True;0;0;False;0;False;0.3834626,0.5188679,0,0;0.3538973,0.9137255,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;48;-1323.597,-185.4976;Inherit;False;Property;_ColorA;ColorA;1;0;Create;True;0;0;False;0;False;0,0.2324269,0.5176471,0;0.09355348,0.1603774,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;47;-878.1624,6.746582;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1001.284,506.3286;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-587.898,416.4535;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-183.7478,144.2083;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;56;651.7512,206.7043;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;UModeler/WC/RotateSoup;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;23;0
WireConnection;25;1;26;0
WireConnection;31;0;23;0
WireConnection;31;1;30;0
WireConnection;29;0;27;0
WireConnection;29;2;31;0
WireConnection;21;0;27;0
WireConnection;21;2;25;0
WireConnection;28;1;29;0
WireConnection;15;1;21;0
WireConnection;32;0;15;1
WireConnection;32;1;28;1
WireConnection;39;0;38;0
WireConnection;39;1;41;0
WireConnection;35;0;32;0
WireConnection;35;1;36;0
WireConnection;33;0;35;0
WireConnection;33;1;37;0
WireConnection;40;0;39;0
WireConnection;42;0;33;0
WireConnection;42;1;40;0
WireConnection;34;0;42;0
WireConnection;47;0;48;0
WireConnection;47;1;12;0
WireConnection;47;2;15;1
WireConnection;16;0;34;0
WireConnection;16;1;14;0
WireConnection;18;0;47;0
WireConnection;18;1;16;0
WireConnection;19;0;47;0
WireConnection;19;1;18;0
WireConnection;56;2;19;0
ASEEND*/
//CHKSM=1F33FB2DD28EE3FC568D8C7AF09DAA7C2F282627
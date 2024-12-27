// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UModeler/WC/CandleFire"
{
	Properties
	{
		_Intensity("Intensity", Float) = 0
		_Offset("Offset", Range( 0 , 1)) = 0
		_Range("Range", Float) = 0
		_Contrast("Contrast", Float) = 0
		_Speed("Speed", Float) = 1
		_ColorA("ColorA", Color) = (0,0,0,0)
		_ColorB("ColorB", Color) = (0,0,0,0)
		_Offset_Tex("Offset_Tex", 2D) = "gray" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Offset_Tex;
		SamplerState sampler_Offset_Tex;
		uniform float _Speed;
		uniform float _Offset;
		uniform float4 _ColorB;
		uniform float4 _ColorA;
		uniform float _Range;
		uniform float _Contrast;
		uniform float _Intensity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_24_0 = ( _Time.y * _Speed );
			float3 objToWorld37 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 uv_TexCoord14 = v.texcoord.xy * float2( 0.05,0.05 );
			float2 temp_output_41_0 = ( frac( ( ( objToWorld37.x + objToWorld37.y ) + objToWorld37.z ) ) + uv_TexCoord14 );
			float2 panner15 = ( temp_output_24_0 * float2( 0,-1 ) + temp_output_41_0);
			float2 panner16 = ( temp_output_24_0 * float2( 0,-0.8 ) + temp_output_41_0);
			float3 appendResult21 = (float3(( ( tex2Dlod( _Offset_Tex, float4( panner15, 0, 0.0) ).r + -0.5 ) * 2.0 ) , 0.0 , ( ( tex2Dlod( _Offset_Tex, float4( panner16, 0, 0.0) ).g + -0.5 ) * 2.0 )));
			v.vertex.xyz += ( ( appendResult21 * _Offset ) * v.color.r );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 lerpResult30 = lerp( _ColorB , _ColorA , saturate( pow( ( i.vertexColor.r + _Range ) , _Contrast ) ));
			o.Emission = ( lerpResult30 * _Intensity ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
}
/*ASEBEGIN
Version=18701
246;152;2253;1141;994.203;471.7012;1;True;False
Node;AmplifyShaderEditor.TransformPositionNode;37;-2695.592,86.80525;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-2443.592,116.8053;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-2302.593,139.8054;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;40;-2137.593,131.8054;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-2285.156,260.7159;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.05,0.05;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;11;-1990.156,563.7159;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2064.084,743.9091;Inherit;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;False;1;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-1783.854,194.822;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1783.911,587.0757;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;15;-1521.626,300.0301;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;16;-1520.626,507.0301;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.8;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;10;-904.4587,190.0503;Inherit;True;Property;_Offset_Tex;Offset_Tex;7;0;Create;True;0;0;False;0;False;10;c9d0d79813912e14cb0b5b21b2e946e9;c9d0d79813912e14cb0b5b21b2e946e9;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-925.8603,428.1904;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;False;10;c9d0d79813912e14cb0b5b21b2e946e9;c9d0d79813912e14cb0b5b21b2e946e9;True;0;False;white;Auto;False;Instance;10;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-1371.383,-16.33202;Inherit;False;Property;_Range;Range;2;0;Create;True;0;0;False;0;False;0;0.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;23;-1440.628,803.6132;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-480.1796,445.5699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-489.1796,253.5699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1013.622,-63.93224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1165.176,92.19781;Inherit;False;Property;_Contrast;Contrast;3;0;Create;True;0;0;False;0;False;0;3.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;33;-801.6982,-67.57634;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-308.1796,445.5699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-317.1796,253.5699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;29;-489.123,-352.3771;Inherit;False;Property;_ColorB;ColorB;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,0.5762761,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-285.5531,601.2441;Inherit;False;Property;_Offset;Offset;1;0;Create;True;0;0;False;0;False;0;0.14;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-124.1796,257.5699;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;34;-619.4221,-64.45122;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-490.0121,-536.2626;Inherit;False;Property;_ColorA;ColorA;5;0;Create;True;0;0;False;0;False;0,0,0,0;1,0.461351,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-156.5,-77;Inherit;False;Property;_Intensity;Intensity;0;0;Create;True;0;0;False;0;False;0;30.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;-170.7012,-410.4833;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;62.4469,297.2441;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;294.8542,253.236;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;248.8658,-322.0243;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-1498.299,121.8583;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;42;650,54;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;UModeler/WC/CandleFire;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;0;37;1
WireConnection;38;1;37;2
WireConnection;39;0;38;0
WireConnection;39;1;37;3
WireConnection;40;0;39;0
WireConnection;41;0;40;0
WireConnection;41;1;14;0
WireConnection;24;0;11;0
WireConnection;24;1;25;0
WireConnection;15;0;41;0
WireConnection;15;1;24;0
WireConnection;16;0;41;0
WireConnection;16;1;24;0
WireConnection;10;1;15;0
WireConnection;13;1;16;0
WireConnection;19;0;13;2
WireConnection;17;0;10;1
WireConnection;32;0;23;1
WireConnection;32;1;35;0
WireConnection;33;0;32;0
WireConnection;33;1;36;0
WireConnection;20;0;19;0
WireConnection;18;0;17;0
WireConnection;21;0;18;0
WireConnection;21;2;20;0
WireConnection;34;0;33;0
WireConnection;30;0;29;0
WireConnection;30;1;7;0
WireConnection;30;2;34;0
WireConnection;26;0;21;0
WireConnection;26;1;28;0
WireConnection;22;0;26;0
WireConnection;22;1;23;1
WireConnection;8;0;30;0
WireConnection;8;1;9;0
WireConnection;42;2;8;0
WireConnection;42;11;22;0
ASEEND*/
//CHKSM=50DF44CD7C61502867590CF6F9DCBE73F8758EFB
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UModeler/WC/PotionPosColor"
{
	Properties
	{
		_Mask_Tex("Mask_Tex", 2D) = "white" {}
		_Color_Tex("Color_Tex", 2D) = "white" {}
		_Normal_Tex("Normal_Tex", 2D) = "bump" {}
		_TintColor("TintColor", Color) = (1,1,1,0)
		_Cork_Saturation("Cork_Saturation", Range( 0 , 1)) = 0.1
		_Bottle_Saturation("Bottle_Saturation", Range( 0 , 1)) = 0.1
		_CorkBrightRange("CorkBrightRange", Range( 0 , 1)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal_Tex;
		uniform float4 _Normal_Tex_ST;
		uniform sampler2D _Color_Tex;
		uniform float4 _Color_Tex_ST;
		uniform float _Bottle_Saturation;
		uniform float4 _TintColor;
		uniform sampler2D _Mask_Tex;
		SamplerState sampler_Mask_Tex;
		uniform float4 _Mask_Tex_ST;
		uniform float _Cork_Saturation;
		uniform float _CorkBrightRange;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal_Tex = i.uv_texcoord * _Normal_Tex_ST.xy + _Normal_Tex_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal_Tex, uv_Normal_Tex ) );
			float2 uv_Color_Tex = i.uv_texcoord * _Color_Tex_ST.xy + _Color_Tex_ST.zw;
			float3 objToWorld14 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float temp_output_17_0 = frac( ( ( objToWorld14.x + objToWorld14.y ) + objToWorld14.z ) );
			float3 hsvTorgb29 = HSVToRGB( float3(temp_output_17_0,_Bottle_Saturation,1.0) );
			float2 uv_Mask_Tex = i.uv_texcoord * _Mask_Tex_ST.xy + _Mask_Tex_ST.zw;
			float4 lerpResult30 = lerp( ( float4( hsvTorgb29 , 0.0 ) * _TintColor ) , float4( 1,1,1,0 ) , tex2D( _Mask_Tex, uv_Mask_Tex ).b);
			float3 hsvTorgb19 = HSVToRGB( float3(temp_output_17_0,_Cork_Saturation,1.0) );
			float4 lerpResult22 = lerp( lerpResult30 , float4( saturate( ( hsvTorgb19 + _CorkBrightRange ) ) , 0.0 ) , i.vertexColor.r);
			o.Albedo = ( tex2D( _Color_Tex, uv_Color_Tex ) * lerpResult22 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18701
1096;152;2253;1141;3057.052;1268.764;2.734596;True;False
Node;AmplifyShaderEditor.TransformPositionNode;14;-2725.665,576.626;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-2437.664,608.626;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-2266.097,638.1669;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;17;-2116.097,651.1658;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2283.456,745.4746;Inherit;False;Property;_Cork_Saturation;Cork_Saturation;4;0;Create;True;0;0;False;0;False;0.1;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2265.967,1069.055;Inherit;False;Property;_Bottle_Saturation;Bottle_Saturation;5;0;Create;True;0;0;False;0;False;0.1;0.36;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;29;-1924.8,1028.021;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;20;-1895.32,1197.478;Inherit;False;Property;_TintColor;TintColor;3;0;Create;True;0;0;False;0;False;1,1,1,0;1,0.9047491,0.682353,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.HSVToRGBNode;19;-1991.506,668.1848;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;27;-2045.06,830.2643;Inherit;False;Property;_CorkBrightRange;CorkBrightRange;6;0;Create;True;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-2272.184,46.93833;Inherit;True;Property;_Mask_Tex;Mask_Tex;0;0;Create;True;0;0;False;0;False;11;1607212386e63bf459a6e602147a3729;1607212386e63bf459a6e602147a3729;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1637.803,1028.132;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1759.471,706.3;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;24;-1482.733,578.0869;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;-1469.84,930.8872;Inherit;False;3;0;COLOR;1,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;25;-1624.833,704.4379;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;12;-1198.957,-330.7225;Inherit;True;Property;_Color_Tex;Color_Tex;1;0;Create;True;0;0;False;0;False;12;cc7bea40577a0ab4d90f3d64e013455f;cc7bea40577a0ab4d90f3d64e013455f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;-1056.202,764.5721;Inherit;False;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-552.1801,573.8664;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-1219.052,318.0465;Inherit;True;Property;_Normal_Tex;Normal_Tex;2;0;Create;True;0;0;False;0;False;13;d7466e4759fa18a4f8f7d92c62408d52;d7466e4759fa18a4f8f7d92c62408d52;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;31;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UModeler/WC/PotionPosColor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;14;1
WireConnection;15;1;14;2
WireConnection;16;0;15;0
WireConnection;16;1;14;3
WireConnection;17;0;16;0
WireConnection;29;0;17;0
WireConnection;29;1;28;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;21;0;29;0
WireConnection;21;1;20;0
WireConnection;26;0;19;0
WireConnection;26;1;27;0
WireConnection;30;0;21;0
WireConnection;30;2;11;3
WireConnection;25;0;26;0
WireConnection;22;0;30;0
WireConnection;22;1;25;0
WireConnection;22;2;24;1
WireConnection;23;0;12;0
WireConnection;23;1;22;0
WireConnection;31;0;23;0
WireConnection;31;1;13;0
ASEEND*/
//CHKSM=3228D9B913284CFC0D07C6420D91CBEB8098A2B5
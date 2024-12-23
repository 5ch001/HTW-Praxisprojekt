// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UModeler/WC/PosBasedColor"
{
	Properties
	{
		_ColorTex("ColorTex", 2D) = "white" {}
		_MaskTex("MaskTex", 2D) = "white" {}
		_NormalTex("NormalTex", 2D) = "bump" {}
		_TintColor("TintColor", Color) = (1,1,1,0)
		_Saturation("Saturation", Range( 0 , 1)) = 0.1
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

		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform sampler2D _ColorTex;
		uniform float4 _ColorTex_ST;
		uniform float _Saturation;
		uniform float4 _TintColor;
		uniform sampler2D _MaskTex;
		SamplerState sampler_MaskTex;
		uniform float4 _MaskTex_ST;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalTex, uv_NormalTex ) );
			float2 uv_ColorTex = i.uv_texcoord * _ColorTex_ST.xy + _ColorTex_ST.zw;
			float3 objToWorld25 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 hsvTorgb30 = HSVToRGB( float3(frac( ( ( objToWorld25.x + objToWorld25.y ) + objToWorld25.z ) ),_Saturation,1.0) );
			float4 lerpResult33 = lerp( float4( 1,1,1,0 ) , ( float4( hsvTorgb30 , 0.0 ) * _TintColor ) , saturate( pow( ( i.vertexColor.r + 0.9 ) , 38.2 ) ));
			o.Albedo = ( tex2D( _ColorTex, uv_ColorTex ) * lerpResult33 ).rgb;
			float2 uv_MaskTex = i.uv_texcoord * _MaskTex_ST.xy + _MaskTex_ST.zw;
			float4 tex2DNode12 = tex2D( _MaskTex, uv_MaskTex );
			o.Metallic = tex2DNode12.r;
			o.Smoothness = tex2DNode12.a;
			o.Occlusion = tex2DNode12.g;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18701
-1466;117;2253;1137;1719.204;165.4362;1.3;True;False
Node;AmplifyShaderEditor.TransformPositionNode;25;-1978.876,953.0082;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1690.876,985.0082;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;35;-1845.511,647.0266;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-1519.309,1014.549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;28;-1369.309,1027.548;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1392.153,1345.189;Inherit;False;Property;_Saturation;Saturation;4;0;Create;True;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1265.719,702.9728;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;30;-1038.066,1264.381;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;36;-976.7188,688.9728;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;38.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-1028.153,1411.189;Inherit;False;Property;_TintColor;TintColor;3;0;Create;True;0;0;False;0;False;1,1,1,0;0.8396226,0.7955647,0.7010057,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-693.1536,1236.189;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;42;-801.7188,694.9728;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1372.527,-101.3427;Inherit;True;Property;_ColorTex;ColorTex;0;0;Create;True;0;0;False;0;False;11;ffe7877669cc80a4bb30bd28438a9daf;ffe7877669cc80a4bb30bd28438a9daf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;33;-636.3976,585.2618;Inherit;False;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-1368.627,150.8573;Inherit;True;Property;_MaskTex;MaskTex;1;0;Create;True;0;0;False;0;False;12;188098727c9720d4fb8173e422b07862;188098727c9720d4fb8173e422b07862;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-1406.327,388.7572;Inherit;True;Property;_NormalTex;NormalTex;2;0;Create;True;0;0;False;0;False;13;23a212c31c2a51b47b8894f9db1de584;23a212c31c2a51b47b8894f9db1de584;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;43;-544.4461,932.4807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-405.1534,368.6894;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;44;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UModeler/WC/PosBasedColor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;25;1
WireConnection;26;1;25;2
WireConnection;27;0;26;0
WireConnection;27;1;25;3
WireConnection;28;0;27;0
WireConnection;38;0;35;1
WireConnection;30;0;28;0
WireConnection;30;1;29;0
WireConnection;36;0;38;0
WireConnection;32;0;30;0
WireConnection;32;1;31;0
WireConnection;42;0;36;0
WireConnection;33;1;32;0
WireConnection;33;2;42;0
WireConnection;43;0;12;3
WireConnection;34;0;11;0
WireConnection;34;1;33;0
WireConnection;44;0;34;0
WireConnection;44;1;13;0
WireConnection;44;3;12;1
WireConnection;44;4;12;4
WireConnection;44;5;12;2
ASEEND*/
//CHKSM=832A179F05219DA2D907AABBC3EB187D837CB984
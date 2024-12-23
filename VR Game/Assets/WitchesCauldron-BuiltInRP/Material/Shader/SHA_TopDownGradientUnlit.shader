// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UModeler/WC/TopDownGradientUnlit"
{
	Properties
	{
		[HDR]_Color_A("Color_A", Color) = (0,0.5200343,1,0)
		[HDR]_Color_B("Color_B", Color) = (0.3745017,0,1,0)
		_Gradient_Range("Gradient_Range", Float) = 0
		_Gradient_Contrast("Gradient_Contrast", Float) = 1
		_Brightness("Brightness", Range( 0 , 3)) = 1
		_Gradient_Offset("Gradient_Offset", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color_B;
		uniform float4 _Color_A;
		uniform float _Gradient_Offset;
		uniform float _Gradient_Range;
		uniform float _Gradient_Contrast;
		uniform float _Brightness;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_cast_0 = (_Gradient_Offset).xx;
			float2 uv_TexCoord7 = i.uv_texcoord + temp_cast_0;
			float4 lerpResult11 = lerp( _Color_B , _Color_A , saturate( pow( ( uv_TexCoord7.y + _Gradient_Range ) , _Gradient_Contrast ) ));
			o.Emission = ( lerpResult11 * _Brightness ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
}
/*ASEBEGIN
Version=18701
978;284;2253;1131;820.615;262.0017;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;17;-2025.5,263;Inherit;False;Property;_Gradient_Offset;Gradient_Offset;5;0;Create;True;0;0;False;0;False;0;0.396;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1718.5,137;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1686.5,320;Inherit;False;Property;_Gradient_Range;Gradient_Range;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1317.5,447;Inherit;False;Property;_Gradient_Contrast;Gradient_Contrast;3;0;Create;True;0;0;False;0;False;1;3.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-1461.5,180;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;13;-994.5,266;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-827.5,-214;Inherit;False;Property;_Color_A;Color_A;0;1;[HDR];Create;True;0;0;False;0;False;0,0.5200343,1,0;0,1,0.9237678,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-637.5,165;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-826.5,-34;Inherit;False;Property;_Color_B;Color_B;1;1;[HDR];Create;True;0;0;False;0;False;0.3745017,0,1,0;0.5433755,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-460.5,-9;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-322.5,591;Inherit;False;Property;_Brightness;Brightness;4;0;Create;True;0;0;False;0;False;1;0.58;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;16.5,106;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;24;232,15;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;UModeler/WC/TopDownGradientUnlit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Front;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;1;17;0
WireConnection;12;0;7;2
WireConnection;12;1;14;0
WireConnection;13;0;12;0
WireConnection;13;1;15;0
WireConnection;16;0;13;0
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;11;2;16;0
WireConnection;20;0;11;0
WireConnection;20;1;23;0
WireConnection;24;2;20;0
ASEEND*/
//CHKSM=5F9EA9A365E4AF4DCD6FCDC2A84F4AF69D8C2DF6
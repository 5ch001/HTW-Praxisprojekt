// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UModeler/WC/BlurPotion"
{
	Properties
	{
		_Distortion("Distortion", Range( -1 , 1)) = 0.4343549
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_BlurIntensity_Near("BlurIntensity_Near", Range( 0 , 0.1)) = 0.01053596
		_BlurIntensity_Far("BlurIntensity_Far", Range( 0 , 0.1)) = 0.01053596
		_BlurIntensity_MaskContrast("BlurIntensity_MaskContrast", Float) = 1
		_BlurIntensity_MaskContrastAdd("BlurIntensity_MaskContrastAdd", Float) = 1
		_sfsfsddf("sfsfsddf", Float) = 0.3764706
		_ColorA("ColorA", Color) = (1,0,0,0)
		_ColorB("ColorB", Color) = (1,0,0,0)
		_T_Potion_D("T_Potion_D", 2D) = "white" {}
		_T_Potion_N("T_Potion_N", 2D) = "bump" {}
		_T_Potion_Mask("T_Potion_Mask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		uniform sampler2D _T_Potion_D;
		uniform float4 _T_Potion_D_ST;
		uniform float4 _ColorA;
		uniform float4 _ColorB;
		uniform sampler2D _T_Potion_Mask;
		SamplerState sampler_T_Potion_Mask;
		uniform float4 _T_Potion_Mask_ST;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _T_Potion_N;
		uniform float4 _T_Potion_N_ST;
		uniform float _Distortion;
		uniform float _BlurIntensity_Near;
		uniform float _BlurIntensity_Far;
		uniform float _sfsfsddf;
		uniform float _BlurIntensity_MaskContrastAdd;
		uniform float _BlurIntensity_MaskContrast;
		uniform float _Smoothness;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_T_Potion_D = i.uv_texcoord * _T_Potion_D_ST.xy + _T_Potion_D_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV162 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode162 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV162, 2.0 ) );
			float4 lerpResult165 = lerp( _ColorA , _ColorB , fresnelNode162);
			float2 uv_T_Potion_Mask = i.uv_texcoord * _T_Potion_Mask_ST.xy + _T_Potion_Mask_ST.zw;
			float4 tex2DNode96 = tex2D( _T_Potion_Mask, uv_T_Potion_Mask );
			float4 lerpResult154 = lerp( lerpResult165 , float4( 1,1,1,0 ) , tex2DNode96.b);
			o.Albedo = ( tex2D( _T_Potion_D, uv_T_Potion_D ) * lerpResult154 ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 uv_T_Potion_N = i.uv_texcoord * _T_Potion_N_ST.xy + _T_Potion_N_ST.zw;
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float3 tangentToWorldDir41 = mul( ase_tangentToWorldFast, UnpackNormal( tex2D( _T_Potion_N, uv_T_Potion_N ) ) );
			float2 temp_output_18_0 = ( (ase_grabScreenPosNorm).xy + (( tangentToWorldDir41 * _Distortion )).xy );
			float4 screenColor94 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_18_0);
			float temp_output_139_0 = distance( ase_worldPos , _WorldSpaceCameraPos );
			float clampResult149 = clamp( ( temp_output_139_0 * _sfsfsddf ) , 0.0 , 1.0 );
			float lerpResult150 = lerp( _BlurIntensity_Near , _BlurIntensity_Far , clampResult149);
			float2 appendResult123 = (float2(0.0 , 1.0));
			float4 screenColor15 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( temp_output_18_0 + ( ( lerpResult150 * saturate( pow( ( ( 1.0 - tex2DNode96.a ) + _BlurIntensity_MaskContrastAdd ) , _BlurIntensity_MaskContrast ) ) ) * appendResult123 ) ));
			float2 appendResult124 = (float2(1.0 , 1.0));
			float4 screenColor79 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( temp_output_18_0 + ( ( lerpResult150 * saturate( pow( ( ( 1.0 - tex2DNode96.a ) + _BlurIntensity_MaskContrastAdd ) , _BlurIntensity_MaskContrast ) ) ) * appendResult124 ) ));
			float2 appendResult120 = (float2(1.0 , 0.0));
			float4 screenColor80 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( temp_output_18_0 + ( ( lerpResult150 * saturate( pow( ( ( 1.0 - tex2DNode96.a ) + _BlurIntensity_MaskContrastAdd ) , _BlurIntensity_MaskContrast ) ) ) * appendResult120 ) ));
			float2 appendResult122 = (float2(1.0 , -1.0));
			float4 screenColor81 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( temp_output_18_0 + ( ( lerpResult150 * saturate( pow( ( ( 1.0 - tex2DNode96.a ) + _BlurIntensity_MaskContrastAdd ) , _BlurIntensity_MaskContrast ) ) ) * appendResult122 ) ));
			float2 appendResult125 = (float2(0.0 , -1.0));
			float4 screenColor104 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( temp_output_18_0 + ( ( lerpResult150 * saturate( pow( ( ( 1.0 - tex2DNode96.a ) + _BlurIntensity_MaskContrastAdd ) , _BlurIntensity_MaskContrast ) ) ) * appendResult125 ) ));
			float2 appendResult126 = (float2(-1.0 , -1.0));
			float4 screenColor103 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( temp_output_18_0 + ( ( lerpResult150 * saturate( pow( ( ( 1.0 - tex2DNode96.a ) + _BlurIntensity_MaskContrastAdd ) , _BlurIntensity_MaskContrast ) ) ) * appendResult126 ) ));
			float2 appendResult119 = (float2(-1.0 , 0.0));
			float4 screenColor102 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( temp_output_18_0 + ( ( lerpResult150 * saturate( pow( ( ( 1.0 - tex2DNode96.a ) + _BlurIntensity_MaskContrastAdd ) , _BlurIntensity_MaskContrast ) ) ) * appendResult119 ) ));
			float2 appendResult121 = (float2(-1.0 , 1.0));
			float4 screenColor101 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( temp_output_18_0 + ( ( lerpResult150 * saturate( pow( ( ( 1.0 - tex2DNode96.a ) + _BlurIntensity_MaskContrastAdd ) , _BlurIntensity_MaskContrast ) ) ) * appendResult121 ) ));
			o.Emission = ( ( ( ( screenColor94 * 0.111111 ) + ( ( ( ( screenColor15 * 0.111111 ) + ( screenColor79 * 0.111111 ) ) + ( ( screenColor80 * 0.111111 ) + ( screenColor81 * 0.111111 ) ) ) + ( ( ( screenColor104 * 0.111111 ) + ( screenColor103 * 0.111111 ) ) + ( ( screenColor102 * 0.111111 ) + ( screenColor101 * 0.111111 ) ) ) ) ) * lerpResult165 ) * ( 1.0 - tex2DNode96.b ) ).rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18701
1096;152;2253;1141;2753.533;57.01059;2.512666;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;141;-6593.797,1271.693;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;140;-6658.797,1416.693;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;96;-5675.797,1634.692;Inherit;True;Property;_T_Potion_Mask;T_Potion_Mask;15;0;Create;True;0;0;False;0;False;96;1607212386e63bf459a6e602147a3729;1607212386e63bf459a6e602147a3729;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;147;-6446.475,1600.37;Float;False;Property;_sfsfsddf;sfsfsddf;9;0;Create;True;0;0;False;0;False;0.3764706;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;139;-6371.796,1285.693;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-5538.662,1305.809;Float;False;Property;_BlurIntensity_MaskContrastAdd;BlurIntensity_MaskContrastAdd;6;0;Create;True;0;0;False;0;False;1;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;136;-5595.169,1066.67;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-5223.662,1388.809;Float;False;Property;_BlurIntensity_MaskContrast;BlurIntensity_MaskContrast;5;0;Create;True;0;0;False;0;False;1;5.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;161;-5186.662,1118.809;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-6114.475,1360.37;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;-4575.104,101.8389;Inherit;True;Property;_T_Potion_N;T_Potion_N;13;0;Create;True;0;0;False;0;False;-1;d7466e4759fa18a4f8f7d92c62408d52;d7466e4759fa18a4f8f7d92c62408d52;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;-5957.852,734.1307;Float;False;Property;_BlurIntensity_Near;BlurIntensity_Near;3;0;Create;True;0;0;False;0;False;0.01053596;0.0111;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;155;-4883.662,1104.809;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-5955.051,819.173;Float;False;Property;_BlurIntensity_Far;BlurIntensity_Far;4;0;Create;True;0;0;False;0;False;0.01053596;0.0026;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;149;-5860.051,1387.173;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;41;-4216.748,6.273064;Inherit;False;Tangent;World;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;156;-4726.662,1045.809;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-4273.892,-91.05114;Float;False;Property;_Distortion;Distortion;1;0;Create;True;0;0;False;0;False;0.4343549;0.02;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;150;-5343.051,828.1731;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-4579.767,785.7052;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;12;-3942.143,-475.6547;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-3849.716,-281.7398;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;-4325.914,1506.18;Inherit;False;FLOAT2;4;0;FLOAT;-1;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;17;-3704.661,-461.1599;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;126;-4316.472,1327.755;Inherit;False;FLOAT2;4;0;FLOAT;-1;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;124;-4316.472,949.7548;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;122;-4328.914,1143.18;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;138;-4328.767,792.7052;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;120;-4315.914,1053.18;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;119;-4319.914,1419.18;Inherit;False;FLOAT2;4;0;FLOAT;-1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;23;-3715.716,-286.7398;Inherit;False;True;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;123;-4320.472,839.7548;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;125;-4322.472,1234.755;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-3936.913,695.1804;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-3920.362,1247.398;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-3918.362,1147.398;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-3922.804,1060.824;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-3932.472,781.7548;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-3934.472,881.7548;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-3930.472,969.7548;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-3486.715,-384.7398;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-3916.362,1335.398;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-2427.172,122.2884;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-2445.049,-166.6083;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-2418.049,513.3916;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-2385.13,1105.168;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-2445.049,321.3916;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-2403.007,1304.271;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-2403.007,816.2712;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-2376.007,1496.271;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;102;-2209.673,1260.401;Inherit;False;Global;_GrabScreen6;Grab Screen 6;2;0;Create;True;0;0;False;0;False;Instance;94;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;15;-2263.983,-169.4846;Inherit;False;Global;_GrabScreen0;Grab Screen 0;2;0;Create;True;0;0;False;0;False;Instance;94;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;104;-2221.941,813.3949;Inherit;False;Global;_GrabScreen8;Grab Screen 8;2;0;Create;True;0;0;False;0;False;Instance;94;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;92;-2480.761,676.0973;Inherit;False;Constant;_Float2;Float 2;9;0;Create;True;0;0;False;0;False;0.111111;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;80;-2251.715,277.5213;Inherit;False;Global;_GrabScreen2;Grab Screen 2;2;0;Create;True;0;0;False;0;False;Instance;94;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;101;-2215.007,1457.271;Inherit;False;Global;_GrabScreen5;Grab Screen 5;2;0;Create;True;0;0;False;0;False;Instance;94;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;81;-2257.049,474.3917;Inherit;False;Global;_GrabScreen3;Grab Screen 3;2;0;Create;True;0;0;False;0;False;Instance;94;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;103;-2209.673,1084.401;Inherit;False;Global;_GrabScreen7;Grab Screen 7;2;0;Create;True;0;0;False;0;False;Instance;94;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;79;-2251.715,101.5214;Inherit;False;Global;_GrabScreen1;Grab Screen 1;2;0;Create;True;0;0;False;0;False;Instance;94;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1942.902,1138.918;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-1923.902,960.9188;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-1965.944,-21.96074;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1954.944,505.0392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-1912.902,1487.918;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-1984.944,156.0392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1928.902,1292.918;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1970.944,310.0392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-1724.944,341.0392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-1682.902,1323.918;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-1740.944,115.0393;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;-1698.902,1097.918;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-1576.944,186.0392;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-1534.902,1168.918;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;94;-2241.382,-392.7743;Inherit;False;Global;_GrabScreen4;Grab Screen 4;2;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;166;-1369.865,-246.8387;Inherit;False;Property;_ColorB;ColorB;11;0;Create;True;0;0;False;0;False;1,0,0,0;0.9872478,1,0.4198113,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;162;-1638.865,-102.8387;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-1382.29,307.9075;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;32;-1372.852,-432.1091;Inherit;False;Property;_ColorA;ColorA;10;0;Create;True;0;0;False;0;False;1,0,0,0;0.291,0.2507553,0.05881914,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-1992.723,-315.2323;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;167;-1074.296,140.8117;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;165;-965.8652,-72.83875;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;154;-706.0769,-184.6033;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;36;-1077.416,-526.1178;Inherit;True;Property;_T_Potion_D;T_Potion_D;12;0;Create;True;0;0;False;0;False;36;cc7bea40577a0ab4d90f3d64e013455f;cc7bea40577a0ab4d90f3d64e013455f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-404.6154,201.3071;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;153;-3868.686,1865.989;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1204.594,2408.673;Inherit;False;Property;_Float0;Float 0;14;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;28;-4095.888,-291.575;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;48;-1419.246,874.4809;Float;False;Property;_Add;Add;7;0;Create;True;0;0;False;0;False;0;0.037;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1370.594,2237.673;Float;False;Property;_Mull;Mull;8;0;Create;True;0;0;False;0;False;0.3764706;0.037;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexelSizeNode;171;-2591.093,-934.0709;Inherit;False;-1;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-481.3929,710.676;Float;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;False;0;False;1;0.037;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1167.348,2077.192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;142;-592.9941,1440.824;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-180.929,247.67;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleNode;143;-822.6526,1503.857;Inherit;False;0.2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;42;-1296.566,2125.829;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-847.3481,2173.192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;47;-527.3481,2109.192;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-321.416,-66.1178;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;172;-1132.527,-711.3917;Inherit;False;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;173;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UModeler/WC/BlurPotion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;139;0;141;0
WireConnection;139;1;140;0
WireConnection;136;0;96;4
WireConnection;161;0;136;0
WireConnection;161;1;160;0
WireConnection;145;0;139;0
WireConnection;145;1;147;0
WireConnection;155;0;161;0
WireConnection;155;1;158;0
WireConnection;149;0;145;0
WireConnection;41;0;38;0
WireConnection;156;0;155;0
WireConnection;150;0;73;0
WireConnection;150;1;151;0
WireConnection;150;2;149;0
WireConnection;137;0;150;0
WireConnection;137;1;156;0
WireConnection;20;0;41;0
WireConnection;20;1;22;0
WireConnection;17;0;12;0
WireConnection;138;0;137;0
WireConnection;23;0;20;0
WireConnection;115;0;138;0
WireConnection;115;1;123;0
WireConnection;132;0;138;0
WireConnection;132;1;119;0
WireConnection;131;0;138;0
WireConnection;131;1;126;0
WireConnection;130;0;138;0
WireConnection;130;1;125;0
WireConnection;128;0;138;0
WireConnection;128;1;124;0
WireConnection;127;0;138;0
WireConnection;127;1;120;0
WireConnection;129;0;138;0
WireConnection;129;1;122;0
WireConnection;18;0;17;0
WireConnection;18;1;23;0
WireConnection;133;0;138;0
WireConnection;133;1;121;0
WireConnection;78;0;18;0
WireConnection;78;1;128;0
WireConnection;82;0;18;0
WireConnection;82;1;115;0
WireConnection;84;0;18;0
WireConnection;84;1;129;0
WireConnection;97;0;18;0
WireConnection;97;1;131;0
WireConnection;83;0;18;0
WireConnection;83;1;127;0
WireConnection;98;0;18;0
WireConnection;98;1;132;0
WireConnection;100;0;18;0
WireConnection;100;1;130;0
WireConnection;99;0;18;0
WireConnection;99;1;133;0
WireConnection;102;0;98;0
WireConnection;15;0;82;0
WireConnection;104;0;100;0
WireConnection;80;0;83;0
WireConnection;101;0;99;0
WireConnection;81;0;84;0
WireConnection;103;0;97;0
WireConnection;79;0;78;0
WireConnection;106;0;103;0
WireConnection;106;1;92;0
WireConnection;107;0;104;0
WireConnection;107;1;92;0
WireConnection;86;0;15;0
WireConnection;86;1;92;0
WireConnection;89;0;81;0
WireConnection;89;1;92;0
WireConnection;108;0;101;0
WireConnection;108;1;92;0
WireConnection;87;0;79;0
WireConnection;87;1;92;0
WireConnection;105;0;102;0
WireConnection;105;1;92;0
WireConnection;88;0;80;0
WireConnection;88;1;92;0
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;109;0;105;0
WireConnection;109;1;108;0
WireConnection;85;0;86;0
WireConnection;85;1;87;0
WireConnection;110;0;107;0
WireConnection;110;1;106;0
WireConnection;91;0;85;0
WireConnection;91;1;90;0
WireConnection;111;0;110;0
WireConnection;111;1;109;0
WireConnection;94;0;18;0
WireConnection;134;0;91;0
WireConnection;134;1;111;0
WireConnection;168;0;94;0
WireConnection;168;1;92;0
WireConnection;167;0;168;0
WireConnection;167;1;134;0
WireConnection;165;0;32;0
WireConnection;165;1;166;0
WireConnection;165;2;162;0
WireConnection;154;0;165;0
WireConnection;154;2;96;3
WireConnection;34;0;167;0
WireConnection;34;1;165;0
WireConnection;153;0;96;3
WireConnection;46;0;42;0
WireConnection;46;1;49;0
WireConnection;142;0;143;0
WireConnection;152;0;34;0
WireConnection;152;1;153;0
WireConnection;143;0;139;0
WireConnection;44;0;46;0
WireConnection;44;1;50;0
WireConnection;47;0;44;0
WireConnection;37;0;36;0
WireConnection;37;1;154;0
WireConnection;173;0;37;0
WireConnection;173;2;152;0
WireConnection;173;4;30;0
ASEEND*/
//CHKSM=A6BBBE33569BF021B0920D640ECF376E2763D86E
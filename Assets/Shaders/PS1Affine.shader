Shader "Custom/PS1Affine"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
		{ 
			"RenderPipeline" = "UniversalPipeline" 
			"Queue" = "Geometry"
			"RenderType"="Opaque" 
			"LightMode" = "UniversalForward"
		}
        LOD 100

		HLSLINCLUDE
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			
			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);

			CBUFFER_START(UnityPerMaterial)
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			CBUFFER_END

			struct VertexInput 
			{
				float4 positionOS   : POSITION;
				float2 uv           : TEXCOORD0;
			};

			struct VertexOutput 
			{
				float4 positionCS	: SV_POSITION;
				noperspective float2 uv : TEXCOORD0;
			};
		ENDHLSL

        Pass
        {
            Cull Back

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			VertexOutput vert(VertexInput i)
			{
				VertexOutput o;

				o.positionCS = TransformObjectToHClip(i.positionOS);

				o.uv = TRANSFORM_TEX(i.uv, _MainTex);

				return o;
			}

			float4 frag(VertexOutput i) : SV_Target
			{
				float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
				return col;
			}
			
			ENDHLSL
        }
    }
}

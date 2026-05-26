// Minimal inverted-hull outline demonstration shader.
// Two passes:
//   Pass 0 — Outline: Cull Front, expands vertices along normals, outputs flat outline colour.
//   Pass 1 — Main:    Cull Back, outputs albedo texture with no lighting (unlit flat colour).
// Intended for thesis demonstration of the inverted-hull technique in isolation.

Shader "Custom/V1_InvertedHullOutline"
{
    Properties
    {
        [Header(Main Surface)]
        _MainTex     ("Albedo Texture", 2D)            = "white" {}
        _Color       ("Surface Color Tint", Color)     = (1, 1, 1, 1)

        [Header(Outline)]
        _OutlineWidth ("Outline Width (world units)", Range(0, 0.05)) = 0.003
        _OutlineColor ("Outline Color", Color)         = (0, 0, 0, 1)

        [Header(Alpha)]
        [Toggle] _EnableAlphaTest ("Alpha Test (eyelashes)", Float) = 0
        _AlphaCutoff  ("Alpha Cutoff", Range(0, 1))    = 0.07
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }

        // ── Pass 0: Inverted Hull Outline ─────────────────────────────────────
        Pass
        {
            Name "Outline"
            Tags { "LightMode" = "SRPDefaultUnlit" }

            Cull Front
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.5

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float4 _OutlineColor;
                float  _OutlineWidth;
                float  _EnableAlphaTest;
                float  _AlphaCutoff;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
                float2 uv         : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv         : TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                // Displace each vertex outward along its world-space normal.
                // Because front faces are culled, only the displaced back faces
                // are visible — they form a solid colour shell (the outline).
                float3 posWS    = TransformObjectToWorld(IN.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(IN.normalOS);
                posWS          += normalWS * _OutlineWidth;
                OUT.positionCS  = TransformWorldToHClip(posWS);
                OUT.uv          = TRANSFORM_TEX(IN.uv, _MainTex);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                if (_EnableAlphaTest > 0.5)
                    clip(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv).a - _AlphaCutoff);
                return _OutlineColor;
            }
            ENDHLSL
        }

        // ── Pass 1: Flat Unlit Surface ────────────────────────────────────────
        Pass
        {
            Name "UnlitSurface"
            Tags { "LightMode" = "UniversalForward" }

            Cull Back
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.5

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float4 _Color;
                float  _EnableAlphaTest;
                float  _AlphaCutoff;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv         : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv         : TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv         = TRANSFORM_TEX(IN.uv, _MainTex);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 tex = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                if (_EnableAlphaTest > 0.5)
                    clip(tex.a - _AlphaCutoff);
                return half4(tex.rgb * _Color.rgb, tex.a * _Color.a);
            }
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}

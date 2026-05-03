// V7: NPR shader - toon shading + curvature-based inner edges.
//
// Patch fixes applied after initial testing:
//   1. Toon ramp: the old formula used rampSample as a smoothstep threshold.
//      With the default white texture rampSample=1 always, pushing the transition
//      to NdotL=1 and rendering the whole avatar dark. Fixed: smoothstep on NdotL
//      directly; ramp texture is applied as a multiplicative shape factor.
//   2. Crease edges: cross(ddy(posWS),ddx(posWS)) computes a per-pixel face normal
//      from position derivatives. OVR position compression + 2x2 raster quads
//      straddling triangle faces made the face normal noisy everywhere on the dense
//      avatar mesh -> crease fired on too many pixels -> filled dark patches.
//      Fixed: curvature = length(ddx(nWS)) + length(ddy(nWS)). Smooth vertex
//      normals are averaged at shared vertices, so they have no per-triangle
//      discontinuity on smooth surfaces and are not affected by position quantization.

Shader "Custom/V7_CreaseEdge"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base Color", 2D) = "white" {}
        _TextureIntensity ("Texture Intensity", Range(0, 1)) = 1.0

        [Header(Toon Shading)]
        _ToonRamp ("Toon Ramp (optional 1D gradient)", 2D) = "white" {}
        _ShadowStrength ("Shadow Strength", Range(0, 1)) = 0.7
        _ToonSmoothness ("Band Softness", Range(0.001, 0.5)) = 0.08

        [Header(Outer Outline)]
        _OuterOutlineColor ("Outer Outline Color", Color) = (0,0,0,1)
        _OuterOutlineWidth ("Outer Outline Width", Range(0, 0.05)) = 0.003

        [Header(Rim Light)]
        _RimColor     ("Rim Color",  Color)          = (0.408,0.408,0.408,1)
        _RimPower     ("Rim Power",  Range(0.5, 10)) = 3.0
        _AmbientColor ("Ambient Color", Color)       = (0.35,0.35,0.35,1)

        [Header(Inner Crease Edges)]
        _InnerLineColor    ("Inner Line Color",  Color)          = (0,0,0,1)
        _EdgeThreshold     ("Crease Threshold",  Range(0, 0.5))  = 0.08
        _EdgeSmoothness    ("Crease Softness",   Range(0, 0.2))  = 0.04
        _InnerLineStrength ("Line Strength",     Range(0, 1))    = 1.0
        _SilhouetteFade    ("Silhouette Fade",   Range(0, 0.5))  = 0.15

        [Toggle] _EnableAlphaTest ("Enable Alpha Test", Float) = 0
        _AlphaCutoff ("Alpha Cutoff", Range(0, 1)) = 0.07
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }

        // -- Outer outline (inverted hull) - same as Meta's Cel-Avatar-Meta.shader --
        Pass
        {
            Name "OuterOutline"
            Tags { "Queue"="Geometry+1" }
            Cull Front
            ZWrite On
            ZTest Less

            HLSLPROGRAM
            #pragma vertex vert_outline
            #pragma fragment frag_outline
            #pragma target 3.5
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "OvrVertexFetchBridge.hlsl"

            struct Attr_OL { float4 vertex : POSITION; float3 normal : NORMAL; float2 uv : TEXCOORD0; uint vertexID : SV_VertexID; };
            struct Vary_OL { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            float4 _MainTex_ST;
            float4 _OuterOutlineColor;
            float  _OuterOutlineWidth;
            float  _EnableAlphaTest;
            float  _AlphaCutoff;

            Vary_OL vert_outline(Attr_OL v)
            {
                Vary_OL o;
                OVR_FETCH_POS_NORM(v.vertex.xyz, v.normal, v.vertexID);
                VertexPositionInputs pi = GetVertexPositionInputs(v.vertex.xyz);
                VertexNormalInputs   ni = GetVertexNormalInputs(v.normal);
                float3 posWS = pi.positionWS + ni.normalWS * _OuterOutlineWidth;
                o.pos = TransformWorldToHClip(posWS);
                o.uv  = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag_outline(Vary_OL i) : SV_Target
            {
                if (_EnableAlphaTest > 0.5)
                    clip(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv).a - _AlphaCutoff);
                return _OuterOutlineColor;
            }
            ENDHLSL
        }

        // -- Forward lit -------------------------------------------------------
        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode"="UniversalForward" }
            Cull Back
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.5
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "OvrVertexFetchBridge.hlsl"

            struct Attr
            {
                float4 vertex   : POSITION;
                float3 normal   : NORMAL;
                float2 uv       : TEXCOORD0;
                uint   vertexID : SV_VertexID;
            };

            struct Vary
            {
                float4 pos   : SV_POSITION;
                float2 uv    : TEXCOORD0;
                float3 posWS : TEXCOORD1;
                float3 nWS   : TEXCOORD2;
            };

            TEXTURE2D(_MainTex);   SAMPLER(sampler_MainTex);
            TEXTURE2D(_ToonRamp);  SAMPLER(sampler_ToonRamp);
            float4 _MainTex_ST;
            float4 _Color;
            float  _TextureIntensity;
            float  _ShadowStrength;
            float  _ToonSmoothness;
            float4 _RimColor;
            float  _RimPower;
            float4 _AmbientColor;
            float4 _InnerLineColor;
            float  _EdgeThreshold;
            float  _EdgeSmoothness;
            float  _InnerLineStrength;
            float  _SilhouetteFade;
            float  _EnableAlphaTest;
            float  _AlphaCutoff;

            Vary vert(Attr v)
            {
                Vary o;
                OVR_FETCH_POS_NORM(v.vertex.xyz, v.normal, v.vertexID);
                VertexPositionInputs pi = GetVertexPositionInputs(v.vertex.xyz);
                VertexNormalInputs   ni = GetVertexNormalInputs(v.normal);
                o.pos   = pi.positionCS;
                o.uv    = TRANSFORM_TEX(v.uv, _MainTex);
                o.posWS = pi.positionWS;
                o.nWS   = ni.normalWS;
                return o;
            }

            half4 frag(Vary IN) : SV_Target
            {
                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                if (_EnableAlphaTest > 0.5)
                    clip(texColor.a - _AlphaCutoff);

                half3 baseColor = lerp(_Color.rgb, texColor.rgb * _Color.rgb, _TextureIntensity);
                half4 albedo    = half4(baseColor, texColor.a * _Color.a);

                float3 nWS = normalize(IN.nWS);
                float3 vWS = normalize(_WorldSpaceCameraPos - IN.posWS);

                // ── Smooth toon shading ───────────────────────────────────────
                // Base: smoothstep on NdotL gives a clean two-tone transition.
                // Ramp texture: used as a multiplicative shape — white (default)
                // has no effect, a custom 1D gradient adds extra toon bands.
                // This avoids the broken threshold behaviour that appeared when
                // the ramp default ("white") made rampSample = 1.0 always,
                // pushing the smoothstep edge to NdotL = 1.0 and darkening
                // the entire avatar.
                Light mainLight = GetMainLight();
                float NdotL = saturate(dot(nWS, mainLight.direction));

                float lit = smoothstep(0.5 - _ToonSmoothness,
                                       0.5 + _ToonSmoothness,
                                       NdotL);
                float rampFactor = SAMPLE_TEXTURE2D(_ToonRamp, sampler_ToonRamp,
                                                    float2(NdotL, 0.5)).r;
                lit = lit * rampFactor;
                lit = lerp(1.0 - _ShadowStrength, 1.0, lit);

                float3 lighting = mainLight.color * lit + _AmbientColor.rgb;
                float  rim      = pow(1.0 - saturate(dot(vWS, nWS)), _RimPower);
                float3 shaded   = albedo.rgb * lighting + rim * _RimColor.rgb;

                // ── Inner crease edges from normal curvature ─────────────────
                // Measures how fast the smooth interpolated vertex normal changes
                // in screen space. Unlike ddx/ddy of posWS (the old face-normal
                // approach), smooth normals are averaged at shared mesh vertices
                // and not subject to OVR vertex-buffer position quantization —
                // so curvature stays near zero on smooth skin/cloth and only
                // spikes where the mesh genuinely has a hard or semi-hard crease.
                //
                // Silhouette suppression: curvature also rises near grazing
                // angles; gating on NdotV prevents a second dark halo where
                // the outer outline already covers the silhouette.
                float3 dNdx = ddx(nWS);
                float3 dNdy = ddy(nWS);
                float  curvature = length(dNdx) + length(dNdy);

                float NdotV = saturate(dot(vWS, nWS));
                float silhouetteMask = smoothstep(0.0, _SilhouetteFade, NdotV);

                float edge = smoothstep(_EdgeThreshold,
                                        _EdgeThreshold + max(_EdgeSmoothness, 0.001),
                                        curvature)
                           * silhouetteMask * _InnerLineStrength;
                shaded = lerp(shaded, _InnerLineColor.rgb, edge);

                return half4(shaded, albedo.a);
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}

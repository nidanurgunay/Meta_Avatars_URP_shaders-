// V6: Toon shading + Sobel edge detection on the NORMAL MAP (object-space, view-independent).
// The color-map Sobel (V3/V5) fires at UV-island boundaries and color-region seams.
// Running Sobel on the tangent-space normal map avoids both problems:
//   - Normal maps are baked seamlessly across UV seams (no false island edges).
//   - Color-region boundaries (skin/clothes) have no effect on normal-map gradients.
//   - Edge detection is purely based on 3D geometry encoded in UV space (view-independent).

Shader "Custom/V6_NormalMapEdge"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base Color (u_BaseColorSampler)", 2D) = "white" {}
        _TextureIntensity ("Texture Intensity", Range(0, 1)) = 1.0

        [Header(Normal Map)]
        _NormalMap ("Normal Map (u_NormalSampler)", 2D) = "bump" {}

        [Header(Toon Shading)]
        _ToonSteps      ("Shading Steps",   Range(1, 10))     = 3
        _ToonSmoothness ("Smoothness",      Range(0.001, 0.1)) = 0.01
        _ShadowStrength ("Shadow Strength", Range(0, 1))      = 0.7

        [Header(Outer Outline)]
        _OuterOutlineColor ("Outer Outline Color", Color) = (0,0,0,1)
        _OuterOutlineWidth ("Outer Outline Width",  Range(0, 0.05)) = 0.003

        [Header(Rim Light)]
        _RimColor     ("Rim Color", Color) = (0.408,0.408,0.408,1)
        _RimPower     ("Rim Power", Range(0.5, 10.0)) = 3.0
        _AmbientColor ("Ambient Color", Color) = (0.35,0.35,0.35,1)

        [Header(Inner Edges NormalMap Sobel)]
        _InnerLineColor    ("Inner Line Color",    Color)           = (0,0,0,1)
        _InnerLineBlur     ("Sample Distance",     Range(0, 10))    = 1.0
        _EdgeThreshold     ("Edge Threshold",      Range(0, 2))     = 0.3
        _EdgeMax           ("Edge Max",            Range(0.1, 8))   = 2.0
        _SeamRangeLimit    ("Seam Range Limit",    Range(0, 2))     = 1.0
        _InnerLineStrength ("Inner Line Strength", Range(0, 1))     = 1.0

        [Toggle] _EnableAlphaTest ("Enable Alpha Test", Float) = 0
        _AlphaCutoff ("Alpha Cutoff", Range(0, 1)) = 0.07
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }

        // -- Outer outline (inverted hull) -------------------------------------
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

        // -- Forward lit: toon + normal-map Sobel edges ------------------------
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

            TEXTURE2D(_MainTex);    SAMPLER(sampler_MainTex);
            TEXTURE2D(_NormalMap);  SAMPLER(sampler_NormalMap);
            float4 _MainTex_ST;
            float4 _NormalMap_ST;
            float4 _Color;
            float  _TextureIntensity;
            float  _ToonSteps;
            float  _ToonSmoothness;
            float  _ShadowStrength;
            float4 _RimColor;
            float  _RimPower;
            float4 _AmbientColor;
            float4 _InnerLineColor;
            float  _InnerLineBlur;
            float  _EdgeThreshold;
            float  _EdgeMax;
            float  _SeamRangeLimit;
            float  _InnerLineStrength;
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

            // Helper: sample normal map and return XY components (encodes tangent-space normal).
            // A flat normal map ("bump" default) returns (0.5, 0.5) -> XY = 0 after unpack.
            float2 SampleNormalXY(float2 uv)
            {
                return SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, uv).xy;
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

                // ── Toon shading ──────────────────────────────────────────────
                Light mainLight = GetMainLight();
                float NdotL  = saturate(dot(nWS, mainLight.direction));
                float steps  = max(1.0, _ToonSteps);
                float scaled = NdotL * steps;
                float band   = floor(scaled);
                float frac   = scaled - band;
                float blend  = smoothstep(1.0 - _ToonSmoothness, 1.0, frac);
                float toon   = saturate((band + blend) / steps);
                toon = lerp(1.0 - _ShadowStrength, 1.0, toon);

                float3 lighting = mainLight.color * toon + _AmbientColor.rgb;
                float  rim      = pow(1.0 - saturate(dot(vWS, nWS)), _RimPower);
                float3 shaded   = albedo.rgb * lighting + rim * _RimColor.rgb;

                // ── Normal-map Sobel (UV-space, view-independent) ─────────────
                // Sample the tangent-space normal map at the 8 Sobel kernel positions.
                // Operating on normal XY avoids color-region boundary artifacts entirely.
                // Normal maps are baked seamlessly, so UV island edges don't cause spikes.
                float offset = _InnerLineBlur * 0.001;

                float2 tl = SampleNormalXY(IN.uv + float2(-offset,  offset));
                float2 t  = SampleNormalXY(IN.uv + float2( 0,       offset));
                float2 tr = SampleNormalXY(IN.uv + float2( offset,  offset));
                float2 l  = SampleNormalXY(IN.uv + float2(-offset,  0     ));
                float2 r  = SampleNormalXY(IN.uv + float2( offset,  0     ));
                float2 bl = SampleNormalXY(IN.uv + float2(-offset, -offset));
                float2 b  = SampleNormalXY(IN.uv + float2( 0,      -offset));
                float2 br = SampleNormalXY(IN.uv + float2( offset, -offset));

                // Sobel on X channel of normal
                float2 sobelX = (tr + 2.0*r + br) - (tl + 2.0*l + bl);
                // Sobel on Y channel of normal
                float2 sobelY = (tl + 2.0*t + tr) - (bl + 2.0*b + br);

                // Combined magnitude across both normal channels
                float edgeMag = sqrt(dot(sobelX, sobelX) + dot(sobelY, sobelY));

                // UV seam guard: if neighbour normal XY range is extreme, suppress.
                // (Flat regions = low range; genuine seam artifacts = high range.)
                float nMin = min(tl.x, min(t.x, min(tr.x, min(l.x, min(r.x, min(bl.x, min(b.x, br.x)))))));
                float nMax = max(tl.x, max(t.x, max(tr.x, max(l.x, max(r.x, max(bl.x, max(b.x, br.x)))))));
                float seamMask = step(nMax - nMin, _SeamRangeLimit);

                // Band-pass: threshold below, clamp above
                float inBand = step(_EdgeThreshold, edgeMag) * step(edgeMag, _EdgeMax);
                float edge   = inBand * seamMask * _InnerLineStrength;
                shaded = lerp(shaded, _InnerLineColor.rgb, edge);

                return half4(shaded, albedo.a);
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}

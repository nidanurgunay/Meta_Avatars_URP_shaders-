// V5 — Hierarchical Edge Detection with Gaussian Pre-blur
// Three-layer hierarchical edge detection (depth proxy, normal discontinuity,
// color Roberts Cross) where the color layer is optionally pre-smoothed with
// a 9-tap Gaussian before the Roberts Cross operator.
//
// Technique breakdown:
//   Depth  layer — ddx/ddy of camera-distance proxy → smoothstep threshold
//   Normal layer — ddx/ddy of world-space normal     → smoothstep threshold
//   Color  layer — 4-tap Roberts Cross on texture luminance, each tap
//                  optionally pre-blurred by a 9-tap Gaussian kernel
//   Fusion       — weighted max-pooling of the three layers
//   Adaptive     — brightness-based suppression to protect highlights

Shader "Custom/V5_HierarchicalGaussian"
{
    Properties
    {
        [Header(Base)]
        _Color            ("Main Color",       Color)      = (1,1,1,1)
        _MainTex          ("Texture",          2D)         = "white" {}
        _TextureIntensity ("Texture Intensity",Range(0,1)) = 1.0

        [Header(Lighting)]
        _ShadowStrength ("Shadow Strength", Range(0,1))    = 0.5
        _AmbientColor   ("Ambient Color",   Color)         = (0.3,0.3,0.3,1)

        [Header(Outer Outline)]
        _OuterOutlineWidth ("Outline Width", Range(0,0.05))  = 0.005
        _OuterOutlineColor ("Outline Color", Color)          = (0,0,0,1)

        [Header(Edge   Depth Layer)]
        [Toggle] _EnableDepthEdge ("Enable Depth Edge", Float) = 1
        _HDepthThreshold ("Depth Threshold", Range(0.001,0.2)) = 0.05
        _HDepthWeight    ("Depth Weight",    Range(0,1))        = 1.0

        [Header(Edge   Normal Layer)]
        [Toggle] _EnableNormalEdge ("Enable Normal Edge", Float) = 1
        _HNormalThreshold ("Normal Threshold", Range(0.05,1.0)) = 0.3
        _HNormalWeight    ("Normal Weight",    Range(0,1))       = 1.0

        [Header(Edge   Color Layer)]
        [Toggle] _EnableColorEdge ("Enable Color Edge", Float) = 1
        _HColorThreshold ("Color Threshold",  Range(0.01,0.5)) = 0.1
        _HColorWeight    ("Color Weight",     Range(0,1))       = 0.5
        _HEdgeWidth      ("Sample Distance",  Range(0.5,10.0)) = 1.0

        [Header(Gaussian Preblur on Color Layer)]
        [Toggle] _EnableGaussBlur  ("Enable Gaussian Preblur", Float) = 1
        _HBlurRadius      ("Blur Radius",     Range(0.1,5.0))  = 0.5
        _HCenterWeight    ("Center Weight",   Range(0,1))       = 0.25
        _HCardinalWeight  ("Cardinal Weight", Range(0,0.5))     = 0.125
        _HDiagonalWeight  ("Diagonal Weight", Range(0,0.25))    = 0.0625

        [Header(Edge Output)]
        _HEdgeColor       ("Edge Color",       Color)      = (0,0,0,1)
        _HEdgeStrength    ("Edge Strength",    Range(0,1)) = 1.0
        _HAdaptiveStrength("Adaptive Strength",Range(0,1)) = 0.5

        [Header(Alpha Test)]
        [Toggle] _EnableAlphaTest ("Alpha Test", Float) = 0
        _AlphaCutoff ("Alpha Cutoff", Range(0,1)) = 0.07
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }

        // ── Outer outline (inverted hull) ────────────────────────────────────
        Pass
        {
            Name "OuterOutline"
            Cull Front
            ZWrite On
            ZTest Less

            HLSLPROGRAM
            #pragma vertex   vert_ol
            #pragma fragment frag_ol
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attr_OL { float4 vertex : POSITION; float3 normal : NORMAL; float2 uv : TEXCOORD0; };
            struct Vary_OL { float4 pos    : SV_POSITION; float2 uv  : TEXCOORD0; };

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float4 _Color, _AmbientColor, _HEdgeColor, _OuterOutlineColor;
                float  _TextureIntensity, _ShadowStrength;
                float  _OuterOutlineWidth;
                float  _EnableAlphaTest, _AlphaCutoff;
                float  _EnableDepthEdge,  _HDepthThreshold,  _HDepthWeight;
                float  _EnableNormalEdge, _HNormalThreshold, _HNormalWeight;
                float  _EnableColorEdge,  _HColorThreshold,  _HColorWeight, _HEdgeWidth;
                float  _EnableGaussBlur,  _HBlurRadius;
                float  _HCenterWeight, _HCardinalWeight, _HDiagonalWeight;
                float  _HEdgeStrength, _HAdaptiveStrength;
            CBUFFER_END

            Vary_OL vert_ol(Attr_OL v)
            {
                Vary_OL o;
                VertexPositionInputs pi = GetVertexPositionInputs(v.vertex.xyz);
                VertexNormalInputs   ni = GetVertexNormalInputs(v.normal);
                o.pos = TransformWorldToHClip(pi.positionWS + ni.normalWS * _OuterOutlineWidth);
                o.uv  = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag_ol(Vary_OL i) : SV_Target
            {
                if (_EnableAlphaTest > 0.5)
                    clip(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv).a - _AlphaCutoff);
                return _OuterOutlineColor;
            }
            ENDHLSL
        }

        // ── Forward lit ──────────────────────────────────────────────────────
        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode"="UniversalForward" }
            Cull Back
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #pragma target   3.0
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attr
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv     : TEXCOORD0;
            };

            struct Vary
            {
                float4 pos   : SV_POSITION;
                float2 uv    : TEXCOORD0;
                float3 posWS : TEXCOORD1;
                float3 nWS   : TEXCOORD2;
            };

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float4 _Color, _AmbientColor, _HEdgeColor, _OuterOutlineColor;
                float  _TextureIntensity, _ShadowStrength;
                float  _OuterOutlineWidth;
                float  _EnableAlphaTest, _AlphaCutoff;
                float  _EnableDepthEdge,  _HDepthThreshold,  _HDepthWeight;
                float  _EnableNormalEdge, _HNormalThreshold, _HNormalWeight;
                float  _EnableColorEdge,  _HColorThreshold,  _HColorWeight, _HEdgeWidth;
                float  _EnableGaussBlur,  _HBlurRadius;
                float  _HCenterWeight, _HCardinalWeight, _HDiagonalWeight;
                float  _HEdgeStrength, _HAdaptiveStrength;
            CBUFFER_END

            static const float3 LUMA = float3(0.299, 0.587, 0.114);

            // 9-tap Gaussian-weighted luminance sample centred at uv.
            // When blur radius is 0 this degenerates to a point sample at the centre.
            float GaussianLuma(float2 uv, float br, float cW, float cardW, float diagW)
            {
                float s = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv).rgb,                LUMA) * cW;
                s += dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv + float2( br,  0)).rgb, LUMA) * cardW;
                s += dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv + float2(-br,  0)).rgb, LUMA) * cardW;
                s += dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv + float2(  0, br)).rgb, LUMA) * cardW;
                s += dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv + float2(  0,-br)).rgb, LUMA) * cardW;
                s += dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv + float2( br, br)).rgb, LUMA) * diagW;
                s += dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv + float2(-br, br)).rgb, LUMA) * diagW;
                s += dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv + float2( br,-br)).rgb, LUMA) * diagW;
                s += dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv + float2(-br,-br)).rgb, LUMA) * diagW;
                return s;
            }

            Vary vert(Attr v)
            {
                Vary o;
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
                if (_EnableAlphaTest > 0.5) clip(texColor.a - _AlphaCutoff);

                half3 baseColor = lerp(_Color.rgb, texColor.rgb * _Color.rgb, _TextureIntensity);
                half4 albedo    = half4(baseColor, texColor.a * _Color.a);

                float3 nWS = normalize(IN.nWS);

                // Smooth Lambert
                Light  mainLight = GetMainLight();
                float  NdotL     = saturate(dot(nWS, mainLight.direction));
                float  diffuse   = lerp(1.0 - _ShadowStrength, 1.0, NdotL);
                float3 shaded    = albedo.rgb * (mainLight.color * diffuse + _AmbientColor.rgb);

                // ── Layer 1: Depth proxy (camera distance gradient) ───────────
                float depthLine = 0.0;
                if (_EnableDepthEdge > 0.5)
                {
                    float d    = length(IN.posWS - _WorldSpaceCameraPos);
                    float dDx  = abs(ddx(d));
                    float dDy  = abs(ddy(d));
                    float edge = sqrt(dDx * dDx + dDy * dDy);
                    depthLine  = smoothstep(_HDepthThreshold - 0.001,
                                            _HDepthThreshold + 0.001, edge);
                }

                // ── Layer 2: Normal discontinuity (world-space) ──────────────
                float normalLine = 0.0;
                if (_EnableNormalEdge > 0.5)
                {
                    float3 dNdx = ddx(nWS);
                    float3 dNdy = ddy(nWS);
                    float  edge = sqrt(dot(dNdx, dNdx) + dot(dNdy, dNdy));
                    normalLine  = smoothstep(_HNormalThreshold - 0.02,
                                             _HNormalThreshold + 0.02, edge);
                }

                // ── Layer 3: Color Roberts Cross with Gaussian preblur ────────
                float colorLine = 0.0;
                if (_EnableColorEdge > 0.5)
                {
                    float off = _HEdgeWidth * 0.001;
                    float br  = _EnableGaussBlur > 0.5 ? _HBlurRadius * 0.001 : 0.0;

                    // Normalise Gaussian weights; degenerate to point sample when blur off
                    float totalW = _HCenterWeight + 4.0*_HCardinalWeight + 4.0*_HDiagonalWeight;
                    float cW     = _EnableGaussBlur > 0.5 ? _HCenterWeight   / totalW : 1.0;
                    float cardW  = _EnableGaussBlur > 0.5 ? _HCardinalWeight / totalW : 0.0;
                    float diagW  = _EnableGaussBlur > 0.5 ? _HDiagonalWeight / totalW : 0.0;

                    float lumTR = GaussianLuma(IN.uv + float2( off,  off), br, cW, cardW, diagW);
                    float lumTL = GaussianLuma(IN.uv + float2(-off,  off), br, cW, cardW, diagW);
                    float lumBR = GaussianLuma(IN.uv + float2( off, -off), br, cW, cardW, diagW);
                    float lumBL = GaussianLuma(IN.uv + float2(-off, -off), br, cW, cardW, diagW);

                    float edge = abs(lumTR - lumBL) + abs(lumTL - lumBR);
                    colorLine  = smoothstep(_HColorThreshold - 0.01,
                                            _HColorThreshold + 0.01, edge);
                }

                // ── Weighted max-pooling + adaptive brightness suppression ────
                float brightness = dot(albedo.rgb, LUMA);
                float adaptive   = lerp(1.0, saturate(brightness * 2.0), _HAdaptiveStrength);

                float edgeFinal = max(depthLine  * _HDepthWeight,
                                  max(normalLine * _HNormalWeight,
                                      colorLine  * _HColorWeight));
                edgeFinal = smoothstep(0.2, 0.55, edgeFinal * adaptive);
                edgeFinal = saturate(edgeFinal * _HEdgeStrength);

                shaded = lerp(shaded, _HEdgeColor.rgb, edgeFinal);
                return half4(shaded, albedo.a);
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/Universal Render Pipeline/FallbackError"
    CustomEditor "AvaturnPresetShaderGUI"
}

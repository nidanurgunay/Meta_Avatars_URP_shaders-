Shader "Custom/MetaAvatar_V3_NPR"
{
    Properties
    {
        // Essential fallback properties
        _BaseMap("Base Map", 2D) = "white" {}
        _BaseColor("Base Color", Color) = (1,1,1,1)

        [Header(Sobel Inner Lines)]
        _InnerLineColor("Inner Line Color", Color) = (0,0,0,1)
        _InnerLineWidth("Inner Line Width", Range(0, 5)) = 1.0
        _ColorThreshold("Color Threshold", Range(0, 1)) = 0.2

        [Header(Inverted Hull Outline)]
        _OutlineColor("Outline Color", Color) = (0,0,0,1)
        _OutlineWidth("Outline Width", Range(0, 0.05)) = 0.005
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }

        // PASS 1: Base Color + Injected Sobel Inner Lines
        Pass
        {
            Name "UniversalForward"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex Vertex_main_instancing
            #pragma fragment Fragment_main

            // UltimateGloveBall Injection Macros
            #define OVR_APP_DECLARATIONS "app_declarations.hlsl"
            #define OVR_APP_FUNCTIONS "app_functions.hlsl"
            #define OVR_APP_VARIANTS "app_variants.hlsl"

            // Include Meta SDK Core - adjust path if necessary for your SDK version
            #include "Packages/com.meta.xr.sdk.avatars/Scripts/ShaderUtils/Style2MetaAvatarCore.hlsl"
            ENDHLSL
        }

        // PASS 2: Inverted Hull Outline
        Pass
        {
            Name "InvertedHullOutline"
            Tags { "LightMode" = "SRPDefaultUnlit" }
            Cull Front // The core of the inverted hull technique

            HLSLPROGRAM
            // We will need to inject a vertex expansion hook here so the 
            // outline respects the Meta Avatar's Compute Skinning.
            // For now, this acts as the dedicated outline pass container.
            ENDHLSL
        }
    }
}
﻿Shader "Custom/CustomLambertianLightingModel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Using custom Lighting model call SimpleLamber, which will automatically find a function call "LightingSimpleLambert"
        #pragma surface surf SimpleLambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Alpha = c.a;
        }
		// s is the surface output form the surface
		// lightDir is the direction of the coming light
		// atten is used to modulate the intensity of the light.
		half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten) {
			// The color coeffciency of the light applying to this surface
			half NdotL = dot(s.Normal, lightDir);
			half4 c;
			// 2 is the tricky number
			c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 1);
			c.a = s.Alpha;
			return c;
		}

        ENDCG
    }
    FallBack "Diffuse"
}

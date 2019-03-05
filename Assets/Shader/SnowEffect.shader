// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/SnowEffect"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Normal("Normal", 2D) = "bump"{}

		_ExtrudeAmount("Extrude Amount", Range(-0.1,0.1)) = 0

		_Snow("Snow Level" , Range(1,-1)) = 1
		_SnowColor("Snow Color", Color) = (1,1,1,1)
		_SnowDirection("Snow Direction", Vector) = (0,1,0)
		_SnowDepth("Snow Depth", Range(0,0.1)) = 0
	}
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _Normal;
		float _ExtrudeAmount;

		// Snow Releated
		float _Snow;
		float4 _SnowColor;
		float4 _SnowDirection;
		float _SnowDepth;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_Normal;
			float3 worldNormal;
			INTERNAL_DATA
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

		void vert(inout appdata_full v)
		{
			v.vertex.xyz += _ExtrudeAmount * v.normal;
			float4 sn = mul(_SnowDirection, unity_WorldToObject);
			if (dot(v.normal, sn.xyz) >= _Snow)
				v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;

		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			
            o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
			if (dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= _Snow)
				o.Albedo = _SnowColor.rgb;
			else
				o.Albedo = c.rgb * _Color;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

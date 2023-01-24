Shader "Custom/UndulatingSurface" {
    Properties {
        _MainTex ("Base Texture", 2D) = "white" {}
        _Speed ("Speed", Range(0, 10)) = 1
        _Amplitude ("Amplitude", Range(0, 1)) = 0.1
        _Frequency ("Frequency", Range(0, 1)) = 0.5
    }

    SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        float _Speed;
        float _Amplitude;
        float _Frequency;

        struct Input {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            float time = _Time.y * _Speed;
            float2 undulation = _Amplitude * sin(_Frequency * IN.uv_MainTex.xy * 15 + time);
            IN.uv_MainTex += undulation;
            // add time-based offset to move texture in x-direction
            IN.uv_MainTex.x += time * 0.1;
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
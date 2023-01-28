Shader "Custom/GlitchyBWTV" {
    Properties {
        _MainTex ("Base Texture", 2D) = "white" {}
        _Speed ("Glitch Speed", Range(0, 10)) = 1
    }
    SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        float _Speed;

        struct Input {
            float2 uv_MainTex;
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o) {
            fixed4 col = tex2D (_MainTex, IN.uv_MainTex);
            col.r = col.g = col.b = (col.r + col.g + col.b) / 3;
            col.a = 1;

            // Add a scrolling offset to the UV coordinates to create the moving glitch effect
            float2 scroll = _Speed * _Time.y;
            col.rgb += tex2D (_MainTex, IN.uv_MainTex + scroll + (tex2D (_MainTex, IN.uv_MainTex + scroll).r - 0.5) * 0.1).rgb * 0.2;
            col.rgb += tex2D (_MainTex, IN.uv_MainTex + scroll + (tex2D (_MainTex, IN.uv_MainTex + scroll).r - 0.5) * -0.1).rgb * 0.2;
            col.rgb += tex2D (_MainTex, IN.uv_MainTex + scroll + (tex2D (_MainTex, IN.uv_MainTex + scroll).r - 0.5) * 0.2).rgb * 0.2;
            col.rgb += tex2D (_MainTex, IN.uv_MainTex + scroll + (tex2D (_MainTex, IN.uv_MainTex + scroll).r - 0.5) * -0.2).rgb * 0.2;
            col.rgb += tex2D (_MainTex, IN.uv_MainTex + scroll + (tex2D (_MainTex, IN.uv_MainTex + scroll).r - 0.5) * 0.3).rgb * 0.1;
            col.rgb += tex2D (_MainTex, IN.uv_MainTex + scroll + (tex2D (_MainTex, IN.uv_MainTex + scroll).r - 0.5) * -0.3).rgb * 0.1;

            o.Albedo = col.rgb;
            o.Alpha = col.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

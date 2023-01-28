Shader "Custom/BrokenCCTV" {
    Properties {
        _MainTex ("Base Texture", 2D) = "white" {}
        _Distortion ("Distortion", Range(0, 1)) = 0.5
        _Noise ("Noise", Range(0, 1)) = 0.5
        _Scanlines ("Scanlines", Range(0, 1)) = 0.5
        _ColorDrift ("Color Drift", Range(0, 1)) = 0.5
    }
    SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        LOD 200

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Distortion;
            float _Noise;
            float _Scanlines;
            float _ColorDrift;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                float dist = tex2D(_MainTex, i.uv + _Distortion * (tex2D(_MainTex, i.uv * 10 + _Time).r - 0.5)).r;
                col.rgb += dist;
                col.rgb += _Noise * tex2D(_MainTex, i.uv * 10 + _Time).r;
                col.rgb += _Scanlines * tex2D(_MainTex, i.uv * 20 + _Time).r;
                col.rgb += _ColorDrift * tex2D(_MainTex, i.uv * 30 + _Time).rgb;
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
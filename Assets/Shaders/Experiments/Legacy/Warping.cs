using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class Warping : MonoBehaviour {
    public Shader postProcessingShader;

    // public Vector3 exposure = new Vector3(1.0f, 1.0f, 1.0f);

    [Range(0f,1f)]
    public float distortion, blur, color;

    // public Vector3 contrast = new Vector3(1.0f, 1.0f, 1.0f);

    // public Vector3 linearMidPoint = new Vector3(0.5f, 0.5f, 0.5f);

    // public Vector3 brightness = new Vector3(0.0f, 0.0f, 0.0f);

    // [ColorUsageAttribute(false, true)]
    // public Color colorFilter;

    // public Vector3 saturation = new Vector3(1.0f, 1.0f, 1.0f);
    
    private Material postProcessMat;

    void OnEnable() {
        postProcessMat = new Material(postProcessingShader);
        postProcessMat.hideFlags = HideFlags.HideAndDontSave;
    }

    void OnDisable() {
        postProcessMat = null;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        postProcessMat.SetFloat("_Distortion", distortion);
        postProcessMat.SetFloat("_Blur", blur);
        // postProcessMat.SetFloat("_Color", color);
        // postProcessMat.SetVector("_Brightness", brightness);
        // postProcessMat.SetVector("_ColorFilter", colorFilter);
        // postProcessMat.SetVector("_Saturation", saturation);
        // postProcessMat.SetFloat("_Temperature", temperature / 100.0f);
        // postProcessMat.SetFloat("_Tint", tint / 100.0f);

        Graphics.Blit(source, destination, postProcessMat);
    }
}
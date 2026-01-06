using Newtonsoft.Json;
using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;
using UnityEngine.SceneManagement;

[CreateAssetMenu(fileName = "Stage_", menuName = "Level/Stage")]
public class StageSO : ModAsset
{
    public LocalizedString Name;
    public FieldID Weather;
    public bool BlocksWeather;
    public Sprite Icon;
    public bool OverrideRainLighting;
    [Space(20)]
    [ColorUsage(false,  true)]public Color ColorSky;
    [ColorUsage(false,  true)]public Color ColorHorizon;
    [ColorUsage(false,  true)]public Color ColorGround;
    [Space(20)]
    public Color ColorFog;
    public float FogDensMin;
    public float FogDensMax;
    [Range(0,1)]public float Shine=1;
    [Range(0,1)]public float CloudsAlpha=1;
    [Range(0,1)]public float RainSmooth=1;
    void RefreshStageShader()
    {
        Shader.SetGlobalFloat("_StageAlpha", 1);
        Shader.SetGlobalFloat("_CloudsAlpha", CloudsAlpha);
        Shader.SetGlobalFloat("_RainSmooth", RainSmooth);
    }
    void SetStageLighting()
    {
        if (SceneManager.GetActiveScene().name != "zone_Battle") return;
        Shader.SetGlobalFloat("_CloudsAlpha", CloudsAlpha);
        Shader.SetGlobalFloat("_RainSmooth", RainSmooth);
        RenderSettings.fogMode = FogMode.Linear;
        RenderSettings.fogEndDistance = FogDensMax;
        RenderSettings.fogStartDistance = FogDensMin;
        RenderSettings.fogColor = ColorFog;
        RenderSettings.ambientSkyColor = ColorSky;
        RenderSettings.ambientEquatorColor = ColorHorizon;
        RenderSettings.ambientGroundColor = ColorGround;
    }
    private void OnValidate()
    {
        SetStageLighting();
    }
    public GameObject Prefab;
    public override void PrintJson()
    {
        string path = Application.streamingAssetsPath + $"/{ModName.ToLower()}/Stage/{this.GetType().Name}/{name}.json";
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Stage"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Stage");
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Stage/{this.GetType().Name}"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Stage/{this.GetType().Name}");
        if (!File.Exists(path))
            File.Create(path).Dispose();
        JsonSerializerSettings serializerSettings = new();
        serializerSettings.Converters.Add(new NewtonsoftColorConverter());
        serializerSettings.Converters.Add(new LocalizedStringJsonConverter());
        serializerSettings.Converters.Add(new NewtonsoftMoveGOConverter());
        serializerSettings.Converters.Add(new SpriteRefJsonConverter());
        File.WriteAllText(path, JsonConvert.SerializeObject(this, Formatting.Indented, serializerSettings));
#if UNITY_EDITOR
        AssetDatabase.Refresh();
#endif
    }
}
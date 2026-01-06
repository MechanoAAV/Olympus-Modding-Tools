using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;
using UnityEngine.Serialization;
[CreateAssetMenu(fileName = "Move_", menuName = "Unna/Move/Move")]

public class MoveSO : ModAsset
{
    [FormerlySerializedAs("nameBase")]public LocalizedString Name;
    [FormerlySerializedAs("_descrBase")]public LocalizedString Description;
    [FormerlySerializedAs("_fxPrefab")]
    public GameObject FXPrefab;
    [FormerlySerializedAs("_damageFxPrefab")]
    public GameObject DamageFXPrefab;
     string FXPrefabRef;
     string DamageFXPrefabRef;
     string BundlePath;
    [FormerlySerializedAs("_type")]public TypesSO Type;
    [FormerlySerializedAs("power")]public float Power=20;
    [FormerlySerializedAs("_blessAmount")]
    [Range(0, 100)] public float BlessPower; 
    [FormerlySerializedAs("_hitTimes")]
    [Range(0, 5)]public int HitTimes=1; 
    [FormerlySerializedAs("_criticalChance")][Min(0)]public float CriticalChance=1;
    [FormerlySerializedAs("_contact")]public bool Contact;
    [Range(0,100)]
    public float RecoilAmount = 0;
    public bool Grounded=false;
    [FormerlySerializedAs("_usagePoints")]
    [Min(1)]public int UsagePoints=10;
    [Range(-10,10)][SerializeField] int priority;
    [FormerlySerializedAs("_moveEffect")] public MoveEffectBase MoveEffect;
    [FormerlySerializedAs("category")]
    public MoveCategory Category;
    [FormerlySerializedAs("target")]
    public MoveTarget Target;
    [FormerlySerializedAs("_fogDistance")]
    public float FogDistance;
    [FormerlySerializedAs("_fogColor")]
    public Color FogColor;
    [FormerlySerializedAs("_envColor")]
    public Color EnvColor;
    public AttackCameraType CamType;
    public string AttackStateName;
    public SecondaryEffectSO Effects;
    public SecondaryEffect[] Secondaries;
    public bool IsCustom { get; set; } = false;
    [Range(0,100)]public int Accuracy=100;
    public bool Accurate=false;
    public override void PrintJson()
    {        
        if(!Directory.Exists(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Move"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Move");
            File.Create(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Move/{name}.txt").Close();
        }
        if(DamageFXPrefab)
        DamageFXPrefabRef = DamageFXPrefab.name;
        if(FXPrefab)
        FXPrefabRef = FXPrefab.name;
        var settings = new JsonSerializerSettings();
        settings.Converters.Add(new NewtonsoftColorConverter());
        settings.Converters.Add(new LocalizedStringJsonConverter());
        settings.Converters.Add(new NewtonsoftMoveGOConverter());
        settings.Converters.Add(new NewtonsoftMoveEffectConverter());
        settings.Converters.Add(new TypeRefJsonConverter());
        string value = JsonConvert.SerializeObject(this, Formatting.Indented,settings);
        File.WriteAllText(Application.streamingAssetsPath+$"/{ModName.ToLower()}/Move/{name}.txt",value);
#if UNITY_EDITOR
        AssetDatabase.Refresh();
#endif
    }
}
public enum AttackCameraType
{
    Side, Front, Status, Field
}
public sealed class NewtonsoftMoveGOConverter : JsonConverter<GameObject>
{
    public override void WriteJson(JsonWriter writer, GameObject value, JsonSerializer serializer)
    {
        JObject obj = new JObject
        (
            new JProperty("MovePrefabName", value ? value.name : string.Empty)
        );
        obj.WriteTo(writer);
    }
    public override GameObject ReadJson(JsonReader reader, Type objectType, GameObject existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return null;
    }
}

[System.Serializable]
public struct MoveEffects
{
    public bool CanBoost;
    public List<StatBoost> Boosts;
    public bool CanStatus;
    public ConditionID Status;
    public bool CanVolatileStatus;
    public ConditionID VStatus;
    public bool CanField;
    public FieldID Field;
}
public enum ConditionID
{
    None, sticky, drowsy, burnt, paralyze, //Non Vol
    advanced, backed, confusion, infected, taunt //Vol
}
public enum FieldID
{
    None, Dry, Wet, Spiky, Clear, Rain, Hot
}
[System.Serializable]
public struct StatBoost
{
    public Stat stat;
    public int boost;
}
public enum MoveCategory
{
    Attack, Status, Self
}
public enum MoveTarget
{
    Foe, Self
}
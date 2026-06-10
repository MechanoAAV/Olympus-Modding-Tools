using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.NetworkInformation;
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;
using UnityEngine.Serialization;
[CreateAssetMenu(fileName = "Move_", menuName = "Unna/Move/Move")]

public class MoveSO : ModAsset
{
    public LocalizedString Name;
    public LocalizedString Description;
    public GameObject FXPrefab;
    public GameObject DamageFXPrefab;
    [HideInInspector]
    public string FXPrefabRef;
    [HideInInspector]
    public string DamageFXPrefabRef;
    [HideInInspector]
    public string BundlePath;
    [HideInInspector]
    public GroupSO Type;
    public string TypeRef;
    public float Power = 20;
    [Range(0, 100)] public float BlessPower;
    [Range(0, 5)] public int HitTimes = 1;
    [Min(0)] public float CriticalChance = 1;
    public bool Contact;
    [Range(0, 100)]
    public float RecoilAmount = 0;
    public bool Grounded = false;
    [Min(1)] public int UsagePoints = 10;
    [Range(-10, 10)][SerializeField] int priority;
    [HideInInspector]
    public MoveEffectBase MoveEffect;
    public string MoveEffectRef;
    public MoveCategory Category;
    public MoveTarget Target;
    public Vector2 FogDistance;
    public Color FogColor;
    public Color EnvColor;
    public AttackCameraType CamType;
    public string AttackStateName;
    public SecondaryEffectSO Effects;
    public SecondaryEffect[] Secondaries;
    public bool IsCustom { get; set; } = false;
    [Range(0, 100)] public int Accuracy = 100;
    public bool Accurate = false;
    public override void PrintJson()
    {
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Move"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Move");
            File.Create(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Move/{name}.txt").Close();
        }
        if (DamageFXPrefab)
            DamageFXPrefabRef = DamageFXPrefab.name;
        if (FXPrefab)
            FXPrefabRef = FXPrefab.name;
        Type = CreateInstance<GroupSO>();
        Type.name = TypeRef;
        MoveEffect = CreateInstance<MoveNormal>();
        MoveEffect.name = MoveEffectRef;
        var settings = new JsonSerializerSettings();
        settings.Converters.Add(new NewtonsoftColorConverter());
        settings.Converters.Add(new LocalizedStringJsonConverter());
        settings.Converters.Add(new NewtonsoftMoveGOConverter());
        settings.Converters.Add(new NewtonsoftVector2Converter());
        settings.Converters.Add(new NewtonsoftMoveEffectConverter());
        settings.Converters.Add(new TypeRefJsonConverter());
        string value = JsonConvert.SerializeObject(this, Formatting.Indented, settings);
        File.WriteAllText(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Move/{name}.txt", value);
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
    public StatBoost(Stat stat, int boost)
    {
        this.stat = stat;
        this.boost = boost;
    }
}
public enum MoveCategory
{
    Attack, Status, Self
}
public enum MoveTarget
{
    Foe, Self
}
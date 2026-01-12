using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;
using System;
using System.Collections.Generic;
using UnityEngine.Localization.Settings;

public class ModAsset : ScriptableObject
{
    public string ModName = "mymod";
    public virtual void PrintJson()
    {

    }
}
public sealed class NewtonsoftMoveEffectConverter : JsonConverter<MoveEffectBase>
{
    public override void WriteJson(JsonWriter writer, MoveEffectBase value, JsonSerializer serializer)
    {
        JObject obj = new JObject
        (
            new JProperty("MoveEffectBaseName", value.name)
        );
        obj.WriteTo(writer);
    }
    public override MoveEffectBase ReadJson(JsonReader reader, Type objectType, MoveEffectBase existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return (MoveEffectBase)ScriptableObject.CreateInstance(obj.Value<string>("MoveEffectBaseName"));
    }
}
public class MoveSOJsonConverter : JsonConverter<MoveSO>
{
    public override MoveSO ReadJson(JsonReader reader, Type objectType, MoveSO existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return null;
    }
    public override void WriteJson(JsonWriter writer, MoveSO value, JsonSerializer serializer)
    {
        JObject obj = new JObject
               (
                   new JProperty("MoveName", value ? value.name : string.Empty)
               );

        obj.WriteTo(writer);
    }
}
public class SpriteRefJsonConverter : JsonConverter<Sprite>
{
    public override Sprite ReadJson(JsonReader reader, Type objectType, Sprite existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return null;
    }
    public override void WriteJson(JsonWriter writer, Sprite value, JsonSerializer serializer)
    {
        JObject obj = new JObject
               (
                   new JProperty("SpriteName", value ? value.name : string.Empty)
               );

        obj.WriteTo(writer);
    }
}
public class TypeRefJsonConverter : JsonConverter<TypesSO>
{
    public override TypesSO ReadJson(JsonReader reader, Type objectType, TypesSO existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return null;
    }
    public override void WriteJson(JsonWriter writer, TypesSO value, JsonSerializer serializer)
    {
        JObject obj = new(new JProperty("TypeName", value.name));
        obj.WriteTo(writer);
    }
}
public class ModifierSOJsonConverter : JsonConverter<ModifierSO>
{
    public override ModifierSO ReadJson(JsonReader reader, Type objectType, ModifierSO existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return null;
    }
    public override void WriteJson(JsonWriter writer, ModifierSO value, JsonSerializer serializer)
    {
        JObject obj = new JObject
               (
                   new JProperty("ModName", value ? value.name : string.Empty)
               );

        obj.WriteTo(writer);
    }
}
public class AbilityJsonConverter : JsonConverter<AbilityBase>
{
    public override AbilityBase ReadJson(JsonReader reader, Type objectType, AbilityBase existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return null;
    }
    public override void WriteJson(JsonWriter writer, AbilityBase value, JsonSerializer serializer)
    {
        JObject obj = new JObject
               (
                   new JProperty("AbilityName", value ? value.name : string.Empty)
               );

        obj.WriteTo(writer);
    }
}
public sealed class UnnaSOJsonConverter : JsonConverter<UnnaSO>
{
    public override void WriteJson(JsonWriter writer, UnnaSO value, JsonSerializer serializer)
    {
        JObject obj = new JObject
        (
            new JProperty("UnnaName", value ? value.name : string.Empty)
        );
        obj.WriteTo(writer);
    }
    public override UnnaSO ReadJson(JsonReader reader, Type objectType, UnnaSO existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return null;
    }
}
public sealed class UnnaPresetJsonConverter : JsonConverter<UnnaPreset>
{
    public override void WriteJson(JsonWriter writer, UnnaPreset value, JsonSerializer serializer)
    {
        if (value.Data.learntMoves == null)
        {
            JObject objN = new JObject
        (
            new JProperty("PresetName", string.Empty),
            new JProperty("UnnaPresetName", string.Empty),
            new JProperty("UnnaPresetModifier", string.Empty),
            new JProperty("UnnaPresetStats", new int[6]),
            new JProperty("UnnaPresetMoves", new List<string>())
        );
            objN.WriteTo(writer);
            return;
        }
        Dictionary<Stat, int> refValues = new();
        for (int i = 0; i < value.Data.StatReinforcement.Length; i++)
        {
            refValues[value.Data.StatReinforcement[i].stat] = value.Data.StatReinforcement[i].boost;
        }
        var jobjectKeyValuePair = new int[6]
        {
            refValues.ContainsKey(Stat.HP)?refValues[Stat.Attack]:0,
            refValues.ContainsKey(Stat.Attack)?refValues[Stat.Attack]:0,
            refValues.ContainsKey(Stat.BlessPower)?refValues[Stat.Attack]:0,
            refValues.ContainsKey(Stat.Defense)?refValues[Stat.Attack]:0,
            refValues.ContainsKey(Stat.BlessRes)?refValues[Stat.Attack]:0,
            refValues.ContainsKey(Stat.Speed)?refValues[Stat.Attack]:0,
        };

        List<string> moves = new();
        foreach (var move in value.Data.learntMoves)
        {
            moves.Add(move);
        }
        JObject obj = new JObject
        (
            new JProperty("PresetName", value.Name),
            new JProperty("UnnaPresetName", value.Data.name),
            new JProperty("UnnaPresetModifier", value.Data.modifier),
            new JProperty("UnnaPresetStats", jobjectKeyValuePair),
            new JProperty("UnnaPresetMoves", value.Data.learntMoves)
        );
        obj.WriteTo(writer);
    }
    public override UnnaPreset ReadJson(JsonReader reader, Type objectType, UnnaPreset existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        return new();
    }
}
public sealed class NewtonsoftColorConverter : JsonConverter<Color>
{
    public override void WriteJson(JsonWriter writer, Color value, JsonSerializer serializer)
    {
        JObject obj = new JObject
        (
            new JProperty("r", value.r),
            new JProperty("g", value.g),
            new JProperty("b", value.b),
            new JProperty("a", value.a)
        );

        obj.WriteTo(writer);
    }

    public override Color ReadJson(JsonReader reader, Type objectType, Color existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return new Color
        (
            obj.Value<float>("r"),
            obj.Value<float>("g"),
            obj.Value<float>("b"),
            obj.Value<float>("a")
        );
    }
}
public class LocalizedStringJsonConverter : JsonConverter<LocalizedString>
{
    public override LocalizedString ReadJson(JsonReader reader, Type objectType, LocalizedString existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        List<JObject> list = obj.Value<JToken>("LocalizData").ToObject<List<JObject>>();
        LocalizedString result;
        var tableRef = obj.Value<string>("TableReference");
        var keyRef = obj.Value<string>("Key");
        for (int i = 0; i < list.Count; i++)
        {
            Locale currentLocale = LocalizationSettings.AvailableLocales.GetLocale(new(list[i].Value<string>("Locale")));
            var table = LocalizationSettings.Instance.GetStringDatabase().GetTable(tableRef, currentLocale);
            var existingEntry = table.GetEntry(keyRef);
            if (existingEntry != null)
            {
                return new
                (
                    tableRef,
                    keyRef
                );
            }
            else
            {
                Debug.Log($"Adding entry {keyRef} in {tableRef}");
                var newEntry = table.AddEntry(keyRef, list[i].Value<string>("Value"));
            }
        }
        result = new(tableRef, keyRef);
        return result;
    }
    public override void WriteJson(JsonWriter writer, LocalizedString value, JsonSerializer serializer)
    {
        List<JObject> data = new();
        for (int i = 0; i < LocalizationSettings.AvailableLocales.Locales.Count; i++)
        {
            value.LocaleOverride = LocalizationSettings.AvailableLocales.Locales[i];
            JObject objEntry = new
               (
                   new JProperty("Locale", LocalizationSettings.AvailableLocales.Locales[i].Identifier.Code),
                   new JProperty("Value", value.GetLocalizedString())
               );
            data.Add(objEntry);
        }
        JObject obj = new
               (
                   new JProperty("TableReference", value.TableReference.TableCollectionName),
                   new JProperty("Key", value.TableEntryReference.ResolveKeyName(LocalizationSettings.Instance.GetStringDatabase().GetTable(value.TableReference.TableCollectionName).SharedData)),
                   new JProperty("LocalizData", data)
               );
        obj.WriteTo(writer);
    }
}
#if UNITY_EDITOR
[CustomEditor(typeof(ModAsset), true)]
class ModAssetEditor : Editor
{
    public override void OnInspectorGUI()
    {
        var _target = target as ModAsset;

        base.OnInspectorGUI();
        GUILayout.Space(30);
        if (GUILayout.Button("Print Data")) _target.PrintJson();
    }
}
#endif
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;
using System;
using System.Collections.Generic;
using UnityEngine.Localization.Settings;
using System.Linq;
using UnityEngine.Rendering;

public class ModAsset : ScriptableObject
{
    public string ModName = "mymod";
    public ulong ModID = 0;
    public virtual void PrintJson()
    {

    }
}
public sealed class UnnaSaveDataJsonConverter : JsonConverter<UnnaSaveData>
{
    public override void WriteJson(JsonWriter writer, UnnaSaveData value, JsonSerializer serializer)
    {
        if (value.learntMoves == null)
        {
            JObject objN = new JObject
        (
            new JProperty("UnnaSaveName", string.Empty),
            new JProperty("UnnaSaveModifier", string.Empty),
             new JProperty("UnnaSaveAbility", 0),
            new JProperty("UnnaSaveAssist", 0),
            new JProperty("UnnaSaveStats", new int[6]),
            new JProperty("UnnaSaveMoves", new List<string>())
        );
            objN.WriteTo(writer);
            return;
        }
        Dictionary<Stat, int> refValues = new()
        {
            { Stat.HP, 0 }, 
            { Stat.Attack, 0 }, 
            { Stat.BlessPower, 0 }, 
            { Stat.Defense, 0 }, 
            { Stat.BlessRes, 0 }, 
            { Stat.Speed, 0 }, 
        };
        for (int i = 0; i < value.StatReinforcement.Length; i++)
        {
            refValues[value.StatReinforcement[i].stat] = value.StatReinforcement[i].boost;
        }
        var jobjectKeyValuePair = new int[6]
        {
            refValues.ContainsKey(Stat.HP)?refValues[Stat.HP]:0,
            refValues.ContainsKey(Stat.Attack)?refValues[Stat.Attack]:0,
            refValues.ContainsKey(Stat.BlessPower)?refValues[Stat.BlessPower]:0,
            refValues.ContainsKey(Stat.Defense)?refValues[Stat.Defense]:0,
            refValues.ContainsKey(Stat.BlessRes)?refValues[Stat.BlessRes]:0,
            refValues.ContainsKey(Stat.Speed)?refValues[Stat.Speed]:0,
        };
        List<string> moves = new();
        foreach (var move in value.learntMoves)
        {
            moves.Add(move);
        }
        JObject obj = new JObject
        (
            new JProperty("UnnaSaveName", value.name),
            new JProperty("UnnaSaveModifier", value.modifier),
            new JProperty("UnnaSaveAbility", value.ability),
            new JProperty("UnnaSaveAssist", value.assist),
            new JProperty("UnnaSaveStats", jobjectKeyValuePair),
            new JProperty("UnnaSaveMoves", value.learntMoves)
        );
        obj.WriteTo(writer);
    }
    public override UnnaSaveData ReadJson(JsonReader reader, Type objectType, UnnaSaveData existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        if (!obj.ContainsKey("UnnaSaveStats"))
        {
            Debug.Log("No stats");
            return new();
        }
        if (!obj.ContainsKey("UnnaSaveMoves"))
        {
            Debug.Log("No moves");
            return new();
        }
        var movesToken = obj.Value<JToken>("UnnaSaveMoves");
        var moves = movesToken.ToObject<List<string>>();

        string[] moveData = new string[moves.Count];
        for (int i = 0; i < moveData.Length; i++)
        {
            moveData[i] = moves.ToList()[i];
        }
        var statsToken = obj.Value<JToken>("UnnaSaveStats");
        var reinfList = statsToken.ToObject<List<int>>();
        if (reinfList.Count == 0) return new UnnaSaveData();
        StatBoost[] jobjectKeyValuePair = new StatBoost[6]
        {
            new()
            {
                stat= Stat.HP,
                boost=reinfList[0]

            },
            new()
            {
                stat= Stat.Attack,
                boost=reinfList[1]

            } ,
            new()
            {
                stat= Stat.Defense,
                boost=reinfList[2]

            } ,
            new()
            {
                stat= Stat.BlessPower,
                boost=reinfList[3]

            } ,
            new()
            {
                stat= Stat.BlessRes,
                boost=reinfList[4]

            } ,
            new()
            {
                stat= Stat.Speed,
                boost=reinfList[5]

            }
        };
        UnnaSaveData data = new()
        {
            name = obj.Value<string>("UnnaSaveName"),
            modifier = obj.Value<string>("UnnaSaveModifier"),
            assist = obj.Value<int>("UnnaSaveAssist"),
            ability = obj.Value<int>("UnnaSaveAbility"),
            learntMoves = moveData.ToArray(),
            StatReinforcement = jobjectKeyValuePair
        };
        return data;
    }
}
public sealed class NewtonsoftVector2Converter : JsonConverter<Vector2>
{
    public override void WriteJson(JsonWriter writer, Vector2 value, JsonSerializer serializer)
    {
        JObject obj = new JObject
        (
            new JProperty("x", value.x),
            new JProperty("y", value.y)
        );

        obj.WriteTo(writer);
    }

    public override Vector2 ReadJson(JsonReader reader, Type objectType, Vector2 existingValue, bool hasExistingValue, JsonSerializer serializer)
    {
        JObject obj = JObject.Load(reader);
        return new Vector2
        (
            obj.Value<float>("x"),
            obj.Value<float>("y")
        );
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
            new JProperty("UnnaPresetAbility", 0),
            new JProperty("UnnaPresetAssist", 0),
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
            refValues.ContainsKey(Stat.HP)?refValues[Stat.HP]:0,
            refValues.ContainsKey(Stat.Attack)?refValues[Stat.Attack]:0,
            refValues.ContainsKey(Stat.BlessPower)?refValues[Stat.BlessPower]:0,
            refValues.ContainsKey(Stat.Defense)?refValues[Stat.Defense]:0,
            refValues.ContainsKey(Stat.BlessRes)?refValues[Stat.BlessRes]:0,
            refValues.ContainsKey(Stat.Speed)?refValues[Stat.Speed]:0,
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
            new JProperty("UnnaPresetAbility", value.Data.ability),
            new JProperty("UnnaPresetAssist", value.Data.assist),
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
        if (!value.IsEmpty)
        {

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
        else
        {
            JObject obj = new
                   (
                       new JProperty("TableReference", string.Empty),
                       new JProperty("Key", string.Empty),
                       new JProperty("LocalizData", data)
                   );
            obj.WriteTo(writer);
        }
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
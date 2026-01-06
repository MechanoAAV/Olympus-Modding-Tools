using Newtonsoft.Json;
using System.Collections;
using System.IO;
using UnityEditor;
using UnityEngine;

public abstract class MoveEffectBase : ScriptableObject
{
    public string ModName = "mymod";
    [SerializeField] float _moveAIValue = .5f;
    /// <summary>
    /// The initial value given by the ai. This determines how likely the ai is to use the move before applying modifiers
    /// </summary>
    public float MoveAIValue => _moveAIValue;
    public virtual void PrintJson()
    {
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName}/Move/{name}"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName}/Move/{name}");
            File.Create(Application.streamingAssetsPath + $"/{ModName}/Move/{name}/{name}.txt").Dispose();
        }
        var settings = new JsonSerializerSettings();
        settings.Converters.Add(new NewtonsoftColorConverter());
        settings.Converters.Add(new LocalizedStringJsonConverter());
        settings.Converters.Add(new NewtonsoftMoveGOConverter());
        settings.Converters.Add(new TypeRefJsonConverter());
        string value = JsonConvert.SerializeObject(this, Formatting.Indented, settings);
        File.WriteAllText(Application.streamingAssetsPath + $"/{ModName}/Move/{name}/{name}.txt", value);
    }
}
#if UNITY_EDITOR
[CustomEditor(typeof(MoveEffectBase), true)]
class MoveEffectBaseEditor : Editor
{
    public override void OnInspectorGUI()
    {
        var _target = target as MoveEffectBase;

        base.OnInspectorGUI();
        GUILayout.Space(30);
        if (GUILayout.Button("Print Data")) _target.PrintJson();
    }
}
#endif
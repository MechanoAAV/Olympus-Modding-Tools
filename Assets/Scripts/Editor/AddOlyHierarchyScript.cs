using Unity.Cinemachine;
using UnityEditor;
using UnityEngine;

public class AddOlyHierarchyScript
{
    // Add a menu item named "Do Something" to MyMenu in the menu bar.
    [MenuItem("MyMenu/Do Something")]
    static void DoSomething()
    {
        Debug.Log("Doing Something...");
    }
    // Add a menu item to create custom GameObjects.
    // Priority 10 ensures it is grouped with the other menu items of the same kind
    // and propagated to the hierarchy dropdown and hierarchy context menus.
    [MenuItem("GameObject/New Oly", false)]
    static void CreateCustomGameObject(MenuCommand menuCommand)
    {
        // Create a custom game object
        GameObject go = new GameObject("Oly");
        // Ensure it gets reparented if this was a context click (otherwise does nothing)
        GameObjectUtility.SetParentAndAlign(go, null);
        // Register the creation in the undo system
        Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
        go.AddComponent<ModelData>();
        GameObject goTg = new GameObject("target");
        GameObjectUtility.SetParentAndAlign(goTg, go);
        goTg.AddComponent<CinemachineTargetGroup>();
        Selection.activeObject = go;
    }
}
using System;
using UnityEngine;
[CreateAssetMenu(fileName = "Ability_", menuName = "Oly/Ability/MoveImmunity")]
public class AbilityImmuneMove : AbilityBase
{
    public ImmuneMoveData[] immuneData;
}
[System.Serializable]
public struct ImmuneMoveData
{
    public string Groups;
    public StatBoost[] _boosts;
    [Range(0, 100)] public float _hpHeal;
}
using System.Collections;
using UnityEngine;

[CreateAssetMenu(fileName = "Ability_", menuName = "Unna/Ability/OnSendout")]
public class AbilityOnSendout : AbilityBase
{
    [SerializeField] AbilityDefeatEffect _effects;
    [SerializeField] bool _assistOnly;
}
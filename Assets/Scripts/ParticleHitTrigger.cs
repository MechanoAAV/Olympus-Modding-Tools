using System;
using UnityEngine;

public class ParticleHitTrigger : MonoBehaviour
{
    [Tooltip("Select the root of the prefab")][SerializeField] GameObject _objectToPool;
    [SerializeField] ParticleCallbackType _particleCallbackType;
    [Tooltip("For OnDelay")][SerializeField] float _delayTime;
}
public enum ParticleCallbackType
{
    OnSpawn, OnStop, OnDelay
}
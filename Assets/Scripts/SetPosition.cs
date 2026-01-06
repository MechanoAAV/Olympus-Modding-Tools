using PrimeTween;
using System;
using UnityEngine;

public class TweenPosition : MonoBehaviour
{
    [SerializeField] bool _autoEnable = true;
    [SerializeField] bool _overridePosX;
    [SerializeField] float overridePosX;
    [SerializeField] bool _overridePosY;
    [SerializeField] float overridePosY;
    [SerializeField] bool _overridePosZ;
    [SerializeField] float overridePosZ;

    Vector3 overriddenPos;
    [SerializeField] bool _overrideRot;
    [SerializeField] Vector3 _newRot;
    [SerializeField] bool _tween = true;
    [SerializeField] bool _resetPos;
    [SerializeField] TweenSettings settings;
    [SerializeField] Vector3 _direction;
    [SerializeField] bool _returnToPool;

}
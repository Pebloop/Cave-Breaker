using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class Database
{
    public string userId = null;
    public string displayName = null;
    public string profilePicture = null;

    public Database()
    {
        userId = null;
        displayName = null;
        profilePicture = null;
    }
}

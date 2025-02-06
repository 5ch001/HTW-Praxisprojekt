// HighscoreModels.cs
using System;
using System.Collections.Generic;

[System.Serializable]
public class HighscoreEntry
{
    public string playerName;
    public float score;
}

[System.Serializable]
public class HighscoreList
{
    public List<HighscoreEntry> entries;
}

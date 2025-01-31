using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class LeaderboardDisplay : MonoBehaviour
{
     public TextMeshProUGUI leaderboardText;
    private const string HighscoresKey = "Highscores";

    void Start()
    {
        DisplayLeaderboard();
    }
    

    public void DisplayLeaderboard()
    {
       List<HighscoreEntry> highscores = LoadHighscores();
    highscores.Sort((x, y) => y.score.CompareTo(x.score));

    // Display only the top 10 players
    int displayCount = Mathf.Min(10, highscores.Count);
    string leaderboardContent = "Leaderboard\n";

    for (int i = 0; i < displayCount; i++)
    {
        HighscoreEntry entry = highscores[i];
        leaderboardContent += $"{i + 1}. {entry.playerName} - {Mathf.FloorToInt(entry.score)}\n";
    }

    leaderboardText.text = leaderboardContent;
    }

    private List<HighscoreEntry> LoadHighscores()
    {
        if (PlayerPrefs.HasKey(HighscoresKey))
        {
            string json = PlayerPrefs.GetString(HighscoresKey);
            return JsonUtility.FromJson<HighscoreList>(json).entries;
        }
        return new List<HighscoreEntry>();
    }
}




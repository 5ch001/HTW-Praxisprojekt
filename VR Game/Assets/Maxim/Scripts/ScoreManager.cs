using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Collections.Generic;


public class ScoreManager : MonoBehaviour
{
    public Text scoreText;
    private float playerScore = 0f;
    public float scoreMultiplier = 2f; //arbitrary value
    private float timeElapsed = 0f;
    private float increaseInterval = 10f; //10 seconds
    public GameObject scorePopupPrefab;

    //private const string DefaultPlayerName = "PlayerHTW";
     public static ScoreManager Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
        DontDestroyOnLoad(gameObject); // Behält das Objekt beim Szenenwechsel
    }

    void Start()
    {
        ResetScore();
    }

    void Update()
    {
        UpdateScore();
        IncreaseMultiplier();
    }

    private void UpdateScore() {

        playerScore += Time.deltaTime * scoreMultiplier;
        scoreText.text = "Score: " + Mathf.FloorToInt(playerScore).ToString();
    }

    private void IncreaseMultiplier() {
        timeElapsed += Time.deltaTime;
        if (timeElapsed >= increaseInterval) {
            scoreMultiplier += 0.1f;
            timeElapsed = 0f;
        }
    }

    private void ResetScore() {
        playerScore = 0f;
        scoreMultiplier = 2f;
        timeElapsed = 0f;
    }

    public void AddScore(float score) { //Called when player destroys an object (in DestroyOnGrab.cs)
        playerScore += score;
        ShowScorePopup(score);
    }

    private void ShowScorePopup(float score)
    {
        GameObject popup = Instantiate(scorePopupPrefab, new Vector3(scoreText.transform.position.x + 5, scoreText.transform.position.y + 5, scoreText.transform.position.z), Quaternion.identity, scoreText.transform.parent);
        popup.GetComponent<Text>().text = "+" + score.ToString();
        popup.transform.localScale = Vector3.one;
        popup.transform.localRotation = Quaternion.identity;
        StartCoroutine(FadeOutAndDestroy(popup));
    }

    private IEnumerator FadeOutAndDestroy(GameObject popup)
    {
        Text popupText = popup.GetComponent<Text>();
        Color originalColor = popupText.color;
        float duration = 2f; // Duration of the fade-out effect
        float elapsedTime = 0f;

        while (elapsedTime < duration)
        {
            elapsedTime += Time.deltaTime;
            float alpha = Mathf.Lerp(1f, 0f, elapsedTime / duration);
            popupText.color = new Color(originalColor.r, originalColor.g, originalColor.b, alpha);
            yield return null;
        }

        Destroy(popup);
    }
    private const string HighscoresKey = "Highscores"; // Key für die Highscores in PlayerPrefs

   public void SaveScore()
{
    List<HighscoreEntry> highscores = LoadHighscores();

    // Retrieve last used player number
    int lastPlayerNumber = PlayerPrefs.GetInt("LastPlayerNumber", 0);
    lastPlayerNumber++;
    
    // Generate a unique name
    string uniquePlayerName = $"Player-HTW{lastPlayerNumber}";

    // Store the new number for next time
    PlayerPrefs.SetInt("LastPlayerNumber", lastPlayerNumber);
    PlayerPrefs.Save();

    highscores.Add(new HighscoreEntry { playerName = uniquePlayerName, score = playerScore });

    highscores.Sort((x, y) => y.score.CompareTo(x.score));

    if (highscores.Count > 10)
    {
        highscores = highscores.GetRange(0, 10);
    }

    string json = JsonUtility.ToJson(new HighscoreList { entries = highscores });
    PlayerPrefs.SetString(HighscoresKey, json);
    PlayerPrefs.Save();

    Debug.Log($"Score saved: {uniquePlayerName} - {playerScore}");
}


    public void EndGameAndSave()
    {
        SaveScore(); // Save the current score with the default player name
        
    }

    // Load high scores
    private List<HighscoreEntry> LoadHighscores()
{
    if (PlayerPrefs.HasKey(HighscoresKey))
    {
        try
        {
            string json = PlayerPrefs.GetString(HighscoresKey);
            return JsonUtility.FromJson<HighscoreList>(json).entries;
        }
        catch (System.Exception ex)
        {
            Debug.LogError("Failed to load highscores: " + ex.Message);
            PlayerPrefs.DeleteKey(HighscoresKey); // Lösche fehlerhafte Daten
        }
    }
    return new List<HighscoreEntry>();
}

}

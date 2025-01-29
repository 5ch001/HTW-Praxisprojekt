using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class ScoreManager : MonoBehaviour
{
    public Text scoreText;
    public float playerScore = 0f;
    public float scoreMultiplier = 2f; //arbitrary value
    private float timeElapsed = 0f;
    private float increaseInterval = 10f; //10 seconds
    public GameObject scorePopupPrefab;

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

    public float GetScore() {
        return playerScore;
    }

    public void SetScore(float score) {
        playerScore = score;
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

}

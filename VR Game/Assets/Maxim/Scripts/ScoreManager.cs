using UnityEngine;
using UnityEngine.UI;

public class ScoreManager : MonoBehaviour
{
    public Text scoreText;
    private float playerScore = 0f;
    public float scoreMultiplier = 2f; //arbitrary value
    void Start()
    {
        
    }

    void Update()
    {
        UpdateScore();
    }

    private void UpdateScore() {

        playerScore += Time.deltaTime * scoreMultiplier;
        scoreText.text = "Score: " + Mathf.FloorToInt(playerScore).ToString();
    }

    private void IncreaseMultiplier() {
        
    }


}

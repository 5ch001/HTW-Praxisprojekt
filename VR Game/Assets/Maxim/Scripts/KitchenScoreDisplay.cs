using TMPro;
using UnityEngine;

public class KitchenScoreDisplay : MonoBehaviour
{
    public TextMeshPro scoreText;
    void FixedUpdate()
    {
        scoreText.text = "Score: " + Mathf.FloorToInt(GlobalScore.playerScore).ToString();
    }
}

using TMPro;
using UnityEngine;

public class CookingScore : MonoBehaviour
{
    public RecipeManager recipeManager; // Referenz zum RecipeManager
    public TextMeshPro scoreText;
    public ScoreManager scoreManager;

    void Start()
    {
        scoreManager = FindFirstObjectByType<ScoreManager>();
        recipeManager = FindFirstObjectByType<RecipeManager>();
        scoreText.text = scoreManager.GetScore().ToString();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

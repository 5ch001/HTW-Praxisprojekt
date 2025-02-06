using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR;
using UnityEngine.SceneManagement;

public class PlayerController : MonoBehaviour
{
    public Image healthBar; // Reference to the UI health bar
    private float healthAmount = 100f; // Player's current health
    private bool isDead = false; // Tracks if the player has lost all lives
    private float destructionRadius = 10f; // Radius within which asteroids will be destroyed
    private ButtonParticleController particleController;
    SceneTransitionManager sceneTransitionManager;

    [Header("Segmented Health Bar")]
    public Image[] healthSegments; // 10 images total

      [Header("Health Gradient")]
    public Gradient healthGradient; // Assign in Inspector

    [SerializeField] Animator transitionAnim;

    // Start is called before the first frame update
    void Start()
    {
        particleController = FindFirstObjectByType<ButtonParticleController>(); // Suche den Partikel-Controller in der Szene
        sceneTransitionManager = FindFirstObjectByType<SceneTransitionManager>();
        particleController.StopParticleSystem();
        healthAmount = 100f; // Initialize health to max
        UpdateSegmentedHealthBar();
        ResetHealthBar();
    }

    void Update()
    {
        if (isDead)
        {
            GameManager.ResetCollectedIngredients();
            sceneTransitionManager.GoToScene(0); // Load in MarsScene
            Debug.Log("Game Over.");
        }
    }

    public float GetHealthAmount() //Used in ObjectSpawnerScript.cs
    {
        return healthAmount;
    }

    public void SetHealthAmount(float newHealth) //Used in DestroyOnGrab.cs
    {
        healthAmount = newHealth;
        healthBar.fillAmount = healthAmount / 100f;
        UpdateSegmentedHealthBar();
    }

    private void OnTriggerEnter(Collider other)
    {
        // Check if the collided object has the tag "asteroid"
        if (other.gameObject.CompareTag("asteroid") && !isDead)
        {
            Debug.Log("Trigger hit with an asteroid!");
            TakeDamage(20f); // Reduce health by a fixed amount
            DestroyNearbyAsteroids(other.transform.position); // Destroy nearby asteroids
        }
    }

    public void TakeDamage(float damage)
    {
        healthAmount -= damage;
        healthAmount = Mathf.Clamp(healthAmount, 0f, 100f); // Ensure health stays between 0 and 100
        healthBar.fillAmount = healthAmount / 100f;
        UpdateSegmentedHealthBar();
        SoundManager.Instance.PlayPainSound();

        if (healthAmount <= 0f)
        {
            isDead = true;
            Debug.Log("Player is dead!");
            //TODO:
            // Additional logic for player death (e.g., game over screen) can go here
            // If player dies, load him into the lobby scene (maybe after pressing a button? Or automatically after a constant time (5sec, 3sec?)) and remove all grabbed ingredients from the list.
        }
    }

    private void UpdateSegmentedHealthBar()
    {
    // Each segment represents 10 health if you have 10 segments total.
    // Example: 100 health → all 10 segments active, 74 health → 8 segments active, etc.
    // You can adjust how you calculate this based on partial segments or rounding.

    // Number of segments to keep active (round up, round down, etc.):
    int segmentsActive = Mathf.CeilToInt(healthAmount / 10f);

   float healthFraction = healthAmount / 100f;
        Color barColor = healthGradient.Evaluate(healthFraction);

        // "On" color = gradient color with alpha=1
        Color onColor = new Color(barColor.r, barColor.g, barColor.b, 1f);
        // "Off" color = same color but alpha=0 (invisible)
        Color offColor = new Color(barColor.r, barColor.g, barColor.b, 0f);

        for (int i = 0; i < healthSegments.Length; i++)
        {
            bool shouldBeOn = (i < segmentsActive);
            float currentAlpha = healthSegments[i].color.a;
            bool isOnNow = currentAlpha > 0.5f;

            if (shouldBeOn && !isOnNow)
            {
                StartCoroutine(FadeSegment(healthSegments[i], onColor, 0.3f));
            }
            else if (!shouldBeOn && isOnNow)
            {
                StartCoroutine(FadeSegment(healthSegments[i], offColor, 0.3f));
            }
        }
    }

 private IEnumerator FadeSegment(Image segment, Color targetColor, float duration)
    {
        Color startColor = segment.color;
        float time = 0f;

        while (time < duration)
        {
            time += Time.deltaTime;
            float t = Mathf.Clamp01(time / duration);
            segment.color = Color.Lerp(startColor, targetColor, t);
            yield return null;
        }

        // Finalize the color
        segment.color = targetColor;
    }
   


    private void ResetHealthBar()
    {
        healthAmount = 100f; // Reset health to full
        healthBar.fillAmount = 1f; // Set health bar to full
    }

    private void DestroyNearbyAsteroids(Vector3 position)
    {
        Collider[] hitColliders = Physics.OverlapSphere(position, destructionRadius);
        foreach (var hitCollider in hitColliders)
        {
            if (hitCollider.gameObject.CompareTag("asteroid"))
            {
                Destroy(hitCollider.gameObject);
                Debug.Log("Destroyed nearby asteroid!");
            }
        }
    }
}



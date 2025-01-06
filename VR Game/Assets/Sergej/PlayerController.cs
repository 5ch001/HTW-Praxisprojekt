using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR;
using UnityEngine.SceneManagement;

public class PlayerController : MonoBehaviour
{
    public Image healthBar; // Reference to the UI health bar
    public Image pressBar; // Reference to the UI press bar
    private float healthAmount = 100f; // Player's current health
    private bool isDead = false; // Tracks if the player has lost all lives
    private bool loadKitchen = false; // Tracks if the kitchen scene should be loaded
    private float buttonHoldTime = 0f; // Tracks how long the button is held down
    private float requiredHoldTime = 3f; // Time required to trigger the action
    private float destructionRadius = 10f; // Radius within which asteroids will be destroyed

      [Header("Segmented Health Bar")]
    public Image[] healthSegments; // 10 images total

      [Header("Health Gradient")]
    public Gradient healthGradient; // Assign in Inspector

    [SerializeField] Animator transitionAnim;

    // Start is called before the first frame update
    void Start()
    {
        healthAmount = 100f; // Initialize health to max
        UpdateSegmentedHealthBar();
        ResetHealthBar();
        ResetPressBar(); // Initialize PressBar to empty
    }

    void Update()
    {
        LoadKitchenScene();

        // Optional debug output
        if (isDead)
        {
            LoadNextLevel();
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

    private void ResetPressBar()
    {
        pressBar.fillAmount = 0f; // Reset press bar to empty
    }

    private void UpdatePressBar()
    {
        pressBar.fillAmount = buttonHoldTime / requiredHoldTime; // Fill the press bar proportionally
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

    public void LoadNextLevel()
    {
        StartCoroutine(LoadLevel());
    }

    IEnumerator LoadLevel()
    {
        transitionAnim.SetTrigger("End");
        yield return new WaitForSeconds(1);
        SceneManager.LoadSceneAsync(SceneManager.GetActiveScene().buildIndex + 1);
        transitionAnim.SetTrigger("Start");
    }

    private void LoadKitchenScene()
    {
        InputDevice controller = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);

        if (controller.isValid)
        {
            bool isButtonPressed;

            // Check if the primary button (A button) is being pressed
            if (controller.TryGetFeatureValue(CommonUsages.primaryButton, out isButtonPressed) && isButtonPressed)
            {
                buttonHoldTime += Time.deltaTime; // Increase the hold time
                UpdatePressBar(); // Update the press bar fill amount

                if (buttonHoldTime >= requiredHoldTime && !loadKitchen)
                {
                    loadKitchen = true;
                    Debug.Log("lade Kochszene");
                    LoadNextLevel();
                    // Also, consider adding a loading screen or transition effect
                    // After pressing the button for 3 seconds, the player is prompted to leave the endless runner and enter the kitchen scene. That ensures that the player doesn't accidentally leave the game.
                }
            }
            else
            {
                buttonHoldTime = 0f; // Reset the timer if the button is released
                ResetPressBar(); // Reset the press bar to empty
            }
        }
    }
}



using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR;

public class PlayerController : MonoBehaviour
{
    public Image healthBar; // Reference to the UI health bar
    public float healthAmount = 100f; // Player's current health

    private bool isDead = false; // Tracks if the player has lost all lives
    private bool loadKitchen = false; // Tracks if the kitchen scene should be loaded
    private float buttonHoldTime = 0f; // Tracks how long the button is held down
    private float requiredHoldTime = 3f; // Time required to trigger the action

    // Start is called before the first frame update
    void Start()
    {
        healthAmount = 100f; // Initialize health to max
        ResetHealthBar();
    }

    private void OnTriggerEnter(Collider other)
    {
        // Check if the collided object has the tag "asteroid"
        if (other.gameObject.CompareTag("asteroid") && !isDead)
        {
            Debug.Log("Trigger hit with an asteroid!");
            TakeDamage(20f); // Reduce health by a fixed amount
        }
    }

    public void TakeDamage(float damage)
    {
        healthAmount -= damage;
        healthAmount = Mathf.Clamp(healthAmount, 0f, 100f); // Ensure health stays between 0 and 100
        healthBar.fillAmount = healthAmount / 100f;

        if (healthAmount <= 0f)
        {
            isDead = true;
            Debug.Log("Player is dead!");
            // Additional logic for player death (e.g., game over screen) can go here
        }
    }

    private void ResetHealthBar()
    {
        healthAmount = 100f; // Reset health to full
        healthBar.fillAmount = 1f; // Set health bar to full
    }

    // Update is called once per frame
    void Update()
    {
        InputDevice controller = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);

        if (controller.isValid)
        {
            bool isButtonPressed;

            // Check if the primary button (A button) is being pressed
            if (controller.TryGetFeatureValue(CommonUsages.primaryButton, out isButtonPressed) && isButtonPressed)
            {
                buttonHoldTime += Time.deltaTime;

                if (buttonHoldTime >= requiredHoldTime && !loadKitchen)
                {
                    loadKitchen = true;
                    Debug.Log("lade Kochszene");
                }
            }
            else
            {
                buttonHoldTime = 0f; // Reset the timer if the button is released
            }
        }

        // Optional debug output
        if (isDead)
        {
            Debug.Log("Game Over.");
        }
    }
}

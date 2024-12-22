using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR;

public class PlayerController : MonoBehaviour
{
    public GameObject m_GotHitScreen; // The UI screen that shows the red overlay
    private int maxLives = 6; // Total lives the player starts with
    private int currentLives; // Current lives the player has
    private float transparencyIncrement = 0.12f; // 8% increment per hit

    private bool isDead = false; // Tracks if the player has lost all lives

    private bool loadKitchen = false; // Tracks if the kitchen scene should be loaded
    private float buttonHoldTime = 0f; // Tracks how long the button is held down
    private float requiredHoldTime = 3f; // Time required to trigger the action

    // Start is called before the first frame update
    void Start()
    {
        currentLives = maxLives; // Initialize lives to max
        ResetScreenTransparency();
    }

    private void OnCollisionEnter(Collision collision)
    {
        // Check if the collided object is named "Asteroid 4"
        if (collision.gameObject.name == "Asteroid 4")
        {
            HandleCollision();
        }
    }

    private void HandleCollision()
    {
        if (isDead) return; // If the player is already dead, do nothing

        currentLives--; // Reduce one life

        if (currentLives > 0)
        {
            UpdateScreenTransparency();
        }

        if (currentLives <= 0)
        {
            isDead = true;
            SetScreenFullyRed();
            Debug.Log("Player is dead!");
            // Additional logic for player death (e.g., Game Over) can go here
        }
        else
        {
            Debug.Log($"Player hit! Lives remaining: {currentLives}");
        }
    }

    private void UpdateScreenTransparency()
    {
        float alpha = Mathf.Min(transparencyIncrement * (maxLives - currentLives), 0.6f); // Cap transparency at 40%
        var color = m_GotHitScreen.GetComponent<Image>().color;
        color.a = Mathf.Clamp(alpha, 0f, 0.6f); // Ensure alpha stays between 0 and 0.4
        m_GotHitScreen.GetComponent<Image>().color = color;
    }

    private void SetScreenFullyRed()
    {
        var color = m_GotHitScreen.GetComponent<Image>().color;
        color.a = 1f; // Set transparency to 100%
        m_GotHitScreen.GetComponent<Image>().color = color;
    }

    private void ResetScreenTransparency()
    {
        var color = m_GotHitScreen.GetComponent<Image>().color;
        color.a = 0f; // Start fully transparent
        m_GotHitScreen.GetComponent<Image>().color = color;
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
            Debug.Log("Game Over: The screen is now fully red.");
        }
    }
}

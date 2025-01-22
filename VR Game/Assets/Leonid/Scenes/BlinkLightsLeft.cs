using UnityEngine;

public class BlinkLightsLeft : MonoBehaviour
{
    public Light[] lights;         // Array of lights in this line
    public float blinkInterval = 0.5f; // Time between each light's blink
    public float maxIntensity = 5f;   // Maximum intensity of the lights
    public float minIntensity = 0f;   // Minimum intensity of the lights

    private float timer = 0f; // Timer for managing blinking
    private int currentLightIndex = 0; // Index of the currently active light

    void Update()
    {
        // Update the timer
        timer += Time.deltaTime;

        // If the timer exceeds the blink interval, switch to the next light
        if (timer >= blinkInterval)
        {
            timer = 0f; // Reset the timer

            // Turn off the previous light
            if (currentLightIndex < lights.Length && lights[currentLightIndex] != null)
            {
                lights[currentLightIndex].intensity = minIntensity;
            }

            // Move to the next light
            currentLightIndex = (currentLightIndex + 1) % lights.Length;

            // Turn on the new light
            if (currentLightIndex < lights.Length && lights[currentLightIndex] != null)
            {
                lights[currentLightIndex].intensity = maxIntensity;
            }
        }
    }
}

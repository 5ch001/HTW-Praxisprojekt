using UnityEngine;
using UnityEngine.UI;

public class NextPlayerNameDisplay : MonoBehaviour
{
    public Text nextPlayerNameText;

    void Start()
    {
        UpdateNextPlayerName();
    }

    // This method calculates the next player's name by adding 1 to the stored player number.
    public void UpdateNextPlayerName()
    {
        // Retrieve the last used player number (for the current session)
        int lastPlayerNumber = PlayerPrefs.GetInt("LastPlayerNumber", 0);
        // The next player's number will be one more.
        int nextPlayerNumber = lastPlayerNumber + 1;
        // Construct the next player's name
        string nextPlayerName = $"Player-HTW{nextPlayerNumber}";
        // Update the text with a welcome message.
        nextPlayerNameText.text = "Welcome,\n you are:\n" + nextPlayerName;
    }
}

using UnityEngine;

public class XRSpawnPosition : MonoBehaviour
{
    void Start()
    {
        transform.SetPositionAndRotation(new Vector3(transform.parent.parent.position.x, transform.parent.parent.position.y, transform.parent.parent.position.z), Quaternion.Euler(transform.parent.parent.rotation.x, transform.parent.parent.rotation.y, transform.parent.parent.rotation.z));
    }
    //This script is attached to the MainCamera from the XR Rig prefab. The values refer to the XR Rig Prefab.
}

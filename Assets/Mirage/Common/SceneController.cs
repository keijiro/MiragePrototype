using UnityEngine;

namespace Mirage
{
    public class SceneController : MonoBehaviour
    {
        void Start()
        {
            if (!Application.isEditor) Cursor.visible = false;
        }

        public void SwitchScene(int index)
        {
            Application.LoadLevel(index);
        }
    }
}

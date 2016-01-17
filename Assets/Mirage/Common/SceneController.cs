using UnityEngine;

namespace Mirage
{
    public class SceneController : MonoBehaviour
    {
        void Start()
        {
            if (!Application.isEditor) Cursor.visible = false;
        }

        public void LoadBackgroundScene()
        {
            Application.LoadLevel(0);
        }

        public void LoadForegroundScene()
        {
            Application.LoadLevel(1);
        }
    }
}

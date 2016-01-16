using UnityEngine;
using Klak.MaterialExtension;

namespace Mirage
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    public class RimLight : MonoBehaviour
    {
        #region Public Properties

        [SerializeField, ColorUsage(true, true, 0, 16, 0.125f, 3)]
        Color _color = Color.white;

        public Color color {
            get { return _color; }
            set { _color = value; }
        }

        [SerializeField, Range(0, 20)]
        float _exponent = 8;

        public float exponent {
            get { return _exponent; }
            set { _exponent = value; }
        }

        #endregion

        #region Private Resources

        [SerializeField]
        Shader _shader;

        Material _material;

        #endregion

        #region MonoBehaviour Functions

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (_material == null) {
                _material = new Material(_shader);
                _material.hideFlags = HideFlags.DontSave;
            }

            _material.
                Property("_Color", _color).
                Property("_Exponent", _exponent);

            Graphics.Blit(source, destination, _material, 0);
        }

        #endregion
    }
}

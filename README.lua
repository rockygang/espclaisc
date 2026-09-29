using UnityEngine;

public class ESPManager : MonoBehaviour
{
    // Color de los cuadros del ESP
    public Color colorEsp = Color.red; 
    private Camera camaraPrincipal;

    void Start()
    {
        // Guardamos la referencia de la cámara principal
        camaraPrincipal = Camera.main;
    }

    void OnGUI()
    {
        // Buscamos a todos los enemigos en la escena
        GameObject[] enemigos = GameObject.FindGameObjectsWithTag("Enemigo");

        foreach (GameObject enemigo in enemigos)
        {
            // 1. Obtener la posición del enemigo en el espacio 3D
            Vector3 posicion3D = enemigo.transform.position;

            // 2. Convertir la posición 3D a coordenadas 2D de la pantalla
            Vector3 posicionPantalla = camaraPrincipal.WorldToScreenPoint(posicion3D);

            // 3. Verificar si el enemigo está frente a la cámara (Z > 0)
            if (posicionPantalla.z > 0)
            {
                // Invertir el eje Y porque las coordenadas de Unity GUI empiezan arriba a la izquierda
                float x = posicionPantalla.x;
                float y = Screen.height - posicionPantalla.y;

                // Calcular la distancia para escalar el tamaño del cuadro
                float distancia = Vector3.Distance(camaraPrincipal.transform.position, posicion3D);
                float ancho = 500 / distancia;
                float alto = 1000 / distancia;

                // 4. Dibujar los elementos en pantalla
                DibujarCuadroESP(x - ancho / 2, y - alto, ancho, alto, colorEsp);
                DibujarTextoESP(x, y + 10, enemigo.name + " [" + Mathf.Round(distancia) + "m]", colorEsp);
            }
        }
    }

    // Función auxiliar para dibujar los rectángulos (Bordes)
    void DibujarCuadroESP(float x, float y, float ancho, float alto, Color color)
    {
        Texture2D textura = Texture2D.whiteTexture;
        GUI.color = color;

        // Línea superior, inferior, izquierda y derecha
        GUI.DrawTexture(new Rect(x, y, ancho, 2), textura);
        GUI.DrawTexture(new Rect(x, y + alto, ancho, 2), textura);
        GUI.DrawTexture(new Rect(x, y, 2, alto), textura);
        GUI.DrawTexture(new Rect(x + ancho, y, 2, alto + 2), textura);
    }

    // Función auxiliar para mostrar texto (Nombre y Distancia)
    void DibujarTextoESP(float x, float y, string texto, Color color)
    {
        GUIStyle estilo = new GUIStyle();
        estilo.normal.textColor = color;
        estilo.alignment = TextAnchor.UpperCenter;
        
        GUI.Label(new Rect(x, y, 0, 0), texto, estilo);
    }
}

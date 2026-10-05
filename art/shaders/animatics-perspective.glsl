#if defined(VERTEX)

uniform mat4 MVPMatrix;

attribute vec2 VertexCoord;
attribute vec2 TexCoord;
attribute vec4 COLOR;

varying vec2 v_tex;
varying vec4 v_col;


/*
    ============================================================
                  ANIMATICS-DX - PERSPECTIVE
    ============================================================

    Chaque paramètre déplace UN coin de l'image.

                    hautGauche ───── hautDroit
                         │               │
                         │     IMAGE     │
                         │               │
                    basGauche  ───── basDroit


    Chaque valeur contient :  X  Y

    X :
        valeur positive = déplacement vers la DROITE
        valeur négative = déplacement vers la GAUCHE

    Y :
        valeur positive = déplacement vers le BAS
        valeur négative = déplacement vers le HAUT

    Exemple :

        hautGauche = 10 -5

        => coin haut gauche :
           10 vers la droite
            5 vers le haut
    ============================================================
*/

uniform vec2 hautGauche;
uniform vec2 hautDroit;
uniform vec2 basGauche;
uniform vec2 basDroit;


void main(void)
{
    vec2 offset = vec2(0.0, 0.0);

    // HAUT GAUCHE
    if(VertexCoord.x <= 0.0 && VertexCoord.y <= 0.0)
        offset = hautGauche;

    // HAUT DROIT
    else if(VertexCoord.x >= 1.0 && VertexCoord.y <= 0.0)
        offset = hautDroit;

    // BAS GAUCHE
    else if(VertexCoord.x <= 0.0 && VertexCoord.y >= 1.0)
        offset = basGauche;

    // BAS DROIT
    else if(VertexCoord.x >= 1.0 && VertexCoord.y >= 1.0)
        offset = basDroit;


    vec3 pos = vec3(VertexCoord + offset, 0.0);

    gl_Position = MVPMatrix * vec4(pos.xy, 0.0, 1.0);

    v_tex = TexCoord;
    v_col = COLOR;
}


#elif defined(FRAGMENT)

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D u_tex;

varying vec2 v_tex;
varying vec4 v_col;


void main(void)
{
    vec4 texColor = texture2D(u_tex, v_tex);

    gl_FragColor = texColor * v_col;
}

#endif
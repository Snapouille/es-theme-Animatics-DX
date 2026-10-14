#if defined(VERTEX)

uniform mat4 MVPMatrix;
attribute vec2 VertexCoord;
attribute vec2 TexCoord;
attribute vec4 COLOR;

uniform vec2 hautGauche;
uniform vec2 hautDroit;
uniform vec2 basGauche;
uniform vec2 basDroit;

// Taille reelle du rectangle XML en pixels (pour ce premier test).
uniform vec2 dimensions;

varying vec3 v_projective;
varying vec4 v_col;

float cross2(vec2 a, vec2 b) {
    return a.x * b.y - a.y * b.x;
}

void main(void) {
    vec2 TL = vec2(0.0, 0.0) + hautGauche;
    vec2 TR = vec2(dimensions.x, 0.0) + hautDroit;
    vec2 BL = vec2(0.0, dimensions.y) + basGauche;
    vec2 BR = dimensions + basDroit;

    // Intersection des diagonales TL->BR et TR->BL.
    vec2 a = BR - TL;
    vec2 b = BL - TR;
    float determinant = cross2(a, b);
    float t = 0.5;
    float u = 0.5;
    if (abs(determinant) > 0.00001) {
        vec2 delta = TR - TL;
        t = cross2(delta, b) / determinant;
        u = cross2(delta, a) / determinant;
    }

    // Valeurs de correction projective aux quatre sommets.
    float q = 1.0;
    vec2 offset = vec2(0.0);
    if (VertexCoord.x <= 0.0 && VertexCoord.y <= 0.0) {
        offset = hautGauche;
        q = 1.0 / max(0.0001, 1.0 - t);
    } else if (VertexCoord.x >= 1.0 && VertexCoord.y <= 0.0) {
        offset = hautDroit;
        q = 1.0 / max(0.0001, 1.0 - u);
    } else if (VertexCoord.x <= 0.0 && VertexCoord.y >= 1.0) {
        offset = basGauche;
        q = 1.0 / max(0.0001, u);
    } else if (VertexCoord.x >= 1.0 && VertexCoord.y >= 1.0) {
        offset = basDroit;
        q = 1.0 / max(0.0001, t);
    }

    gl_Position = MVPMatrix * vec4(VertexCoord + offset, 0.0, 1.0);
    v_projective = vec3(TexCoord * q, q);
    v_col = COLOR;
}

#elif defined(FRAGMENT)
#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D u_tex;
varying vec3 v_projective;
varying vec4 v_col;

void main(void) {
    vec2 uv = v_projective.xy / max(v_projective.z, 0.0001);
    gl_FragColor = texture2D(u_tex, uv) * v_col;
}
#endif

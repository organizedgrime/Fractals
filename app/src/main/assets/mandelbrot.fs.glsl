precision highp float;

uniform vec2 viewportDimensions;
uniform float maxIterations;
uniform int coloringType;
uniform vec4 bounds;

// z = x + yi
// c = x0 + y0
// z^2 + c = x^2 + 2yxi - y^2 + x0 + i*y0

float real(vec2 z, float cx) {
    // x^2 - y^2 + x0
    return pow(z.x, 2.0) - pow(z.y, 2.0) + cx;
}

float imaginary(vec2 z, float cy) {
    // 2yx + y0
    return 2.0 * z.x * z.y + cy;
}

float mandelbrot(vec2 c) {
    vec2 z = c;
    float its = 0.0;
    for(int i = 0; i < int(maxIterations); i++) {
        float t = imaginary(z, c.y);
        z.x = real(z, c.x);
        z.y = t;

        if(z.x * z.x + z.y * z.y > 4.0) {
            break;
        }

        its += 1.0;
    }

    return its;
}

void main() {
    vec2 c = vec2(
        gl_FragCoord.x * (bounds.w - bounds.z) / viewportDimensions.x + bounds.z,
        gl_FragCoord.y * (bounds.y - bounds.x) / viewportDimensions.y + bounds.x
    );

    gl_FragColor = colorFractal(coloringType, c, mandelbrot(c), maxIterations);
}

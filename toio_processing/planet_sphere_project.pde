public class PColor {
    public float r;
    public float g;
    public float b;
    public float a;

    public float t_r;
    public float t_g;
    public float t_b;
    public float t_a;
    
    PColor(float red, float green, float blue, float alpha) {
        r = red;
        g = green;
        b = blue;
        a = alpha;

        t_r = red;
        t_g = green;
        t_b = blue;
        t_a = alpha;
    }
    
    public color get_temp_color() {
        return color(t_r,t_g,t_b,t_a);
    }

    public void decrement_color() {
        t_r -= 1;
        t_g -= 1;
        t_b -= 1;
    }

    public void increment_color() {
        t_r += 1;
        t_g += 1;
        t_b += 1;

        if (t_r > 255) {
            t_r = 255;
        }
        if (t_b > 255) {
            t_b = 255;
        }
        if (t_g > 255) {
            t_g = 255;
        }
    }

    public void increment_color_raw(float r, float g, float b) {
        t_r += r;
        t_g += g;
        t_b += b;
    }

    public void reset_color() {
        t_r = r;
        t_g = g;
        t_b = b;
    }
}

public class FunctionCounter {
    public float a;
    public float b;
    public int steps;

    FunctionCounter(float a, float b, int steps) {
        this.a = a;
        this.b = b;
        this.steps = steps;
    }

    public float GetLinearValue(int step) {
        return a + (step / steps) * (b - a);
    }

    public float GetSquaredPolyValue(int step) {
        return a + pow((step / steps),2) * (b - a);
    }
    
}

//Color col = new Color(255,255,255,1);
PColor col = new PColor(173,211,255,1);

void planet_setup() {
    // noStroke();
    // size(512, 512);
    // rectMode(CENTER);
}

void project_planet(float x, float y, float rad, float r, float g, float b) {
    float radius = rad * 3;
    PColor c = new PColor(r-rad,g-rad,b-rad,1);
    float decrement = 1;

    float step = 0;
    float total = floor(radius);
    while (step < total) {
        offscreen1.fill(c.t_r,c.t_g,c.t_b);
        c.increment_color();
        radius = rad - pow((step / total),3) * (rad);
        offscreen1.ellipse(x,y,radius*2,radius*2);
        step += 1;
    }
}

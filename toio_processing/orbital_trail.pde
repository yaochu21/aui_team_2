public class Color {
    public float r;
    public float g;
    public float b;
    public float a;
    
    Color(float r, float g, float b, float a) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }
}

public class Vector {
    public float x;
    public float y;

    Vector(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public float magnitude() {
        return sqrt(sq(x) + sq(y));
    }
}

public class Particle {
    public Vector position;
    public Color col;

    Particle(Vector pos, Color col) {
        this.position = pos;
        this.col = col;
    }
}

public class Trail {
    public ArrayList<Particle> particles;
    public ArrayList<Vector> mousePositions;
    public int maxLength;
    public float maxWidth;
    public Color col;

    Trail(int maxLength, float maxWidth, Color col) {
        particles = new ArrayList<Particle>();
        mousePositions = new ArrayList<Vector>();
        this.maxLength = maxLength;
        this.maxWidth = maxWidth;
        this.col = col;
    }

    public void UpdateMousePositions(float x, float y) {
        mousePositions.add(new Vector(x,y));
        if (mousePositions.size() > maxLength) {
            mousePositions.remove(0);
        }
    }

    public void UpdateParticles() {
        particles.clear();
        // for (int i = 0; i < mousePositions.size(); i++) {
        //     Vector position = mousePositions.get(i);
        //     particles.add(new Particle(position,col));
        // }

        Vector head = mousePositions.get(mousePositions.size() - 1);
        for (int i = 0; i < mousePositions.size(); i++) {
            Vector vec = mousePositions.get(i);
            Vector dirToHead = new Vector(head.x - vec.x,head.y - vec.y);
            Vector unitNormal = new Vector(dirToHead.y / dirToHead.magnitude(),-dirToHead.x / dirToHead.magnitude());

            for (int j = 0; j < 20; j++) {
                float randMag = random(-1, 1) * (maxWidth * 0.5) * (((float) i )/ mousePositions.size());
                Vector verticalOffset = new Vector(unitNormal.x * randMag, unitNormal.y * randMag);
                Vector horizOffset = new Vector(dirToHead.x * 22 * random(-1, 1) / dirToHead.magnitude(),dirToHead.y * 22 * random(-1, 1) / dirToHead.magnitude());
                float alpha = 255 * ((float) i) / mousePositions.size();
                particles.add(new Particle(new Vector(vec.x + verticalOffset.x + horizOffset.x,vec.y + verticalOffset.y + horizOffset.y), new Color(this.col.r,this.col.g,this.col.b,alpha)));
            }
        }
    }

}

Trail trail; 
float dotSize = 5;

void trail_setup() {
    trail = new Trail(20,40,new Color(251,109,109,255));
}

void trail_draw(float x, float y, Trail trail) {
    trail.UpdateMousePositions(x,y);
    trail.UpdateParticles();

    noStroke();
    for (int i = 0; i < trail.particles.size(); i++) {
        Particle particle = trail.particles.get(i);
        fill(particle.col.r,particle.col.g,particle.col.b,particle.col.a);
        circle(particle.position.x,particle.position.y,dotSize);
    }
}
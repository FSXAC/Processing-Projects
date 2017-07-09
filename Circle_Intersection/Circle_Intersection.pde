// Experiments with intersecting a line with a circle

public class Circle {
    private PVector m_position;
    private float   m_radius;
    private boolean m_highlighted;
    private boolean m_locked;
    private PVector m_offset;
    
    Circle(PVector newPosition, float newRadius) {
        m_position = newPosition;
        m_radius = newRadius;
        m_locked = false;
        m_offset = new PVector(0, 0);
    }
    
    public void draw() {
        // update
        m_highlighted = (dist(mouseX, mouseY, m_position.x, m_position.y) <= m_radius);
        
        // draw
        if (m_locked) {
            fill(255, 0, 0, 50);
        } else {
            noFill();
        }
        stroke(m_highlighted ? 0 : 150);
        ellipse(m_position.x, m_position.y, 2 * m_radius, 2 * m_radius);
    }
    
    // obtain offset from mouse
    public void mouseOffset() {
        m_offset.x = mouseX - m_position.x;
        m_offset.y = mouseY - m_position.y;
    }
    
    public void applyOffset() {
        if (m_locked) {
            m_position.x = mouseX - m_offset.x;
            m_position.y = mouseY - m_offset.y;
        }
    }
    
    // getters
    public boolean highlighted() {
        return m_highlighted;
    }
    public boolean locked() {
        return m_locked;
    }
    public PVector position() {
        return m_position;
    }
    public float radius() {
        return m_radius;
    }
    
    // setters
    public void setLocked(boolean locked) {
        if (m_locked != locked) {
            m_locked = locked;
        }
    }
}

public class Line {
    Circle m_p1, m_p2;
    
    Line(Circle p1, Circle p2) {
        m_p1 = p1;
        m_p2 = p2;
    }
    
    void draw() {
        stroke(0, 0, 255);
        // find slope of the line
        //float slope  = (m_p2.position().y - m_p1.position().y) / (m_p2.position().x - m_p1.position().x);
        //float startY = m_p1.position().y - m_p1.position().x * slope;
        //float endY   = m_p2.position().y + (width - m_p2.position().x) * slope;
        //line(0, startY, width, endY);
        line(m_p1.position().x, m_p1.position().y, m_p2.position().x, m_p2.position().y);
    }
}

// ====================[ Main program ]====================
Circle circle;
Circle p1, p2;
Line lineSegment;

void setup() {
    size(800, 800);
    background(255);
    
    // object instantiation
    circle = new Circle(new PVector(width / 2, height / 2), 100);
    p1 = new Circle(new PVector(100, 100), 5);
    p2 = new Circle(new PVector(700, 600), 5);
    lineSegment = new Line(p1, p2);
}

void draw() {
    // refresh background
    background(255);
    
    // draw a circle that can be
    circle.draw();
    p1.draw();
    p2.draw();
    lineSegment.draw();
    
    findIntersect();
}

//PVector getPointClosest( float x1, float y1, float x2, float y2, float x, float y ){
PVector getPointClosest(Line line, float x, float y) {
    float x1 = line.m_p1.position().x;
    float y1 = line.m_p1.position().y;
    float x2 = line.m_p2.position().x;
    float y2 = line.m_p2.position().y;
    
    PVector result = new PVector(); 
      
    float dx = x2 - x1; 
    float dy = y2 - y1; 
    float d = sqrt( dx*dx + dy*dy ); 
    float ca = dx/d; // cosine
    float sa = dy/d; // sine 
      
    float mX = (-x1+x)*ca + (-y1+y)*sa; 
  
    if( mX <= 0 ){
        result.x = x1; 
        result.y = y1; 
    } else if( mX >= d ){
        result.x = x2; 
        result.y = y2; 
    } else {
        result.x = x1 + mX*ca; 
        result.y = y1 + mX*sa; 
    }
      
    dx = x - result.x; 
    dy = y - result.y; 
    result.z = sqrt( dx*dx + dy*dy ); 
    return result;   
}

void getIntersectPointsOLD(PVector cPoint) {
    PVector circleOrigin    = circle.position(); 
    float halfSegmentLength = sqrt(sq(circle.radius()) - sq(dist(circleOrigin.x, circleOrigin.y, cPoint.x, cPoint.y)));
    PVector originToCPoint = cPoint.copy().sub(circleOrigin);
    float ratio = halfSegmentLength / circle.radius();
    
    // angle between center->cpoint and center->ipoint
    //float angle = 0;
    //if (abs(ratio) <= 1) {
    //    angle = -acos(ratio);
    //}
    float angle = -acos(ratio);
    angle += originToCPoint.heading() + PI/2;
    float ix = circleOrigin.x + circle.radius() * cos(angle);
    float iy = circleOrigin.y + circle.radius() * sin(angle);
    ellipse(ix, iy, 5, 5);
}

void getIntersectPoints(PVector c_) {
    float   R   = circle.radius();
    PVector O_  = circle.position();
    float   r   = sqrt(sq(R) - sq(dist(O_.x, O_.y, c_.x, c_.y)));
    PVector a__ = c_.copy().sub(O_);
    PVector b__ = new PVector(r, 0);
    
    b__.rotate(a__.heading() - PI/2);
    
    PVector p1_ = PVector.add(c_, b__);
    PVector p2_ = PVector.sub(c_, b__);
    ellipse(p1_.x, p1_.y, 5, 5);
    ellipse(p2_.y, p2_.y, 5, 5);
}

void findIntersect() {
    PVector closestPoint = getPointClosest(lineSegment, circle.position().x, circle.position().y);
    fill(255, 0, 0);
    ellipse(closestPoint.x, closestPoint.y, 5, 5);
    stroke(200);
    line(closestPoint.x, closestPoint.y, circle.position().x, circle.position().y);
    
    getIntersectPoints(closestPoint);
    
    // check if line intersects circle
    if (dist(closestPoint.x, closestPoint.y, circle.position().x, circle.position().y) <= circle.radius()) {
        text("INTERSECTION OCCURED", 20, 20);
    } else {
        text("NO INTERSECTION", 20, 20);
    }
}

// ====================[ Mouse events ]====================
void mousePressed() {
    circle.setLocked(circle.highlighted());
    circle.mouseOffset();
    
    p1.setLocked(p1.highlighted());
    p1.mouseOffset();
    
    p2.setLocked(p2.highlighted());
    p2.mouseOffset();
}

void mouseDragged() {
    circle.applyOffset();
    p1.applyOffset();
    p2.applyOffset();
}

void mouseReleased() {
    circle.setLocked(false);
    p1.setLocked(false);
    p2.setLocked(false);
}
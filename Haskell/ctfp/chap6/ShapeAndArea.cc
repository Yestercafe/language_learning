#include <iostream>
#include <numbers>
using std::numbers::pi;

class Shape {
public:
    virtual double area() const = 0;
};

class Circle : public Shape {
public:
    double area() const override {
        return pi * r * r;
    }
    Circle(double r) : r{r} {}
private:
    double r;
};

class Rect : public Shape {
public:
    double area() const override {
        return w * h;
    }
    Rect(double w, double h) : w{w}, h{h} {}
private:
    double w, h;
};

double area(Shape* shape) {
    return shape->area();
}

double circ(Shape* shape) {
    // ??? idk how to do this without the modification of the Shape
}

int main() {
    Shape* circle = new Circle(2.);
    Shape* rect = new Rect(2.5, 4.5);
    std::cout << area(circle) << ' ' << area(rect) << std::endl;
    std::cout << circ(circle) << ' ' << circ(rect) << std::endl;
}

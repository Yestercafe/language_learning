#include <cmath>
#include <functional>
#include <iostream>
using std::sqrt;
using std::function;

template<typename A> class optional {
    bool _isValid;
    A _value;
public:
    optional() : _isValid(false) {}
    optional(A v) : _isValid(true), _value(v) {}
    bool isValid() const { return _isValid; }
    A value() const { return _value; }
};

template<typename A, typename B, typename C>
function<optional<C>(A)> compose(function<optional<B>(A)> f, function<optional<C>(B)> g) {
    return [f, g](A a) -> optional<C> {
        auto fa = f(a);
        if (!fa.isValid()) return optional<C>{};
        auto gb = g(fa.value());
        if (!gb.isValid()) return optional<C>{};
        return optional<C>{gb.value()};
    };
}

template<typename A>
optional<A> identity(A a) {
    return {a};
}

optional<double> safe_root(double x) {
    if (x >= 0) return {sqrt(x)};
    else return {};
}

optional<double> safe_reciprocal(double x) {
    if (x == 0) return {};
    else return { 1. / x };
}

auto safe_root_reciprocal = compose<double, double, double>(safe_reciprocal, safe_root);

int main() {
    auto res = safe_root_reciprocal(0.25);
    if (res.isValid()){
        std::cout << res.value() << std::endl;
    }
}

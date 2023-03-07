#include <iostream>
#include <functional>

template<typename T>
class optional {
    bool _isValid;
    T _v;
public:
    optional() : _isValid{false} {}
    optional(T x) : _v{x}, _isValid{true} {}
    bool isValid() const { return _isValid; }
    T val() const { return _v; }
};

template<typename A, typename B>
std::function<optional<B>(optional<A>)>
fmap(std::function<B(A)> f) {
    return [f](optional<A> opt) {
        if (!opt.isValid()) {
            return optional<B>{};
        } else {
            return optional<B>{ f(opt.val()) };
        }
    };
}

template<typename A, typename B>
optional<B> fmap(std::function<B(A)> f, optional<A> opt) {
    if (!opt.isValid()) {
        return optional<B>{};
    } else {
        return optional<B>{ f(opt.val()) };
    }
}

std::function<bool(int)> f = [](const int i) { return !i; };
auto g = fmap(f);

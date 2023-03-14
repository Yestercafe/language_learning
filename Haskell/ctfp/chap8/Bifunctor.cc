#include <utility>
#include <functional>
#include <iostream>
using std::function;
using std::pair;

template<typename A, typename B, typename A_, typename B_>
pair<A_, B_> bimap(function<A_(A)> f, function<B_(B)> g, const pair<A, B>& p) {
    return { f(p.first), g(p.second) };
}

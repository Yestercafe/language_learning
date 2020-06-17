// refer to LH_Mouse(喵喵) https://www.bilibili.com/video/BV11E411T74B
#include <utility>
#include <iterator>
#include <algorithm>
#include <iostream>

template<int... valsT> struct seq { };

template<int... valsT>
void print(seq<valsT...>)
{
    static constexpr int vals[] = { valsT... };
    ::std::copy(::std::begin(vals), ::std::end(vals), 
                ::std::ostream_iterator<int>(::std::cout, " "));
    ::std::endl(::std::cout);
}

template<typename T, typename S> struct divide;

template<int... fT, int yT, int... sT> struct divide<seq<fT...>, seq<yT, sT...>>
    : ::std::conditional<(sizeof...(fT) < 1 + sizeof...(sT)),
                         divide<seq<fT..., yT>, seq<sT...>>,
                         ::std::pair<seq<fT...>, seq<yT, sT...>>
        >::type
    { };

template<int... fT> struct divide<seq<fT...>, seq<>>
    : ::std::pair<seq<fT...>, seq<>>
    { };

template<typename R, typename T, typename S> struct merge;

template<int... rT> struct merge<seq<rT...>, seq<>, seq<>>
    : ::std::enable_if<true, seq<rT...>>
    { };

template<int... rT, int... fT> struct merge<seq<rT...>, seq<fT...>, seq<>>
    : ::std::enable_if<true, seq<rT..., fT...>>
    { };

template<int... rT, int... sT> struct merge<seq<rT...>, seq<>, seq<sT...>>
    : ::std::enable_if<true, seq<rT..., sT...>>
    { };

template<int... rT, int xT, int... fT, int yT, int... sT>
struct merge<seq<rT...>, seq<xT, fT...>, seq<yT, sT...>>
    : ::std::conditional<(xT < yT),
                         merge<seq<rT..., xT>, seq<fT...>, seq<yT, sT...>>,
                         merge<seq<rT..., yT>, seq<xT, fT...>, seq<sT...>>
        >::type
    { };

template<typename S> struct sort { };

template<> struct sort<seq<>>
    : ::std::enable_if<true, seq<>>
    { };

template<int xT> struct sort<seq<xT>>
    : ::std::enable_if<true, seq<xT>>
    { };

template<int xT, int yT> struct sort<seq<xT, yT>>
    : ::std::conditional<(xT < yT),
                         seq<xT, yT>, seq<yT, xT>>
    { };

template<int... sT>
struct sort<seq<sT...>> {
    using D = divide<seq<>, seq<sT...>>;
    using M = merge<seq<>,
                    typename sort<typename D::first_type>::type,
                    typename sort<typename D::second_type>::type>;
    using type = typename M::type;
    
};

int main()
{
    using ISEQ = seq<1, 3, 4, 7, 2, 6, 5>;
    print(ISEQ());
    print(sort<ISEQ>::type());
}

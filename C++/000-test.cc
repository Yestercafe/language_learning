#include <iostream>

template<unsigned N>
struct Fact {
	enum {value = N * Fact<N-1>::value};
};

template<>
struct Fact<0u> {
	enum {value = 1u};
};

int main() {
	std::cout << "5! = " << Fact<5u>::value << std::endl;
}

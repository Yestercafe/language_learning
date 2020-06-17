#include <iostream>
#include <vector>
#include <ranges>

int main()
{
    std::vector<int> ivec {1, 2, 3, 4, 5};
    auto even = [](int i) { return 0 == i % 2; };
    auto square = [](int i) { return i * i; };

    for (auto i : ivec | std::views::filter(even) | std::views::transform(square)) {
        std::cout << i << " ";
    }
}
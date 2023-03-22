// 这段代码受《Haskell 函数式编程入门》8.7 节的启发
// 因为没地方放，所以放在这个仓库应该没问题吧（
#include <string>
#include <unordered_map>
#include <vector>
#include <iostream>
#include <functional>

int main()
{
    std::vector<std::string> ans;
    std::unordered_map<int, std::vector<std::string>> mem;
    mem[0] = {""};
    std::function<std::vector<std::string>&(int)> brace = [&](int n) -> std::vector<std::string>& {
        if (mem.contains(n)) return mem[n];
        std::vector<std::string> brace_n;
        for (int i = 0; i < n; ++i) {
            for (auto&& bl : brace(i)) {
                for (auto&& br : brace(n - 1 - i)) {
                    using namespace std::string_literals;
                    brace_n.push_back("("s + bl + ")"s + br);
                }
            }
        }
        mem.emplace(n, std::move(brace_n));
        return mem[n];
    };
    
    constexpr int N = 7;
    auto& r = brace(N);
    for (auto&& i : r) {
        std::cout << i << std::endl;
    }
    std::cout << "Catalan(" << N << ") = " << r.size() << std::endl;

    return 0;
}


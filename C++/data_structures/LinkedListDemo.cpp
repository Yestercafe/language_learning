#include "LinkedList.hpp"
#include <iostream>
#include <functional>
#include <string>

int main()
{
    {
        DS::LinkedList<int> lsti;
        for (int k = 1; k <= 5; ++k)
            lsti.push_back(k);
        lsti.pop_back();
        auto lsti2(lsti);
        lsti2.for_each([](const int& i) {
            std::cout << i << ' ';
        });
        std::endl(std::cout);
    }

    {
        DS::LinkedList<std::string> lsts;
        lsts.push_back({"hello"});
        lsts.push_back({", "});
        lsts.push_back({"world"});
        lsts.push_back({"\n"});
        std::cout << lsts.accumulate<std::string, std::string>(std::string(), std::plus<std::string>()) << std::flush;
    }

}
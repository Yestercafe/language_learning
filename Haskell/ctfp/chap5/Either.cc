#include <iostream>
#include <cassert>

enum class Tag {
    LEFT,
    RIGHT,
};
class Either {
    using LeftT = int;
    using RightT = bool;
    Tag tag;
    int left;
    bool right;
public:
    Either(Tag tag, int t) : tag{tag} {
        assert(tag == Tag::LEFT);
        left = t;
    }
    Either(Tag tag, bool t) : tag{tag} {
        assert(tag == Tag::RIGHT);
        right = t;
    }
    Tag getTag() const { return tag; }
    int getLeft() const { return left; }
    bool getRight() const { return right; }
};

int i(int n) { return n; }
int j(bool b) { return (int) b; }

int m(Either const& e) {
    if (e.getTag() == Tag::LEFT) return i(e.getLeft());
    if (e.getTag() == Tag::RIGHT) return i(e.getRight());
    assert(0);
}

int main() {
    Either e1(Tag::LEFT, 1);
    Either et(Tag::RIGHT, true);
    std::cout << m(e1) << std::endl
              << m(et) << std::endl;
}

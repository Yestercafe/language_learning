#include <functional>

template<typename T>
struct Tree {
    virtual ~Tree() {}
};

template<typename T>
struct Leaf : public Tree<T> {
    T label;
    Leaf(T l) : label{l} {}
};

template<typename T>
struct Node : public Tree<T> {
    Tree<T>* left;
    Tree<T>* right;
    Node(Tree<T>* l, Tree<T>* r) : left{l}, right{r} {}
};

template<typename A, typename B>
Tree<B>* fmap(std::function<B(A)> f, Tree<A>* t) {
    Leaf<A>* pl = dynamic_cast<Leaf<A>*>(t);
    if (pl) {
        return new Leaf<B>(f(t->label));
    }
    Node<A>* pn = dynamic_cast<Node<A>*>(t);
    if (pn) {
        return new Node<B>( fmap(f, t->left)
                          , fmap(f, t->right));
    }
    return nullptr;
}

#ifndef DS_LINKED_LIST_HPP__
#define DS_LINKED_LIST_HPP__
#include <cstddef>

namespace DS {

template<typename Tx>
class LinkedList {
    template<typename T>
    class LinkedListNode {
        using Node = LinkedListNode<T>;
        friend class LinkedList<T>;
      public:
        LinkedListNode() = default;
        LinkedListNode(T data_, Node* node_ = nullptr)
         : data(data_), next(node_) { }
        T& operator*() {
            return this->data;
        }
        const T& operator*() const {
            return this->data;
        }
      private:
        T data;
        Node* next;
    };
    using Node = LinkedListNode<Tx>;

  public:
    LinkedList()
     : head(nullptr), tail(nullptr), length(0u) { }
    LinkedList(const LinkedList& other)
     : LinkedList() {
        auto itr = other.head;
        while (itr != nullptr) {
            this->push_back(**itr);
            itr = itr->next;
        }
        this->length = other.length;
    }

  public:
    ~LinkedList() {
        this->clear();
    }

  public:
    ::size_t size() const { return this->length; }
    bool empty() const { return this->size() == 0; }

  public:
    void push_back(Tx item) {
        if (head == nullptr) {
            head = tail = new Node(item);
        } else {
            tail->next = new Node(item);
            tail = tail->next;
        }
        ++this->length;
    }
    void pop_back() {
        if (head == nullptr) {
            return ;
        } else if (head == tail) {
            delete head;
            head = tail = nullptr;
        } else {
            auto new_tail = head;
            while (new_tail->next != tail) {
                new_tail = new_tail->next;
            }
            delete tail;
            new_tail->next = nullptr;
            tail = new_tail;
        }
        --this->length;
    }

  public:
    template<typename UnaryFunction>
    void for_each(UnaryFunction&& uf) {
        auto itr = head;
        while (itr != nullptr) {
            uf(**itr);
            itr = itr->next;
        }
    }
    template<typename RetT, typename InitT, typename BinaryOperator>
    RetT accumulate(const InitT& init, BinaryOperator&& op) {
        RetT ret = init;
        auto itr = this->head;
        while (itr != nullptr) {
            ret = op(ret, **itr);
            itr = itr->next;
        }
        return ret;
    }
    void clear() {
        while (length != 0)
            this->pop_back();
    }

  private:
    Node* head;
    Node* tail;
    ::size_t length;
};

} /* namespace DS */

#endif /* DS_LINKED_LIST_HPP__ */
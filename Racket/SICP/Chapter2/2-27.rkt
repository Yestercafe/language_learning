#lang scheme

(define (deep-reverse tree)
  (define (empty-tree? tree)
    (null? tree))
  (define (leaf? tree)
    (not (pair? tree)))
  (define (make-tree left-branch right-branch)
    (list left-branch right-branch))
  (define (left-branch tree)
    (car tree))
  (define (right-branch tree)
    (cadr tree))
  (cond ((empty-tree? tree)
         '())
        ((leaf? tree)
         tree)
        (else
         (reverse (make-tree (deep-reverse (left-branch tree))
                             (deep-reverse (right-branch tree)))))))

(define lst (list (list 1 2) (list 3 4)))
(deep-reverse lst)
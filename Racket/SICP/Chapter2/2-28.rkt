#lang scheme

(define (fringe tree)
  (define (empty-tree? tree)
    (null? tree))
  (define (leaf? tree)
    (not (pair? tree)))
  (define (left-branch tree)
    (car tree))
  (define (right-branch tree)
    (cadr tree))
  (cond ((empty-tree? tree)
         '())
        ((leaf? tree)
         (list tree))
        (else
         (append (fringe (left-branch tree))
                 (fringe (right-branch tree))))))

(define x (list (list 1 2) (list 3 4)))

(fringe x)
(fringe (list x x))
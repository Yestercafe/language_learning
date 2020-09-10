#lang scheme

(define (make-tree left-subtree right-subtree)
  (cons left-subtree right-subtree))
(define (left-subtree tree)
  (car tree))
(define (right-subtree tree)
  (cdr tree))
(define (leaf? tree)
  (not (pair? tree)))
(define (empty-tree? tree)
  (null? tree))

(define (square x)
  (* x x))

(define (tree-map proc items)
  (cond ((null? items)
         null)
        ((not (pair? items))
         (proc items))
        (else (cons (tree-map proc (car items))
                    (tree-map proc (cdr items))))))

(define (square-tree tree) (tree-map square tree))
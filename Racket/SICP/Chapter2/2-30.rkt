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

; recursive
(define (square-tree-builtin tree)
  (cond ((empty-tree? tree)
         null)
        ((leaf? tree)
         (square tree))
        (else
         (make-tree (square-tree-builtin (left-subtree tree))
                    (square-tree-builtin (right-subtree tree))))))

; map
(define (map proc items)
  (cond ((null? items)
         null)
        ((not (pair? items))
         (proc items))
        (else (cons (map proc (car items))
                    (map proc (cdr items))))))

(define (square-tree-map tree)
  (let ((proc (lambda (x) (square x))))
    (map proc tree)))

(square-tree-builtin (make-tree (make-tree 1 null) (make-tree (make-tree 4 5) 3)))
(square-tree-map (make-tree (make-tree 1 null) (make-tree (make-tree 4 5) 3)))


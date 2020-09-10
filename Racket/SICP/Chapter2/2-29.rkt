#lang scheme

; abstraction
(define (make-mobile left right)
  (list left right))
(define (make-branch length structure)
  (list length structure))

(define (left-branch mobile)
  (car mobile))
(define (right-branch mobile)
  (cadr mobile))

(define (branch-length branch)
  (car branch))
(define (branch-structure branch)
  (cadr branch))

; total-weight
(define (total-weight mobile)
  (+ (branch-weight (left-branch mobile))
     (branch-weight (right-branch mobile))))

(define (branch-weight branch)
  (if (structure-is-number? (branch-structure branch))
      (branch-structure branch)
      (total-weight (branch-structure branch))))

(define (structure-is-number? structure)
  (not (pair? structure)))

; weight tests
(define mobile (make-mobile (make-branch 10 20)
                            (make-branch 10 25)))
(total-weight mobile)

(define another-mobile (make-mobile (make-branch 10 mobile)
                                    (make-branch 10 20)))
(total-weight another-mobile)

; mobile-banlance?
(define (mobile-balance? mobile)
  (define (mobile-torque branch)
    (* (branch-length branch)
       (branch-weight branch)))
  (if (structure-is-number? mobile)
      #t
      (and
       (= (mobile-torque (left-branch mobile))
          (mobile-torque (right-branch mobile)))
       (mobile-balance? (branch-structure (left-branch mobile)))
       (mobile-balance? (branch-structure (right-branch mobile))))))

; balance tests
(define balance-mobile (make-mobile (make-branch 10 10)
                                    (make-branch 10 10)))
(mobile-balance? balance-mobile)

(define unbalance-mobile (make-mobile (make-branch 0 0)
                                      (make-branch 10 10)))
(mobile-balance? unbalance-mobile)

(define mobile-with-sub-mobile (make-mobile (make-branch 10 balance-mobile)
                                            (make-branch 10 balance-mobile)))
(mobile-balance? mobile-with-sub-mobile)
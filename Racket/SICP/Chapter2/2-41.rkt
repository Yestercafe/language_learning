#lang scheme

(define (filter predicate sequence)
  (cond ((null? sequence) null)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
      null
      (cons low (enumerate-interval (+ low 1) high))))

(define (flatmap proc seq)
  (accumulate append
              '()
              (map proc seq)))

(define (remove seq item)
  (filter (lambda (x) (not (= x item)))
          seq))

(define (unique-pairs n)
  (flatmap (lambda (i)
             (map (lambda (j) (list i j))
                  (remove (enumerate-interval 1 n) i)))
           (enumerate-interval 1 n)))

(define (unique-triples n)
  (let ((seq (enumerate-interval 1 n)))
    (flatmap (lambda (i)
               (flatmap (lambda (j)
                          (map (lambda (k)
                                 (list i j k))
                               (remove (remove seq j) i)))
                        (remove seq i)))
             seq)))

(define (triple-sum-equal-to? s triple)
  (= s
     (+ (car triple)
        (cadr triple)
        (caddr triple))))

(define (remove-triples-not-equal-to s seq)
  (filter (lambda (triple)
            (triple-sum-equal-to? s triple))
          seq))
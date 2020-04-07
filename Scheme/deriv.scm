(define (deriv exp var)
  (cond ((constant? exp var) 0)
	((same-var? exp var) 1)
	((sum? exp)
	 (make-sum (deriv (a1 exp) var)
		   (deriv (a2 exp) var)))
	((product? exp)
	 (make-sum
	  (make-product (deriv (m1 exp) var) (m2 exp))
	  (make-product (m1 exp) (deriv (m2 exp) var))))))

(define (constant? exp var)
  (and (atom? exp)
       (not (eq? exp var))))

(define (same-var? exp var)
  (and (atom? exp)
       (eq? exp var)))

(define (sum? exp)
  (and (not (atom? exp))
       (eq? (car exp) '+)))

(define (make-sum a b)
  (cond ((and (number? a)
	      (number? b))
	 (+ a b))
	((and (number? a)
	      (= a 0))
	 b)
	((and (number? b)
	      (= b 0))
	 a)
	(else (list '+ a b))))

(define a1 cadr)
(define a2 caddr)

(define (product? exp)
  (and (not (atom? exp))
       (eq? (car exp) '*)))

(define (make-product a b)
  (cond ((or (and (number? a)
		  (= a 0))
	     (and (number? b)
		  (= b 0)))
	 0)
	((and (number? a)
	      (= a 1))
	 b)
	((and (number? b)
	      (= b 1))
	 a)
	(else (list '* a b))))

(define (atom? x)
  (not (or (pair? x)
	   (null? x)
	   (vector? x))))

(define m1 cadr)
(define m2 caddr)

(define foo
  '(+ (* a (* x x))
      (+ (* b x)
	 c)))

(write-line (deriv foo 'x))

(write-line (deriv foo 'a))

(write-line (deriv foo 'b))

(write-line (deriv foo 'c))


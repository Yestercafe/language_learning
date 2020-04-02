(define (sqrt-iter a guess)
  (if (good-enough? a guess)
      a
      (sqrt-iter a (opt a guess))))

(define (good-enough? a guess)
  (< (abs (- (sq guess) a)) 0.000001))

(define (abs a)
  (if (< a 0)
      (- a)
      a))

(define (sq a)
  (* a a))

(define (opt a guess)
  (avg (/ a guess) guess))

(define (avg a b)
  (/ (+ a b) 2))

; (write-line (sqrt 3.))

; (write-line (sqrt 4.))

(define (make-point x y)
  (cons x y))

(define (point-x pt)
  (car pt))

(define (point-y pt)
  (cdr pt))

(define (make-line a b)
  (cons a b))

(define (line-st ln)
  (car ln))

(define (line-ed ln)
  (cdr ln))

(define (line-length ln)
  (sqrt (+ (sq (- (point-x (line-st ln))
		  (point-x (line-ed ln))))
	   (sq (- (point-y (line-st ln))
		  (point-y (line-ed ln)))))))


(define pt1 (make-point 0. 0.))
(define pt2 (make-point 1. 1.))

(define line (make-line pt1 pt2))

(write-line (line-length line))


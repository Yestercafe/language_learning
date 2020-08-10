;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname create-a-tree) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define scale-factor 20)

(place-image (circle (* 3 scale-factor) "solid" "green")
             (* 3 scale-factor) (* 3 scale-factor)
             (place-image (rectangle (* 2 scale-factor)
                                     (* 4 scale-factor)
                                     "solid" "brown")
                          (* 3 scale-factor) (* 8 scale-factor)
                          (empty-scene (* 6 scale-factor)
                                       (* 10 scale-factor))))

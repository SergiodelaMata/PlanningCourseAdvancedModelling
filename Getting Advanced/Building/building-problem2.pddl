(define (problem building-problem2)
	(:domain building)
	(:objects
		n0 n1 n2 n3 n4 n5 n6 n7 n8 - number ;; Números cuya correspondencia sería n0 --> 0, n1 --> 1, ...
		p0 p1 p2 p3 - person ;; Personas
		fastlift1 fastlift2 - fastlift ;; Ascensores rápidos
		slowlift1 slowlift2 - slowlift ;; Ascensores lentos
	)
	(:init
		;; Números consecutivos de forma ascendente
		(next-number n0 n1) (next-number n1 n2) (next-number n2 n3) (next-number n3 n4)
		(next-number n4 n5) (next-number n5 n6) (next-number n6 n7) (next-number n7 n8)
		;; Situaciones en las que el segundo número es superior al primero
		(above n0 n1) (above n0 n2) (above n0 n3) (above n0 n4) (above n0 n5) (above n0 n6) (above n0 n7) (above n0 n8)
		(above n1 n2) (above n1 n3) (above n1 n4) (above n1 n5) (above n1 n6) (above n1 n7) (above n1 n8)
		(above n2 n3) (above n2 n4) (above n2 n5) (above n2 n6) (above n2 n7) (above n2 n8)
		(above n3 n4) (above n3 n5) (above n3 n6) (above n3 n7) (above n3 n8)
		(above n4 n5) (above n4 n6) (above n4 n7) (above n4 n8)
		(above n5 n6) (above n5 n7) (above n5 n8)
		(above n6 n7) (above n6 n8)
		(above n7 n8)
		;; Posición inicial de los ascensores y de las personas
		(at-floor fastlift1 n1)(at-floor fastlift2 n3)
		(at-floor slowlift1 n5)(at-floor slowlift2 n8)
		(at-floor p0 n4) (at-floor p1 n2) (at-floor p2 n2)
		(at-lift p3 slowlift1)
		;; Plantas en las que pueden parar cada ascensor
		(can-stop fastlift1 n1) (can-stop fastlift1 n2) (can-stop fastlift1 n4) (can-stop fastlift1 n8)
		(can-stop fastlift2 n3) (can-stop fastlift2 n6)
		(can-stop slowlift1 n0) (can-stop slowlift1 n1) (can-stop slowlift1 n2) (can-stop slowlift1 n3) (can-stop slowlift1 n4) (can-stop slowlift1 n5) (can-stop slowlift1 n6) (can-stop slowlift1 n7) (can-stop slowlift1 n8) 
		(can-stop slowlift2 n0) (can-stop slowlift2 n1) (can-stop slowlift2 n2) (can-stop slowlift2 n3) (can-stop slowlift2 n4) (can-stop slowlift2 n5) (can-stop slowlift2 n6) (can-stop slowlift2 n7) (can-stop slowlift2 n8)
		;; Número de pasajeros iniciales de cada ascensor
		(is-num-passengers fastlift1 n0) (is-num-passengers fastlift2 n0)
		(is-num-passengers slowlift1 n1) (is-num-passengers slowlift2 n0)
		;; Distancia entre plantas
		(= (distance n0 n1) 1) (= (distance n0 n2) 2) (= (distance n0 n3) 3) (= (distance n0 n4) 4) (= (distance n0 n5) 5) (= (distance n0 n6) 6) (= (distance n0 n7) 7) (= (distance n0 n8) 8)
		(= (distance n1 n0) 1) (= (distance n1 n2) 1) (= (distance n1 n3) 2) (= (distance n1 n4) 3) (= (distance n1 n5) 4) (= (distance n1 n6) 5) (= (distance n1 n7) 6) (= (distance n1 n8) 7)
		(= (distance n2 n0) 2) (= (distance n2 n1) 1) (= (distance n2 n3) 1) (= (distance n2 n4) 2) (= (distance n2 n5) 3) (= (distance n2 n6) 4) (= (distance n2 n7) 5) (= (distance n2 n8) 6)
		(= (distance n3 n0) 3) (= (distance n3 n1) 2) (= (distance n3 n2) 1) (= (distance n3 n4) 1) (= (distance n3 n5) 2) (= (distance n3 n6) 3) (= (distance n3 n7) 4) (= (distance n3 n8) 5)
		(= (distance n4 n0) 4) (= (distance n4 n1) 3) (= (distance n4 n2) 2) (= (distance n4 n3) 1) (= (distance n4 n5) 1) (= (distance n4 n6) 2) (= (distance n4 n7) 3) (= (distance n4 n8) 4)
		(= (distance n5 n0) 5) (= (distance n5 n1) 4) (= (distance n5 n2) 3) (= (distance n5 n4) 2) (= (distance n5 n4) 1) (= (distance n5 n6) 1) (= (distance n5 n7) 2) (= (distance n5 n8) 3)
		(= (distance n6 n0) 6) (= (distance n6 n1) 5) (= (distance n6 n2) 4) (= (distance n6 n4) 3) (= (distance n6 n5) 2) (= (distance n6 n5) 1) (= (distance n6 n7) 1) (= (distance n6 n8) 2) 
		(= (distance n7 n0) 7) (= (distance n7 n1) 6) (= (distance n7 n2) 5) (= (distance n7 n4) 4) (= (distance n7 n5) 3) (= (distance n7 n6) 2) (= (distance n7 n6) 1) (= (distance n7 n8) 1) 
		(= (distance n8 n0) 8) (= (distance n8 n1) 7) (= (distance n8 n2) 6) (= (distance n8 n4) 5) (= (distance n8 n5) 4) (= (distance n8 n6) 3) (= (distance n8 n6) 2) (= (distance n8 n7) 1) 
		;; Velocidad de cada ascensor
		(= (speed-travel-slow slowlift1) 1) (= (speed-travel-slow slowlift2) 1)
		(= (speed-travel-fast fastlift1) 4) (= (speed-travel-fast fastlift2) 4)
	)
	(:goal
	;; La persona p0 acaba en la planta n1, la persona p1 en n3 y el ascensor fastlift1 acaba en la planta n4
		(and
			(at-floor p0 n1) (at-floor p1 n3)
			(at-floor p2 n7) (at-floor p3 n5)
			(at-floor fastlift1 n4)
			(at-floor fastlift2 n6)
		)
	)
)
		
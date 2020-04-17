(define (domain building)
	(:requirements :strips :typing :equality 
		:negative-preconditions :fluents :durative-actions)
	(:types
		lift - object 
		slowlift fastlift - lift
		person - object
		number - object
	)
	(:predicates 
		(at-floor ?elem - (either person lift) ?floor - number)
		(at-lift ?p - person ?l - lift)
		(can-stop ?l - lift ?f - number)
		(above ?f1 ?f2 - number)
		(next-number ?n1 ?n2 - number)
		(is-num-passengers ?l - lift ?num - number)
	)
	(:functions 
		(speed-travel-slow ?l - slowlift)
		(speed-travel-fast ?l - fastlift)
		(distance ?f1 ?f2 - number)
	)
	
	;; Acción para que se mueva hacia arriba los ascensores rápidos
	(:durative-action move-up-fast
		:parameters (?l - fastlift ?floor1 ?floor2 - number)
		:duration (= ?duration (/ (distance ?floor1 ?floor2)(speed-travel-fast ?l)))
		:condition 
			(and
				(at start (at-floor ?l ?floor1))
				(at start (above ?floor1 ?floor2))
				(at start (can-stop ?l ?floor2)) 
			)
		:effect 
			(and 
				(at start (not(at-floor ?l ?floor1)))
				(at end (at-floor ?l ?floor2))
			)
	)
	;; Acción para que se mueva hacia arriba los ascensores lentos
	(:durative-action move-up-slow
		:parameters (?l - slowlift ?floor1 ?floor2 - number)
		:duration (= ?duration (/ (distance ?floor1 ?floor2)(speed-travel-slow ?l)))
		:condition 
			(and
				(at start (at-floor ?l ?floor1))
				(at start (above ?floor1 ?floor2))
			)
		:effect 
			(and 
				(at start (not(at-floor ?l ?floor1)))
				(at end (at-floor ?l ?floor2))
			)
	)
	
	;; Acción para que se mueva hacia abajo los ascensores rápidos
	(:durative-action move-down-fast
		:parameters (?l - fastlift ?floor1 ?floor2 - number)
		:duration (= ?duration (/ (distance ?floor1 ?floor2)(speed-travel-fast ?l)))
		:condition 
			(and
				(at start (at-floor ?l ?floor1))
				(at start (above ?floor2 ?floor1))
				(at start (can-stop ?l ?floor2)) 
			)
		:effect 
			(and 
				(at start (not(at-floor ?l ?floor1)))
				(at end (at-floor ?l ?floor2))
			)
	)
	;; Acción para que se mueva hacia abajo los ascensores lentos
	(:durative-action move-down-slow
		:parameters (?l - slowlift ?floor1 ?floor2 - number)
		:duration (= ?duration (/ (distance ?floor1 ?floor2)(speed-travel-slow ?l)))
		:condition 
			(and
				(at start (at-floor ?l ?floor1))
				(at start (above ?floor2 ?floor1))
			)
		:effect 
			(and 
				(at start (not(at-floor ?l ?floor1)))
				(at end (at-floor ?l ?floor2))
			)
	)
	
	;; Acción para que se meta una persona a un ascensor
	(:durative-action board
		:parameters (?p - person ?l - lift ?floor ?num-passenger-lift1 ?num-passenger-lift2 - number)
		:duration (= ?duration 1)
		:condition 
			(and
				(at start (at-floor ?p ?floor))
				(at start (at-floor ?l ?floor))
				(at start (is-num-passengers ?l ?num-passenger-lift1))
				(at start (next-number ?num-passenger-lift1 ?num-passenger-lift2))
			)
		:effect 
			(and 
				(at start (at-floor ?l ?floor))
				(at start (not(at-floor ?p ?floor)))
				(at start (not(is-num-passengers ?l ?num-passenger-lift1)))
				(at end (is-num-passengers ?l ?num-passenger-lift2))
				(at end (at-lift ?p ?l))
				(at end (at-floor ?l ?floor))
			)
	)
	
	;; Acción para que se salga una persona a un ascensor
	(:durative-action leave
		:parameters (?p - person ?l - lift ?floor ?num-passenger-lift1 ?num-passenger-lift2 - number)
		:duration (= ?duration 1)
		:condition 
			(and
				(at start (not(at-floor ?p ?floor)))
				(at start (at-floor ?l ?floor))
				(at start (is-num-passengers ?l ?num-passenger-lift1))
				(at start (next-number ?num-passenger-lift2 ?num-passenger-lift1))
			)
		:effect 
			(and 
				(at start (at-floor ?l ?floor))
				(at start (at-floor ?p ?floor))
				(at start (not(is-num-passengers ?l ?num-passenger-lift1)))
				(at end (is-num-passengers ?l ?num-passenger-lift2))
				(at end (not(at-lift ?p ?l)))
				(at end (at-floor ?l ?floor))
			)
	)	
)
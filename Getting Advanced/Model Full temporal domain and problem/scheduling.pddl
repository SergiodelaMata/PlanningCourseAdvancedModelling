(define (domain scheduling)
	(:requirements :strips :typing :equality :negative-preconditions :fluents 
		:durative-actions :preferences :constraints)
		(:types
			date-week - object
			class - object
			num-classes - object
			person - object
			teacher student - object
			number - object
		)
		(:predicates
			(was-made ?h1 ?h2 - number ?c - class ?d - date-week)
			(num-classes ?n - number ?c - class ?t - teacher)
			(next-number ?n1 ?n2 - number)
			(greater ?n1 ?n2 - number)
			(at-class ?h1 ?h2 - number ?d - date-week ?c - class ?t - teacher)
			;;(is-from ?s - student ?c - class)
			;;(has-num-classes ?s - student ?n - number ?t - teacher)
			
		)
		(:functions
			(difference-time ?h1 ?h2 - number ?d1 ?d2 - date-week)
			(total-time-teachers)
		)
		
		(:durative-action make-class
			:parameters(?t - teacher ?c - class ?n ?n1 ?n2 ?h1 ?h2 - number ?d1 ?d2 - date-week)
			:duration(= ?duration (difference-time ?h1 ?h2 ?d1 ?d2))
			:condition(and
							(at start (= ?d1 ?d2))
							(at start (greater ?n ?n1)) ;; No se ha alcanzado el máximo número de clases que debe realizar con los alumnos
							(at start (next-number ?n1 ?n2)) ;; Son números ascendientemente contiguos
							(at start (num-classes ?n1 ?c ?t)) ;; Número de clases inicial dadas por un profesor a una clases
							(at start (next-number ?h1 ?h2))
						)
			:effect(and
						(at start (at-class ?h1 ?h2 ?d1 ?c ?t))
						(at start (not(num-classes ?n1 ?c ?t)))
						(at end (num-classes ?n2 ?c ?t))
						(at end (was-made ?h1 ?2 ?c ?d1))
						(at end (at-class ?h1 ?h2 ?d1 ?c ?t))
					)
		)
		(:durative-action move
			:parameters(?t - teacher ?c - class ?n ?n1 ?n2 ?h1 ?2 - number ?d1 ?d2 - date-week)
			:duration(= ?duration (difference-time ?h1 ?h2 ?d1 ?d2))
			:condition(and
							
						)
			:effect(and
						
					)
		)
)
							
							

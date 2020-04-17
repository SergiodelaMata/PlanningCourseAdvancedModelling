(define (domain rover)
	(:requirements :strips :typing :equality 
		:negative-preconditions :fluents :durative-actions)
	(:types position)
	(:predicates 
		(at-position ?p - position)
		(have-picture ?p - position)
		(have-drilled ?p - position)
		(have-contact-earth ?p - position)
		(have-analysed-samples ?p - position)
		(have-extended-solar-panels ?p - position)
		(moving)
	)
	(:functions 
		(battery-level)
		(capacity)
		(battery-requiered-move-fast ?p1 ?p2 - position)
		(battery-requiered-move-slow ?p1 ?p2 - position)
		(battery-requiered-take-picture-fast)
		(battery-requiered-take-picture-slow)
		(battery-requiered-drilling-fast)
		(battery-requiered-drilling-slow)
		(battery-requiered-have-contact-earth-fast)
		(battery-requiered-have-contact-earth-slow)
		(battery-requiered-analyse-samples-fast)
		(battery-requiered-analyse-samples-slow)
		(battery-requiered-extend-solar-panels-fast)
		(battery-requiered-extend-solar-panels-slow)
		(recharge-battery-rate)
		(distance ?p1 ?p2 - position)
		(speed-fast)
		(speed-slow)
		(total-battery-used)
	)
	;; Acción del movimiento del rover con velocidad rápida
	(:durative-action move-fast
		:parameters (?p1 ?p2 - position)
		:duration (= ?duration (/ (distance ?p1 ?p2)(speed-fast)))
		:condition 
			(and
				(at start (not(moving)))
				(at start (at-position ?p1))
				(at start (not(at-position ?p2)))
				(at start (>= (battery-level) (/ (distance ?p1 ?p2)(speed-fast)))) 
			)
		:effect 
			(and 
				(at start (moving))
				(at start (not (at-position ?p1))) 
				(at start (at-position ?p2))
				;; Baja el nivel de batería de acuerdo con respecto a que vaya rápido el rovel y el tiempo que tarda en moverse
				(at end (decrease (battery-level) (/(*(battery-requiered-move-fast ?p1 ?p2)(distance ?p1 ?p2))(speed-fast)))) 
				(at end (increase (total-battery-used)(/(*(battery-requiered-move-fast ?p1 ?p2)(distance ?p1 ?p2))(speed-fast))))
				(at end (not(moving)))
			)
	)
	;; Acción del movimiento del rover con velocidad rápida
	(:durative-action move-slow
		:parameters (?p1 ?p2 - position)
		:duration (= ?duration (/ (distance ?p1 ?p2)(speed-slow)))
		:condition 
			(and
				(at start (not(moving)))
				(at start (at-position ?p1))
				(at start (not(at-position ?p2)))
				(at start (>= (battery-level) (/ (distance ?p1 ?p2)(speed-slow)))) 
			)
		:effect 
			(and 
				(at start (moving))
				(at start (not (at-position ?p1))) 
				(at start (at-position ?p2))
				;; Baja el nivel de batería de acuerdo con respecto a que vaya despacio el rovel y el tiempo que tarda en moverse
				(at end (decrease (battery-level) (/(*(battery-requiered-move-slow ?p1 ?p2)(distance ?p1 ?p2))(speed-slow)))) 
				(at end (increase (total-battery-used) (/(*(battery-requiered-move-slow ?p1 ?p2)(distance ?p1 ?p2))(speed-slow))))
				(at end (not(moving)))
			)
	)

	;; Acción para realizar una imagen de manera lenta
	(:durative-action take-picture-slow
		:parameters(?p - position)
		:duration (= ?duration 5)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not (moving)))
				(at start (not (have-picture ?p)))
				(at start (>= (battery-level) (battery-requiered-take-picture-slow)))
				
			)
		:effect
			(and
				(at start (not(moving)))
				(at start (have-picture ?p))
				(at end (decrease (battery-level) (battery-requiered-take-picture-slow))) 
				(at end (increase (total-battery-used) (battery-requiered-take-picture-slow)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para realizar una imagen de manera rápida
	(:durative-action take-picture-fast
		:parameters(?p - position)
		:duration (= ?duration 2)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not (moving)))
				(at start (not (have-picture ?p)))
				(at start (>= (battery-level) (battery-requiered-take-picture-fast)))
				
			)
		:effect
			(and
				(at start (not(moving)))
				(at start (have-picture ?p))
				(at end (decrease (battery-level) (battery-requiered-take-picture-fast))) 
				(at end (increase (total-battery-used) (battery-requiered-take-picture-fast)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para escabar de manera lenta
	(:durative-action drill-slow
		:parameters(?p - position)
		:duration (= ?duration 50)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-drilled ?p)))
				(at start (>= (battery-level) (battery-requiered-drilling-slow)))
				
			)
		:effect	
			(and
				(at start (not(moving)))
				(at start (have-drilled ?p))
				(at end (decrease (battery-level) (battery-requiered-drilling-slow))) 
				(at end (increase (total-battery-used) (battery-requiered-drilling-slow)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para escabar de manera rápida
	(:durative-action drill-fast
		:parameters(?p - position)
		:duration (= ?duration 20)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-drilled ?p)))
				(at start (>= (battery-level) (battery-requiered-drilling-fast)))
				
			)
		:effect	
			(and
				(at start (not(moving)))
				(at start (have-drilled ?p))
				(at end (decrease (battery-level) (battery-requiered-drilling-fast))) 
				(at end (increase (total-battery-used) (battery-requiered-drilling-fast)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para tener contacto con la tierra de manera lenta
	(:durative-action make-contact-earth-slow
		:parameters(?p - position)
		:duration (= ?duration 30)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-contact-earth ?p)))
				(at start (>= (battery-level) (battery-requiered-have-contact-earth-slow)))
				
			)
		:effect	
			(and
				(at start (not(moving)))
				(at start (have-contact-earth ?p))
				(at end (decrease (battery-level) (battery-requiered-have-contact-earth-slow))) 
				(at end (increase (total-battery-used)(battery-requiered-have-contact-earth-slow)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para tener contacto con la tierra de manera rápida
	(:durative-action make-contact-earth-fast
		:parameters(?p - position)
		:duration (= ?duration 10)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-contact-earth ?p)))
				(at start (>= (battery-level) (battery-requiered-have-contact-earth-fast)))
				
			)
		:effect	
			(and
				(at start (not(moving)))
				(at start (have-contact-earth ?p))
				(at end (decrease (battery-level) (battery-requiered-have-contact-earth-fast))) 
				(at end (increase (total-battery-used) (battery-requiered-have-contact-earth-fast)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para analizar las muestras de manera lenta
	(:durative-action analyse-samples-slow
		:parameters(?p - position)
		:duration (= ?duration 80)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-analysed-samples ?p)))
				(at start (>= (battery-level) (battery-requiered-analyse-samples-slow)))
				
			)
		:effect	
			(and
				(at start (not(moving)))
				(at start (have-analysed-samples ?p))
				(at end (decrease (battery-level) (battery-requiered-analyse-samples-slow))) 
				(at end (increase (total-battery-used) (battery-requiered-analyse-samples-slow)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para analizar las muestras de manera rápida
	(:durative-action analyse-samples-fast
		:parameters(?p - position)
		:duration (= ?duration 50)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-analysed-samples ?p)))
				(at start (>= (battery-level) (battery-requiered-analyse-samples-fast)))
				
			)
		:effect	
			(and
				(at start (not(moving)))
				(at start (have-analysed-samples ?p))
				(at end (decrease (battery-level) (battery-requiered-analyse-samples-fast))) 
				(at end (increase (total-battery-used) (battery-requiered-analyse-samples-fast)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para analizar las muestras de manera lenta
	(:durative-action extend-solar-panels-slow
		:parameters(?p - position)
		:duration (= ?duration 20)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-extended-solar-panels ?p)))
				(at start (>= (battery-level) (battery-requiered-extend-solar-panels-slow)))
				
			)
		:effect	
			(and
				(at start (not(moving)))
				(at start (have-extended-solar-panels ?p))
				(at end (decrease (battery-level) (battery-requiered-extend-solar-panels-slow))) 
				(at end (increase (total-battery-used) (battery-requiered-extend-solar-panels-slow)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para analizar las muestras de manera rápida
	(:durative-action extend-solar-panels-fast
		:parameters(?p - position)
		:duration (= ?duration 10)
		:condition
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-extended-solar-panels ?p)))
				(at start (>= (battery-level) (battery-requiered-extend-solar-panels-fast)))
				
			)
		:effect	
			(and
				(at start (not(moving)))
				(at start (have-extended-solar-panels ?p))
				(at end (decrease (battery-level) (battery-requiered-extend-solar-panels-fast))) 
				(at end (increase (total-battery-used) (battery-requiered-extend-solar-panels-fast)))
				(at end (not(moving)))
			)
	)
	
	;; Acción para recargar el rover
	(:durative-action recharge
		:parameters(?p - position)
		:duration (= ?duration (/ (- (capacity) (battery-level)) (recharge-battery-rate)))
		:condition
			(and
				(at start (not(moving)))
				(at start (have-extended-solar-panels ?p))
			)
		:effect	
			(and
				(at start (not(moving)))
				(at end (not(have-extended-solar-panels ?p)))
				(at end (assign (battery-level) (capacity))) 
				(at end (not(moving)))
			)
	)
	
)
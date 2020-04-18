(define (domain building)
	(:requirements :strips :typing :equality 
		:negative-preconditions :fluents :durative-actions)
	(:types
		lift - object ;; Objeto ascensor
		slowlift fastlift - lift ;; Tipos de ascensores según su velocidad
		person - object ;; Objeto persona
		number - object ;; Objeto número
	)
	(:predicates 
		(at-floor ?elem - (either person lift) ?floor - number) ;; Predicado para conocer la planta en donde se encuentra una persona o un ascensor
		(at-lift ?p - person ?l - lift) ;; Predicado para conocer en que ascensor se encuentra una persona
		(can-stop ?l - lift ?f - number) ;; Predicado para conocer si un ascensor puede parar en una planta
		(above ?f1 ?f2 - number) ;; Predicado para conocer si un valor está por encima de otro siendo el segundo que se encuentra por encima
		(next-number ?n1 ?n2 - number) ;; Predicado para conocer el siguiente valor a un número
		(is-num-passengers ?l - lift ?num - number) ;; Predicado para conocer el número de personas en un ascensor
	)
	(:functions 
		(speed-travel-slow ?l - slowlift) ;; Función para conocer la velocidad de un ascensor lento
		(speed-travel-fast ?l - fastlift) ;; Función para conocer la velocidad de un ascensor rápido
		(distance ?f1 ?f2 - number) ;; Función para conocer la distancia entre dos números
	)
	
	;; Acción para que se mueva hacia arriba los ascensores rápidos
	(:durative-action move-up-fast
		:parameters (?l - fastlift ?floor1 ?floor2 - number)
		:duration (= ?duration (/ (distance ?floor1 ?floor2)(speed-travel-fast ?l))) ;; Duración en relación a la distancia entre plantas y la velocidad del ascensor
		:condition 
		;; Ha de conocerse si el ascensor rápido puede parar en una planta o no, la planta de destino está por encima que la de origen y que se encuentra en la planta origen y no en la de destino
			(and
				(at start (at-floor ?l ?floor1))
				(at start (above ?floor1 ?floor2))
				(at start (can-stop ?l ?floor2)) 
			)
		:effect 
		;; Se tiene que tener en cuenta que el ascensor al inicio ya no se encuentra en la posición de origen y que al final está en la de destino
			(and 
				(at start (not(at-floor ?l ?floor1)))
				(at end (at-floor ?l ?floor2))
			)
	)
	;; Acción para que se mueva hacia arriba los ascensores lentos
	(:durative-action move-up-slow
		:parameters (?l - slowlift ?floor1 ?floor2 - number)
		:duration (= ?duration (/ (distance ?floor1 ?floor2)(speed-travel-slow ?l))) ;; Duración en relación a la distancia entre plantas y la velocidad del ascensor
		:condition 
		;; Ha de conocerse si el ascensor lento puede parar en una planta o no, la planta de destino está por encima que la de origen y que se encuentra en la planta origen y no en la de destino
			(and
				(at start (at-floor ?l ?floor1))
				(at start (above ?floor1 ?floor2))
			)
		:effect 
		;; Se tiene que tener en cuenta que el ascensor al inicio ya no se encuentra en la posición de origen y que al final está en la de destino
			(and 
				(at start (not(at-floor ?l ?floor1)))
				(at end (at-floor ?l ?floor2))
			)
	)
	
	;; Acción para que se mueva hacia abajo los ascensores rápidos
	(:durative-action move-down-fast
		:parameters (?l - fastlift ?floor1 ?floor2 - number)
		:duration (= ?duration (/ (distance ?floor1 ?floor2)(speed-travel-fast ?l))) ;; Duración en relación a la distancia entre plantas y la velocidad del ascensor
		:condition 
		;; Ha de conocerse si el ascensor rápido puede parar en una planta o no, la planta de origen está por encima que la de destino y que se encuentra en la planta origen y no en la de destino
			(and
				(at start (at-floor ?l ?floor1))
				(at start (above ?floor2 ?floor1))
				(at start (can-stop ?l ?floor2)) 
			)
		:effect 
		;; Se tiene que tener en cuenta que el ascensor al inicio ya no se encuentra en la posición de origen y que al final está en la de destino
			(and 
				(at start (not(at-floor ?l ?floor1)))
				(at end (at-floor ?l ?floor2))
			)
	)
	;; Acción para que se mueva hacia abajo los ascensores lentos
	(:durative-action move-down-slow
		:parameters (?l - slowlift ?floor1 ?floor2 - number)
		:duration (= ?duration (/ (distance ?floor1 ?floor2)(speed-travel-slow ?l))) ;; Duración en relación a la distancia entre plantas y la velocidad del ascensor
		:condition 
		;; Ha de conocerse si el ascensor rápido puede parar en una planta o no, la planta de origen está por encima que la de destino y que se encuentra en la planta origen y no en la de destino
			(and
				(at start (at-floor ?l ?floor1))
				(at start (above ?floor2 ?floor1))
			)
		:effect 
		;; Se tiene que tener en cuenta que el ascensor al inicio ya no se encuentra en la posición de origen y que al final está en la de destino
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
		;; Ha de conocerse si el ascensor y la persona están en una misma planta y que el número de pasajeros aumenta en una unidad
			(and
				(at start (at-floor ?p ?floor))
				(at start (at-floor ?l ?floor))
				(at start (is-num-passengers ?l ?num-passenger-lift1))
				(at start (next-number ?num-passenger-lift1 ?num-passenger-lift2))
			)
		:effect 
		;; Se tiene en cuenta que ahora ha aumentado el número de pasajeros, que el ascensor se queda en la planta durante toda la acción y la persona ahora no está en la planta sino que está en el ascensor
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
		;; Ha de conocerse si la persona está en el ascensor y el ascensor está en una planta y que el número de pasajeros disminuye en una unidad
			(and
				(at start (not(at-floor ?p ?floor)))
				(at start (at-floor ?l ?floor))
				(at start (is-num-passengers ?l ?num-passenger-lift1))
				(at start (next-number ?num-passenger-lift2 ?num-passenger-lift1))
			)
		:effect 
		;; Se tiene en cuenta que ahora ha disminuido el número de pasajeros, que el ascensor se queda en la planta durante toda la acción y la persona ahora está en la planta y no en el ascensor
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
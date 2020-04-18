(define (domain rover)
	(:requirements :strips :typing :equality 
		:negative-preconditions :fluents :durative-actions)
	(:types position)
	(:predicates 
		(at-position ?p - position) ;; Predicado para conocer la posición del rover
		(have-picture ?p - position) ;; Predicado para saber si el rover ha hecho una foto en una posición
		(have-drilled ?p - position) ;; Predicado para saber si el rover ha taladrado en una posición
		(have-contact-earth ?p - position) ;; Predicado para saber si el rover ha contactado con la tierra en una posición
		(have-analysed-samples ?p - position) ;; Predicado para saber si el rover ha analizado unas muestras en una posición
		(have-extended-solar-panels ?p - position) ;; Predicado para saber si el rover ha extendido sus paneles solares en una posición
		(moving)
	)
	;; Se ha de tener en cuenta de que todas las acciones tienen dos velocidades salvo la recarga
	(:functions 
		(battery-level) ;; Función para saber el nivel de batería del rover
		(capacity) ;; Función para conocer el nivel máximo de batería del rover
		(battery-requiered-move-fast ?p1 ?p2 - position) ;; Función para conocer la bateria por unidad de tiempo requerida por el rover para moverse de forma rápida entre dos posiciones
		(battery-requiered-move-slow ?p1 ?p2 - position) ;; Función para conocer la bateria por unidad de tiempo requerida por el rover para moverse de forma lenta entre dos posiciones
		(battery-requiered-take-picture-fast) ;; Función para conocer la bateria requerida por el rover para realizar una foto de forma rápida
		(battery-requiered-take-picture-slow) ;; Función para conocer la bateria requerida por el rover para realizar una foto de forma lenta
		(battery-requiered-drilling-fast) ;; Función para conocer la bateria requerida por el rover para taladrar de forma rápida
		(battery-requiered-drilling-slow) ;; Función para conocer la bateria requerida por el rover para taladrar de forma lenta
		(battery-requiered-have-contact-earth-fast) ;; Función para conocer la bateria requerida por el rover para hacer contacto con la tierra de forma rápida
		(battery-requiered-have-contact-earth-slow) ;; Función para conocer la bateria requerida por el rover para hacer contacto con la tierra de forma lenta
		(battery-requiered-analyse-samples-fast) ;; Función para conocer la bateria requerida por el rover para analizar muestras de forma rápida
		(battery-requiered-analyse-samples-slow) ;; Función para conocer la bateria requerida por el rover para analizar muestras de forma lenta
		(battery-requiered-extend-solar-panels-fast) ;; Función para conocer la bateria requerida por el rover para extender los paneles solares de forma rápida
		(battery-requiered-extend-solar-panels-slow) ;; Función para conocer la bateria requerida por el rover para extender los paneles solares de forma lenta
		(recharge-battery-rate) ;; Función para saber ratio de recarga del rover
		(distance ?p1 ?p2 - position) ;; Función para saber la distancia entre dos posiciones
		(speed-fast) ;; Función para que el rover se mueva con velocidad rápida
		(speed-slow) ;; Función para que el rover se mueva con velocidad rápida
		(total-battery-used) ;; Función para que obtener la batería total usada por el rover para realizar una serie de acciones
	)
	;; Acción del movimiento del rover con velocidad rápida
	(:durative-action move-fast
		:parameters (?p1 ?p2 - position)
		:duration (= ?duration (/ (distance ?p1 ?p2)(speed-fast))) ;; Duración obtenida a partir de la distancia y la velocidad rápida del rover
		:condition 
			(and 
			;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior a la necesaria para moverse, que no se está moviendo aún, que no se encuentra en la posición de destino y está en la posición de origen
				(at start (not(moving)))
				(at start (at-position ?p1))
				(at start (not(at-position ?p2)))
				(at start (>= (battery-level) (/ (distance ?p1 ?p2)(speed-fast)))) 
			)
		:effect 
		;; Se debe tener en cuenta que el rover solo se mueve durante el transcurso del movimiento, que ya no está el rover en la posición de origen al inicio del movimiento y que al final está en la de destino, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		:duration (= ?duration (/ (distance ?p1 ?p2)(speed-slow))) ;; Duración obtenida a partir de la distancia y la velocidad lenta del rover
		:condition 
			(and
			;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior a la necesaria para moverse, que no se está moviendo aún, que no se encuentra en la posición de destino y está en la posición de origen
				(at start (not(moving)))
				(at start (at-position ?p1))
				(at start (not(at-position ?p2)))
				(at start (>= (battery-level) (/ (distance ?p1 ?p2)(speed-slow)))) 
			)
		:effect 
		;; Se debe tener en cuenta que el rover solo se mueve durante el transcurso del movimiento, que ya no está el rover en la posición de origen al inicio del movimiento y que al final está en la de destino, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no ha hecho foto en esa posición
			(and
				(at start (at-position ?p))
				(at start (not (moving)))
				(at start (not (have-picture ?p)))
				(at start (>= (battery-level) (battery-requiered-take-picture-slow)))
				
			)
		:effect
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha realizado la foto, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no ha hecho foto en esa posición
			(and
				(at start (at-position ?p))
				(at start (not (moving)))
				(at start (not (have-picture ?p)))
				(at start (>= (battery-level) (battery-requiered-take-picture-fast)))
				
			)
		:effect
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha realizado la foto, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no ha taladrado en esa posición
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-drilled ?p)))
				(at start (>= (battery-level) (battery-requiered-drilling-slow)))
				
			)
		:effect	
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha taladrado, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no ha taladrado en esa posición
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-drilled ?p)))
				(at start (>= (battery-level) (battery-requiered-drilling-fast)))
				
			)
		:effect	
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha taladrado, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no ha contactado con la tierra en esa posición
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-contact-earth ?p)))
				(at start (>= (battery-level) (battery-requiered-have-contact-earth-slow)))
				
			)
		:effect	
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha contactado con la tierra, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no ha contactado con la tierra en esa posición
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-contact-earth ?p)))
				(at start (>= (battery-level) (battery-requiered-have-contact-earth-fast)))
				
			)
		:effect	
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha contactado con la tierra, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no ha analizado las muestras en esa posición
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-analysed-samples ?p)))
				(at start (>= (battery-level) (battery-requiered-analyse-samples-slow)))
				
			)
		:effect	
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha analizado las muestras, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no ha analizado las muestras en esa posición
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-analysed-samples ?p)))
				(at start (>= (battery-level) (battery-requiered-analyse-samples-fast)))
				
			)
		:effect	
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha analizado las muestras, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no se han extendido los paneles solares en esa posición
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-extended-solar-panels ?p)))
				(at start (>= (battery-level) (battery-requiered-extend-solar-panels-slow)))
				
			)
		:effect	
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha extendido los paneles solares, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		;; Ha de tenerse en cuenta que inicialmente el rover debe tener energía suficiente o superior para realizar la acción, el rover se encuentra en la posición y no se han extendido los paneles solares en esa posición
			(and
				(at start (at-position ?p))
				(at start (not(moving)))
				(at start (not(have-extended-solar-panels ?p)))
				(at start (>= (battery-level) (battery-requiered-extend-solar-panels-fast)))
				
			)
		:effect	
		;; Se debe tener en cuenta que el rover no se mueve en ningún momento, ya ha extendido los paneles solares, la batería del rover ha disminuido y ha aumentado la batería total usada
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
		:duration (= ?duration (/ (- (capacity) (battery-level)) (recharge-battery-rate))) ;; Duración en relación a la batería a introducir y el ratio de carga
		:condition
		;; Ha de tenerse en cuenta que los paneles solares deben estar extendidos y que no se está moviendo
			(and
				(at start (not(moving)))
				(at start (have-extended-solar-panels ?p))
			)
		:effect	
		;; Se debe tener en cuenta que no se mueve en ningún momento, que los paneles no están extendidos una vez que se haya cargado y la batería del rover tiene su máxima capacidad
			(and
				(at start (not(moving)))
				(at end (not(have-extended-solar-panels ?p)))
				(at end (assign (battery-level) (capacity))) 
				(at end (not(moving)))
			)
	)
	
)
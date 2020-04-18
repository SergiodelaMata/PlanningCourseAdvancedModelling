(define (problem rover-problem)
	(:domain rover)
	(:objects
		p1 p2 p3 - position ;; Declaración de las 3 posiciones donde se puede situar el rover
	)
	(:init
		(at-position p1) ;; Posición inical del rover
		(=(battery-level) 50) ;; Nivel inicial de la batería
		(=(capacity) 400) ;; Capacidad del rover máxima
		;; Batería requerida para cada una de las operaciones que puede realizar el rover
		(=(battery-requiered-move-fast p1 p2) 10)
		(=(battery-requiered-move-slow p1 p2) 5)
		(=(battery-requiered-move-fast p1 p3) 15)
		(=(battery-requiered-move-slow p1 p3) 8)
		(=(battery-requiered-move-fast p2 p1) 10)
		(=(battery-requiered-move-slow p2 p1) 5)
		(=(battery-requiered-move-fast p2 p3) 20)
		(=(battery-requiered-move-slow p2 p3) 12)
		(=(battery-requiered-move-fast p3 p1) 15)
		(=(battery-requiered-move-slow p3 p1) 8)
		(=(battery-requiered-move-fast p3 p2) 20)
		(=(battery-requiered-move-slow p3 p2) 12)
		(=(battery-requiered-take-picture-fast) 30)
		(=(battery-requiered-take-picture-slow) 15)
		(=(battery-requiered-drilling-fast) 40)
		(=(battery-requiered-drilling-slow) 10)
		(=(battery-requiered-have-contact-earth-fast) 10)
		(=(battery-requiered-have-contact-earth-slow) 5)
		(=(battery-requiered-analyse-samples-fast) 25)
		(=(battery-requiered-analyse-samples-slow) 15)
		(=(battery-requiered-extend-solar-panels-fast) 5)
		(=(battery-requiered-extend-solar-panels-slow) 0)
		;; Ratio de batería a la hora de recargar el rover
		(=(recharge-battery-rate) 40)
		;; Distancia entre las distintas posiciones
		(=(distance p1 p2) 30)
		(=(distance p1 p3) 20)
		(=(distance p2 p1) 30)
		(=(distance p2 p3) 10)
		(=(distance p3 p1) 20)
		(=(distance p3 p2) 10)
		;; Velocidades del rover
		(=(speed-fast) 20)
		(=(speed-slow) 10)
		;; Batería total inicial usada
		(=(total-battery-used) 0)
	)
	(:goal (and
	;; El rover acaba en p2, habiendo hecho una foto en p1, taladrado p3, hecho contacto con la tierra en p1, analizado las muestras en p3 y extendido los paneles solares en p2
		(at-position p2)
		(have-picture p1)
		(have-drilled p3)
		(have-contact-earth p1)
		(have-analysed-samples p3)
		(have-extended-solar-panels p2))
	)
	;; Se busca el camino con el menor coste de batería
	(:metric minimize (total-battery-used))
	
)
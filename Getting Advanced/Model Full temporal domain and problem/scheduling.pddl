(define (domain scheduling)
	(:requirements :strips :typing :equality :negative-preconditions :fluents 
		:durative-actions :preferences :constraints)
		(:types
			date-week - object
			class - object
			teacher - object
			number - object
		)
		(:predicates
			(greater ?n1 ?n2 - number) ;; Número superior a otro
			(next-number ?n1 ?n2 - number) ;; Siguiente número
			(greater-date ?d1 ?d2 - date-week) ;; Un día está más avanzado en el tiempo que el otro
			;;(next-date ?d1 ?d2 - date-week) ;; Siguiente día
			(class-made ?c - class ?t - teacher ?d - date) ;; Clase realizada por un profesor un día a un grupo
			(class-hours-made ?h1 ?h2 - number ?c - class ?d - date) ;; Clase realizada a un grupo un día entre dos horas contiguas
			(num-classes ?num - number ?c - class ?t - teacher) ;; Número de clases ha realizar un profesor a un grupo
			(at-time-location ?h - number ?d - date ?t - teacher) ;; Localización temporal de un profesor un día a una hora
			(at-location ?c - class ?t - teacher) ;; Localización espacial de un profesor
			(class-can-be-made ?c - class ?d - date ?t - teacher) ;; Válida si una clase puede realizarse un día por un profesor a un día
			(class-can-be-done ?h1 ?h2 - number ?d - date ?c - class) ;; Válida si se puede realizarse una clase en un intervalo de tiempo a una clase en un día
			(available ?t - teacher) ;; Un profesor no se encuentra en clase o ya no puede dar más clases
			(do-class ?c - class) ;; Clases que se deben enseñar a los alumnos de un grupo
			(rest-class ?c - class) ;; Clases en las que se puede esperar a dar clase
			(initial-hour ?h - number) ;; Hora inicial de un día para empezar las clases
			(last-hour ?h - number) ;; Hora final de un día para terminar las clases
			(different-cero ?num - number) ;; Número distinto de cero
		)
		(:functions
			(date-difference ?d1 ?d2 - date-week) ;; Diferencia temporal entre dos días
			(hour-difference ?h1 ?h2 - number) ;; Diferencia temporal entre dos horas
			(total-time-teachers) ;; Tiempo total del sumatorio de horas que deben tenerse en cuenta de cada profesor esta que realice el total de horas que tiene que realizar con todos grupos en una semana
		)
		;; Acción para permitir a un profesor realice una clase en un intervalo de tiempo de un día a un grupo de alumnos
		(:durative-action make-class
			:parameters(?t - teacher ?c1 ?c2 - class ?num1 ?num2 ?n1 ?n2 ?h1 ?h2 - number ?d1 ?d2 - date-week)
			:duration(= ?duration (hour-difference ?h1 ?h2)) ;; Duración de la clase
			:condition(and
							(at start (= ?d1 ?d2)) ;; Mismo día
							(at start (greater ?h1 ?h2)) ;; La segunda hora es superior a la primera
							(at start (next-number ?h1 ?h2)) ;; La segunda hora es la siguiente hora con respecto a la primera
							(at start (at-time-location ?h1 ?d1 ?t) ;; Localización temporal inicial de un profesor
							(at start (at-location ?c1 ?t)) ;; Localización espacial inicial de un profesor
							(at start (greater num2 num1)) ;; El primer número es mayor al segundo número
							(at start (next-number num2 num1)) ;; El segundo número es el siguiente número con respecto al primero
							(at start (class-can-be-made ?c2 ?d1 ?t)) ;; Aún no ha realizado un profesor su clase con un grupo un día de la semana
							(at start (class-can-be-done ?h1 ?h2 ?d1 ?c2)) ;; Aún no se ha realizado la clase de un grupo en un intervalo de tiempo un día de la semana
							(at start (available ?t)) ;; El profesor no está dando de clase
							(at start (num-classes ?num1 ?c2 ?t)) ;; Aún dispone de alguna clase que realizar
							(at start (do-class ?c2)) ;; Se trata de una clase en la que se debe dar clase  
						)
			:effect(and
						(over all (not (available ?t))) ;; Durante la clase, el profesor no se encuentra disponible
						(at start (not (at-location ?c1 ?t))) ;; Inicialmente ya no se encuentra en la localización inicial
						(over all (at-location ?c2 ?t)) ;; Durante todo el proceso ya se encuentra en la localización final
						;; Disminuye el número de clases que tiene que realizar un profesor con una clase a la semana
						(at start (not(num-classes ?num1 ?c2 ?t)))
						(at end (num-classes ?num2 ?c2 ?t))
						(over all (class-made ?c2 ?t ?d1)) ;; Clase realizado con un grupo un día de la semana ha sido realizada
						(over all (class-hours-made ?h1 ?h2 ?c2 ?d1)) ;; Clase realizada de un grupo en un intervalo de horas de un día
						(at start (at-time-location ?h1 ?d1 ?t) ;; Comienza estando en la hora inicial de un día un profesor
						(at end (not(at-time-location ?h1 ?d1 ?t))) ;; Termina no estando en la hora inicial de un día un profesor
						(at end (at-time-location ?h2 ?d2 ?t)) ;; Termina estando en la hora final de un día un profesor
						(at start (not(class-can-be-made ?c2 ?d1 ?t))) ;; Una vez se vaya a realizar la clase de un grupo un día por un profesor, ésta ya no va estar de nuevo disponible para ese profesor ese día
						(at start (not(class-can-be-done ?h1 ?h2 ?d1 ?c2))) ;; Una vez ya ha sido asignada una clase de un grupo de un intervalo de tiempo un día, éste ya no va a estar disponible para realizarse en ese día 
						(at end (available ?t)) ;; Al final de la clase, el profesor vuelve a estar disponible
						(at end (increase (total-time-teachers) (hour-difference ?h1 ?h2))) ;; Incrementa el tiempo total entre todos los profesores
					)
		)
		;; Acción para que un profesor espere a realizar una clase
		(:durative-action wait-next-class
			:parameters(?t - teacher ?c1 ?c2 - class ?num ?h1 ?h2 - number ?d1 ?d2 - date-week)
			:duration(= ?duration (hour-difference ?h1 ?h2)) ;; Duración de la clase
			:condition(and
							(at start (= ?d1 ?d2)) ;; Mismo día
							(at start (greater ?h1 ?h2)) ;; La segunda hora es superior a la primera
							
							(at start (at-time-location ?h1 ?d1 ?t) ;; Localización temporal inicial de un profesor
							(at start (at-location ?c1 ?t)) ;; Localización espacial inicial de un profesor
							
							(at start (available ?t)) ;; El profesor no está disponible para dar una clase mientras espera
							(at start (different-cero ?num)) ;; El número de clases a realizar es distinto de cero
							(at start (num-classes ?num ?c2 ?t)) ;; Aún dispone de alguna clase que realizar
							(at start (rest-class ?c2)) ;; Se trata de una clase en la que se debe dar clase 
						)
			:effect(and
						(at end (not(at-time-location ?h1 ?d1 ?t))) ;; Termina no estando en la hora inicial de un día un profesor
						(at end (at-time-location ?h2 ?d2 ?t)) ;; Termina estando en la hora final de un día un profesor
						(at start (not(at-location ?c1 ?t))) ;; Inicialmente ya no se encuentra en la localización inicial
						(over all (at-location ?c2 ?t)) ;; Durante todo el proceso ya se encuentra en la localización final
						
						(over all (not (available ?t))) ;; Mientras espera, el profesor no se encuentra disponible
						(at end (available ?t)) ;; Al final de la espera, el profesor vuelve a estar disponible
						(at end (increase (total-time-teachers) (hour-difference ?h1 ?h2))) ;; Incrementa el tiempo total entre todos los profesores
					)
		)
		;; Acción para que se tenga el cambio de día para dar clases un profesor
		(:durative-action wait-next-day
			:parameters(?t - teacher ?c1 ?c2 - class ?num ?h1 ?h2 - number ?d1 ?d2 - date-week)
			:duration(= ?duration (date-difference ?d1 ?d2)) ;; Duración de la clase
			:condition(and
							(at start (greater-date ?d1 ?d2)) ;; El segundo día está más avanzado en el tiempo que el primero
							(at start (last-hour ?h1)) ;; Es la última hora del primer día
							(at start (initial-hour ?h2)) ;; Es la primera hora del segundo día
							(at start (at-time-location ?h1 ?d1 ?t) ;; Localización temporal inicial de un profesor
							(at start (at-location ?c1 ?t)) ;; Localización espacial inicial de un profesor
							
							(at start (available ?t)) ;; El profesor no está dando clase
							(at start (different-cero ?num)) ;; El número de clases a realizar es distinto de cero
							(at start (num-classes ?num ?c2 ?t)) ;; Aún dispone de alguna clase que realizar
						)
			:effect(and
						(at end (not(at-time-location ?h1 ?d1 ?t))) ;; Termina no estando en la hora inicial de un día un profesor
						(at end (at-time-location ?h2 ?d2 ?t)) ;; Termina estando en la hora final de un día un profesor
						(at start (not(at-location ?c1 ?t))) ;; Inicialmente ya no se encuentra en la localización inicial
						(over all (at-location ?c2 ?t)) ;; Durante todo el proceso ya se encuentra en la localización final
						
						(over all (not (available ?t))) ;; Mientras espera, el profesor no se encuentra disponible
						(at end (available ?t)) ;; Al final de la espera, el profesor vuelve a estar disponible
						(at end (increase (total-time-teachers) (date-difference ?d1 ?d2))) ;; Incrementa el tiempo total entre todos los profesores
					)
		)
		
)
							
							

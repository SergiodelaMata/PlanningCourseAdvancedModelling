(define (domain scheduling)
	(:requirements :strips :typing :equality :negative-preconditions :fluents 
		:durative-actions :preferences :constraints)
		(:types
			date-week - object ;; Objecto día de la semana
			class - object ;; Objeto clase de grupo de alumnos
			teacher - object ;; Objeto profesor
			numbers - object ;; Objeto número
		)
		(:predicates
			(greater ?n1 ?n2 - numbers) ;; Predicado para saber si un número es superior a otro
			(next-number ?n1 ?n2 - numbers) ;; Predicado para conocer el siguiente número a otro
			(greater-date ?d1 ?d2 - date-week) ;; Predicado para saber si un día está alejado en el tiempo con respecto a otro
			(class-made ?c - class ?t - teacher ?d - date-week) ;; Predicado para saber si una clase ha sido realizada por un profesor un día a un grupo
			(class-hours-made ?h1 ?h2 - numbers ?c - class ?d - date-week) ;; Predicado para saber si una clase ha sido realizada a un grupo un día entre dos horas contiguas
			(num-classes ?num - numbers ?c - class ?t - teacher) ;; Predicado para saber el número de clases a realizar un profesor a un grupo
			(at-time-location ?h - numbers ?d - date-week ?t - teacher) ;; Predicado para saber la localización temporal de un profesor un día a una hora
			(at-location ?c - class ?t - teacher) ;; Predicado para saber la localización espacial de un profesor
			(class-can-be-made ?c - class ?d - date-week ?t - teacher) ;; Predicado para validar si una clase puede realizarse un día por un profesor a un día
			(class-can-be-done ?h1 ?h2 - numbers ?d - date-week ?c - class) ;; Predicado para validar si se puede realizarse una clase en un intervalo de tiempo a una clase en un día
			(available ?t - teacher) ;; Predicado para saber si un profesor no se encuentra en clase
			(free-class ?c - class) ;; Predicado para indica que una clase no está teniendo clase en un momento dado
			(do-class ?c - class) ;; Predicado para identifica las clases que se deben enseñar a los alumnos de un grupo
			(rest-class ?c - class) ;; Predicado para identificar las clases en las que se puede esperar a dar clase
			(initial-hour ?h - numbers) ;; Predicado para saber la hora inicial de un día para empezar las clases
			(last-hour ?h - numbers) ;; Predicado para saber la hora final de un día para terminar las clases
			(different-cero ?num - numbers) ;; Predicado para conocer si un número es distinto de cero
		)
		(:functions
			(date-difference ?d1 ?d2 - date-week) ;; Función para saber la diferencia temporal entre dos días
			(hour-difference ?h1 ?h2 - numbers) ;; Función para saber la diferencia temporal entre dos horas
			(total-time-teachers) ;; Función para saber el tiempo total del sumatorio de horas que deben tenerse en cuenta de cada profesor esta que realice el total de horas que tiene que realizar con todos grupos en una semana
		)
		;; Acción para permitir a un profesor realice una clase en un intervalo de tiempo de un día a un grupo de alumnos
		(:durative-action make-class
			:parameters(?t - teacher ?c1 ?c2 - class ?num1 ?num2 ?h1 ?h2 - numbers ?d1 ?d2 - date-week)
			:duration(= ?duration (hour-difference ?h1 ?h2)) ;; Duración de la clase
			:condition(and
							(at start (= ?d1 ?d2)) ;; Mismo día
							(at start (greater ?h1 ?h2)) ;; La segunda hora es superior a la primera
							(at start (next-number ?h1 ?h2)) ;; La segunda hora es la siguiente hora con respecto a la primera
							(at start (at-time-location ?h1 ?d1 ?t)) ;; Localización temporal inicial de un profesor
							(at start (at-location ?c1 ?t)) ;; Localización espacial inicial de un profesor
							(at start (different-cero ?num1)) ;; El número de clases a realizar es distinto de cero
							(at start (greater ?num2 ?num1)) ;; El primer número es mayor al segundo número
							(at start (next-number ?num2 ?num1)) ;; El segundo número es el siguiente número con respecto al primero
							(at start (free-class ?c2)) ;; La clase no está recibiendo una clase
							(at start (class-can-be-made ?c2 ?d1 ?t)) ;; Aún no ha realizado un profesor su clase con un grupo un día de la semana
							(at start (class-can-be-done ?h1 ?h2 ?d1 ?c2)) ;; Aún no se ha realizado la clase de un grupo en un intervalo de tiempo un día de la semana
							(at start (available ?t)) ;; El profesor no está dando de clase
							(at start (num-classes ?num1 ?c2 ?t)) ;; Aún dispone de alguna clase que realizar
							(at start (do-class ?c2)) ;; Se trata de una clase en la que se debe dar clase  
						)
			:effect(and
						(at start (not(free-class ?c2))) ;; La clase para un grupo de alumnos va a comenzar 
						(at start (not (at-location ?c1 ?t))) ;; Inicialmente ya no se encuentra en la localización inicial
						(at start (not(class-can-be-made ?c2 ?d1 ?t))) ;; Una vez se vaya a realizar la clase de un grupo un día por un profesor, ésta ya no va estar de nuevo disponible para ese profesor ese día
						(at start (not(class-can-be-done ?h1 ?h2 ?d1 ?c2))) ;; Una vez ya ha sido asignada una clase de un grupo de un intervalo de tiempo un día, éste ya no va a estar disponible para realizarse en ese día 
						(at start (not (available ?t))) ;; Durante la clase, el profesor no se encuentra disponible
						(at start (at-location ?c2 ?t)) ;; Durante todo el proceso ya se encuentra en la localización final
						(at end (class-made ?c2 ?t ?d1)) ;; Clase realizado con un grupo un día de la semana ha sido realizada
						(at end (class-hours-made ?h1 ?h2 ?c2 ?d1)) ;; Clase realizada de un grupo en un intervalo de horas de un día
						(at end (not(num-classes ?num1 ?c2 ?t))) ;; Ya se está realizando una de las clases
						(at end (num-classes ?num2 ?c2 ?t)) ;; Disminuye el número de clases que tiene que realizar un profesor con una clase a la semana
						(at end (not(at-time-location ?h1 ?d1 ?t))) ;; Termina no estando en la hora inicial de un día un profesor
						(at end (at-time-location ?h2 ?d2 ?t)) ;; Termina estando en la hora final de un día un profesor
						(at end (available ?t)) ;; Al final de la clase, el profesor vuelve a estar disponible
						(at end (free-class ?c2)) ;; La clase ya ha terminado para un grupo de alumnos 
						(at end (increase (total-time-teachers) (hour-difference ?h1 ?h2))) ;; Incrementa el tiempo total entre todos los profesores
					)
		)
		;; Acción para que un profesor espere a realizar una clase
		(:durative-action wait-next-class
			:parameters(?t - teacher ?c1 ?c2 - class ?num ?h1 ?h2 - numbers ?d1 ?d2 - date-week)
			:duration(= ?duration (hour-difference ?h1 ?h2)) ;; Duración de la clase
			:condition(and
							(at start (= ?d1 ?d2)) ;; Mismo día
							(at start (greater ?h1 ?h2)) ;; La segunda hora es superior a la primera
							(at start (at-time-location ?h1 ?d1 ?t)) ;; Localización temporal inicial de un profesor
							(at start (at-location ?c1 ?t)) ;; Localización espacial inicial de un profesor
							(at start (available ?t)) ;; El profesor no está disponible para dar una clase mientras espera
							(at start (rest-class ?c2)) ;; Se trata de una clase en la que se debe dar clase 
						)
			:effect(and
						(at start (not(at-location ?c1 ?t))) ;; Inicialmente ya no se encuentra en la localización inicial
						(at start (not (available ?t))) ;; Mientras espera, el profesor no se encuentra disponible
						(at start (at-location ?c2 ?t)) ;; Durante todo el proceso ya se encuentra en la localización final
						(at end (not(at-time-location ?h1 ?d1 ?t))) ;; Termina no estando en la hora inicial de un día un profesor
						(at end (at-time-location ?h2 ?d2 ?t)) ;; Termina estando en la hora final de un día un profesor
						(at end (available ?t)) ;; Al final de la espera, el profesor vuelve a estar disponible
						(at end (increase (total-time-teachers) (hour-difference ?h1 ?h2))) ;; Incrementa el tiempo total entre todos los profesores
					)
		)
		;; Acción para que se tenga el cambio de día para dar clases un profesor
		(:durative-action wait-next-day
			:parameters(?t - teacher ?c1 ?c2 - class ?h1 ?h2 - numbers ?d1 ?d2 - date-week)
			:duration(= ?duration (date-difference ?d1 ?d2)) ;; Duración de la clase
			:condition(and
							(at start (greater-date ?d1 ?d2)) ;; El segundo día está más avanzado en el tiempo que el primero
							(at start (last-hour ?h1)) ;; Es la última hora del primer día
							(at start (initial-hour ?h2)) ;; Es la primera hora del segundo día
							(at start (at-time-location ?h1 ?d1 ?t)) ;; Localización temporal inicial de un profesor
							(at start (at-location ?c1 ?t)) ;; Localización espacial inicial de un profesor
							(at start (rest-class ?c2)) ;; Se trata de una clase en la que se debe dar clase 
							(at start (available ?t)) ;; El profesor no está dando clase
						)
			:effect(and
						(at start (not(at-location ?c1 ?t))) ;; Inicialmente ya no se encuentra en la localización inicial
						(at start (not (available ?t))) ;; Mientras espera, el profesor no se encuentra disponible
						(at start (at-location ?c2 ?t)) ;; Durante todo el proceso ya se encuentra en la localización final
						(at end (not(at-time-location ?h1 ?d1 ?t))) ;; Termina no estando en la hora inicial de un día un profesor
						(at end (at-time-location ?h2 ?d2 ?t)) ;; Termina estando en la hora final de un día un profesor
						(at end (available ?t)) ;; Al final de la espera, el profesor vuelve a estar disponible
						(at end (increase (total-time-teachers) (date-difference ?d1 ?d2))) ;; Incrementa el tiempo total entre todos los profesores
					)
		)
)
							
							

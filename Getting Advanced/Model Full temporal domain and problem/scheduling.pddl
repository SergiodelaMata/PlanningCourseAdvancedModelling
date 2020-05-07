(define (domain scheduling)
	(:requirements :strips :typing :equality :negative-preconditions :fluents 
		:durative-actions :preferences :constraints)
		(:types
			date-week - object
			class - object
			;;num-classes - object
			person - object
			teacher student - object
			number - object
		)
		(:predicates
			(greater ?n1 ?n2 - number) ;; Número superior a otro
			(next-number ?n1 ?n2 - number) ;; Siguiente número
			(next-date ?d1 ?d2 - date-week) ;; Siguiente día
			(class-made ?c - class ?t - teacher ?d - date) ;; Clase realizada por un profesor un día a un grupo
			(class-hours-made ?h1 ?h2 - number ?c - class ?d - date) ;; Clase realizada a un grupo un día entre dos horas contiguas
			(num-classes ?num - number ?c - class ?t - teacher) ;; Número de clases ha realizar un profesor a un grupo
			(at-time-location ?h - number ?d - date ?t - teacher) ;; Localización temporal de un profesor un día a una hora
			(at-location ?c - class ?t - teacher) ;; Localización espacial de un profesor
			(class-can-be-made ?c - class ?d - date ?t - teacher) ;; Válida si una clase puede realizarse un día por un profesor a un día
			(class-can-be-done ?h1 ?h2 - number ?d - date ?c - class) ;; Válida si se puede realizarse una clase en un intervalo de tiempo a una clase en un día
			(available ?t - teacher) ;; Un profesor no se encuentra en clase o ya no puede dar más clases
		)
		(:functions
			(date-difference ?d1 ?d2 - date-week) ;; Diferencia temporal entre dos días
			(hour-difference ?h1 ?h2 - number) ;; Diferencia temporal entre dos horas
			(total-time-teachers) ;; Tiempo total del sumatorio de horas que deben tenerse en cuenta de cada profesor esta que realice el total de horas que tiene que realizar con todos grupos en una semana
		)
		
		(:durative-action make-class
			:parameters(?t - teacher ?c1 ?c2 - class ?num1 ?num2 ?n1 ?n2 ?h1 ?h2 - number ?d1 ?d2 - date-week)
			:duration(= ?duration (+ (date-difference ?d1 ?d2) (hour-difference ?h1 ?h2)))
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
							
							

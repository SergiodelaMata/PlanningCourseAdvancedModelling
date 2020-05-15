(define (problem scheduling-problem2)
	(:domain scheduling)
	(:objects
		d1, d2 - date-week
		c0, c1, c2 - class
		t1, t2, t3, t4 - teacher
		h0, h1, h2, h3, h4, n0, n1, n2 - numbers
	)
	(:init
		;; Número por encima por otros
		(greater n0 n1)(greater n0 n2)
		(greater n1 n2)
		
		;; Horas más tardías que otras
		(greater h0 h1)(greater h0 h2)(greater h0 h3)(greater h0 h4)
		(greater h1 h2)(greater h1 h3)(greater h1 h4)
		(greater h2 h3)(greater h2 h4)
		(greater h3 h4)
		
		;; Número consecutivo mayor a otro
		(next-number n0 n1)(next-number n1 n2)
		
		;; Hora consecutiva mayor que otra
		(next-number h0 h1)(next-number h1 h2)(next-number h2 h3)(next-number h3 h4)
		
		;; Día más tardío con respecto a otro 
		(greater-date d1 d2)
		
		;; Número de clases ha realizar un profesor con un grupo
		(num-classes n2 c1 t1)(num-classes n2 c2 t1)
		(num-classes n2 c1 t2)(num-classes n2 c2 t2)
		(num-classes n2 c1 t3)(num-classes n2 c2 t3)
		(num-classes n2 c1 t4)(num-classes n2 c2 t4)
		
		;; Localización temporal inicial de los profesores
		(at-time-location h0 d1 t1)
		(at-time-location h0 d1 t2)
		(at-time-location h0 d1 t3)
		(at-time-location h0 d1 t4)
		
		;; Localización espacial inicial de los profesores
		(at-location c0 t1)
		(at-location c0 t2)
		(at-location c0 t3)
		(at-location c0 t4)
		
		;; Clases que pueden realizarse por cada profesor, cada día
		(class-can-be-made c1 d1 t1)(class-can-be-made c2 d1 t1)
		(class-can-be-made c1 d1 t2)(class-can-be-made c2 d1 t2)
		(class-can-be-made c1 d1 t3)(class-can-be-made c2 d1 t3)
		(class-can-be-made c1 d1 t4)(class-can-be-made c2 d1 t4)
		
		(class-can-be-made c1 d2 t1)(class-can-be-made c2 d2 t1)
		(class-can-be-made c1 d2 t2)(class-can-be-made c2 d2 t2)
		(class-can-be-made c1 d2 t3)(class-can-be-made c2 d2 t3)
		(class-can-be-made c1 d2 t4)(class-can-be-made c2 d2 t4)
		
		;; Clases que pueden realizarse por cada profesor, cada día
		(class-can-be-done h0 h1 d1 c1)(class-can-be-done h0 h1 d1 c2)
		(class-can-be-done h1 h2 d1 c1)(class-can-be-done h1 h2 d1 c2)
		(class-can-be-done h2 h3 d1 c1)(class-can-be-done h2 h3 d1 c2)
		(class-can-be-done h3 h4 d1 c1)(class-can-be-done h3 h4 d1 c2)
		
		(class-can-be-done h0 h1 d2 c1)(class-can-be-done h0 h1 d2 c2)
		(class-can-be-done h1 h2 d2 c1)(class-can-be-done h1 h2 d2 c2)
		(class-can-be-done h2 h3 d2 c1)(class-can-be-done h2 h3 d2 c2)
		(class-can-be-done h3 h4 d2 c1)(class-can-be-done h3 h4 d2 c2)
		
		;; Profesor disponibles inicialmente
		(available t1)(available t2)(available t3)(available t4)
		
		;; Clases de alumnos inicialmente sin clase
		(free-class c1)(free-class c2)
		
		;; Clases en las que tiene que dar clase un profesor a unos alumnos
		(do-class c1)(do-class c2)
		
		;; Clases en las que un profesor espera a dar clase
		(rest-class c0)
		
		;; Hora inicial de un día
		(initial-hour h0)
		
		;; Hora final de un día
		(last-hour h4)
		
		;; Números distintos a cero
		(different-cero n1)(different-cero n2)
		
		;; Diferencia temporal entre días
		(= (date-difference d1 d2) 12)
		
		;; Diferencia temporal entre horas
		(= (hour-difference h0 h1) 1)(= (hour-difference h0 h2) 2)(= (hour-difference h0 h3) 3)(= (hour-difference h0 h4) 4)
		(= (hour-difference h1 h2) 1)(= (hour-difference h1 h3) 2)(= (hour-difference h1 h4) 3)
		(= (hour-difference h2 h3) 1)(= (hour-difference h2 h4) 2)
		(= (hour-difference h3 h4) 1)
		
		;; Tiempo total del sumatorio de horas que deben tenerse en cuenta de cada profesor esta que realice el total de horas que tiene que realizar con todos grupos en una semana
		(= (total-time-teachers) 0)
	)
	(:goal
	;; Todos los profesores deben haber dado todas sus clases a todos sus grupos de alumnos
		(and
			;; Número de clases ha realizar un profesor con un grupo
			(num-classes n0 c1 t1)(num-classes n0 c2 t1)
			(num-classes n0 c1 t2)(num-classes n0 c2 t2)
			(num-classes n0 c1 t3)(num-classes n0 c2 t3)
			(num-classes n0 c1 t4)(num-classes n0 c2 t4)
			
			;; Los profesores han realizado las clases que debían realizar los días que le correspondería
			(class-made c1 t1 d1)(class-made c1 t1 d2)
			(class-made c2 t1 d1)(class-made c2 t1 d2)
			
			(class-made c1 t2 d1)(class-made c1 t2 d2)
			(class-made c2 t2 d1)(class-made c2 t2 d2)
			
			(class-made c1 t3 d1)(class-made c1 t3 d2)
			(class-made c2 t3 d1)(class-made c2 t3 d2)
			
			(class-made c1 t4 d1)(class-made c1 t4 d2)
			(class-made c2 t4 d1)(class-made c2 t4 d2)
		)
	)
	(:metric minimize (total-time-teachers)) ;; Minimizar por el tiempo total para realizar todas sus clases los profesores
)
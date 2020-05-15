(define (problem scheduling-problem1)
	(:domain scheduling)
	(:objects
		;;d1, d2, d3, d4, d5 - date-week
		;;c0, c1, c2, c3 - class
		;;t1, t2, t3, t4, t5, t6 - teacher
		;;h0, h1, h2, h3, h4, h5, h6, n0, n1, n2, n3, n4, n5 - numbers
		d1, d2, d3 - date-week
		c0, c1, c2, c3 - class
		t1, t2, t3 - teacher
		h0, h1, h2, h3, n0, n1, n2, n3 - numbers
	)
	(:init
		;; Número por encima por otros
		(greater n0 n1)(greater n0 n2)(greater n0 n3)
		(greater n1 n2)(greater n1 n3)
		(greater n2 n3)
		
		;; Horas más tardías que otras
		(greater h0 h1)(greater h0 h2)(greater h0 h3)
		(greater h1 h2)(greater h1 h3)
		(greater h2 h3)
		
		;; Número consecutivo mayor a otro
		(next-number n0 n1)(next-number n1 n2)(next-number n2 n3)
		
		;; Hora consecutiva mayor que otra
		(next-number h0 h1)(next-number h1 h2)(next-number h2 h3)
		
		;; Día más tardío con respecto a otro 
		(greater-date d1 d2)(greater-date d1 d3)
		(greater-date d2 d3)
		
		;; Número de clases ha realizar un profesor con un grupo
		(num-classes n3 c1 t1)(num-classes n3 c2 t1)(num-classes n3 c3 t1)
		(num-classes n3 c1 t2)(num-classes n3 c2 t2)(num-classes n3 c3 t2)
		(num-classes n3 c1 t3)(num-classes n3 c2 t3)(num-classes n3 c3 t3)
		
		;; Localización temporal inicial de los profesores
		(at-time-location h0 d1 t1)
		(at-time-location h0 d1 t2)
		(at-time-location h0 d1 t3)
		
		;; Localización espacial inicial de los profesores
		(at-location c0 t1)
		(at-location c0 t2)
		(at-location c0 t3)
		
		;; Clases que pueden realizarse por cada profesor, cada día
		(class-can-be-made c1 d1 t1)(class-can-be-made c2 d1 t1)(class-can-be-made c3 d1 t1)
		(class-can-be-made c1 d1 t2)(class-can-be-made c2 d1 t2)(class-can-be-made c3 d1 t2)
		(class-can-be-made c1 d1 t3)(class-can-be-made c2 d1 t3)(class-can-be-made c3 d1 t3)

		(class-can-be-made c1 d2 t1)(class-can-be-made c2 d2 t1)(class-can-be-made c3 d2 t1)
		(class-can-be-made c1 d2 t2)(class-can-be-made c2 d2 t2)(class-can-be-made c3 d2 t2)
		(class-can-be-made c1 d2 t3)(class-can-be-made c2 d2 t3)(class-can-be-made c3 d2 t3)

		(class-can-be-made c1 d3 t1)(class-can-be-made c2 d3 t1)(class-can-be-made c3 d3 t1)
		(class-can-be-made c1 d3 t2)(class-can-be-made c2 d3 t2)(class-can-be-made c3 d3 t2)
		(class-can-be-made c1 d3 t3)(class-can-be-made c2 d3 t3)(class-can-be-made c3 d3 t3)

		;; Clases que pueden realizarse por cada profesor, cada día
		(class-can-be-done h0 h1 d1 c1)(class-can-be-done h0 h1 d1 c2)(class-can-be-done h0 h1 d1 c3)
		(class-can-be-done h1 h2 d1 c1)(class-can-be-done h1 h2 d1 c2)(class-can-be-done h1 h2 d1 c3)
		(class-can-be-done h2 h3 d1 c1)(class-can-be-done h2 h3 d1 c2)(class-can-be-done h2 h3 d1 c3)
		
		(class-can-be-done h0 h1 d2 c1)(class-can-be-done h0 h1 d2 c2)(class-can-be-done h0 h1 d2 c3)
		(class-can-be-done h1 h2 d2 c1)(class-can-be-done h1 h2 d2 c2)(class-can-be-done h1 h2 d2 c3)
		(class-can-be-done h2 h3 d2 c1)(class-can-be-done h2 h3 d2 c2)(class-can-be-done h2 h3 d2 c3)
		
		(class-can-be-done h0 h1 d3 c1)(class-can-be-done h0 h1 d3 c2)(class-can-be-done h0 h1 d3 c3)
		(class-can-be-done h1 h2 d3 c1)(class-can-be-done h1 h2 d3 c2)(class-can-be-done h1 h2 d3 c3)
		(class-can-be-done h2 h3 d3 c1)(class-can-be-done h2 h3 d3 c2)(class-can-be-done h2 h3 d3 c3)
		
		;; Profesor disponibles inicialmente
		(available t1)(available t2)(available t3)
		
		;; Clases de alumnos inicialmente sin clase
		(free-class c1)(free-class c2)(free-class c3)
		
		;; Clases en las que tiene que dar clase un profesor a unos alumnos
		(do-class c1)(do-class c2)(do-class c3)
		
		;; Clases en las que un profesor espera a dar clase
		(rest-class c0)
		
		;; Hora inicial de un día
		(initial-hour h0)
		
		;; Hora final de un día
		(last-hour h3)
		
		;; Números distintos a cero
		(different-cero n1)(different-cero n2)(different-cero n3)
		
		;; Diferencia temporal entre días
		(= (date-difference d1 d2) 12)(= (date-difference d1 d3) 24)
		(= (date-difference d2 d3) 12)
		
		;; Diferencia temporal entre horas
		(= (hour-difference h0 h1) 1)(= (hour-difference h0 h2) 2)(= (hour-difference h0 h3) 3)
		(= (hour-difference h1 h2) 1)(= (hour-difference h1 h3) 2)
		(= (hour-difference h2 h3) 1)
		
		;; Tiempo total del sumatorio de horas que deben tenerse en cuenta de cada profesor esta que realice el total de horas que tiene que realizar con todos grupos en una semana
		(= (total-time-teachers) 0)
	)
	(:goal
	;; Todos los profesores deben haber dado todas sus clases a todos sus grupos de alumnos
		(and
			;; Número de clases ha realizar un profesor con un grupo
			(num-classes n0 c1 t1)(num-classes n0 c2 t1)(num-classes n0 c3 t1)
			(num-classes n0 c1 t2)(num-classes n0 c2 t2)(num-classes n0 c3 t2)
			(num-classes n0 c1 t3)(num-classes n0 c2 t3)(num-classes n0 c3 t3)
			
			;; Los profesores han realizado las clases que debían realizar los días que le correspondería
			(class-made c1 t1 d1)(class-made c1 t1 d2)(class-made c1 t1 d3)
			(class-made c2 t1 d1)(class-made c2 t1 d2)(class-made c2 t1 d3)
			(class-made c3 t1 d1)(class-made c3 t1 d2)(class-made c3 t1 d3)
			
			(class-made c1 t2 d1)(class-made c1 t2 d2)(class-made c1 t2 d3)
			(class-made c2 t2 d1)(class-made c2 t2 d2)(class-made c2 t2 d3)
			(class-made c3 t2 d1)(class-made c3 t2 d2)(class-made c3 t2 d3)
			
			(class-made c1 t3 d1)(class-made c1 t3 d2)(class-made c1 t3 d3)
			(class-made c2 t3 d1)(class-made c2 t3 d2)(class-made c2 t3 d3)
			(class-made c3 t3 d1)(class-made c3 t3 d2)(class-made c3 t3 d3)
		)
	)
	(:metric minimize (total-time-teachers)) ;; Minimizar por el tiempo total para realizar todas sus clases los profesores
)
(define (problem scheduling-problem1)
	(:domain scheduling)
	(:objects
		d1, d2, d3, d4, d5 - date-week
		c0, c1, c2, c3 - class
		t1, t2, t3, t4, t5, t6 - teacher
		h0, h1, h2, h3, h4, h5, h6, n0, n1, n2, n3, n4, n5 - numbers
	)
	(:init
		;; Número por encima por otros
		(greater n0 n1)(greater n0 n2)(greater n0 n3)(greater n0 n4)(greater n0 n5)
		(greater n1 n2)(greater n1 n3)(greater n1 n4)(greater n1 n5)
		(greater n2 n3)(greater n2 n4)(greater n2 n5)
		(greater n3 n4)(greater n3 n5)
		(greater n4 n5)
		
		;; Horas más tardías que otras
		(greater h0 h1)(greater h0 h2)(greater h0 h3)(greater h0 h4)(greater h0 h5)(greater h0 h6)
		(greater h1 h2)(greater h1 h3)(greater h1 h4)(greater h1 h5)(greater h1 h6)
		(greater h2 h3)(greater h2 h4)(greater h2 h5)(greater h2 h6)
		(greater h3 h4)(greater h3 h5)(greater h3 h6)
		(greater h4 h5)(greater h4 h6)
		(greater h5 h6)
		
		;; Número consecutivo mayor a otro
		(next-number n0 n1)(next-number n1 n2)(next-number n2 n3)(next-number n3 n4)(next-number n4 n5)
		
		;; Hora consecutiva mayor que otra
		(next-number h0 h1)(next-number h1 h2)(next-number h2 h3)(next-number h3 h4)(next-number h4 h5)(next-number h5 h6)
		
		;; Día más tardío con respecto a otro 
		(greater-date d1 d2)(greater-date d1 d3)(greater-date d1 d4)(greater-date d1 d5)
		(greater-date d2 d3)(greater-date d2 d4)(greater-date d2 d5)
		(greater-date d3 d4)(greater-date d3 d5)
		(greater-date d4 d5)
		
		;; Número de clases ha realizar un profesor con un grupo
		(num-classes n5 c1 t1)(num-classes n5 c2 t1)(num-classes n5 c3 t1)
		(num-classes n5 c1 t2)(num-classes n5 c2 t2)(num-classes n5 c3 t2)
		(num-classes n5 c1 t3)(num-classes n5 c2 t3)(num-classes n5 c3 t3)
		(num-classes n5 c1 t4)(num-classes n5 c2 t4)(num-classes n5 c3 t4)
		(num-classes n5 c1 t5)(num-classes n5 c2 t5)(num-classes n5 c3 t5)
		(num-classes n5 c1 t6)(num-classes n5 c2 t6)(num-classes n5 c3 t6)
		
		;; Localización temporal inicial de los profesores
		(at-time-location h0 d1 t1)
		(at-time-location h0 d1 t2)
		(at-time-location h0 d1 t3)
		(at-time-location h0 d1 t4)
		(at-time-location h0 d1 t5)
		(at-time-location h0 d1 t6)
		
		;; Localización espacial inicial de los profesores
		(at-location c0 t1)
		(at-location c0 t2)
		(at-location c0 t3)
		(at-location c0 t4)
		(at-location c0 t5)
		(at-location c0 t6)
		
		;; Clases que pueden realizarse por cada profesor, cada día
		(class-can-be-made c1 d1 t1)(class-can-be-made c2 d1 t1)(class-can-be-made c3 d1 t1)
		(class-can-be-made c1 d1 t2)(class-can-be-made c2 d1 t2)(class-can-be-made c3 d1 t2)
		(class-can-be-made c1 d1 t3)(class-can-be-made c2 d1 t3)(class-can-be-made c3 d1 t3)
		(class-can-be-made c1 d1 t4)(class-can-be-made c2 d1 t4)(class-can-be-made c3 d1 t4)
		(class-can-be-made c1 d1 t5)(class-can-be-made c2 d1 t5)(class-can-be-made c3 d1 t5)
		(class-can-be-made c1 d1 t6)(class-can-be-made c2 d1 t6)(class-can-be-made c3 d1 t6)

		(class-can-be-made c1 d2 t1)(class-can-be-made c2 d2 t1)(class-can-be-made c3 d2 t1)
		(class-can-be-made c1 d2 t2)(class-can-be-made c2 d2 t2)(class-can-be-made c3 d2 t2)
		(class-can-be-made c1 d2 t3)(class-can-be-made c2 d2 t3)(class-can-be-made c3 d2 t3)
		(class-can-be-made c1 d2 t4)(class-can-be-made c2 d2 t4)(class-can-be-made c3 d2 t4)
		(class-can-be-made c1 d2 t5)(class-can-be-made c2 d2 t5)(class-can-be-made c3 d2 t5)
		(class-can-be-made c1 d2 t6)(class-can-be-made c2 d2 t6)(class-can-be-made c3 d2 t6)

		(class-can-be-made c1 d3 t1)(class-can-be-made c2 d3 t1)(class-can-be-made c3 d3 t1)
		(class-can-be-made c1 d3 t2)(class-can-be-made c2 d3 t2)(class-can-be-made c3 d3 t2)
		(class-can-be-made c1 d3 t3)(class-can-be-made c2 d3 t3)(class-can-be-made c3 d3 t3)
		(class-can-be-made c1 d3 t4)(class-can-be-made c2 d3 t4)(class-can-be-made c3 d3 t4)
		(class-can-be-made c1 d3 t5)(class-can-be-made c2 d3 t5)(class-can-be-made c3 d3 t5)
		(class-can-be-made c1 d3 t6)(class-can-be-made c2 d3 t6)(class-can-be-made c3 d3 t6)

		(class-can-be-made c1 d4 t1)(class-can-be-made c2 d4 t1)(class-can-be-made c3 d4 t1)
		(class-can-be-made c1 d4 t2)(class-can-be-made c2 d4 t2)(class-can-be-made c3 d4 t2)
		(class-can-be-made c1 d4 t3)(class-can-be-made c2 d4 t3)(class-can-be-made c3 d4 t3)
		(class-can-be-made c1 d4 t4)(class-can-be-made c2 d4 t4)(class-can-be-made c3 d4 t4)
		(class-can-be-made c1 d4 t5)(class-can-be-made c2 d4 t5)(class-can-be-made c3 d4 t5)
		(class-can-be-made c1 d4 t6)(class-can-be-made c2 d4 t6)(class-can-be-made c3 d4 t6)

		(class-can-be-made c1 d5 t1)(class-can-be-made c2 d5 t1)(class-can-be-made c3 d5 t1)
		(class-can-be-made c1 d5 t2)(class-can-be-made c2 d5 t2)(class-can-be-made c3 d5 t2)
		(class-can-be-made c1 d5 t3)(class-can-be-made c2 d5 t3)(class-can-be-made c3 d5 t3)
		(class-can-be-made c1 d5 t4)(class-can-be-made c2 d5 t4)(class-can-be-made c3 d5 t4)
		(class-can-be-made c1 d5 t5)(class-can-be-made c2 d5 t5)(class-can-be-made c3 d5 t5)
		(class-can-be-made c1 d5 t6)(class-can-be-made c2 d5 t6)(class-can-be-made c3 d5 t6)
		
		;; Clases que pueden realizarse por cada profesor, cada día
		(class-can-be-done h0 h1 d1 c1)(class-can-be-done h0 h1 d1 c2)(class-can-be-done h0 h1 d1 c3)
		(class-can-be-done h1 h2 d1 c1)(class-can-be-done h1 h2 d1 c2)(class-can-be-done h1 h2 d1 c3)
		(class-can-be-done h2 h3 d1 c1)(class-can-be-done h2 h3 d1 c2)(class-can-be-done h2 h3 d1 c3)
		(class-can-be-done h3 h4 d1 c1)(class-can-be-done h3 h4 d1 c2)(class-can-be-done h3 h4 d1 c3)
		(class-can-be-done h4 h5 d1 c1)(class-can-be-done h4 h5 d1 c2)(class-can-be-done h4 h5 d1 c3)
		(class-can-be-done h5 h6 d1 c1)(class-can-be-done h5 h6 d1 c2)(class-can-be-done h5 h6 d1 c3)
		
		(class-can-be-done h0 h1 d2 c1)(class-can-be-done h0 h1 d2 c2)(class-can-be-done h0 h1 d2 c3)
		(class-can-be-done h1 h2 d2 c1)(class-can-be-done h1 h2 d2 c2)(class-can-be-done h1 h2 d2 c3)
		(class-can-be-done h2 h3 d2 c1)(class-can-be-done h2 h3 d2 c2)(class-can-be-done h2 h3 d2 c3)
		(class-can-be-done h3 h4 d2 c1)(class-can-be-done h3 h4 d2 c2)(class-can-be-done h3 h4 d2 c3)
		(class-can-be-done h4 h5 d2 c1)(class-can-be-done h4 h5 d2 c2)(class-can-be-done h4 h5 d2 c3)
		(class-can-be-done h5 h6 d2 c1)(class-can-be-done h5 h6 d2 c2)(class-can-be-done h5 h6 d2 c3)
		
		(class-can-be-done h0 h1 d3 c1)(class-can-be-done h0 h1 d3 c2)(class-can-be-done h0 h1 d3 c3)
		(class-can-be-done h1 h2 d3 c1)(class-can-be-done h1 h2 d3 c2)(class-can-be-done h1 h2 d3 c3)
		(class-can-be-done h2 h3 d3 c1)(class-can-be-done h2 h3 d3 c2)(class-can-be-done h2 h3 d3 c3)
		(class-can-be-done h3 h4 d3 c1)(class-can-be-done h3 h4 d3 c2)(class-can-be-done h3 h4 d3 c3)
		(class-can-be-done h4 h5 d3 c1)(class-can-be-done h4 h5 d3 c2)(class-can-be-done h4 h5 d3 c3)
		(class-can-be-done h5 h6 d3 c1)(class-can-be-done h5 h6 d3 c2)(class-can-be-done h5 h6 d3 c3)
		
		(class-can-be-done h0 h1 d4 c1)(class-can-be-done h0 h1 d4 c2)(class-can-be-done h0 h1 d4 c3)
		(class-can-be-done h1 h2 d4 c1)(class-can-be-done h1 h2 d4 c2)(class-can-be-done h1 h2 d4 c3)
		(class-can-be-done h2 h3 d4 c1)(class-can-be-done h2 h3 d4 c2)(class-can-be-done h2 h3 d4 c3)
		(class-can-be-done h3 h4 d4 c1)(class-can-be-done h3 h4 d4 c2)(class-can-be-done h3 h4 d4 c3)
		(class-can-be-done h4 h5 d4 c1)(class-can-be-done h4 h5 d4 c2)(class-can-be-done h4 h5 d4 c3)
		(class-can-be-done h5 h6 d4 c1)(class-can-be-done h5 h6 d4 c2)(class-can-be-done h5 h6 d4 c3)
		
		(class-can-be-done h0 h1 d5 c1)(class-can-be-done h0 h1 d5 c2)(class-can-be-done h0 h1 d5 c3)
		(class-can-be-done h1 h2 d5 c1)(class-can-be-done h1 h2 d5 c2)(class-can-be-done h1 h2 d5 c3)
		(class-can-be-done h2 h3 d5 c1)(class-can-be-done h2 h3 d5 c2)(class-can-be-done h2 h3 d5 c3)
		(class-can-be-done h3 h4 d5 c1)(class-can-be-done h3 h4 d5 c2)(class-can-be-done h3 h4 d5 c3)
		(class-can-be-done h4 h5 d5 c1)(class-can-be-done h4 h5 d5 c2)(class-can-be-done h4 h5 d5 c3)
		(class-can-be-done h5 h6 d5 c1)(class-can-be-done h5 h6 d5 c2)(class-can-be-done h5 h6 d5 c3)
		
		;; Profesor disponibles inicialmente
		(available t1)(available t2)(available t3)(available t4)(available t5)(available t6)
		
		;; Clases de alumnos inicialmente sin clase
		(free-class c1)(free-class c2)(free-class c3)
		
		;; Clases en las que tiene que dar clase un profesor a unos alumnos
		(do-class c1)(do-class c2)(do-class c3)
		
		;; Clases en las que un profesor espera a dar clase
		(rest-class c0)
		
		;; Hora inicial de un día
		(initial-hour h0)
		
		;; Hora final de un día
		(last-hour h6)
		
		;; Números distintos a cero
		(different-cero n1)(different-cero n2)(different-cero n3)(different-cero n4)(different-cero n5)
		
		;; Diferencia temporal entre días
		(= (date-difference d1 d2) 12)(= (date-difference d1 d3) 24)(= (date-difference d1 d4) 36)(= (date-difference d1 d5) 48)
		(= (date-difference d2 d3) 12)(= (date-difference d2 d4) 24)(= (date-difference d2 d5) 36)
		(= (date-difference d3 d4) 12)(= (date-difference d3 d5) 24)
		(= (date-difference d4 d5) 12)
		
		;; Diferencia temporal entre horas
		(= (hour-difference h0 h1) 1)(= (hour-difference h0 h2) 2)(= (hour-difference h0 h3) 3)(= (hour-difference h0 h4) 4)(= (hour-difference h0 h5) 5)(= (hour-difference h0 h6) 6)
		(= (hour-difference h1 h2) 1)(= (hour-difference h1 h3) 2)(= (hour-difference h1 h4) 3)(= (hour-difference h1 h5) 4)(= (hour-difference h1 h6) 5)
		(= (hour-difference h2 h3) 1)(= (hour-difference h2 h4) 2)(= (hour-difference h2 h5) 3)(= (hour-difference h2 h6) 4)
		(= (hour-difference h3 h4) 1)(= (hour-difference h3 h5) 2)(= (hour-difference h3 h6) 3)
		(= (hour-difference h4 h5) 1)(= (hour-difference h4 h6) 2)
		(= (hour-difference h5 h6) 1)
		
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
			(num-classes n0 c1 t4)(num-classes n0 c2 t4)(num-classes n0 c3 t4)
			(num-classes n0 c1 t5)(num-classes n0 c2 t5)(num-classes n0 c3 t5)
			(num-classes n0 c1 t6)(num-classes n0 c2 t6)(num-classes n0 c3 t6)
			
			;; Los profesores han realizado las clases que debían realizar los días que le correspondería
			(class-made c1 t1 d1)(class-made c1 t1 d2)(class-made c1 t1 d3)(class-made c1 t1 d4)(class-made c1 t1 d5)
			(class-made c2 t1 d1)(class-made c2 t1 d2)(class-made c2 t1 d3)(class-made c2 t1 d4)(class-made c2 t1 d5)
			(class-made c3 t1 d1)(class-made c3 t1 d2)(class-made c3 t1 d3)(class-made c3 t1 d4)(class-made c3 t1 d5)
			
			(class-made c1 t2 d1)(class-made c1 t2 d2)(class-made c1 t2 d3)(class-made c1 t2 d4)(class-made c1 t2 d5)
			(class-made c2 t2 d1)(class-made c2 t2 d2)(class-made c2 t2 d3)(class-made c2 t2 d4)(class-made c2 t2 d5)
			(class-made c3 t2 d1)(class-made c3 t2 d2)(class-made c3 t2 d3)(class-made c3 t2 d4)(class-made c3 t2 d5)
			
			(class-made c1 t3 d1)(class-made c1 t3 d2)(class-made c1 t3 d3)(class-made c1 t3 d4)(class-made c1 t3 d5)
			(class-made c2 t3 d1)(class-made c2 t3 d2)(class-made c2 t3 d3)(class-made c2 t3 d4)(class-made c2 t3 d5)
			(class-made c3 t3 d1)(class-made c3 t3 d2)(class-made c3 t3 d3)(class-made c3 t3 d4)(class-made c3 t3 d5)
			
			(class-made c1 t4 d1)(class-made c1 t4 d2)(class-made c1 t4 d3)(class-made c1 t4 d4)(class-made c1 t4 d5)
			(class-made c2 t4 d1)(class-made c2 t4 d2)(class-made c2 t4 d3)(class-made c2 t4 d4)(class-made c2 t4 d5)
			(class-made c3 t4 d1)(class-made c3 t4 d2)(class-made c3 t4 d3)(class-made c3 t4 d4)(class-made c3 t4 d5)
			
			(class-made c1 t5 d1)(class-made c1 t5 d2)(class-made c1 t5 d3)(class-made c1 t5 d4)(class-made c1 t5 d5)
			(class-made c2 t5 d1)(class-made c2 t5 d2)(class-made c2 t5 d3)(class-made c2 t5 d4)(class-made c2 t5 d5)
			(class-made c3 t5 d1)(class-made c3 t5 d2)(class-made c3 t5 d3)(class-made c3 t5 d4)(class-made c3 t5 d5)
			
			(class-made c1 t6 d1)(class-made c1 t6 d2)(class-made c1 t6 d3)(class-made c1 t6 d4)(class-made c1 t6 d5)
			(class-made c2 t6 d1)(class-made c2 t6 d2)(class-made c2 t6 d3)(class-made c2 t6 d4)(class-made c2 t6 d5)
			(class-made c3 t6 d1)(class-made c3 t6 d2)(class-made c3 t6 d3)(class-made c3 t6 d4)(class-made c3 t6 d5)
			
		)
	)
	(:metric minimize (total-time-teachers)) ;; Minimizar por el tiempo total para realizar todas sus clases los profesores
)
(define (problem building-problem2)
	(:domain building)
	(:objects
		n0 n1 n2 n3 n4 n5 - number ; Cuya correspondencia sería n0 --> 0, n1 --> 1, ...
		v0 v1 v2 - number
		p0 p1 - person
		fastlift1 fastlift2 - fastlift
		slowlift1 slowlift2 - slowlift
	)
	(:init
		(next-number n0 n1) (next-number n1 n2) (next-number n2 n3) (next-number n3 n4) 

		(above n0 n1) (above n0 n2) (above n0 n3) (above n0 n4)
		(above n1 n2) (above n1 n3) (above n1 n4)
		(above n2 n3) (above n2 n4)
		(above n3 n4)
		
		(at-floor fastlift1 n1)(at-floor fastlift2 n0)
		(at-floor slowlift1 n1)(at-floor slowlift2 n4)
		(at-floor p0 n4) (at-floor p1 n2)
		
		(can-stop fastlift2 n0) 
		(can-stop fastlift1 n1) (can-stop fastlift1 n2) (can-stop fastlift1 n4)
		(can-stop slowlift1 n0) (can-stop slowlift1 n1) (can-stop slowlift1 n2) (can-stop slowlift1 n3) (can-stop slowlift1 n4)
		(can-stop slowlift2 n0) (can-stop slowlift2 n1) (can-stop slowlift2 n2) (can-stop slowlift2 n3) (can-stop slowlift2 n4)
		
		(is-num-passengers fastlift1 n0) (is-num-passengers fastlift2 n0)
		(is-num-passengers slowlift1 n0) (is-num-passengers slowlift2 n0)
		
		
		(= (distance n0 n1) 1) (= (distance n0 n2) 2) (= (distance n0 n3) 3) (= (distance n0 n4) 4)
		(= (distance n1 n0) 1) (= (distance n1 n2) 1) (= (distance n1 n3) 2) (= (distance n1 n4) 3)
		(= (distance n2 n0) 2) (= (distance n2 n1) 1) (= (distance n2 n3) 1) (= (distance n2 n4) 2)
		(= (distance n3 n0) 3) (= (distance n3 n1) 2) (= (distance n3 n2) 1) (= (distance n3 n4) 1)
		(= (distance n4 n0) 4) (= (distance n4 n1) 3) (= (distance n4 n2) 2) (= (distance n4 n3) 1)
		
		(= (speed-travel-slow slowlift1) 1) (= (speed-travel-slow slowlift2) 1)
		(= (speed-travel-fast fastlift1) 4) (= (speed-travel-fast fastlift2) 4)
	)
	(:goal
		(and
			(at-floor p0 n1) (at-floor p1 n3)
			(at-floor fastlift1 n4)
		)
	)
)
		
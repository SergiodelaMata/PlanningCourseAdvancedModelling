(define (problem cooperation-problem)
	(:domain cooperation)
	(:objects
		dock1 - dock
		x_1 x_5 x_6 x_10 x_16 - coordX 
		y_1 y_2 y_9 y_10 y_13 - coordY 
		Leader - ugv
		Follower0 - uav
		N0 N1 - navmode
		P_0 P_45 P_90 P_135 P_180 P_225 P_270 P_315 - pan
		T_0 T_45 T_90 T_270 T_315 - tilt
	)
	
	(:init
		(at-position dock1 x_1 y_1)
		(at-position Leader x_6 y_10)
		(at-position Follower0 x_10 y_2)
		(has-nav-mode Leader N0)
		(has-nav-mode Follower0 N0)
		(is-horizontal-pan Leader P_0)
		(is-horizontal-pan Follower0 P_0)
		(is-horizontal-tilt Leader T_0)
		(is-horizontal-tilt Follower0 T_0)
		
		(= (total-time-use) 0)
	
		(= (speed N0) 1)
		(= (speed N1) 2)
		
		(= (distance x_1 y_1 x_5 y_9) 9)
		(= (distance x_1 y_1 x_6 y_10) 10)
		(= (distance x_1 y_1 x_10 y_2) 9)
		(= (distance x_1 y_1 x_16 y_13) 19)
		
		(= (distance x_5 y_9 x_1 y_1) 9)
		(= (distance x_5 y_9 x_6 y_10) 1)
		(= (distance x_5 y_9 x_10 y_2) 9)
		(= (distance x_5 y_9 x_16 y_13) 12)
		
		(= (distance x_6 y_10 x_1 y_1) 10)
		(= (distance x_6 y_10 x_5 y_9) 9)
		(= (distance x_6 y_10 x_10 y_2) 9)
		(= (distance x_6 y_10 x_16 y_13) 10)
		
		(= (distance x_10 y_2 x_1 y_1) 9)
		(= (distance x_10 y_2 x_5 y_9) 9)
		(= (distance x_10 y_2 x_6 y_10) 9)
		(= (distance x_10 y_2 x_16 y_13) 12)
		
		(= (distance x_16 y_13 x_1 y_1) 19)
		(= (distance x_16 y_13 x_5 y_9) 11)
		(= (distance x_16 y_13 x_6 y_10) 10)
		(= (distance x_16 y_13 x_10 y_2) 12)
	)
	(:goal
		(and
			(is-taken-picture Leader x_5 y_9 P_0 T_0)
			(is-taken-picture Follower0 x_16 y_13 P_0 T_0)
		)
	)
	(:constraints
		(and
			(preference OUT-DOCK-UAV (always (not(at-dock Follower0 dock1))))
			(preference OUT-DOCK-UGV (sometime (at-dock Leader dock1)))
		)
	)
	(:metric minimize
		(+ 	(* 20 (total-time-use))
			(* 10 (is-violated OUT-DOCK-UAV))
			(* 4 (is-violated OUT-DOCK-UGV))
		)
	)
)